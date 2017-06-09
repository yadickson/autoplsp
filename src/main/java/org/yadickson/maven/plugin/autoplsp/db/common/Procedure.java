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
package org.yadickson.maven.plugin.autoplsp.db.common;

import java.util.ArrayList;
import java.util.List;
import org.yadickson.maven.plugin.autoplsp.util.CapitalizeUtil;

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
     * @param parameters
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
     *
     * @return
     */
    public String getClassName() {
        return CapitalizeUtil.capitalize(this.name);
    }

    /**
     *
     * @return
     */
    public boolean getHasInput() {
        return !inputParameters.isEmpty();
    }

    /**
     *
     * @return
     */
    public boolean getHasOutput() {
        return !outputParameters.isEmpty();
    }

    /**
     *
     * @return
     */
    public boolean getHasPackage() {
        return this.packageName != null;
    }

    /**
     * Permite conocer si el procedimiento posee un result set
     *
     * @return verdadero si posee un result set
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
     * Permite conocer si el procedimiento posee un objeto
     *
     * @return verdadero si posee un objeto
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
     *
     * @return
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
     *
     * @return
     */
    public String getLowerName() {
        return this.name.toLowerCase();
    }

    /**
     *
     * @return
     */
    public String getName() {
        return this.name;
    }

    /**
     *
     * @return
     */
    public String getPackageName() {
        return this.packageName;
    }

    /**
     *
     * @return
     */
    public List<Parameter> getParameters() {
        return this.parameters;
    }

    /**
     *
     * @return @throws Exception
     */
    public Parameter getRetorno() throws Exception {
        if (!this.isFunction()) {
            throw new Exception("No tiene retorno");
        }

        return this.getParameters().get(0);
    }

    /**
     *
     * @return
     */
    public String getFullName() {
        return (getHasPackage() ? getPackageName() + "." : "") + getName();
    }

    /**
     * @return the inputParameters
     */
    public List<Parameter> getInputParameters() {
        return inputParameters;
    }

    /**
     * @return the outputParameters
     */
    public List<Parameter> getOutputParameters() {
        return outputParameters;
    }

    /**
     *
     * @return false
     */
    public boolean isFunction() {
        return false;
    }
}
