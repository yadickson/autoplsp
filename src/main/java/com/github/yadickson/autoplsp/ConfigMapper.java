/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.github.yadickson.autoplsp;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Yadickson Soto
 */
public final class ConfigMapper {

    private String procedureName;
    private String cursorName;
    private final List<String> keys = new ArrayList<String>();

    /**
     * @return the procedureName
     */
    public String getProcedureName() {
        return procedureName;
    }

    /**
     * @param procedureName the procedureName to set
     */
    public void setProcedureName(String procedureName) {
        this.procedureName = procedureName;
    }

    /**
     * @return the cursorName
     */
    public String getCursorName() {
        return cursorName;
    }

    /**
     * @param cursorName the cursorName to set
     */
    public void setCursorName(String cursorName) {
        this.cursorName = cursorName;
    }

    /**
     * @return the keys
     */
    public List<String> getKeys() {
        return keys;
    }

}
