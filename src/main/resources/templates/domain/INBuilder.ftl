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
package ${javaPackage}.${domainFolderName};
<#assign importList = []>
<#list proc.arrayImports as parameter>
<#if arrayFolderName != domainFolderName>
<#assign importList = importList + ["${javaPackage}.${arrayFolderName}.${parameter.javaTypeName}"]>
</#if>
</#list>
<#list proc.objectImports as parameter>
<#if objectFolderName != domainFolderName>
<#assign importList = importList + ["${javaPackage}.${objectFolderName}.${parameter.javaTypeName}"]>
</#if>
</#list>
<#list proc.inputParameters as parameter>
<#if parameter.date>
<#assign importList = importList + ["java.util.Date"]>
<#if fullConstructor && utilFolderName != domainFolderName>
<#assign importList = importList + ["${javaPackage}.${utilFolderName}.${prefixUtilityName}SafeDate"]>
</#if>
<#elseif parameter.blob>
<#if fullConstructor && utilFolderName != domainFolderName>
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
 * Input builder parameters for <#if proc.function>function<#else>stored procedure</#if>.
 *
 * ${proc.fullName}
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
 </#if>
public final class ${proc.className}INBuilder {
<#if !fullConstructor>

<#if documentation>
    /**
     * Input parameter ${proc.className}INImpl to build.
     *
     * ${proc.fullName}
     */
</#if>
    private final ${proc.className}INImpl input;
<#else>
<#list proc.inputParameters as parameter>

<#if documentation>
    /**
     * Input parameter ${parameter.name}.
     *
     * ${proc.fullName}
     */
</#if>
    private ${parameter.javaTypeName} ${parameter.fieldName}${proc.className} = null;
</#list>
</#if>
<#if !fullConstructor>

<#if documentation>
    /**
     * Class constructor ${proc.className}INBuilder.
     *
     * ${proc.fullName}
     *
     */
</#if>
    public ${proc.className}INBuilder() {
        this.input = new ${proc.className}INImpl();
    }
</#if>
<#list proc.inputParameters as parameter>

<#if documentation>
    /**
     * Getter of ${parameter.name}.
     *
     * ${proc.fullName}
     *
     * @return The ${proc.className}INBuilder instance.
     */
</#if>
    public ${proc.className}INBuilder ${parameter.fieldName}(final ${parameter.javaTypeName} ${parameter.fieldName}) {
<#if !fullConstructor>
        this.input.set${parameter.propertyName}(${parameter.fieldName});
<#else>
<#if parameter.date>
        this.${parameter.fieldName}${proc.className} = ${prefixUtilityName}SafeDate.process(${parameter.fieldName});
<#elseif parameter.blob>
        this.${parameter.fieldName}${proc.className} = ${prefixUtilityName}SafeByteArray.process(${parameter.fieldName});
<#else>
        this.${parameter.fieldName}${proc.className} = ${parameter.fieldName};
</#if>
</#if>
        return this;
    }
</#list>

<#if documentation>
    /**
     * Getter ${proc.className}IN instance.
     *
     * ${proc.fullName}
     *
     * @return The ${proc.className}IN instance.
     */
</#if>
    public ${proc.className}IN build() {
<#if fullConstructor>
        return new ${proc.className}INImpl(${'\n'}            <#list proc.inputParameters as parameter>${parameter.fieldName}${proc.className}<#sep>,${'\n'}            </#sep></#list>${'\n'}        );
<#else>
        return this.input;
</#if>
    }
}
