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

import com.github.yadickson.autoplsp.handler.BusinessException;
import java.util.ArrayList;
import java.util.List;
import com.github.yadickson.autoplsp.util.CapitalizeUtil;
import java.io.Serializable;
import java.util.Collection;
import java.util.Map;
import java.util.TreeMap;

/**
 * The procedure class
 *
 * @author Yadickson Soto
 */
public class Procedure implements Serializable {

    static final long serialVersionUID = 1;

    private final Boolean addPackageName;
    private final String outParameterCode;
    private final String outParameterMessage;

    private final String name;
    private final String packageName;
    private List<Parameter> parameters;
    private final List<Parameter> inputParameters;
    private final List<Parameter> outputParameters;

    /**
     * Class constructor
     *
     * @param addPackageName flag to add package name.
     * @param packageName The package name
     * @param procedureName The procedure name
     * @param outParameterCode The output parameter code name.
     * @param outParameterMessage The output parameter message name.
     */
    public Procedure(
            final Boolean addPackageName,
            final String packageName,
            final String procedureName,
            final String outParameterCode,
            final String outParameterMessage
    ) {

        this.addPackageName = addPackageName;
        this.packageName = packageName;
        this.name = procedureName;
        this.outParameterCode = outParameterCode;
        this.outParameterMessage = outParameterMessage;

        parameters = new ArrayList<Parameter>();
        inputParameters = new ArrayList<Parameter>();
        outputParameters = new ArrayList<Parameter>();
    }

    /**
     * Setter parameter list and fill input/output parameter list too
     *
     * @param parameters all parameters
     */
    public void setParameters(List<Parameter> parameters) {
        this.parameters = parameters;

        inputParameters.clear();
        outputParameters.clear();

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
        return CapitalizeUtil.capitalize(this.addPackageName ? getFullName().replace(".", "_") : getName());
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
     * Getter is procedure has date type parameter.
     *
     * @return true is has date type parameter
     * @throws BusinessException if error
     */
    public boolean getHasDate() throws BusinessException {
        for (Parameter param : this.parameters) {
            if (param.isDate()) {
                return true;
            }

            if (param.isResultSet() || param.isReturnResultSet()) {
                for (Parameter param2 : param.getParameters()) {
                    if (param2.isDate()) {
                        return true;
                    }
                }
            }
        }

        return false;
    }

    /**
     * Getter is procedure has clob type parameter.
     *
     * @param params parameters to evaluate
     * @return true is has clob type parameter
     * @throws BusinessException if error
     */
    public boolean getHasClob(final List<Parameter> params) throws BusinessException {
        for (Parameter param : params) {
            if (param.isClob()) {
                return true;
            }
        }

        return false;
    }

    /**
     * Getter is procedure has clob type parameter.
     *
     * @return true is has clob type parameter
     * @throws BusinessException if error
     */
    public boolean getHasInputClob() throws BusinessException {
        return getHasClob(this.inputParameters);
    }

    /**
     * Getter is procedure has clob type parameter.
     *
     * @return true is has clob type parameter
     * @throws BusinessException if error
     */
    public boolean getHasOutputClob() throws BusinessException {
        return getHasClob(this.outputParameters);
    }

    /**
     * Getter is procedure has blob type parameter.
     *
     * @param params parameters to evaluate
     * @return true is has blob type parameter
     * @throws BusinessException if error
     */
    public boolean getHasBlob(final List<Parameter> params) throws BusinessException {
        for (Parameter param : params) {
            if (param.isBlob()) {
                return true;
            }
        }

        return false;
    }

    /**
     * Getter is procedure has blob type parameter.
     *
     * @return true is has blob type parameter
     * @throws BusinessException if error
     */
    public boolean getHasInputBlob() throws BusinessException {
        return getHasClob(this.inputParameters);
    }

    /**
     * Getter is procedure has blob type parameter.
     *
     * @return true is has blob type parameter
     * @throws BusinessException if error
     */
    public boolean getHasOutputBlob() throws BusinessException {
        return getHasClob(this.outputParameters);
    }

    /**
     * Getter is procedure has return result set parameter
     *
     * @return true is has return result set parameter
     */
    public boolean getReturnResultSet() {
        for (Parameter param : this.getParameters()) {
            if (param.isReturnResultSet()) {
                return true;
            }
        }

        return false;
    }

    /**
     * Getter is procedure has return void parameter
     *
     * @return true is has return void parameter
     */
    public boolean getReturVoid() {
        for (Parameter param : this.getParameters()) {
            if (param.isOutput() && param.isVoid()) {
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

    /**
     * Method to get function inline definition condition
     *
     * @return false
     */
    public boolean isFunctionInline() {
        return false;
    }

    public int getInputParameterSize() {
        return inputParameters.size();
    }

    public int getOutputParameterSize() {
        return outputParameters.size();
    }

    public boolean isCheckResult() {

        boolean hasCode = false;
        boolean hasMessage = false;

        for (Parameter parameter : outputParameters) {
            hasCode |= parameter.isNumber() && parameter.getPosition() > 0 && parameter.getName().equalsIgnoreCase(outParameterCode);
            hasMessage |= parameter.isString() && parameter.getPosition() > 0 && parameter.getName().equalsIgnoreCase(outParameterMessage);
        }

        return hasCode && hasMessage;
    }

    /**
     * Getter the array import list.
     *
     * @return the import list
     * @throws BusinessException error if not supported
     */
    public Collection<Parameter> getArrayImports() throws BusinessException {
        Map<String, Parameter> map = new TreeMap<String, Parameter>();

        for (Parameter param : getParameters()) {
            if (param.isArray()) {
                map.put(param.getJavaTypeName(), param);
            }
        }

        return map.values();
    }

    /**
     * Getter the object import list.
     *
     * @return the import list
     * @throws BusinessException error if not supported
     */
    public Collection<Parameter> getObjectImports() throws BusinessException {
        Map<String, Parameter> map = new TreeMap<String, Parameter>();

        for (Parameter param : getParameters()) {
            if (param.isObject()) {
                map.put(param.getJavaTypeName(), param);
            }
        }

        return map.values();
    }
}
