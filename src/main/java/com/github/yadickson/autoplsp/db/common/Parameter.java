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
package com.github.yadickson.autoplsp.db.common;

import com.github.yadickson.autoplsp.handler.BusinessException;
import java.util.List;
import com.github.yadickson.autoplsp.util.CapitalizeUtil;

/**
 * Parameter class
 *
 * @author Yadickson Soto
 */
public abstract class Parameter {

    private final Direction direction;
    private final String name;
    private final Integer position;

    /**
     * Class constructor
     *
     * @param position The parameter position
     * @param name The parameter name
     * @param direction The parameter direction
     */
    public Parameter(Integer position, String name, Direction direction) {
        this.position = position;
        this.name = name;
        this.direction = direction;
    }

    /**
     * Getter direction
     *
     * @return the direction
     */
    public Direction getDirection() {
        return this.direction;
    }

    /**
     * Getter field name
     *
     * @return the field name
     */
    public String getFieldName() {
        return CapitalizeUtil.uncapitalize(getName());
    }

    /**
     * Getter parameter name
     *
     * @return the parameter name
     */
    public String getName() {
        return (this.name == null) ? "out_return" : this.name;
    }

    /**
     * Getter parameter list
     *
     * @return the parameter list
     * @throws BusinessException error if not supported
     */
    public List<Parameter> getParameters() throws BusinessException {
        throw new BusinessException("Parameters not found");
    }

    /**
     * Setter parameter list
     *
     * @param params The new parameter list
     * @throws BusinessException error if not supported
     */
    public void setParameters(List<Parameter> params) throws BusinessException {
        throw new BusinessException("Parameters not found");
    }

    /**
     * Getter position
     *
     * @return the parameter position
     */
    public Integer getPosition() {
        return this.position;
    }

    /**
     * Getter property name (The name capitalized)
     *
     * @return the property name
     */
    public String getPropertyName() {
        return CapitalizeUtil.capitalize(getName());
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
     * Method to know if parameter is table (array).
     *
     * @return true if table
     */
    public boolean isArray() {
        return false;
    }

    /**
     * Getter the object database name
     *
     * @return the object name
     * @throws BusinessException error if not supported
     */
    public String getObjectName() throws BusinessException {
        throw new BusinessException("Object Name not found");
    }

    /**
     * Getter the java type name
     *
     * @return The java type name
     */
    public abstract String getJavaTypeName();

    /**
     * Getter the sql type
     *
     * @return The sql type
     */
    public abstract int getSqlType();

    /**
     * Getter the sql type name
     *
     * @return the sql type name
     */
    public abstract String getSqlTypeName();

}
