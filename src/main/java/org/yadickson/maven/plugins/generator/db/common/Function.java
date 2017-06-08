package org.yadickson.maven.plugins.generator.db.common;

import java.util.List;

/**
 * The function class
 *
 * @author Yadickson Soto
 */
public class Function extends Procedure {

    /**
     * Class constructor
     *
     * @param packageName The package name
     * @param functionName The function name
     * @param params The parameter list
     */
    public Function(String packageName, String functionName, List<Parameter> params) {
        super(packageName, functionName, params);
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
}
