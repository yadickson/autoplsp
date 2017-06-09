package org.yadickson.maven.plugin.autoplsp.db.parameter;

import org.yadickson.maven.plugin.autoplsp.db.common.Direction;
import org.yadickson.maven.plugin.autoplsp.db.common.Parameter;

/**
 *
 * @author Yadickson Soto
 */
public class DateParameter extends Parameter {

    /**
     *
     * @param position
     * @param pname
     * @param pdirection
     */
    public DateParameter(int position, String pname, Direction pdirection) {
        super(position, pname, pdirection);
    }

    /**
     *
     * @return
     */
    @Override
    public String getJavaTypeName() {
        return "java.util.Date";
    }

    /**
     *
     * @return
     */
    @Override
    public int getSqlType() {
        return java.sql.Types.TIMESTAMP;
    }

    /**
     *
     * @return
     */
    @Override
    public String getSqlTypeName() {
        return "java.sql.Types.TIMESTAMP";
    }
}
