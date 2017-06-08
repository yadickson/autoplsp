package org.yadickson.maven.plugins.generator.db.parameter;

import org.yadickson.maven.plugins.generator.db.common.Parameter;
import org.yadickson.maven.plugins.generator.db.common.Direction;

/**
 *
 * @author Yadickson Soto
 */
public abstract class DataSetParameter extends Parameter {

    /**
     *
     * @param ppos
     * @param pname
     * @param pdirection
     */
    public DataSetParameter(int ppos, String pname, Direction pdirection) {
        super(ppos, pname, pdirection);
    }

    /**
     *
     * @return
     */
    @Override
    public boolean isResultSet() {
        return true;
    }

}
