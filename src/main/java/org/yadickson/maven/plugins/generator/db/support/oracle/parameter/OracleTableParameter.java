/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.yadickson.maven.plugins.generator.db.support.oracle.parameter;

import org.yadickson.maven.plugins.generator.db.common.Direction;
import org.yadickson.maven.plugins.generator.db.common.Parameter;
import org.yadickson.maven.plugins.generator.logger.LoggerManager;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import org.apache.commons.lang.WordUtils;

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
     * @param ppos
     * @param pname
     * @param direction
     * @param connection
     * @param typeName
     * @throws Exception
     */
    public OracleTableParameter(int ppos, String pname, Direction direction, Connection connection, String typeName) throws Exception {
        super(ppos, pname, direction);
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

    public String getRealObjectName() {
        return objectName;
    }

    @Override
    public String getObjectName() {
        return WordUtils.capitalizeFully(objectName, new char[]{'_'}).replaceAll("_", "");
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
