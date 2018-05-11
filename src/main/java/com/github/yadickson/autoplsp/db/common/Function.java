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
package com.github.yadickson.autoplsp.db.common;

/**
 * The function class
 *
 * @author Yadickson Soto
 */
public class Function extends Procedure {

    static final long serialVersionUID = 1;

    /**
     * Class constructor
     *
     * @param packageName The package name
     * @param functionName The function name
     */
    public Function(String packageName, String functionName) {
        super(packageName, functionName);
    }

    /**
     * Method to get function definition condition
     *
     * @return true
     */
    @Override
    public boolean isFunction() {
        return true;
    }

    @Override
    public int getOutputParameterSize() {
        return super.getOutputParameterSize() + 1;
    }
}
