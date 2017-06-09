package org.yadickson.maven.plugin.autoplsp.db.support.oracle.parameter;

import org.yadickson.maven.plugin.autoplsp.db.common.Direction;
import org.yadickson.maven.plugin.autoplsp.db.parameter.RowIdParameter;

/**
 *
 * @author Yadickson Soto
 */
public class OracleRowIdParameter extends RowIdParameter {

    /**
     *
     * @param position
     * @param pname
     * @param pdirection
     */
    public OracleRowIdParameter(int position, String pname, Direction pdirection) {
        super(position, pname, pdirection);
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
