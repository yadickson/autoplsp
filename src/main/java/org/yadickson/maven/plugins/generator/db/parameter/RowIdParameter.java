package org.yadickson.maven.plugins.generator.db.parameter;

import org.yadickson.maven.plugins.generator.db.common.Parameter;
import org.yadickson.maven.plugins.generator.db.common.Direction;

/**
 *
 * @author Yadickson Soto
 */
public abstract class RowIdParameter extends Parameter {

    /**
     *
     * @param ppos
     * @param pname
     * @param pdirection
     */
    public RowIdParameter(int ppos, String pname, Direction pdirection) {
        super(ppos, pname, pdirection);
    }

    /**
     *
     * @return
     */
    @Override
    public int getSqlType() {
        return java.sql.Types.OTHER;
    }

    /**
     *
     * @return
     */
    @Override
    public String getSqlTypeName() {
        return "java.sql.Types.OTHER";
    }
}
