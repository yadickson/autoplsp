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
package com.github.yadickson.autoplsp.db;

import com.github.yadickson.autoplsp.db.common.Direction;
import com.github.yadickson.autoplsp.handler.BusinessException;

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
     * @throws BusinessException If the direction value is not supported
     */
    public Direction getDirection(String value) throws BusinessException {
        if (value == null) {
            throw new BusinessException("Direction is null");
        }

        if (value.equalsIgnoreCase("IN")) {
            return Direction.INPUT;
        }

        if (value.equalsIgnoreCase("OUT")) {
            return Direction.OUTPUT;
        }

        if (value.equalsIgnoreCase("IN/OUT")) {
            return Direction.INPUT_OUTPUT;
        }

        throw new BusinessException("Direction [" + value + "] not implement");
    }

}
