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
package com.github.yadickson.autoplsp.db.support.postgresql;

import com.github.yadickson.autoplsp.db.MakeDirection;
import com.github.yadickson.autoplsp.db.common.Procedure;
import com.github.yadickson.autoplsp.db.common.Parameter;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;
import com.github.yadickson.autoplsp.db.SPGenerator;
import com.github.yadickson.autoplsp.db.bean.ParameterBean;
import com.github.yadickson.autoplsp.db.common.Direction;
import com.github.yadickson.autoplsp.util.ParameterSort;
import com.github.yadickson.autoplsp.db.support.postgresql.parameter.PostgreSqlMakeParameter;
import com.github.yadickson.autoplsp.db.util.FindParameterImpl;
import com.github.yadickson.autoplsp.logger.LoggerManager;
import com.github.yadickson.autoplsp.handler.BusinessException;
import java.util.Collections;
import java.util.Map;
import java.util.TreeMap;

/**
 * Oracle Store procedure and function generator class
 *
 * @author Yadickson Soto
 */
public class PostgreSqlSPGenerator extends SPGenerator {

    /**
     * Class constructor
     *
     * @param name sp generator
     */
    public PostgreSqlSPGenerator(String name) {
        super(name);
    }

    /**
     * Method getter sql procedures
     *
     * @return sql to find procedures
     */
    @Override
    public String getProcedureQuery() {
        return "SELECT null as PKG, CASE WHEN pg_catalog.format_type(p.prorettype, NULL) = 'void' or pg_catalog.format_type(p.prorettype, NULL) = 'record' THEN 'PROCEDURE' ELSE 'FUNCTION' END as type, p.proname as name FROM pg_catalog.pg_namespace n JOIN pg_catalog.pg_proc p ON pronamespace = n.oid WHERE nspname = 'public' AND pg_catalog.pg_function_is_visible(p.oid)";
    }

    /**
     * Fill parameters of procedure from database
     *
     * @param connection Database connection
     * @param procedure procedure
     * @throws BusinessException If error
     */
    @Override
    public void fillProcedure(Connection connection, Procedure procedure) throws BusinessException {
        LoggerManager.getInstance().info("[PostgreSqlSPGenerator] Create store procedure " + procedure.getFullName());

        Map<Integer, Parameter> mparameters = new TreeMap<Integer, Parameter>();

        String sql = "select p[1] as position, p[2] as direction, p[3] as name, p[4] as dtype\n" +
            "from (\n" +
            "SELECT regexp_split_to_array(param, ':') from \n" +
            "(\n" +
            "SELECT\n" +
            "CASE WHEN p.proretset THEN 'setof ' ELSE '' END ||\n" +
            "pg_catalog.format_type(p.prorettype, NULL) as \"out\",\n" +
            "CASE WHEN proallargtypes IS NOT NULL THEN\n" +
            "pg_catalog.array_to_string(ARRAY(\n" +
            "SELECT\n" +
            "s.i || ':' ||\n" +
            "CASE\n" +
            "WHEN p.proargmodes[s.i] = 'i' THEN 'IN:'\n" +
            "WHEN p.proargmodes[s.i] = 'o' THEN 'OUT:'\n" +
            "WHEN p.proargmodes[s.i] = 'b' THEN 'INOUT:'\n" +
            "END ||\n" +
            "CASE\n" +
            "WHEN COALESCE(p.proargnames[s.i], '') = '' THEN ''\n" +
            "ELSE p.proargnames[s.i] || ':'\n" +
            "END ||\n" +
            "pg_catalog.format_type(p.proallargtypes[s.i], NULL)\n" +
            "FROM\n" +
            "pg_catalog.generate_series(1,\n" +
            "pg_catalog.array_upper(p.proallargtypes, 1)) AS s(i)\n" +
            "), ',')\n" +
            "ELSE\n" +
            "pg_catalog.array_to_string(ARRAY(\n" +
            "SELECT\n" +
            "s.i+1 || ':IN:' ||\n" +
            "CASE\n" +
            "WHEN COALESCE(p.proargnames[s.i+1], '') = '' THEN ''\n" +
            "ELSE p.proargnames[s.i+1] || ':'\n" +
            "END ||\n" +
            "pg_catalog.format_type(p.proargtypes[s.i], NULL)\n" +
            "FROM\n" +
            "pg_catalog.generate_series(0,\n" +
            "pg_catalog.array_upper(p.proargtypes, 1)) AS s(i)\n" +
            "), ', ')\n" +
            "END AS \"input\"\n" +
            "FROM pg_catalog.pg_proc p\n" +
            "LEFT JOIN pg_catalog.pg_namespace n ON n.oid = p.pronamespace\n" +
            "LEFT JOIN pg_catalog.pg_language l ON l.oid = p.prolang\n" +
            "JOIN pg_catalog.pg_roles r ON r.oid = p.proowner\n" +
            "WHERE p.prorettype <> 'pg_catalog.cstring'::pg_catalog.regtype\n" +
            "AND (p.proargtypes[0] IS NULL\n" +
            "OR p.proargtypes[0] <> 'pg_catalog.cstring'::pg_catalog.regtype)\n" +
            "AND NOT p.proisagg\n" +
            "AND pg_catalog.pg_function_is_visible(p.oid)\n" +
            "AND p.proname ilike ?\n" +
            ") as t, unnest(string_to_array(input, ',')) s(param)\n" +
            ") as dt(p)";

        List<ParameterBean> parameters = new FindParameterImpl().getParameters(connection, sql, procedure.getName());

        for (ParameterBean p : parameters) {

            String dataType = p.getDtype();
            String typeName = p.getNtype();

            Integer position = p.getPosition();
            String parameterName = p.getName();
            Direction direction = new MakeDirection().getDirection(p.getDirection());

            LoggerManager.getInstance().info("[PostgreSqlSPGenerator] Process (" + position + ") " + parameterName + " " + direction + " " + dataType + " " + typeName);
            Parameter param = new PostgreSqlMakeParameter().create(dataType, position, parameterName, direction, connection, typeName, procedure);
            LoggerManager.getInstance().info("[PostgreSqlSPGenerator] Parameter (" + param.getPosition() + ") " + param.getName() + " " + param.getDirection() + " [" + param.getSqlTypeName() + "]");

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
                    throw new BusinessException("[PostgreSqlSPGenerator] ResultSet null");
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
