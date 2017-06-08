package org.yadickson.maven.plugins.generator.db.support.oracle;

import org.yadickson.maven.plugins.generator.db.support.oracle.parameter.OracleMakeParameter;
import org.yadickson.maven.plugins.generator.db.common.Procedure;
import org.yadickson.maven.plugins.generator.db.common.Parameter;
import org.yadickson.maven.plugins.generator.db.common.Direction;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.List;
import org.yadickson.maven.plugins.generator.db.SPGenerator;
import org.yadickson.maven.plugins.generator.logger.LoggerManager;
import java.util.Collections;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;
import java.util.TreeSet;
import org.apache.commons.lang.StringUtils;
import org.yadickson.maven.plugins.generator.db.MakeDirection;
import org.yadickson.maven.plugins.generator.db.common.Function;

/**
 *
 * @author Yadickson Soto
 */
public class OracleSPGenerator implements SPGenerator {

    /**
     *
     * @param connection
     * @return
     * @throws Exception
     */
    @Override
    public List<Procedure> findProcedures(Connection connection) throws Exception {
        LoggerManager.getInstance().info("[OracleSPGenerator] Find all procedure by name");

        PreparedStatement statement = connection.prepareStatement("SELECT OBJECT_NAME as PACKAGE, PROCEDURE_NAME as NAME, case when (SELECT count(position) as type FROM all_arguments WHERE OWNER=USER AND object_name = allp.PROCEDURE_NAME AND package_name = allp.OBJECT_NAME and position = 0) = 0 then 'PROCEDURE' else 'FUNCTION' end as type FROM SYS.ALL_PROCEDURES allp WHERE OWNER=USER and OBJECT_TYPE ='PACKAGE' and PROCEDURE_NAME is not null\n"
                + "union SELECT null as PACKAGE, OBJECT_NAME AS NAME, OBJECT_TYPE as TYPE FROM SYS.ALL_PROCEDURES WHERE OWNER=USER and (OBJECT_TYPE = 'FUNCTION' or OBJECT_TYPE='PROCEDURE')");

        if (!statement.execute()) {
            throw new Exception("[OracleSPGenerator] Error find procedures");
        }

        ResultSet result = statement.getResultSet();

        List<Procedure> list = new ArrayList<Procedure>();

        try {
            while (result.next()) {
                String pkg = result.getString("package");
                String name = result.getString("name");
                Boolean p = result.getString("type").equalsIgnoreCase("PROCEDURE");
                Procedure procedure = p ? new Procedure(pkg, name) : new Function(pkg, name);
                LoggerManager.getInstance().info("[OracleSPGenerator] Found " + procedure.getFullName());
                list.add(procedure);
            }
        } catch (Exception ex) {
            throw new Exception(ex);
        } finally {
            result.close();
            statement.close();
        }

        LoggerManager.getInstance().info("[OracleSPGenerator] Found " + list.size() + " procedures");

        return list;
    }

    /**
     *
     * @param connection
     * @param procedure
     * @throws Exception
     */
    @Override
    public void fillProcedure(Connection connection, Procedure procedure) throws Exception {
        LoggerManager.getInstance().info("[OracleSPGenerator] Create store procedure " + procedure.getFullName());

        PreparedStatement statement = connection.prepareStatement("SELECT argument_name, data_type, position, in_out, type_name FROM all_arguments WHERE OWNER=USER AND object_name = ? AND (? is null OR package_name = ?) order by argument_name asc nulls first, position");

        statement.setString(1, procedure.getName());
        statement.setString(2, procedure.getPackageName());
        statement.setString(3, procedure.getPackageName());

        if (!statement.execute()) {
            throw new Exception("[OracleSPGenerator] Error find parameter from procedure " + procedure.getFullName());
        }

        ResultSet result = statement.getResultSet();

        Map<Integer, Parameter> parameters = new TreeMap<Integer, Parameter>();

        try {
            while (result.next()) {

                String dataType = result.getString("DATA_TYPE");
                String typeName = result.getString("TYPE_NAME");

                Integer position = result.getInt("POSITION");
                String parameterName = result.getString("ARGUMENT_NAME");
                Direction direction = new MakeDirection().getDirection(result.getString("IN_OUT"));

                LoggerManager.getInstance().info("[OracleSPGenerator] Process (" + position + ") " + parameterName + " " + direction + " " + dataType + " " + typeName);
                Parameter param = new OracleMakeParameter().create(dataType, position, parameterName, direction, connection, typeName);
                LoggerManager.getInstance().info("[OracleSPGenerator] Parameter (" + param.getPosition() + ") " + param.getName() + " " + param.getDirection() + " [" + param.getSqlTypeName() + "]");

                parameters.put(position, param);
            }
        } catch (Exception ex) {
            throw new Exception(ex);
        } finally {
            result.close();
            statement.close();
        }

        boolean findMultiple = false;

        List<Parameter> psort = new ArrayList<Parameter>(parameters.values());
        Collections.sort(psort);

        for (Parameter param : psort) {

            if (param.isResultSet()) {
                findMultiple = true;
                break;
            }
        }

        if (findMultiple) {
            findOracleDataSetParameter(connection, procedure, psort);
        }

        procedure.setParameters(psort);
    }

    private void findOracleDataSetParameter(Connection connection, Procedure procedure, List<Parameter> parameters) throws Exception {

        boolean isFunction = procedure.isFunction();

        String sql = "{call ";
        if (isFunction) {
            sql += "?:= ";
        }

        sql += procedure.getFullName();
        sql += "(";

        int args = isFunction ? parameters.size() - 1 : parameters.size();
        List<String> argv = new ArrayList<String>();

        for (int i = 0; i < args; i++) {
            argv.add("?");
        }

        sql += StringUtils.join(argv, ",");
        sql += ") }";

        LoggerManager.getInstance().info(sql);
        CallableStatement statement = connection.prepareCall(sql);

        try {

            for (int i = 0; i < parameters.size(); i++) {
                if (parameters.get(i).isInput()) {
                    statement.setObject(i + 1, null);
                } else {
                    statement.registerOutParameter(i + 1, parameters.get(i).getSqlType());
                }
            }

            statement.execute();

            for (int i = 0; i < parameters.size(); i++) {

                if (!parameters.get(i).isOutput() || !parameters.get(i).isResultSet()) {
                    continue;
                }

                int position = parameters.get(i).getPosition() + (isFunction ? 1 : 0);
                LoggerManager.getInstance().info("Find resultset from position: " + position);

                ResultSet result = (ResultSet) statement.getObject(position);

                if (result == null) {
                    throw new Exception("[OracleSPGenerator] ResultSet null");
                }

                ResultSetMetaData metadata = result.getMetaData();

                List<Parameter> list = new ArrayList<Parameter>();
                Set<String> pNames = new TreeSet<String>();

                try {
                    for (int j = 0; j < metadata.getColumnCount(); j++) {
                        Parameter p = new OracleMakeParameter().create(metadata.getColumnTypeName(j + 1), j + 1, metadata.getColumnName(j + 1), Direction.Output, connection, null);

                        if (pNames.contains(p.getName())) {
                            throw new Exception("Parameter name [" + p.getName() + "] is duplicated");
                        }

                        pNames.add(p.getName());
                        list.add(p);
                    }
                } catch (Exception ex) {
                    throw new Exception(ex);
                } finally {
                    result.close();
                }

                parameters.get(i).setParameters(list);
            }

        } finally {
            statement.close();
        }
    }
}
