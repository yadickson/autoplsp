/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.github.yadickson.autoplsp.db.common;

import com.github.yadickson.autoplsp.util.CapitalizeUtil;
import java.io.Serializable;

/**
 *
 * @author Yadickson Soto
 */
public final class TableField implements Serializable {

    static long serialVersionUID = 1;

    private final String name;

    private final String type;

    private final String position;

    private final String minSize;

    private final String maxSize;

    private final Boolean notNull;

    private final String defaultValue;

    /**
     * Class constructor.
     *
     * @param name field name.
     * @param type field type.
     * @param position field position.
     * @param minSize min size of filed.
     * @param maxSize max size of filed.
     * @param notNull not null flag.
     * @param defaultValue default value.
     */
    public TableField(
            final String name,
            final String type,
            final String position,
            final String minSize,
            final String maxSize,
            final String notNull,
            final String defaultValue
    ) {
        this.name = name;
        this.type = type.toUpperCase();
        this.position = position;
        this.minSize = minSize;
        this.maxSize = maxSize;
        this.notNull = "1".equals(notNull);
        this.defaultValue = defaultValue;
    }

    /**
     * @return the name
     */
    public String getName() {
        return name;
    }

    /**
     * @return the type
     */
    public String getType() {
        return type;
    }

    /**
     * @return the position
     */
    public String getPosition() {
        return position;
    }

    /**
     * @return the minSize
     */
    public String getMinSize() {
        return minSize;
    }

    /**
     * @return the maxSize
     */
    public String getMaxSize() {
        return maxSize;
    }

    /**
     * @return the notNull
     */
    public Boolean getNotNull() {
        return notNull;
    }

    /**
     * @return the defaultValue
     */
    public String getDefaultValue() {
        return defaultValue;
    }

    /**
     * Getter field name.
     *
     * @return the field name
     */
    public String getFieldName() {
        return CapitalizeUtil.uncapitalize(getName());
    }

    /**
     * Getter property name (The name capitalized).
     *
     * @return the property name
     */
    public String getPropertyName() {
        return CapitalizeUtil.capitalize(getName());
    }

}
