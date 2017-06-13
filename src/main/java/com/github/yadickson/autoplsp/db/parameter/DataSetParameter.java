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
package com.github.yadickson.autoplsp.db.parameter;

import com.github.yadickson.autoplsp.db.common.Parameter;
import com.github.yadickson.autoplsp.db.common.Direction;

/**
 * Dataset parameter class
 *
 * @author Yadickson Soto
 */
public abstract class DataSetParameter extends Parameter {

    /**
     * Class constructor
     *
     * @param position The parameter position
     * @param name The parameter name
     * @param direction The parameter direction
     */
    public DataSetParameter(int position, String name, Direction direction) {
        super(position, name, direction);
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

}
