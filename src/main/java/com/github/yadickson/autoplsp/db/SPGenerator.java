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
package com.github.yadickson.autoplsp.db;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;
import java.util.TreeSet;

import org.apache.commons.lang.StringUtils;

import com.github.yadickson.autoplsp.db.bean.ParameterBean;
import com.github.yadickson.autoplsp.db.bean.ProcedureBean;
import com.github.yadickson.autoplsp.db.common.Direction;
import com.github.yadickson.autoplsp.db.common.Function;
import com.github.yadickson.autoplsp.db.common.Parameter;
import com.github.yadickson.autoplsp.db.common.Procedure;
import com.github.yadickson.autoplsp.db.util.FindParameter;
import com.github.yadickson.autoplsp.db.util.FindParameterImpl;
import com.github.yadickson.autoplsp.db.util.FindProcedureImpl;
import com.github.yadickson.autoplsp.handler.BusinessException;
import com.github.yadickson.autoplsp.logger.LoggerManager;
import com.github.yadickson.autoplsp.util.ParameterSort;
import java.sql.PreparedStatement;

/**
 * Store procedure and function generator interface
 *
 * @author Yadickson Soto
 */
public abstract class SPGenerator {

    private final String name;

    /**
     * Class constructor
     *
     * @param name sp generator name
     */
    public SPGenerator(String name) {
        this.name = name;
    }

    /**
     * Get generator name
     *
     * @return procedure list
     */
    public String getName() {
        return name;
    }

    /**
     * Method getter sql procedures
     *
     * @return sql to find procedures
     */
    public abstract String getProcedureQuery();

    /**
     * Method getter sql parameters
     *
     * @param procedure procedure
     * @return sql to find parameters
     */
    public abstract String getParameterQuery(final Procedure procedure);

    /**
     * Method getter all sql parameters objects
     *
     * @param procedure procedure
     * @return sql objects to find parameters
     */
    public abstract Object[] getParameterObjects(final Procedure procedure);

    /**
     * Method getter maker
     *
     * @return maker
     */
    public abstract MakeParameter getMakeParameter();

    /**
     * Find all procedure from database
     *
     * @param connection Database connection
     * @return procedure list
     * @throws BusinessException If error
     */
    public final List<Procedure> findProcedures(Connection connection) throws BusinessException {
        LoggerManager.getInstance().info("[SPGenerator] Find all procedure by name");

        List<Procedure> list = new ArrayList<Procedure>();

        List<ProcedureBean> procedures = new FindProcedureImpl().getProcedures(connection, getProcedureQuery());

        for (ProcedureBean p : procedures) {
            Procedure procedure = p.getType().equalsIgnoreCase("PROCEDURE") ? new Procedure(p.getPkg(), p.getName()) : new Function(p.getPkg(), p.getName(), p.getType().equalsIgnoreCase("FUNCTION_INLINE"));
            LoggerManager.getInstance().info("[SPGenerator] Found (" + p.getType() + ") " + procedure.getFullName());
            list.add(procedure);
        }

        LoggerManager.getInstance().info("[SPGenerator] Found " + list.size() + " procedures");

        return list;
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
    public void fillProcedure(
            final Connection connection,
            final Procedure procedure,
            final String objectSuffix,
            final String arraySuffix) throws BusinessException {
        LoggerManager.getInstance().info("[SPGenerator] Create store procedure " + procedure.getFullName());

        Map<Integer, Parameter> mparameters = new TreeMap<Integer, Parameter>();

        String sql = getParameterQuery(procedure);
        Object[] objects = getParameterObjects(procedure);

        MakeParameter maker = getMakeParameter();

        FindParameter find = new FindParameterImpl();

        List<ParameterBean> parameters = find.getParameters(connection, sql, objects);

        for (ParameterBean p : parameters) {

            String dataType = p.getDtype();
            String typeName = p.getNtype();

            Integer position = p.getPosition();
            String parameterName = p.getName().replaceAll("^[@\\$]", "");
            Direction direction = new MakeDirection().getDirection(p.getDirection());

            LoggerManager.getInstance().info("[SPGenerator] Process (" + position + ") " + parameterName + " " + direction + " " + dataType + " " + typeName);
            Parameter param = maker.create(dataType, position, parameterName, direction, connection, typeName, procedure, objectSuffix, arraySuffix);
            LoggerManager.getInstance().info("[SPGenerator] Parameter (" + param.getPosition() + ") " + param.getName() + " " + param.getDirection() + " [" + param.getSqlTypeName() + "]");

            mparameters.put(position, param);
        }

        List<Parameter> list = new ArrayList<Parameter>(mparameters.values());
        procedure.setParameters(list);

        boolean found = false;

        if (!procedure.isFunction()) {
            found = findRetunResultSet(maker, connection, procedure, list, objectSuffix, arraySuffix);
        }

        if (!found && procedure.isFunctionInline() && !procedure.getHasOutput()) {
            found = findRetunResultTable(maker, connection, procedure, list, objectSuffix, arraySuffix);
        }

        if (!found && procedure.getHasResultSet()) {
            findDataSetParameter(maker, connection, procedure, list, objectSuffix, arraySuffix);
        }

        Collections.sort(procedure.getParameters(), new ParameterSort());
    }

    public void findDataSetParameter(
            final MakeParameter maker,
            final Connection connection,
            final Procedure procedure,
            final List<Parameter> parameters,
            final String objectSuffix,
            final String arraySuffix) throws BusinessException {

        boolean isFunction = procedure.isFunction();

        String sql = getProcedureSql(procedure, parameters);

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

            boolean isResult = statement.execute();
            LoggerManager.getInstance().info("Has result set [" + isResult + "]");

            for (int i = 0; i < parameters.size(); i++) {

                if (!parameters.get(i).isOutput() || !parameters.get(i).isResultSet()) {
                    continue;
                }

                int position = parameters.get(i).getPosition() + (isFunction ? 1 : 0);
                LoggerManager.getInstance().info("Find resultset from position: " + position);

                ResultSet result = (ResultSet) statement.getObject(position);

                if (result == null) {
                    throw new BusinessException("[SPGenerator] ResultSet null");
                }

                parameters.get(i).setParameters(getParameters(maker, procedure, connection, result, objectSuffix, arraySuffix));
            }

        } catch (SQLException ex) {
            throw new BusinessException("", ex);
        } finally {
            try {
                if (statement != null) {
                    statement.close();
                    statement = null;
                }
            } catch (SQLException ex) {
                LoggerManager.getInstance().error(ex);
            }
        }
    }

    public boolean findRetunResultSet(
            final MakeParameter maker,
            final Connection connection,
            final Procedure procedure,
            final List<Parameter> parameters,
            final String objectSuffix,
            final String arraySuffix) throws BusinessException {

        String sql = getProcedureSql(procedure, parameters);

        CallableStatement statement = null;

        try {

            statement = connection.prepareCall(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

            for (int i = 0; i < parameters.size(); i++) {
                if (parameters.get(i).isInput()) {
                    statement.setObject(i + 1, null);
                } else {
                    statement.registerOutParameter(i + 1, parameters.get(i).getSqlType());
                }
            }

            boolean isResult = statement.execute();
            LoggerManager.getInstance().info("Has result set [" + isResult + "]");

            if (isResult) {

                int position = Integer.MIN_VALUE;
                boolean first = true;
                int index = 1;
                String pname = "return_value";

                do {

                    ResultSet result = (ResultSet) statement.getResultSet();

                    Parameter rs = maker.getReturnResultSet(position++, first ? pname : pname + "_" + index, procedure, connection, objectSuffix, arraySuffix);
                    rs.setParameters(getParameters(maker, procedure, connection, result, objectSuffix, arraySuffix));
                    parameters.add(rs);
                    procedure.setParameters(parameters);
                    first = false;
                    index++;

                } while (statement.getMoreResults());

            }

            return isResult;

        } catch (SQLException ex) {
            LoggerManager.getInstance().info(ex.getMessage());
        } finally {
            try {
                if (statement != null) {
                    statement.close();
                    statement = null;
                }
            } catch (SQLException ex) {
                LoggerManager.getInstance().error(ex);
            }
        }

        return false;
    }

    public boolean findRetunResultTable(
            final MakeParameter maker,
            final Connection connection,
            final Procedure procedure,
            final List<Parameter> parameters,
            final String objectSuffix,
            final String arraySuffix) throws BusinessException {

        String sql = getProcedureSql(procedure, parameters);

        PreparedStatement statement = null;

        try {

            statement = connection.prepareStatement(sql);

            for (int i = 0; i < parameters.size(); i++) {
                if (parameters.get(i).isInput()) {
                    statement.setObject(i + 1, null);
                }
            }

            ResultSet result = statement.executeQuery();
            LoggerManager.getInstance().info("Has result set [true]");

            if (result == null) {
                return false;
            }

            Parameter rs = maker.getReturnResultSet(0, "return_value", procedure, connection, objectSuffix, arraySuffix);
            rs.setParameters(getParameters(maker, procedure, connection, result, objectSuffix, arraySuffix));
            parameters.add(rs);
            procedure.setParameters(parameters);

            return true;

        } catch (SQLException ex) {
            LoggerManager.getInstance().info(ex.getMessage());
        } finally {
            try {
                if (statement != null) {
                    statement.close();
                    statement = null;
                }
            } catch (SQLException ex) {
                LoggerManager.getInstance().error(ex);
            }
        }

        return false;
    }

    /**
     * Getter Sql open and close keys.
     *
     * @return keys
     */
    public String[] getSqlKeys() {
        return new String[]{"{", "}"};
    }

    /**
     * Getter Sql open and close keys.
     *
     * @return keys
     */
    public String getSqlSelect() {
        return "select * from ";
    }

    public String getProcedureSql(
            final Procedure procedure,
            final List<Parameter> parameters) {
        boolean isFunction = procedure.isFunction();
        boolean isFunctionInline = procedure.isFunctionInline();
        boolean hasReturnVoid = procedure.getReturVoid();
        
        String sql = isFunctionInline ? getSqlSelect() : getSqlKeys()[0] + " call ";

        if (isFunction && !isFunctionInline && !hasReturnVoid) {
            sql += "?:= ";
        }

        sql += procedure.getFullName();
        sql += "(";

        int args = isFunction && !isFunctionInline && !hasReturnVoid ? parameters.size() - 1 : parameters.size();
        List<String> argv = new ArrayList<String>();

        for (int i = 0; i < args; i++) {
            argv.add("?");
        }

        sql += StringUtils.join(argv, ",");
        sql += ")";
        sql += isFunctionInline ? ";" : " " + getSqlKeys()[1];

        LoggerManager.getInstance().info(sql);

        return sql;
    }

    public List<Parameter> getParameters(
            final MakeParameter maker,
            final Procedure procedure,
            final Connection connection,
            final ResultSet result,
            final String objectSuffix,
            final String arraySuffix) throws BusinessException, SQLException {

        ResultSetMetaData metadata = result.getMetaData();

        List<Parameter> list = new ArrayList<Parameter>();
        Set<String> pNames = new TreeSet<String>();

        try {
            for (int j = 0; j < metadata.getColumnCount(); j++) {

                Parameter p = maker.create(metadata.getColumnTypeName(j + 1).split(" ")[0], j + 1, metadata.getColumnName(j + 1), Direction.OUTPUT, connection, null, procedure, objectSuffix, arraySuffix);

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
