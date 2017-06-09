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
package org.yadickson.maven.plugin.autoplsp.db.support.oracle.parameter;

import org.yadickson.maven.plugin.autoplsp.db.common.Direction;
import org.yadickson.maven.plugin.autoplsp.db.common.Parameter;
import org.yadickson.maven.plugin.autoplsp.logger.LoggerManager;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import org.yadickson.maven.plugin.autoplsp.util.CapitalizeUtil;

/**
 * Clase para la representacion de un tipo de objeto de oracle
 *
 * @author Yadickson Soto
 */
public class OracleObjectParameter extends Parameter {

    private List<Parameter> parameters;
    private final String objectName;

    /**
     *
     * @param position
     * @param pname
     * @param direction
     * @param connection
     * @param typeName
     * @throws Exception
     */
    public OracleObjectParameter(int position, String pname, Direction direction, Connection connection, String typeName) throws Exception {
        super(position, pname, direction);
        this.objectName = typeName;
        addParameters(connection, typeName);
    }

    /**
     *
     * @return @throws Exception
     */
    @Override
    public List<Parameter> getParameters() throws Exception {
        return parameters;
    }

    /**
     *
     * @return
     */
    @Override
    public String getJavaTypeName() {
        return getObjectName() + "Object";
    }

    /**
     *
     * @return
     */
    @Override
    public int getSqlType() {
        return oracle.jdbc.OracleTypes.STRUCT;
    }

    /**
     *
     * @return
     */
    @Override
    public String getSqlTypeName() {
        return "oracle.jdbc.OracleTypes.STRUCT";
    }

    /**
     *
     * @return
     */
    @Override
    public boolean isObject() {
        return true;
    }

    /**
     *
     * @return
     */
    public String getRealObjectName() {
        return objectName;
    }

    @Override
    public String getObjectName() {
        return CapitalizeUtil.capitalize(objectName);
    }

    private void addParameters(Connection connection, String typeName) throws Exception {

        if (connection == null) {
            return;
        }

        LoggerManager.getInstance().info("[OracleObjectParameter] Create object parameter " + typeName);

        PreparedStatement statement = connection.prepareStatement("SELECT ATTR_NAME, ATTR_TYPE_NAME, ATTR_NO from SYS.ALL_TYPE_ATTRS WHERE OWNER=USER AND TYPE_NAME = ? ORDER BY ATTR_NO");
        statement.setString(1, typeName);

        if (!statement.execute()) {
            throw new Exception("[OracleObjectParameter] Error find attributes from type " + typeName);
        }

        ResultSet result = statement.getResultSet();
        parameters = new ArrayList<Parameter>();

        try {
            while (result.next()) {
                String dType = result.getString("ATTR_TYPE_NAME");
                int pos = result.getInt("ATTR_NO");
                String pName = result.getString("ATTR_NAME");
                Parameter param = new OracleMakeParameter().create(dType, pos, pName, Direction.Input, connection, null);
                LoggerManager.getInstance().info("[OracleObjectParameter] (" + param.getPosition() + ") " + param.getName() + " [" + param.getSqlTypeName() + "]");
                parameters.add(param);
            }
        } catch (Exception ex) {
            throw new Exception(ex);
        } finally {
            result.close();
            statement.close();
        }
    }

}
