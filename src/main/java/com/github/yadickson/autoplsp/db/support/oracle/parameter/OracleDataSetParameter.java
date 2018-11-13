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

import com.github.yadickson.autoplsp.db.ConstantTypes;
import com.github.yadickson.autoplsp.db.common.Parameter;
import com.github.yadickson.autoplsp.db.common.Direction;
import com.github.yadickson.autoplsp.db.common.Procedure;
import com.github.yadickson.autoplsp.db.parameter.DataSetParameter;
import java.util.List;

/**
 * Oracle Dataset parameter class
 *
 * @author Yadickson Soto
 */
public class OracleDataSetParameter extends DataSetParameter {

    static final long serialVersionUID = 1;

    private List<Parameter> parameters;

    /**
     * Class constructor
     *
     * @param position The parameter position
     * @param name The parameter name
     * @param procedure The procedure
     */
    public OracleDataSetParameter(int position, String name, Procedure procedure) {
        super(position, name, Direction.OUTPUT, procedure);
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

    /**
     * Getter the sql type
     *
     * @return The sql type
     */
    @Override
    public int getSqlType() {
        return ConstantTypes.ORACLE_CURSOR;
    }

    /**
     * Getter the sql type name
     *
     * @return the sql type name
     */
    @Override
    public String getSqlTypeName() {
        return "oracle.jdbc.OracleTypes.CURSOR";
    }
}
