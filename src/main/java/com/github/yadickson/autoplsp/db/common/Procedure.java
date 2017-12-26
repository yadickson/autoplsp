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

import java.util.ArrayList;
import java.util.List;
import com.github.yadickson.autoplsp.util.CapitalizeUtil;

/**
 * The procedure class
 *
 * @author Yadickson Soto
 */
public class Procedure {

    private final String name;
    private final String packageName;
    private List<Parameter> parameters;
    private List<Parameter> inputParameters;
    private List<Parameter> outputParameters;

    /**
     * Class constructor
     *
     * @param packageName The package name
     * @param procedureName The procedure name
     */
    public Procedure(String packageName, String procedureName) {
        this.packageName = packageName;
        this.name = procedureName;
    }

    /**
     * Setter parameter list and fill input/output parameter list too
     *
     * @param parameters all parameters
     */
    public void setParameters(List<Parameter> parameters) {
        this.parameters = parameters;

        inputParameters = new ArrayList<Parameter>();
        outputParameters = new ArrayList<Parameter>();

        for (Parameter p : parameters) {
            if (p.isInput()) {
                inputParameters.add(p);
            }
            if (p.isOutput()) {
                outputParameters.add(p);
            }
        }
    }

    /**
     * Getter is procedure has package name
     *
     * @return true is package name is not null
     */
    public boolean getHasPackage() {
        return this.packageName != null;
    }

    /**
     * Getter class name capitalized
     *
     * @return the class name capitalized
     */
    public String getClassName() {
        return CapitalizeUtil.capitalize(getFullName().replace(".", "_"));
    }

    /**
     * Getter is procedure has input parameter
     *
     * @return true is has input parameter
     */
    public boolean getHasInput() {
        return !inputParameters.isEmpty();
    }

    /**
     * Getter is procedure has output parameter
     *
     * @return true is has output parameter
     */
    public boolean getHasOutput() {
        return !outputParameters.isEmpty();
    }

    /**
     * Getter is procedure has result set parameter
     *
     * @return true is has result set parameter
     */
    public boolean getHasResultSet() {
        for (Parameter param : this.getParameters()) {
            if (param.isResultSet()) {
                return true;
            }
        }

        return false;
    }

    /**
     * Getter is procedure has object parameter
     *
     * @return true is has object parameter
     */
    public boolean getHasObject() {
        for (Parameter param : this.getParameters()) {
            if (param.isObject()) {
                return true;
            }
        }

        return false;
    }

    /**
     * Getter is procedure has table (array) parameter
     *
     * @return true is has table (array) parameter
     */
    public boolean getHasArray() {
        for (Parameter param : this.parameters) {
            if (param.isArray()) {
                return true;
            }
        }

        return false;
    }

    /**
     * Getter procedure name
     *
     * @return the name
     */
    public String getName() {
        return this.name;
    }

    /**
     * Getter procedure package name
     *
     * @return the package name
     */
    public String getPackageName() {
        return this.packageName;
    }

    /**
     * Getter procedure parameter list
     *
     * @return the parameter list
     */
    public List<Parameter> getParameters() {
        return this.parameters;
    }

    /**
     * Getter procedure full name (package name and procedure name)
     *
     * @return the full name
     */
    public String getFullName() {
        return (getHasPackage() ? getPackageName() + "." : "") + getName();
    }

    /**
     * Getter the input parameters
     *
     * @return the inputParameters
     */
    public List<Parameter> getInputParameters() {
        return inputParameters;
    }

    /**
     * Getter the output parameters
     *
     * @return the outputParameters
     */
    public List<Parameter> getOutputParameters() {
        return outputParameters;
    }

    /**
     * Method to get function definition condition
     *
     * @return false
     */
    public boolean isFunction() {
        return false;
    }
    
    public int getInputParameterSize() {
        return inputParameters.size();
    }
    
    public int getOutputParameterSize() {
        return outputParameters.size();
    }
}
