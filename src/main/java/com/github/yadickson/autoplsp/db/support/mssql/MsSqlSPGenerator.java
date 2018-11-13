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
package com.github.yadickson.autoplsp.db.support.mssql;

import com.github.yadickson.autoplsp.db.MakeDirection;
import com.github.yadickson.autoplsp.db.common.Procedure;
import com.github.yadickson.autoplsp.db.common.Parameter;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;
import com.github.yadickson.autoplsp.db.SPGenerator;
import com.github.yadickson.autoplsp.db.bean.ParameterBean;
import com.github.yadickson.autoplsp.db.common.Direction;
import com.github.yadickson.autoplsp.db.support.mssql.parameter.MsSqlMakeParameter;
import com.github.yadickson.autoplsp.db.util.FindParameterImpl;
import com.github.yadickson.autoplsp.logger.LoggerManager;
import com.github.yadickson.autoplsp.handler.BusinessException;
import java.util.Map;
import java.util.TreeMap;

/**
 * Microsoft SQL procedure and function generator class
 *
 * @author Yadickson Soto
 */
public class MsSqlSPGenerator extends SPGenerator {

    /**
     * Class constructor
     *
     * @param name sp generator
     */
    public MsSqlSPGenerator(String name) {
        super(name);
    }

    /**
     * Method getter sql procedures
     *
     * @return sql to find procedures
     */
    @Override
    public String getProcedureQuery() {
        return "SELECT pkg = null, name, case when type = 'P' then 'PROCEDURE' else 'FUNCTION' end as type\n" +
               "FROM sysobjects\n" +
               "WHERE type IN (\n" +
               "    'P', -- stored procedures\n" +
               "    'FN', -- scalar functions \n" +
               "    'IF', -- inline table-valued functions\n" +
               "    'TF' -- table-valued functions\n" +
               ")\n" +
               "ORDER BY type, name";
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
        LoggerManager.getInstance().info("[MsSqlSPGenerator] Create store procedure " + procedure.getFullName());

        Map<Integer, Parameter> mparameters = new TreeMap<Integer, Parameter>();

        String sql = "select  \n" +
        "   'name' = name,  \n" +
        "   'dtype'   = case when is_cursor_ref = 1 then 'cursor' else type_name(user_type_id) end,  \n" +
        "   'position'  = parameter_id,\n" +
        "   'direction' = case when is_output = 0 then 'IN' else 'OUT' end\n" +
        "  from sys.parameters where object_id = object_id(?)";

        List<ParameterBean> parameters = new FindParameterImpl().getParameters(connection, sql, procedure.getName());

        for (ParameterBean p : parameters) {

            String dataType = p.getDtype();
            String typeName = p.getNtype();

            Integer position = p.getPosition();
            String parameterName = p.getName().replace("@","");
            Direction direction = new MakeDirection().getDirection(p.getDirection());

            LoggerManager.getInstance().info("[MsSqlSPGenerator] Process (" + position + ") " + parameterName + " " + direction + " " + dataType + " " + typeName);
            Parameter param = new MsSqlMakeParameter().create(dataType, position, parameterName, direction, connection, typeName, procedure, objectSuffix, arraySuffix);
            LoggerManager.getInstance().info("[MsSqlSPGenerator] Parameter (" + param.getPosition() + ") " + param.getName() + " " + param.getDirection() + " [" + param.getSqlTypeName() + "]");

            mparameters.put(position, param);
        }

        List<Parameter> list = new ArrayList<Parameter>(mparameters.values());
        procedure.setParameters(list);

        //if (procedure.getHasResultSet()) {
            //findOracleDataSetParameter(connection, procedure, list);
        //}

    }
/*
    private void findOracleDataSetParameter(Procedure procedure, Connection connection, Procedure procedure, List<Parameter> parameters) throws BusinessException {

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
                    throw new BusinessException("[MsSqlSPGenerator] ResultSet null");
                }

                parameters.get(i).setParameters(getParameters(procedure, connection, result));
            }

        } catch (SQLException ex) {
            throw new BusinessException("", ex);
        } finally {
            try {
                statement.close();
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

    private List<Parameter> getParameters(Connection connection, ResultSet result) throws BusinessException, SQLException {

        ResultSetMetaData metadata = result.getMetaData();

        List<Parameter> list = new ArrayList<Parameter>();
        Set<String> pNames = new TreeSet<String>();

        try {
            for (int j = 0; j < metadata.getColumnCount(); j++) {
                Parameter p = null; //new OracleMakeParameter().create(metadata.getColumnTypeName(j + 1), j + 1, metadata.getColumnName(j + 1), Direction.OUTPUT, connection, null, procedure);

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
*/
}
