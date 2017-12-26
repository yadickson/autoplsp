/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.github.yadickson.autoplsp.bean;

import java.io.Serializable;

/**
 *
 * @author Yadickson Soto
 */
@SuppressWarnings("serial")
public class ProcedureBean implements Serializable {
    
    private String pkg;
    private String name;
    private String type;

    public String getPkg() {
        return pkg;
    }

    public void setPkg(String pname) {
        this.pkg = pname;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }
}
