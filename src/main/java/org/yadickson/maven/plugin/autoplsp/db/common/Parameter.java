package org.yadickson.maven.plugin.autoplsp.db.common;

import java.util.List;
import org.apache.commons.lang.WordUtils;

/**
 * Parameter class
 *
 * @author Yadickson Soto
 */
public abstract class Parameter implements Comparable<Parameter> {

    private final Direction direction;
    private final String name;
    private final Integer position;

    /**
     *
     * @param position
     * @param pname
     * @param pdirection
     */
    public Parameter(Integer position, String pname, Direction pdirection) {
        this.position = position;
        this.name = pname;
        this.direction = pdirection;
    }

    /**
     *
     * @return
     */
    public Direction getDirection() {
        return this.direction;
    }

    /**
     *
     * @return
     */
    public String getFieldName() {
        return WordUtils.uncapitalize(getPropertyName());
    }

    /**
     *
     * @return
     */
    public String getName() {
        return (this.name == null) ? "return" : this.name;
    }

    /**
     *
     * @return @throws Exception
     */
    public List<Parameter> getParameters() throws Exception {
        throw new Exception("Parameters not found");
    }

    /**
     *
     * @param params
     * @throws Exception
     */
    public void setParameters(List<Parameter> params) throws Exception {
        throw new Exception("Parameters not found");
    }

    /**
     *
     * @return @throws Exception
     */
    public String getJavaTypeName() throws Exception {
        throw new Exception("Java Type Name not found");
    }

    /**
     *
     * @return
     */
    public Integer getPosition() {
        return this.position;
    }

    /**
     *
     * @return
     */
    public String getPropertyName() {
        return WordUtils.capitalizeFully(getName(), new char[]{'_'}).replaceAll("_", "");
    }

    /**
     *
     * @return
     */
    public boolean isInput() {
        return this.direction == Direction.Input || this.direction == Direction.InputOutput;
    }

    /**
     *
     * @return
     */
    public boolean isOutput() {
        return this.direction == Direction.Output || this.direction == Direction.InputOutput;
    }

    /**
     *
     * @return
     */
    public boolean isNumber() {
        return false;
    }

    /**
     *
     * @return
     */
    public boolean isString() {
        return false;
    }

    /**
     *
     * @return
     */
    public boolean isResultSet() {
        return false;
    }

    /**
     *
     * @return
     */
    public boolean isObject() {
        return false;
    }

    /**
     *
     * @return
     */
    public boolean isArray() {
        return false;
    }

    /**
     *
     * @return @throws Exception
     */
    public String getObjectName() throws Exception {
        throw new Exception("Object Name not found");
    }

    /**
     *
     * @return
     */
    public abstract int getSqlType();

    /**
     *
     * @return
     */
    public abstract String getSqlTypeName();

    @Override
    public int compareTo(Parameter o) {
        return position.compareTo(o.position);
    }

}
