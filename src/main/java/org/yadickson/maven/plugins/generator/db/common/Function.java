package org.yadickson.maven.plugins.generator.db.common;

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
}
