package org.yadickson.maven.plugin.autoplsp.db.parameter;

import org.yadickson.maven.plugin.autoplsp.db.common.Direction;
import org.yadickson.maven.plugin.autoplsp.db.common.Parameter;

/**
 *
 * @author Yadickson Soto
 */
public class NumberParameter extends Parameter {

    /**
     *
     * @param position
     * @param pname
     * @param pdirection
     */
    public NumberParameter(int position, String pname, Direction pdirection) {
        super(position, pname, pdirection);
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
