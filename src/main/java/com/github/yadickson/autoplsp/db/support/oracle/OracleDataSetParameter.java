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

import com.github.yadickson.autoplsp.db.ConstantTypes;
import com.github.yadickson.autoplsp.db.common.Direction;
import com.github.yadickson.autoplsp.db.common.Procedure;
import com.github.yadickson.autoplsp.db.parameter.DataSetParameter;

/**
 * Oracle Dataset parameter class
 *
 * @author Yadickson Soto
 */
public class OracleDataSetParameter extends DataSetParameter {

    static final long serialVersionUID = 1;

    /**
     * Class constructor
     *
     * @param position The parameter position
     * @param name The parameter name
     * @param prefix The prefix
     * @param procedure The procedure
     * @param sqlNativeTypeName The sql native type name.
     */
    public OracleDataSetParameter(
            final int position,
            final String name,
            final String prefix,
            final Procedure procedure,
            final String sqlNativeTypeName
    ) {
        super(position, name, Direction.OUTPUT, prefix, procedure, "OUT", sqlNativeTypeName);
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
