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

    private final String scale;

    private final String maxNumberValue;

    private final Boolean notNull;

    private final String defaultValue;

    private final String charUsed;

    /**
     * Class constructor.
     *
     * @param name field name.
     * @param type field type.
     * @param position field position.
     * @param minSize min size of filed.
     * @param maxSize max size of filed.
     * @param scale precision.
     * @param maxNumberValue max number value.
     * @param notNull not null flag.
     * @param defaultValue default value.
     * @param charUsed char used.
     */
    public TableField(
            final String name,
            final String type,
            final String position,
            final String minSize,
            final String maxSize,
            final String scale,
            final String maxNumberValue,
            final String notNull,
            final String defaultValue,
            final String charUsed
    ) {
        this.name = name;
        this.type = type.toUpperCase();
        this.position = position;
        this.minSize = minSize;
        this.maxSize = maxSize;
        this.scale = scale;
        this.maxNumberValue = maxNumberValue;
        this.notNull = "1".equals(notNull);
        this.defaultValue = defaultValue;
        this.charUsed = charUsed == null ? null : charUsed.toUpperCase();
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
     * @return the scale
     */
    public String getScale() {
        return scale;
    }

    /**
     * @return the maxNumberValue
     */
    public String getMaxNumberValue() {
        return maxNumberValue;
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
     * @return the charUsed
     */
    public String getCharUsed() {
        return charUsed;
    }

}
