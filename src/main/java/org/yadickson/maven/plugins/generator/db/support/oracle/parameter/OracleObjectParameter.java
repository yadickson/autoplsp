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
 * Clase para la representacion de un tipo de objeto de oracle
 *
 * @author Yadickson Soto
 */
public class OracleObjectParameter extends Parameter {

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
    public OracleObjectParameter(int ppos, String pname, Direction direction, Connection connection, String typeName) throws Exception {
        super(ppos, pname, direction);
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

    public String getRealObjectName() {
        return objectName;
    }

    @Override
    public String getObjectName() {
        return WordUtils.capitalizeFully(objectName, new char[]{'_'}).replaceAll("_", "");
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
