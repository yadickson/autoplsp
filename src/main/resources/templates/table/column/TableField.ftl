<#if header>/*
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
</#if>
package ${javaPackage}.table.column;

import ${javaPackage}.table.column.type.FieldType;

<#if documentation>
/**
 * Class definition for ${table.name} - ${field.name}.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
</#if>
public interface ${table.propertyName}${field.propertyName} <#if field.charUsed??><#if field.charUsed == 'BYTE' >extends ${javaPackage}.table.column.type.BinaryField <#elseif field.charUsed == 'CHAR'>extends ${javaPackage}.table.column.type.CharacterField </#if><#elseif field.type == 'NUMERIC'>extends ${javaPackage}.table.column.type.NumericField <#elseif field.type == 'DATE'>extends ${javaPackage}.table.column.type.DateField </#if>{

<#if documentation>
    /**
     * @return the type
     */
</#if>
    FieldType getType();

<#if documentation>
    /**
     * @return the position
     */
</#if>
    int getPosition();

}
