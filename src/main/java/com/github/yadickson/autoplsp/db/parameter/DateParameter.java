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
import com.github.yadickson.autoplsp.db.common.Parameter;
import com.github.yadickson.autoplsp.db.common.Procedure;

/**
 * Date parameter class
 *
 * @author Yadickson Soto
 */
public class DateParameter extends Parameter {

    static final long serialVersionUID = 1;

    /**
     * Class constructor
     *
     * @param position The parameter position
     * @param name The parameter name
     * @param direction The parameter direction
     * @param prefix The prefix
     * @param procedure The procedure
     */
    public DateParameter(int position, String name, Direction direction, String prefix, Procedure procedure) {
        super(position, name, direction, prefix, procedure);
    }

    /**
     * Getter the java type name
     *
     * @return the java type name
     */
    @Override
    public String getJavaTypeName() {
        return "Date";
    }

    /**
     * Getter the sql type
     *
     * @return the sql type
     */
    @Override
    public int getSqlType() {
        return java.sql.Types.TIMESTAMP;
    }

    /**
     * Getter the sql type name
     *
     * @return the sql type name
     */
    @Override
    public String getSqlTypeName() {
        return "java.sql.Types.TIMESTAMP";
    }

    /**
     * Method to know if parameter is date.
     *
     * @return true if date
     */
    @Override
    public boolean isDate() {
        return true;
    }
}
