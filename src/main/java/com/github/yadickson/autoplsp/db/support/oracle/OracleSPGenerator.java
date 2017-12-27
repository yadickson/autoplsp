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
import com.github.yadickson.autoplsp.db.bean.ProcedureBean;
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
import com.github.yadickson.autoplsp.db.common.Function;
import com.github.yadickson.autoplsp.db.util.FindProcedureImpl;
import com.github.yadickson.autoplsp.handler.BusinessException;
import java.sql.SQLException;
import java.util.Map;
import java.util.TreeMap;
import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.ResultSetHandler;
import org.apache.commons.dbutils.handlers.BeanListHandler;

/**
 * Oracle Store procedure and function generator class
 *
 * @author Yadickson Soto
 */
public class OracleSPGenerator implements SPGenerator {

    /**
     * Find all procedure from database
     *
     * @param connection Database connection
     * @return procedure list
     * @throws BusinessException If error
     */
    @Override
    public List<Procedure> findProcedures(Connection connection) throws BusinessException {
        LoggerManager.getInstance().info("[OracleSPGenerator] Find all procedure by name");

        List<Procedure> list = new ArrayList<Procedure>();

        String sql = "SELECT OBJECT_NAME as PKG, PROCEDURE_NAME as NAME, case when (SELECT count(position) as type FROM all_arguments WHERE OWNER=USER AND object_name = allp.PROCEDURE_NAME AND package_name = allp.OBJECT_NAME and position = 0) = 0 then 'PROCEDURE' else 'FUNCTION' end as type FROM SYS.ALL_PROCEDURES allp WHERE OWNER=USER and OBJECT_TYPE ='PACKAGE' and PROCEDURE_NAME is not null union SELECT null as PKG, OBJECT_NAME AS NAME, OBJECT_TYPE as TYPE FROM SYS.ALL_PROCEDURES WHERE OWNER=USER and (OBJECT_TYPE = 'FUNCTION' or OBJECT_TYPE='PROCEDURE')";

        List<ProcedureBean> procedures = new FindProcedureImpl().getProcedures(connection, sql);

        for (ProcedureBean p : procedures) {
            Procedure procedure = p.getType().equalsIgnoreCase("PROCEDURE") ? new Procedure(p.getPkg(), p.getName()) : new Function(p.getPkg(), p.getName());
            LoggerManager.getInstance().info("[OracleSPGenerator] Found (" + p.getType() + ") " + procedure.getFullName());
            list.add(procedure);
        }

        LoggerManager.getInstance().info("[OracleSPGenerator] Found " + list.size() + " procedures");

        return list;
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
        LoggerManager.getInstance().info("[OracleSPGenerator] Create store procedure " + procedure.getFullName());

        Map<Integer, Parameter> mparameters = new TreeMap<Integer, Parameter>();
        List<ParameterBean> parameters = null;

        QueryRunner run = new QueryRunner();
        ResultSetHandler<List<ParameterBean>> h = new BeanListHandler<ParameterBean>(ParameterBean.class);

        String sql = "SELECT argument_name as name, position, in_out as direction, data_type as dtype, type_name as ntype FROM all_arguments WHERE OWNER=USER AND object_name = ? AND (? is null OR package_name = ?) order by position asc, argument_name asc nulls first";

        try {
            parameters = run.query(connection, sql, h, procedure.getName(), procedure.getPackageName(), procedure.getPackageName());
        } catch (SQLException ex) {
            throw new BusinessException("[OracleSPGenerator] Error find parameter from procedure " + procedure.getFullName(), ex);
        }

        for (ParameterBean p : parameters) {

            String dataType = p.getDtype();
            String typeName = p.getNtype();

            Integer position = p.getPosition();
            String parameterName = p.getName();
            Direction direction = new MakeDirection().getDirection(p.getDirection());

            LoggerManager.getInstance().info("[OracleSPGenerator] Process (" + position + ") " + parameterName + " " + direction + " " + dataType + " " + typeName);
            Parameter param = new OracleMakeParameter().create(dataType, position, parameterName, direction, connection, typeName, procedure);
            LoggerManager.getInstance().info("[OracleSPGenerator] Parameter (" + param.getPosition() + ") " + param.getName() + " " + param.getDirection() + " [" + param.getSqlTypeName() + "]");

            mparameters.put(position, param);
        }

        List<Parameter> list = new ArrayList<Parameter>(mparameters.values());
        procedure.setParameters(list);

        if (procedure.getHasResultSet()) {
            findOracleDataSetParameter(connection, procedure, list);
        }

    }

    private void findOracleDataSetParameter(Connection connection, Procedure procedure, List<Parameter> parameters) throws BusinessException {

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

                ResultSetMetaData metadata = result.getMetaData();

                List<Parameter> list = new ArrayList<Parameter>();
                Set<String> pNames = new TreeSet<String>();

                try {
                    for (int j = 0; j < metadata.getColumnCount(); j++) {
                        Parameter p = new OracleMakeParameter().create(metadata.getColumnTypeName(j + 1), j + 1, metadata.getColumnName(j + 1), Direction.OUTPUT, connection, null, null);

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

                parameters.get(i).setParameters(list);
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
}
