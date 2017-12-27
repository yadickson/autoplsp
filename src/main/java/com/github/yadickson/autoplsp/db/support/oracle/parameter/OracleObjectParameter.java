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
package com.github.yadickson.autoplsp.db.support.oracle.parameter;

import com.github.yadickson.autoplsp.db.bean.ParameterBean;
import com.github.yadickson.autoplsp.db.common.Direction;
import com.github.yadickson.autoplsp.db.common.Parameter;
import com.github.yadickson.autoplsp.handler.BusinessException;
import com.github.yadickson.autoplsp.logger.LoggerManager;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;
import com.github.yadickson.autoplsp.util.CapitalizeUtil;

/**
 * Oracle object parameter class
 *
 * @author Yadickson Soto
 */
public class OracleObjectParameter extends Parameter {

    private final List<Parameter> parameters = new ArrayList<Parameter>();
    private final String objectName;

    /**
     * Class constructor
     *
     * @param position The parameter position
     * @param name The parameter name
     * @param direction Parameter direction
     * @param connection Database connection
     * @param typeName Particular parameter type name
     * @throws BusinessException If create psrameter process throws an error
     */
    public OracleObjectParameter(int position, String name, Direction direction, Connection connection, String typeName) throws BusinessException {
        super(position, name, direction);
        this.objectName = typeName;
        addParameters(connection, typeName);
    }

    /**
     * Getter parameter list
     *
     * @return the parameter list
     */
    @Override
    public List<Parameter> getParameters() {
        return parameters;
    }

    /**
     * Getter the java type name
     *
     * @return The java type name
     */
    @Override
    public String getJavaTypeName() {
        return getObjectName() + "Object";
    }

    /**
     * Getter the sql type
     *
     * @return The sql type
     */
    @Override
    public int getSqlType() {
        return oracle.jdbc.OracleTypes.STRUCT;
    }

    /**
     * Getter the sql type name
     *
     * @return the sql type name
     */
    @Override
    public String getSqlTypeName() {
        return "oracle.jdbc.OracleTypes.STRUCT";
    }

    /**
     * Method to know if parameter is object.
     *
     * @return true if object
     */
    @Override
    public boolean isObject() {
        return true;
    }

    /**
     * Getter the real object database name
     *
     * @return the real object name
     */
    public String getRealObjectName() {
        return objectName;
    }

    /**
     * Getter the object database name
     *
     * @return the object name
     */
    @Override
    public String getObjectName() {
        return CapitalizeUtil.capitalize(objectName);
    }

    private void addParameters(Connection connection, String typeName) throws BusinessException {

        String sql = "SELECT ATTR_NAME as name, ATTR_TYPE_NAME as dtype, ATTR_NO as position from SYS.ALL_TYPE_ATTRS WHERE OWNER=USER AND TYPE_NAME = ? ORDER BY ATTR_NO";

        List<ParameterBean> list = OracleComplexParameter.getParameters(connection, sql, typeName);

        for (ParameterBean p : list) {

            String dataType = p.getDtype();
            Integer position = p.getPosition();
            String parameterName = p.getName();

            Parameter param = new OracleMakeParameter().create(dataType, position, parameterName, Direction.Input, connection, null, null);
            LoggerManager.getInstance().info("[OracleObjectParameter] (" + param.getPosition() + ") " + param.getName() + " [" + param.getSqlTypeName() + "]");
            parameters.add(param);
        }
    }

}
