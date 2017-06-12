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
package org.yadickson.maven.plugin.autoplsp.db.parameter;

import org.yadickson.maven.plugin.autoplsp.db.common.Direction;
import org.yadickson.maven.plugin.autoplsp.db.common.Parameter;

/**
 * Number parameter class
 *
 * @author Yadickson Soto
 */
public class NumberParameter extends Parameter {

    /**
     * Class constructor
     *
     * @param position The parameter position
     * @param name The parameter name
     * @param direction The parameter direction
     */
    public NumberParameter(int position, String name, Direction direction) {
        super(position, name, direction);
    }

    /**
     * Getter the java type name
     *
     * @return the java type name
     */
    @Override
    public String getJavaTypeName() {
        return "Number";
    }

    /**
     * Getter the sql type
     *
     * @return the sql type
     */
    @Override
    public int getSqlType() {
        return java.sql.Types.NUMERIC;
    }

    /**
     * Getter the sql type name
     *
     * @return the sql type name
     */
    @Override
    public String getSqlTypeName() {
        return "java.sql.Types.NUMERIC";
    }

    /**
     * Method to know if parameter is number.
     *
     * @return true if number
     */
    @Override
    public boolean isNumber() {
        return true;
    }
}
