/*
 * Copyright (C) 2019 Yadickson Soto
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package com.github.yadickson.autoplsp.db.common;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import com.github.yadickson.autoplsp.util.CapitalizeUtil;

/**
 * Table class
 *
 * @author Yadickson Soto
 */
public final class Table implements Serializable {

    static final long serialVersionUID = 1;

    private final String name;

    private final List<TableField> fields = new ArrayList<TableField>();
    private final String suffix;

    /**
     * Class constructor.
     *
     * @param name The parameter name
     * @param suffix the suffix
     */
    public Table(final String name, final String suffix) {
        this.name = name;
        this.suffix = suffix;
    }

    /**
     * Getter parameter name.
     *
     * @return the parameter name
     */
    public String getName() {
        return this.name;
    }

    /**
     * @return the fields
     */
    public List<TableField> getFields() {
        return fields;
    }

    /**
     * Getter field name.
     *
     * @return the field name
     */
    public String getFieldName() {
        return CapitalizeUtil.uncapitalize(getName() +  "_" + suffix);
    }

    /**
     * Getter property name (The name capitalized).
     *
     * @return the property name
     */
    public String getPropertyName() {
        return CapitalizeUtil.capitalize(getName() +  "_" + suffix);
    }

}
