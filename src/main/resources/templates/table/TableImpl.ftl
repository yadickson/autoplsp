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
package ${javaPackage}.${tableFolderName};
<#assign importList = ["org.springframework.stereotype.Component"]>
<#list table.fields as field>
<#assign importList = importList + ["${javaPackage}.${tableFolderName}.column.${table.propertyName}${field.propertyName}"]>
</#list>

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
 * Table definitions for ${table.name}.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
</#if>
@Component
final class ${table.propertyName}Impl implements ${table.propertyName} {
<#list table.fields as field>
<#if documentation>
    /**
     * Field name ${field.name}.
     */
</#if>
    private final ${table.propertyName}${field.propertyName} ${field.fieldName}${table.propertyName};

</#list>
<#if documentation>
    /**
     * Class constructor.
     *
     * ${table.propertyName}Impl
     */
</#if>
    public ${table.propertyName}Impl(${'\n'}            <#list table.fields as field>final ${table.propertyName}${field.propertyName} ${field.fieldName}<#sep>,${'\n'}            </#sep></#list>${'\n'}    ) {
<#list table.fields as field>
        this.${field.fieldName}${table.propertyName} = ${field.fieldName};
</#list>
    }

<#list table.fields as field>
<#if documentation>
    /**
     * Getter field name definination for ${field.name}.
     *
     * @return the ${field.name}.
     */
</#if>
    @Override
    public ${table.propertyName}${field.propertyName} get${field.propertyName}() {
        return ${field.fieldName}${table.propertyName};
    }

</#list>
}
