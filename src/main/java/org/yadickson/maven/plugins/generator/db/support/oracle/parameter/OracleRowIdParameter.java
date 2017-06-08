package org.yadickson.maven.plugins.generator.db.support.oracle.parameter;

import org.yadickson.maven.plugins.generator.db.common.Direction;
import org.yadickson.maven.plugins.generator.db.parameter.RowIdParameter;

/**
 *
 * @author Yadickson Soto
 */
public class OracleRowIdParameter extends RowIdParameter {

    /**
     *
     * @param ppos
     * @param pname
     * @param pdirection
     */
    public OracleRowIdParameter(int ppos, String pname, Direction pdirection) {
        super(ppos, pname, pdirection);
    }

    /**
     *
     * @return
     */
    @Override
    public String getJavaTypeName() {
        return "oracle.sql.ROWID";
    }
}
