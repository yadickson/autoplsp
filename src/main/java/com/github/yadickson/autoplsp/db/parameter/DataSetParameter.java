/*
 * Copyright (C) 2017 Yadickson Soto
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
package com.github.yadickson.autoplsp.db.parameter;

import com.github.yadickson.autoplsp.db.common.Parameter;
import com.github.yadickson.autoplsp.db.common.Direction;
import com.github.yadickson.autoplsp.db.common.Procedure;
import com.github.yadickson.autoplsp.util.CapitalizeUtil;

/**
 * Dataset parameter class
 *
 * @author Yadickson Soto
 */
public abstract class DataSetParameter extends Parameter {

    private String hierarchyName;
    private boolean superClass;
    private boolean extend;

    /**
     * Class constructor
     *
     * @param position The parameter position
     * @param name The parameter name
     * @param direction The parameter direction
     * @param procedure The procedure
     */
    public DataSetParameter(int position, String name, Direction direction, Procedure procedure) {
        super(position, name, direction, procedure);
        this.superClass = false;
        this.extend = false;
    }

    /**
     * Method to know if parameter is result set or cursor.
     *
     * @return true if result set
     */
    @Override
    public boolean isResultSet() {
        return true;
    }

    /**
     * Getter field name
     *
     * @return the field name
     */
    public String getHierarchyFieldName() {
        return CapitalizeUtil.capitalize(getHierarchyName());
    }

    /**
     * @return the hierarchyName
     */
    public String getHierarchyName() {
        return hierarchyName;
    }

    /**
     * @param hierarchyName the hierarchyName to set
     */
    public void setHierarchyName(String hierarchyName) {
        this.hierarchyName = hierarchyName;
    }

    /**
     * @return the superClass
     */
    public boolean getSuperClass() {
        return superClass;
    }

    /**
     * @param superClass the superClass to set
     */
    public void setSuperClass(boolean superClass) {
        this.superClass = superClass;
    }

    /**
     * @return the extend
     */
    public boolean getExtend() {
        return extend;
    }

    /**
     * @param extend the extend to set
     */
    public void setExtend(boolean extend) {
        this.extend = extend;
    }

    public String getDataSetClassName() {
        return superClass ? getHierarchyFieldName() : this.getJavaTypeName();
    }
    
}
