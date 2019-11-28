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
package com.github.yadickson.autoplsp.db.common;

/**
 * The function class
 *
 * @author Yadickson Soto
 */
public class Function extends Procedure {
    
    static final long serialVersionUID = 1;
    
    private final Boolean functionInline;

    /**
     * Class constructor
     *
     * @param addPackageName Flag add package name.
     * @param packageName The package name
     * @param functionName The function name
     * @param functionInline The flag to function inline
     * @param outParameterCode The output parameter code name.
     * @param outParameterMessage The output parameter message name.
     */
    public Function(
            final Boolean addPackageName,
            final String packageName,
            final String functionName,
            final String outParameterCode,
            final String outParameterMessage,
            final Boolean functionInline) {
        super(addPackageName, packageName, functionName, outParameterCode, outParameterMessage);
        this.functionInline = functionInline;
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

    /**
     * Method to get function inline definition condition
     *
     * @return false
     */
    @Override
    public boolean isFunctionInline() {
        return functionInline;
    }
    
    @Override
    public int getOutputParameterSize() {
        return super.getOutputParameterSize() + 1;
    }
}
