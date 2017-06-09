package org.yadickson.maven.plugin.autoplsp.db.parameter;

import org.yadickson.maven.plugin.autoplsp.db.common.Direction;
import org.yadickson.maven.plugin.autoplsp.db.common.Parameter;

/**
 *
 * @author Yadickson Soto
 */
public class BlobParameter extends Parameter {

    /**
     *
     * @param position
     * @param pname
     * @param pdirection
     */
    public BlobParameter(int position, String pname, Direction pdirection) {
        super(position, pname, pdirection);
    }

    /**
     *
     * @return
     */
    @Override
    public String getJavaTypeName() {
        return "java.sql.Blob";
    }

    /**
     *
     * @return
     */
    @Override
    public int getSqlType() {
        return java.sql.Types.BLOB;
    }

    /**
     *
     * @return
     */
    @Override
    public String getSqlTypeName() {
        return "java.sql.Types.BLOB";
    }
}
