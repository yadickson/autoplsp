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
package ${javaPackage}.${objectFolderName};
<#assign importList = []>
<#if jsonNonNull>
<#assign importList = importList + ["com.fasterxml.jackson.annotation.JsonInclude"]>
</#if>
<#list parameter.parameters as parameter2>
<#if parameter2.date>
<#assign importList = importList + ["java.util.Date"]>
<#if utilFolderName != objectFolderName>
<#assign importList = importList + ["${javaPackage}.${utilFolderName}.${prefixUtilityName}SafeDate"]>
</#if>
</#if>
<#if parameter2.blob>
<#if utilFolderName != objectFolderName>
<#assign importList = importList + ["${javaPackage}.${utilFolderName}.${prefixUtilityName}SafeByteArray"]>
</#if>
</#if>
</#list>
<#if serialization>
<#assign importList = importList + ["java.io.Serializable"]>
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
 * Bean object for datatype ${parameter.realObjectName}.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
</#if>
<#if jsonNonNull>
@JsonInclude(JsonInclude.Include.NON_NULL)
</#if>
public final class ${parameter.javaTypeName}Impl implements${'\n'}        ${parameter.javaTypeName}<#if serialization>,${'\n'}        Serializable</#if> {
<#if serialization>

<#if documentation>
    /**
     * Serialization.
     */
</#if>
    static final long serialVersionUID = 1L;
</#if>
<#list parameter.parameters as parameter2>

<#if documentation>
    /**
     * Field parameter ${parameter2.fieldName}.
     */
</#if>
    private <#if fullConstructor>final </#if>${parameter2.javaTypeName} ${parameter2.fieldName}${parameter.javaTypeName}<#if !fullConstructor> = null</#if>;
</#list>
<#if fullConstructor>

<#if documentation>
    /**
     * Class Constructor ${parameter.javaTypeName}Impl.
     *
<#list parameter.parameters as parameter2>
     * @param ${parameter2.fieldName} set value of ${parameter2.fieldName}
</#list>
     */
</#if>
    public ${parameter.javaTypeName}Impl(${'\n'}            <#list parameter.parameters as parameter2>final ${parameter2.javaTypeName} ${parameter2.fieldName}<#sep>,${'\n'}        </#sep></#list>) {
<#list parameter.parameters as parameter2>
<#if parameter2.date>
        this.${parameter2.fieldName}${parameter.javaTypeName} = ${prefixUtilityName}SafeDate.process(${parameter2.fieldName});
<#elseif parameter2.blob>
        this.${parameter2.fieldName}${parameter.javaTypeName} = ${prefixUtilityName}SafeByteArray.process(${parameter2.fieldName});
<#else>
        this.${parameter2.fieldName}${parameter.javaTypeName} = ${parameter2.fieldName};
</#if>
</#list>
    }
</#if>
<#list parameter.parameters as parameter2>

<#if documentation>
    /**
     * Getter for ${parameter2.fieldName}.
     *
     * @return ${parameter2.fieldName}
     */
</#if>
    @Override
    public ${parameter2.javaTypeName} get${parameter2.propertyName}() {
<#if parameter2.date>
        return ${prefixUtilityName}SafeDate.process(${parameter2.fieldName}${parameter.javaTypeName});
<#elseif parameter2.blob>
        return ${prefixUtilityName}SafeByteArray.process(${parameter2.fieldName}${parameter.javaTypeName});
<#else>
        return ${parameter2.fieldName}${parameter.javaTypeName};
</#if>
    }
<#if !fullConstructor>

<#if documentation>
    /**
     * Setter for ${parameter2.fieldName}.
     *
     * @param ${parameter2.fieldName} ${parameter2.fieldName} to set
     */
</#if>
    public void set${parameter2.propertyName}(final ${parameter2.javaTypeName} ${parameter2.fieldName}) {
<#if parameter2.date>
        this.${parameter2.fieldName}${parameter.javaTypeName} = ${prefixUtilityName}SafeDate.process(${parameter2.fieldName});
<#elseif parameter2.blob>
        this.${parameter2.fieldName}${parameter.javaTypeName} = ${prefixUtilityName}SafeByteArray.process(${parameter2.fieldName});
<#else>
        this.${parameter2.fieldName}${parameter.javaTypeName} = ${parameter2.fieldName};
</#if>
    }
</#if>
</#list>
}
