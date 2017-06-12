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
package org.yadickson.maven.plugin.autoplsp.db.common;

import java.util.List;
import org.yadickson.maven.plugin.autoplsp.util.CapitalizeUtil;

/**
 * Parameter class
 *
 * @author Yadickson Soto
 */
public abstract class Parameter implements Comparable<Parameter> {

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
     *
     * @return
     */
    public String getName() {
        return (this.name == null) ? "out_return" : this.name;
    }

    /**
     * Getter parameter list
     *
     * @return @throws Exception error if not supported
     */
    public List<Parameter> getParameters() throws Exception {
        throw new Exception("Parameters not found");
    }

    /**
     * Setter parameter list
     *
     * @param params The new parameter list
     * @throws Exception error if not supported
     */
    public void setParameters(List<Parameter> params) throws Exception {
        throw new Exception("Parameters not found");
    }

    /**
     *
     * @return
     */
    public Integer getPosition() {
        return this.position;
    }

    /**
     *
     * @return
     */
    public String getPropertyName() {
        return CapitalizeUtil.capitalize(getName());
    }

    /**
     *
     * @return
     */
    public boolean isInput() {
        return this.direction == Direction.Input || this.direction == Direction.InputOutput;
    }

    /**
     *
     * @return
     */
    public boolean isOutput() {
        return this.direction == Direction.Output || this.direction == Direction.InputOutput;
    }

    /**
     *
     * @return
     */
    public boolean isNumber() {
        return false;
    }

    /**
     *
     * @return
     */
    public boolean isString() {
        return false;
    }

    /**
     *
     * @return
     */
    public boolean isResultSet() {
        return false;
    }

    /**
     *
     * @return
     */
    public boolean isObject() {
        return false;
    }

    /**
     *
     * @return
     */
    public boolean isArray() {
        return false;
    }

    /**
     *
     * @return @throws Exception error if not supported
     */
    public String getObjectName() throws Exception {
        throw new Exception("Object Name not found");
    }

    /**
     * Getter the java type name
     *
     * @return The java type name
     */
    public abstract String getJavaTypeName();

    /**
     *
     * @return
     */
    public abstract int getSqlType();

    /**
     *
     * @return
     */
    public abstract String getSqlTypeName();

    /**
     *
     * @param o
     * @return
     */
    @Override
    public int compareTo(Parameter o) {
        return position.compareTo(o.position);
    }

}
