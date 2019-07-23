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
package com.github.yadickson.autoplsp.db.parameter;

import com.github.yadickson.autoplsp.db.common.Parameter;
import com.github.yadickson.autoplsp.db.common.Direction;
import com.github.yadickson.autoplsp.db.common.Procedure;
import com.github.yadickson.autoplsp.util.CapitalizeUtil;
import java.util.ArrayList;
import java.util.List;

/**
 * Dataset parameter class
 *
 * @author Yadickson Soto
 */
public abstract class DataSetParameter extends Parameter {

    static final long serialVersionUID = 1;

    private final String className;

    private List<Parameter> parameters = new ArrayList<Parameter>();

    /**
     * Class constructor
     *
     * @param position The parameter position
     * @param name The parameter name
     * @param direction The parameter direction
     * @param prefix The prefix
     * @param procedure The procedure
     */
    public DataSetParameter(int position, String name, Direction direction, String prefix, Procedure procedure) {
        super(position, name, direction, prefix, procedure);
        this.className = procedure.getClassName();
    }

    /**
     * Method to know if parameter is result set or cursor.
     *
     * @return true if result set
     */
    @Override
    public boolean isResultSet() {
        return true;
    }

    /**
     * Getter the java type name.
     *
     * @return The java type name
     */
    @Override
    public String getJavaTypeName() {
        return className + CapitalizeUtil.capitalize(getName()) + "RS";
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
     * Setter parameter list
     *
     * @param params The new parameter list
     */
    @Override
    public void setParameters(List<Parameter> params) {
        this.parameters = params;
    }

}
