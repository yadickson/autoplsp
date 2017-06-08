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
    private final List<Parameter> parameters;
    private final List<Parameter> inputParameters;
    private final List<Parameter> outputParameters;

    /**
     *
     * @param ppackageName
     * @param pname
     * @param pparams
     */
    public Procedure(String ppackageName, String pname, List<Parameter> pparams) {
        this.packageName = ppackageName;
        this.name = pname;
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

    /**
     *
     * @return
     */
    public boolean isFunction() {
        if (this.parameters.isEmpty()) {
            return false;
        }

        return this.parameters.get(0).getPosition() == 0;
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
}
