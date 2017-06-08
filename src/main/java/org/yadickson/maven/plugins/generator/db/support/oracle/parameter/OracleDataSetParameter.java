package org.yadickson.maven.plugins.generator.db.support.oracle.parameter;

import org.yadickson.maven.plugins.generator.db.common.Parameter;
import org.yadickson.maven.plugins.generator.db.common.Direction;
import org.yadickson.maven.plugins.generator.db.parameter.DataSetParameter;
import java.util.List;

/**
 *
 * @author Yadickson Soto
 */
public class OracleDataSetParameter extends DataSetParameter {

    private List<Parameter> parameters;
    
    /**
     *
     * @param ppos
     * @param pname
     */
    public OracleDataSetParameter(int ppos, String pname) {
        super(ppos, pname, Direction.Output);
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
