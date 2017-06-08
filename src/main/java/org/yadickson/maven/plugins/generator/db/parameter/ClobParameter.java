package org.yadickson.maven.plugins.generator.db.parameter;

import org.yadickson.maven.plugins.generator.db.common.Direction;
import org.yadickson.maven.plugins.generator.db.common.Parameter;

/**
 *
 * @author Yadickson Soto
 */
public class ClobParameter extends Parameter {

    /**
     *
     * @param ppos
     * @param pname
     * @param pdirection
     */
    public ClobParameter(int ppos, String pname, Direction pdirection) {
        super(ppos, pname, pdirection);
    }

    /**
     *
     * @return
     */
    @Override
    public String getJavaTypeName() {
        return "String";
    }

    /**
     *
     * @return
     */
    @Override
    public int getSqlType() {
        return java.sql.Types.CLOB;
    }

    /**
     *
     * @return
     */
    @Override
    public String getSqlTypeName() {
        return "java.sql.Types.CLOB";
    }
}
