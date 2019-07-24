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

package ${javaPackage}.table.column;

import ${javaPackage}.table.column.type.FieldType;

/**
 * Class definition for ${table.name} - ${field.name}.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
public interface ${table.propertyName}${field.propertyName} {

    /**
     * @return the type
     */
    FieldType getType();

    /**
     * @return the position
     */
    int getPosition();
<#if field.maxSize??>

    /**
     * @return the minSize
     */
    int getMinSize();
<#if field.charUsed??>
<#if field.charUsed == 'BYTE' >

    /**
     * @return the maxByteSize
     */
    int getMaxByteSize();
<#elseif field.charUsed == 'CHAR'>

    /**
     * @return the maxCharSize
     */
    int getMaxCharSize();
</#if>
<#elseif field.type == 'NUMERIC'>

    /**
     * @return the maxSize
     */
    int getMaxSize();

    /**
     * @return the maxNumberValue
     */
    Long getMaxNumberValue();

    /**
     * @return the scale
     */
    int getScale();
</#if>
</#if>

    /**
     * @return the notNull
     */
    Boolean getNotNull();
<#if field.defaultValue?? && field.type == 'STRING' && field.type == 'NUMERIC'>

    /**
     * @return the defaultValue
     */
    <#if field.type == 'STRING'>String<#elseif field.type == 'NUMERIC'>Number<#elseif field.type == 'DATE'>java.lang.Date<#else>Object</#if> getDefaultValue();
</#if>
}
