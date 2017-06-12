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
 * Implementacion para soporte de tipo de datos Table
 *
 * @author Yadickson Soto
 */
public class OracleTableParameter extends Parameter {

    private List<Parameter> parameters;
    private final String objectName;

    /**
     *
     * @param position The parameter position
     * @param name The parameter name
     * @param direction
     * @param connection
     * @param typeName
     * @throws Exception
     */
    public OracleTableParameter(int position, String name, Direction direction, Connection connection, String typeName) throws Exception {
        super(position, name, direction);
        this.objectName = typeName;
        addParameters(connection, typeName);
    }

    /**
     *
     * @return
     */
    @Override
    public List<Parameter> getParameters() {
        return this.parameters;
    }

    /**
     *
     * @return
     */
    @Override
    public int getSqlType() {
        return oracle.jdbc.OracleTypes.ARRAY;
    }

    /**
     *
     * @return
     */
    @Override
    public String getSqlTypeName() {
        return "oracle.jdbc.OracleTypes.ARRAY";
    }

    /**
     *
     * @return
     */
    @Override
    public boolean isArray() {
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

    /**
     *
     * @return
     */
    @Override
    public String getJavaTypeName() {
        return getObjectName() + "Table";
    }

    private void addParameters(Connection connection, String typeName) throws Exception {

        if (connection == null) {
            return;
        }

        LoggerManager.getInstance().info("[OracleArrayParameter] Create object parameter " + typeName);

        PreparedStatement statement = connection.prepareStatement("select (CASE WHEN ELEM_TYPE_OWNER IS NOT NULL THEN 'OBJECT' ELSE ELEM_TYPE_NAME END) AS TYPE, ELEM_TYPE_NAME AS NAME from SYS.ALL_COLL_TYPES WHERE OWNER=USER and TYPE_NAME = ?");
        statement.setString(1, typeName);

        if (!statement.execute()) {
            throw new Exception("[OracleArrayParameter] Error find attributes from type " + typeName);
        }

        ResultSet result = statement.getResultSet();
        parameters = new ArrayList<Parameter>();

        try {
            if (result.next()) {
                String dType = result.getString("TYPE");
                String pName = result.getString("NAME");

                LoggerManager.getInstance().info("[OracleArrayParameter] type: " + dType + " name: " + pName);
                parameters.add(new OracleMakeParameter().create(dType, 0, "Value", Direction.Input, connection, pName));
            }
        } catch (Exception ex) {
            throw new Exception(ex);
        } finally {
            result.close();
            statement.close();
        }
    }

}
