package org.yadickson.maven.plugin.autoplsp.db.support.oracle.parameter;

import org.yadickson.maven.plugin.autoplsp.db.common.Parameter;
import org.yadickson.maven.plugin.autoplsp.db.common.Direction;
import org.yadickson.maven.plugin.autoplsp.db.parameter.DataSetParameter;
import java.util.List;

/**
 *
 * @author Yadickson Soto
 */
public class OracleDataSetParameter extends DataSetParameter {

    private List<Parameter> parameters;
    
    /**
     *
     * @param position
     * @param pname
     */
    public OracleDataSetParameter(int position, String pname) {
        super(position, pname, Direction.Output);
    }

    /**
     *
     * @return
     */
    @Override
    public List<Parameter> getParameters() {
        return this.parameters;
    }

    /**
     *
     * @param params
     */
    @Override
    public void setParameters(List<Parameter> params) {
        this.parameters = params;
    }

    /**
     *
     * @return
     */
    @Override
    public int getSqlType() {
        return oracle.jdbc.OracleTypes.CURSOR;
    }

    /**
     *
     * @return
     */
    @Override
    public String getSqlTypeName() {
        return "oracle.jdbc.OracleTypes.CURSOR";
    }
}
