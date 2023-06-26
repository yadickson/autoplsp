<#if documentation>
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
</#if>
package ${javaPackage}.${objectFolderName};
<#assign importList = []>
<#list parameter.parameters as parameter2>
<#if parameter2.date>
<#assign importList = importList + ["java.util.Date"]>
<#if fullConstructor && utilFolderName != objectFolderName>
<#assign importList = importList + ["${javaPackage}.${utilFolderName}.${prefixUtilityName}SafeDate"]>
</#if>
</#if>
<#if parameter2.blob>
<#if fullConstructor && utilFolderName != objectFolderName>
<#assign importList = importList + ["${javaPackage}.${utilFolderName}.${prefixUtilityName}SafeByteArray"]>
</#if>
</#if>
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
 * Bean object builder for datatype ${parameter.realObjectName}.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
 </#if>
public final class ${parameter.javaTypeName}Builder {
<#if !fullConstructor>

<#if documentation>
    /**
     * Bean object ${parameter.javaTypeName}Impl to build.
     */
</#if>
    private final ${parameter.javaTypeName}Impl object;
<#else>
<#list parameter.parameters as parameter2>

<#if documentation>
    /**
     * Field ${parameter2.name}.
     */
</#if>
    private ${parameter2.javaTypeName} ${parameter2.fieldName}${parameter.javaTypeName} = null;
</#list>
</#if>

<#if documentation>
    /**
     * Class constructor ${parameter.javaTypeName}Builder.
     */
</#if>
    public ${parameter.javaTypeName}Builder() {
<#if !fullConstructor>
        this.object = new ${parameter.javaTypeName}Impl();
</#if>
    }

<#if documentation>
    /**
     * Class constructor ${parameter.javaTypeName}Builder.
     *
     * @param ${parameter.javaTypeName} object${parameter.javaTypeName}Instance
     *
     */
</#if>
    public ${parameter.javaTypeName}Builder(final ${parameter.javaTypeName} object${parameter.javaTypeName}Instance) {
<#if !fullConstructor>
        this.object = new ${parameter.javaTypeName}Impl(object${parameter.javaTypeName}Instance);
<#else>
<#list parameter.parameters as parameter2>
        this. ${parameter2.fieldName}(object${parameter.javaTypeName}Instance.get${parameter2.propertyName}());
</#list>
</#if>
    }
<#list parameter.parameters as parameter2>

<#if documentation>
    /**
     * Getter of ${parameter2.name}.
     *
     * @return The ${parameter.javaTypeName}Builder object${parameter.javaTypeName}Instance.
     */
</#if>
    public ${parameter.javaTypeName}Builder ${parameter2.fieldName}(final ${parameter2.javaTypeName} ${parameter2.fieldName}) {
<#if !fullConstructor>
        this.object.set${parameter2.propertyName}(${parameter2.fieldName});
<#else>
<#if parameter2.date>
        this.${parameter2.fieldName}${parameter.javaTypeName} = ${prefixUtilityName}SafeDate.process(${parameter2.fieldName});
<#elseif parameter2.blob>
        this.${parameter2.fieldName}${parameter.javaTypeName} = ${prefixUtilityName}SafeByteArray.process(${parameter2.fieldName});
<#else>
        this.${parameter2.fieldName}${parameter.javaTypeName} = ${parameter2.fieldName};
</#if>
</#if>
        return this;
    }
</#list>

<#if documentation>
    /**
     * Getter ${parameter.javaTypeName} object${parameter.javaTypeName}Instance.
     *
     * @return The ${parameter.javaTypeName}Object object${parameter.javaTypeName}Instance.
     */
</#if>
    public ${parameter.javaTypeName} build() {
<#if fullConstructor>
        return new ${parameter.javaTypeName}Impl(${'\n'}            <#list parameter.parameters as parameter2>this.${parameter2.fieldName}${parameter.javaTypeName}<#sep>,${'\n'}            </#sep></#list>${'\n'}        );
<#else>
        return this.object;
</#if>
    }
}
