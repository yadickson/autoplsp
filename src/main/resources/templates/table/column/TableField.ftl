<#if header>
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
</#if>
package ${javaPackage}.${tableFolderName}.column;
<#assign importList = ["${javaPackage}.${tableFolderName}.column.type.FieldType"]>
<#if field.charUsed??>
<#if field.charUsed == 'BYTE' >
<#assign extendField = 'BinaryField'>
<#elseif field.charUsed == 'CHAR'>
<#assign extendField = 'CharacterField'>
</#if>
<#elseif field.type == 'NUMERIC'>
<#assign extendField = 'NumericField'>
<#elseif field.type == 'DATE'>
<#assign extendField = 'DateField'>
</#if>
<#if extendField??>
<#assign importList = importList + ["${javaPackage}.${tableFolderName}.column.type.${extendField}"]>
</#if>

<#list importSort(importList) as import>
<#if previousImportMatch?? && !import?starts_with(previousImportMatch)>

</#if>
import ${import};
<#assign previousImportMatch = import?keep_before_last(".") >
</#list>
<#if importList?has_content>

</#if>
<#if documentation>
/**
 * Class definition for ${table.name} - ${field.name}.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
</#if>
public interface ${table.propertyName}${field.propertyName}<#if extendField??> extends ${extendField}</#if> {

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
