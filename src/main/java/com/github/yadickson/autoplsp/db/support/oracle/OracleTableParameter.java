/*
 * Copyright (C) 2019 Yadickson Soto
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

import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;

import com.github.yadickson.autoplsp.db.bean.ParameterBean;
import com.github.yadickson.autoplsp.db.common.Direction;
import com.github.yadickson.autoplsp.db.common.Parameter;
import com.github.yadickson.autoplsp.db.common.Procedure;
import com.github.yadickson.autoplsp.db.util.FindParameterImpl;
import com.github.yadickson.autoplsp.handler.BusinessException;
import com.github.yadickson.autoplsp.logger.LoggerManager;
import com.github.yadickson.autoplsp.util.CapitalizeUtil;

/**
 * Oracle Table (Array) parameter class
 *
 * @author Yadickson Soto
 */
public class OracleTableParameter extends Parameter {

    static final long serialVersionUID = 1;

    private final List<Parameter> parameters = new ArrayList<Parameter>();
    private final String objectName;
    private final String objectSuffix;
    private final String arraySuffix;
    
    /**
     * Class constructor.
     *
     * @param position The parameter position
     * @param name The parameter name
     * @param direction Parameter direction
     * @param prefix The prefix
     * @param procedure Procedure
     * @param connection Database connection
     * @param typeName Particular parameter type name
     * @param objectSuffix Object suffix name
     * @param arraySuffix Array suffix name
     * @param sqlNativeDirection The sql native direction.
     * @throws BusinessException If create parameter process throws an error
     */
    public OracleTableParameter(
            final int position,
            final String name,
            final Direction direction,
            final String prefix,
            final Procedure procedure,
            final Connection connection,
            final String typeName,
            final String objectSuffix,
            final String arraySuffix,
            final String sqlNativeDirection)
            throws BusinessException {
        super(position, name, direction, prefix, procedure, sqlNativeDirection, typeName);
        this.objectName = typeName;
        this.objectSuffix = objectSuffix;
        this.arraySuffix = arraySuffix;
        addParameters(procedure, connection, typeName);
    }

    /**
     * Getter parameter list
     *
     * @return the parameter list
     */
    @Override
    public List<Parameter> getParameters() {
        return this.parameters;
    }

    /**
     * Getter the sql type
     *
     * @return The sql type
     */
    @Override
    public int getSqlType() {
        return java.sql.Types.ARRAY;
    }

    /**
     * Getter the sql type name
     *
     * @return the sql type name
     */
    @Override
    public String getSqlTypeName() {
        return "oracle.jdbc.OracleTypes.ARRAY";
    }

    /**
     * Method to know if parameter is table (array).
     *
     * @return true if table (array)
     */
    @Override
    public boolean isArray() {
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

    /**
     * Getter the java type name
     *
     * @return The java type name
     */
    @Override
    public String getJavaTypeName() {
        return getObjectName() + arraySuffix;
    }

    private void addParameters(Procedure procedure, Connection connection, String typeName) throws BusinessException {

        String sql = "select (CASE WHEN ELEM_TYPE_OWNER IS NOT NULL THEN 'OBJECT' ELSE ELEM_TYPE_NAME END) AS DTYPE, ELEM_TYPE_NAME AS NAME from ALL_COLL_TYPES WHERE OWNER=USER and TYPE_NAME = ?";
        List<ParameterBean> list = new FindParameterImpl().getParameters(connection, sql, new Object[]{typeName});

        for (ParameterBean p : list) {

            String dataType = p.getDtype();
            String parameterName = p.getName();

            LoggerManager.getInstance().info("[OracleArrayParameter] type: " + dataType + " name: " + parameterName);
            parameters.add(new OracleMakeParameter().create(dataType, 0, "Value", Direction.INPUT, "IN", connection, parameterName, procedure, objectSuffix, arraySuffix));
        }
    }
}
