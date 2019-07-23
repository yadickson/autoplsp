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

import com.github.yadickson.autoplsp.db.common.Direction;
import com.github.yadickson.autoplsp.db.common.Procedure;
import com.github.yadickson.autoplsp.handler.BusinessException;

/**
 * Dataset parameter class
 *
 * @author Yadickson Soto
 */
public class ReturnResultSetParameter extends DataSetParameter {

    static final long serialVersionUID = 1;

    /**
     * Class constructor
     *
     * @param position The parameter position
     * @param name The parameter name
     * @param prefix The prefix
     * @param procedure The procedure
     */
    public ReturnResultSetParameter(int position, String name, String prefix, Procedure procedure) {
        super(position, name, Direction.OUTPUT, prefix, procedure);
    }

    /**
     * Method to know if parameter is result set or cursor.
     *
     * @return true if result set
     */
    @Override
    public boolean isResultSet() {
        return false;
    }

    /**
     * Getter if parameter use SqlInOut or ResultSet.
     *
     * @return always false
     */
    @Override
    public boolean isReturnResultSet() {
        return true;
    }

    /**
     * Getter the sql type.
     *
     * @return The sql type
     * @throws BusinessException if error
     */
    @Override
    public int getSqlType() throws BusinessException {
        return java.sql.Types.OTHER;
    }

    /**
     * Getter the sql type name.
     *
     * @return the sql type name
     * @throws BusinessException if error
     */
    @Override
    public String getSqlTypeName() throws BusinessException {
        return "java.sql.Types.OTHER";
    }

}
