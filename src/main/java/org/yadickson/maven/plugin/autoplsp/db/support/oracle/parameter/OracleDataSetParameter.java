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

import org.yadickson.maven.plugin.autoplsp.db.common.Parameter;
import org.yadickson.maven.plugin.autoplsp.db.common.Direction;
import org.yadickson.maven.plugin.autoplsp.db.parameter.DataSetParameter;
import java.util.List;

/**
 *
 * @author Yadickson Soto
 */
public class OracleDataSetParameter extends DataSetParameter {

    private List<Parameter> parameters;
    
    /**
     *
     * @param position
     * @param pname
     */
    public OracleDataSetParameter(int position, String pname) {
        super(position, pname, Direction.Output);
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
     * @param params
     */
    @Override
    public void setParameters(List<Parameter> params) {
        this.parameters = params;
    }

    /**
     *
     * @return
     */
    @Override
    public int getSqlType() {
        return oracle.jdbc.OracleTypes.CURSOR;
    }

    /**
     *
     * @return
     */
    @Override
    public String getSqlTypeName() {
        return "oracle.jdbc.OracleTypes.CURSOR";
    }
}
