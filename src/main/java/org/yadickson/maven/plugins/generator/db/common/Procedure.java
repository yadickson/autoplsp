package org.yadickson.maven.plugins.generator.db.common;

import java.util.ArrayList;
import java.util.List;
import org.apache.commons.lang.WordUtils;

/**
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
     *
     * @param ppackageName
     * @param pname
     */
    public Procedure(String ppackageName, String pname) {
        this.packageName = ppackageName;
        this.name = pname;
    }

    public void setParameters(List<Parameter> pparams) {
        this.parameters = pparams;

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
        return WordUtils.capitalizeFully(this.name, new char[]{'_'}).replaceAll("_", "");
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
     * @return
     */
    public boolean isFunction() {
        return false;
    }
}
