package org.yadickson.maven.plugins.generator.db.parameter;

import org.yadickson.maven.plugins.generator.db.common.Direction;
import org.yadickson.maven.plugins.generator.db.common.Parameter;

/**
 *
 * @author Yadickson Soto
 */
public class DateParameter extends Parameter {

    /**
     *
     * @param ppos
     * @param pname
     * @param pdirection
     */
    public DateParameter(int ppos, String pname, Direction pdirection) {
        super(ppos, pname, pdirection);
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
