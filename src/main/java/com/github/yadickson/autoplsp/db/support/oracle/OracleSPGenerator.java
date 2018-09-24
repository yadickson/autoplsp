/*
 * Copyright (C) 2017 Yadickson Soto
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package com.github.yadickson.autoplsp.db.support.oracle;

import com.github.yadickson.autoplsp.db.bean.ParameterBean;
import com.github.yadickson.autoplsp.db.support.oracle.parameter.OracleMakeParameter;
import com.github.yadickson.autoplsp.db.common.Procedure;
import com.github.yadickson.autoplsp.db.common.Parameter;
import com.github.yadickson.autoplsp.db.common.Direction;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.List;
import com.github.yadickson.autoplsp.db.SPGenerator;
import com.github.yadickson.autoplsp.logger.LoggerManager;
import java.util.Set;
import java.util.TreeSet;
import org.apache.commons.lang.StringUtils;
import com.github.yadickson.autoplsp.db.MakeDirection;
import com.github.yadickson.autoplsp.db.util.FindParameter;
import com.github.yadickson.autoplsp.util.ParameterSort;
import com.github.yadickson.autoplsp.db.util.FindParameterImpl;
import com.github.yadickson.autoplsp.handler.BusinessException;
import java.sql.SQLException;
import java.util.Collections;
import java.util.Map;
import java.util.TreeMap;

/**
 * Oracle Store procedure and function generator class
 *
 * @author Yadickson Soto
 */
public class OracleSPGenerator extends SPGenerator {

    /**
     * Class constructor
     *
     * @param name sp generator
     */
    public OracleSPGenerator(String name) {
        super(name);
    }

    /**
     * Method getter sql procedures
     *
     * @return sql to find procedures
     */
    @Override
    public String getProcedureQuery() {
        return "SELECT OBJECT_NAME as PKG, PROCEDURE_NAME as NAME, case when (SELECT count(position) as type FROM all_arguments WHERE OWNER=USER AND object_name = allp.PROCEDURE_NAME AND package_name = allp.OBJECT_NAME and position = 0) = 0 then 'PROCEDURE' else 'FUNCTION' end as type FROM ALL_PROCEDURES allp WHERE OWNER=USER and OBJECT_TYPE ='PACKAGE' and PROCEDURE_NAME is not null union SELECT null as PKG, OBJECT_NAME AS NAME, OBJECT_TYPE as TYPE FROM ALL_PROCEDURES WHERE OWNER=USER and (OBJECT_TYPE = 'FUNCTION' or OBJECT_TYPE='PROCEDURE')";
    }

    /**
     * Fill parameters of procedure from database
     *
     * @param connection Database connection
     * @param procedure procedure
     * @param objectSuffix Object suffix name
     * @param arraySuffix Array suffix name
     * @throws BusinessException If error
     */
    @Override
    public void fillProcedure(
            final Connection connection,
            final Procedure procedure,
            final String objectSuffix,
            final String arraySuffix) throws BusinessException {
        LoggerManager.getInstance().info("[OracleSPGenerator] Create store procedure " + procedure.getFullName());

        Map<Integer, Parameter> mparameters = new TreeMap<Integer, Parameter>();
        String pkg = procedure.getPackageName() == null ? "" : "AND package_name = ?";
        String sql = "SELECT argument_name as name, position, in_out as direction, data_type as dtype, type_name as ntype FROM all_arguments WHERE OWNER=USER AND object_name = ? " + pkg + " order by position asc, argument_name asc nulls first";

        FindParameter find = new FindParameterImpl();

        List<ParameterBean> parameters = procedure.getPackageName() == null ? find.getParameters(connection, sql, procedure.getName()) : find.getParameters(connection, sql, procedure.getName(), procedure.getPackageName());

        for (ParameterBean p : parameters) {

            String dataType = p.getDtype();
            String typeName = p.getNtype();

            Integer position = p.getPosition();
            String parameterName = p.getName();
            Direction direction = new MakeDirection().getDirection(p.getDirection());

            LoggerManager.getInstance().info("[OracleSPGenerator] Process (" + position + ") " + parameterName + " " + direction + " " + dataType + " " + typeName);
            Parameter param = new OracleMakeParameter().create(dataType, position, parameterName, direction, connection, typeName, procedure, objectSuffix, arraySuffix);
            LoggerManager.getInstance().info("[OracleSPGenerator] Parameter (" + param.getPosition() + ") " + param.getName() + " " + param.getDirection() + " [" + param.getSqlTypeName() + "]");

            mparameters.put(position, param);
        }

        List<Parameter> list = new ArrayList<Parameter>(mparameters.values());
        procedure.setParameters(list);

        if (procedure.getHasResultSet()) {
            findOracleDataSetParameter(connection, procedure, list, objectSuffix, arraySuffix);
        }

    }

    private void findOracleDataSetParameter(
            final Connection connection,
            final Procedure procedure,
            final List<Parameter> parameters,
            final String objectSuffix,
            final String arraySuffix) throws BusinessException {

        boolean isFunction = procedure.isFunction();

        String sql = getProcedureSql(procedure, parameters);

        LoggerManager.getInstance().info(sql);

        CallableStatement statement = null;

        try {

            statement = connection.prepareCall(sql);

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
                    throw new BusinessException("[OracleSPGenerator] ResultSet null");
                }

                parameters.get(i).setParameters(getParameters(procedure, connection, result, objectSuffix, arraySuffix));
            }

        } catch (SQLException ex) {
            throw new BusinessException("", ex);
        } finally {
            try {
                if (statement != null) {
                    statement.close();
                }
            } catch (SQLException ex) {
                LoggerManager.getInstance().error(ex);
            }
        }
    }

    private String getProcedureSql(Procedure procedure, List<Parameter> parameters) {
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

        return sql;
    }

    private List<Parameter> getParameters(Procedure procedure, Connection connection, ResultSet result, String objectSuffix, String arraySuffix) throws BusinessException, SQLException {

        ResultSetMetaData metadata = result.getMetaData();

        List<Parameter> list = new ArrayList<Parameter>();
        Set<String> pNames = new TreeSet<String>();

        try {
            for (int j = 0; j < metadata.getColumnCount(); j++) {
                Parameter p = new OracleMakeParameter().create(metadata.getColumnTypeName(j + 1), j + 1, metadata.getColumnName(j + 1), Direction.OUTPUT, connection, null, procedure, objectSuffix, arraySuffix);

                if (pNames.contains(p.getName())) {
                    throw new BusinessException("Parameter name [" + p.getName() + "] is duplicated");
                }

                LoggerManager.getInstance().info("Parameter (" + p.getPosition() + ") " + p.getName() + " [" + p.getSqlTypeName() + "]");
                pNames.add(p.getName());
                list.add(p);
            }
        } catch (Exception ex) {
            throw new BusinessException("", ex);
        } finally {
            result.close();
        }

        Collections.sort(list, new ParameterSort());

        return list;
    }

}
