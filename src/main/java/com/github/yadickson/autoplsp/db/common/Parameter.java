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
package com.github.yadickson.autoplsp.db.common;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import com.github.yadickson.autoplsp.util.CapitalizeUtil;

/**
 * Parameter class
 *
 * @author Yadickson Soto
 */
public abstract class Parameter implements Serializable {

    static final long serialVersionUID = 1;

    private final Direction direction;
    private final String name;
    private final Integer position;
    private final String parent;
    private final String prefix;
    private final String sqlNativeDirection;
    private final String sqlNativeTypeName;
    private final List<Parameter> parameters;

    /**
     * Class constructor.
     *
     * @param position The parameter position
     * @param name The parameter name
     * @param direction The parameter direction
     * @param prefix prefix value
     * @param procedure The procedure parent
     * @param sqlNativeDirection The sql native direction.
     * @param sqlNativeTypeName The sql native type name.
     */
    public Parameter(
            final Integer position,
            final String name,
            final Direction direction,
            final String prefix,
            final Procedure procedure,
            final String sqlNativeDirection,
            final String sqlNativeTypeName
    ) {
        this.position = position;
        this.name = name;
        this.direction = direction;
        this.prefix = prefix;
        this.parent = procedure == null ? "" : procedure.getFullName();
        this.sqlNativeDirection = sqlNativeDirection;
        this.sqlNativeTypeName = sqlNativeTypeName;
        this.parameters = new ArrayList<Parameter>();
    }

    /**
     * Getter direction.
     *
     * @return the direction
     */
    public Direction getDirection() {
        return this.direction;
    }

    /**
     * Getter field name.
     *
     * @return the field name
     */
    public String getFieldName() {
        return CapitalizeUtil.uncapitalize(getName());
    }

    /**
     * Getter parameter name.
     *
     * @return the parameter name
     */
    public String getName() {
        return this.name;
    }

    /**
     * Getter parameter list.
     *
     * @return the parameter list
     */
    public List<Parameter> getParameters() {
        return this.parameters;
    }

    /**
     * Setter parameter list.
     *
     * @param params The new parameter list
     */
    public void setParameters(final List<Parameter> params) {
        this.parameters.clear();
        this.parameters.addAll(params);
    }

    /**
     * Getter position.
     *
     * @return the parameter position
     */
    public Integer getPosition() {
        return this.position;
    }

    /**
     * Getter property name (The name capitalized).
     *
     * @return the property name
     */
    public String getPropertyName() {
        return CapitalizeUtil.capitalize(getName());
    }

    /**
     * Getter java type file name (The name uncapitalize).
     *
     * @return the property name
     */
    public String getJavaTypeFieldName() {
        return CapitalizeUtil.uncapitalize(getJavaTypeName());
    }

    /**
     * Getter parent name.
     *
     * @return the parent
     */
    public String getParent() {
        return parent;
    }

    /**
     * Method to know if parameter is input.
     *
     * @return true if direction is input
     */
    public boolean isInput() {
        return this.direction == Direction.INPUT || this.direction == Direction.INPUT_OUTPUT;
    }

    /**
     * Method to know if parameter is output.
     *
     * @return true if direction is output
     */
    public boolean isOutput() {
        return this.direction == Direction.OUTPUT || this.direction == Direction.INPUT_OUTPUT;
    }

    /**
     * Method to know if parameter is input.
     *
     * @return true if direction is input
     */
    public boolean isInputOutput() {
        return this.direction == Direction.INPUT_OUTPUT;
    }

    /**
     * Method to know if parameter is number.
     *
     * @return true if number
     */
    public boolean isNumber() {
        return false;
    }

    /**
     * Method to know if parameter is string.
     *
     * @return true if string
     */
    public boolean isString() {
        return false;
    }

    /**
     * Method to know if parameter is boolean.
     *
     * @return true if boolean
     */
    public boolean isBoolean() {
        return false;
    }

    /**
     * Method to know if parameter is date.
     *
     * @return true if date
     */
    public boolean isDate() {
        return false;
    }

    /**
     * Getter if parameter has dates.
     *
     * @return true if parameter has dates.
     */
    public boolean hasDate() {

        for (Parameter parameter : getParameters()) {
            if (parameter.isDate() || parameter.hasDate()) {
                return true;
            }
        }

        return false;
    }

    /**
     * Method to know if parameter is clob.
     *
     * @return true if date
     */
    public boolean isClob() {
        return false;
    }

    /**
     * Getter if parameter has clobs.
     *
     * @return true if parameter has clobs.
     */
    public boolean hasClob() {

        for (Parameter parameter : getParameters()) {
            if (parameter.isClob() || parameter.hasClob()) {
                return true;
            }
        }

        return false;
    }

    /**
     * Method to know if parameter is blob.
     *
     * @return true if date
     */
    public boolean isBlob() {
        return false;
    }

    /**
     * Getter if parameter has blobs.
     *
     * @return true if parameter has blobs.
     */
    public boolean hasBlob() {

        for (Parameter parameter : getParameters()) {
            if (parameter.isBlob() || parameter.hasBlob()) {
                return true;
            }
        }

        return false;
    }

    /**
     * Method to know if parameter is void.
     *
     * @return true if boolean
     */
    public boolean isVoid() {
        return false;
    }

    /**
     * Method to know if parameter is result set or cursor.
     *
     * @return true if result set
     */
    public boolean isResultSet() {
        return false;
    }

    /**
     * Method to know if parameter is object.
     *
     * @return true if object
     */
    public boolean isObject() {
        return false;
    }

    /**
     * Getter if parameter has objects.
     *
     * @return true if parameter has objects.
     */
    public boolean hasObject() {

        for (Parameter parameter : getParameters()) {
            if (parameter.isObject() || parameter.hasObject()) {
                return true;
            }
        }

        return false;
    }

    /**
     * Method to know if parameter is table (array).
     *
     * @return true if table
     */
    public boolean isArray() {
        return false;
    }

    /**
     * Getter if parameter has arrays.
     *
     * @return true if parameter has arrays.
     */
    public boolean hasArray() {

        for (Parameter parameter : getParameters()) {
            if (parameter.isArray() || parameter.hasArray()) {
                return true;
            }
        }

        return false;
    }

    /**
     * Getter the object database name.
     *
     * @return the object name
     */
    public String getObjectName() {
        return null;
    }

    /**
     * Getter prefix variable name.
     *
     * @return prefix
     */
    public String getPrefix() {
        return prefix;
    }

    /**
     * Getter if parameter use SqlInOut or ResultSet.
     *
     * @return always false
     */
    public boolean isReturnResultSet() {
        return false;
    }

    /**
     * Getter the java type name.
     *
     * @return The java type name
     */
    public abstract String getJavaTypeName();

    /**
     * Getter the sql type.
     *
     * @return The sql type
     */
    public abstract int getSqlType();

    /**
     * Getter the sql type name.
     *
     * @return the sql type name
     */
    public abstract String getSqlTypeName();

    /**
     * @return the sqlNativeDirection
     */
    public String getSqlNativeDirection() {
        return sqlNativeDirection;
    }

    /**
     * @return the sqlNativeTypeName
     */
    public String getSqlNativeTypeName() {
        return sqlNativeTypeName;
    }

}
