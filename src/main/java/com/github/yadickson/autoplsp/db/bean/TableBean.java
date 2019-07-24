/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.github.yadickson.autoplsp.db.bean;

import java.io.Serializable;

/**
 *
 * @author Yadickson Soto
 */
public final class TableBean implements Serializable {

    static final long serialVersionUID = 1;

    private String name;

    private String fieldname;

    private String fieldtype;

    private String fieldposition;

    private String fieldminsize;

    private String fieldmaxsize;

    private String fieldscale;

    private String fieldmaxnumbervalue;

    private String fieldnotnull;

    private String fielddefaultvalue;

    private String fieldcharused;

    /**
     * @return the name
     */
    public String getName() {
        return name;
    }

    /**
     * @param name the name to set
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * @return the fieldname
     */
    public String getFieldname() {
        return fieldname;
    }

    /**
     * @param fieldname the fieldname to set
     */
    public void setFieldname(String fieldname) {
        this.fieldname = fieldname;
    }

    /**
     * @return the fieldtype
     */
    public String getFieldtype() {
        return fieldtype;
    }

    /**
     * @param fieldtype the fieldtype to set
     */
    public void setFieldtype(String fieldtype) {
        this.fieldtype = fieldtype;
    }

    /**
     * @return the fieldposition
     */
    public String getFieldposition() {
        return fieldposition;
    }

    /**
     * @param fieldposition the fieldposition to set
     */
    public void setFieldposition(String fieldposition) {
        this.fieldposition = fieldposition;
    }

    /**
     * @return the fieldminsize
     */
    public String getFieldminsize() {
        return fieldminsize;
    }

    /**
     * @param fieldminsize the fieldminsize to set
     */
    public void setFieldminsize(String fieldminsize) {
        this.fieldminsize = fieldminsize;
    }

    /**
     * @return the fieldmaxsize
     */
    public String getFieldmaxsize() {
        return fieldmaxsize;
    }

    /**
     * @param fieldmaxsize the fieldmaxsize to set
     */
    public void setFieldmaxsize(String fieldmaxsize) {
        this.fieldmaxsize = fieldmaxsize;
    }

    /**
     * @return the fieldscale
     */
    public String getFieldscale() {
        return fieldscale;
    }

    /**
     * @param fieldscale the fieldscale to set
     */
    public void setFieldscale(String fieldscale) {
        this.fieldscale = fieldscale;
    }

    /**
     * @return the fieldmaxnumbervalue
     */
    public String getFieldmaxnumbervalue() {
        return fieldmaxnumbervalue;
    }

    /**
     * @param fieldmaxnumbervalue the fieldmaxnumbervalue to set
     */
    public void setFieldmaxnumbervalue(String fieldmaxnumbervalue) {
        this.fieldmaxnumbervalue = fieldmaxnumbervalue;
    }

    /**
     * @return the fieldnotnull
     */
    public String getFieldnotnull() {
        return fieldnotnull;
    }

    /**
     * @param fieldnotnull the fieldnotnull to set
     */
    public void setFieldnotnull(String fieldnotnull) {
        this.fieldnotnull = fieldnotnull;
    }

    /**
     * @return the fielddefaultvalue
     */
    public String getFielddefaultvalue() {
        return fielddefaultvalue;
    }

    /**
     * @param fielddefaultvalue the fielddefaultvalue to set
     */
    public void setFielddefaultvalue(String fielddefaultvalue) {
        this.fielddefaultvalue = fielddefaultvalue;
    }

    /**
     * @return the fieldcharused
     */
    public String getFieldcharused() {
        return fieldcharused;
    }

    /**
     * @param fieldcharused the fieldcharused to set
     */
    public void setFieldcharused(String fieldcharused) {
        this.fieldcharused = fieldcharused;
    }

}
