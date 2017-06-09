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
package org.yadickson.maven.plugin.autoplsp.db;

import org.yadickson.maven.plugin.autoplsp.db.common.Direction;

/**
 * Make direction parameter class fron string value
 *
 * @author Yadickson Soto
 */
public class MakeDirection {

    /**
     * Make direction fron string value
     *
     * @param value Direction string value
     * @return direction value
     * @throws Exception If the direction value is not supported
     */
    public Direction getDirection(String value) throws Exception {
        if (value == null) {
            throw new Exception("Direction is null");
        }

        if (value.equalsIgnoreCase("IN")) {
            return Direction.Input;
        }

        if (value.equalsIgnoreCase("OUT")) {
            return Direction.Output;
        }

        if (value.equalsIgnoreCase("IN/OUT")) {
            return Direction.InputOutput;
        }

        throw new Exception("Direction [" + value + "] not implement");
    }

}
