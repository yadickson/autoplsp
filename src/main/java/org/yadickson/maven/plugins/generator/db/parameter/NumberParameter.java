package org.yadickson.maven.plugins.generator.db.parameter;

import org.yadickson.maven.plugins.generator.db.common.Direction;
import org.yadickson.maven.plugins.generator.db.common.Parameter;

/**
 *
 * @author Yadickson Soto
 */
public class NumberParameter extends Parameter {

    /**
     *
     * @param ppos
     * @param pname
     * @param pdirection
     */
    public NumberParameter(int ppos, String pname, Direction pdirection) {
        super(ppos, pname, pdirection);
    }

    /**
     *
     * @return
     */
    @Override
    public String getJavaTypeName() {
        return "Number";
    }

    /**
     *
     * @return
     */
    @Override
    public int getSqlType() {
        return java.sql.Types.NUMERIC;
    }

    /**
     *
     * @return
     */
    @Override
    public String getSqlTypeName() {
        return "java.sql.Types.NUMERIC";
    }

    /**
     *
     * @return
     */
    @Override
    public boolean isNumber() {
        return true;
    }
}
