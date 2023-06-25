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
package ${javaPackage}.${cursorFolderName};
<#assign importList = []>
<#if jsonNonNull>
<#assign importList = importList + ["com.fasterxml.jackson.annotation.JsonInclude"]>
</#if>
<#if serialization>
<#assign importList = importList + ["java.io.Serializable"]>
</#if>
<#list parameter.parameters as parameter2>
<#if parameter2.date>
<#assign importSafeDate = 1>
<#assign importList = importList + ["java.util.Date"]>
<#if utilFolderName != cursorFolderName>
<#assign importList = importList + ["${javaPackage}.${utilFolderName}.${prefixUtilityName}SafeDate"]>
</#if>
</#if>
<#if parameter2.blob>
<#assign importSafeByteArray = 1>
<#if utilFolderName != cursorFolderName>
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
 * DataSet parameter for <#if proc.function>function<#else>stored procedure</#if>.
 *
 * ${proc.fullName}
 *
 * ${parameter.name}
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
     * Column ${parameter2.name}.
     *
     * ${proc.fullName}
     *
     * ${parameter.name}
     */
</#if>
    private <#if fullConstructor>final </#if>${parameter2.javaTypeName} ${parameter2.fieldName}${parameter.javaTypeName}<#if !fullConstructor> = null</#if>;
</#list>
<#if fullConstructor>

<#if documentation>
    /**
     * Class constructor ${parameter.javaTypeName}Impl.
     *
     * ${proc.fullName}
     *
     * ${parameter.name}
     *
    <#list parameter.parameters as parameter2>
     * @param ${parameter2.fieldName} set value of ${parameter2.name}
    </#list>
     */
</#if>
    public ${parameter.javaTypeName}Impl(${'\n'}            <#list parameter.parameters as parameter2>final ${parameter2.javaTypeName} ${parameter2.fieldName}<#sep>,${'\n'}            </#sep></#list>${'\n'}    ) {
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
     * Getter of ${parameter2.name}.
     *
     * ${proc.fullName}
     *
     * ${parameter.name}
     *
     * @return The ${parameter2.name} value.
     */
</#if>
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
     * Setter of ${parameter2.name}.
     *
     * ${proc.fullName}
     *
     * ${parameter.name}
     *
     * @param ${parameter2.fieldName} ${parameter2.name} to set
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
