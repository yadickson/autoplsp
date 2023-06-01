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
package ${javaPackage}.domain;

<#list proc.arrayImports as parameter>
import ${javaPackage}.array.${parameter.javaTypeName};
</#list>
<#list proc.objectImports as parameter>
import ${javaPackage}.object.${parameter.javaTypeName};
</#list>
<#list proc.inputParameters as parameter>
<#if parameter.date>
<#assign importSafeDate = 1>
</#if>
<#if parameter.blob>
<#assign importSafeByteArray = 1>
</#if>
</#list>
<#if importSafeDate??>
import ${javaPackage}.util.${prefixUtilityName}SafeDate;
</#if>
<#if importSafeByteArray??>
import ${javaPackage}.util.${prefixUtilityName}SafeByteArray;
</#if>
<#if importSafeDate??>

<#if java8>
import java.time.LocalDateTime;
<#else>
import java.util.Date;
</#if>

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
public final class ${proc.className}INBuilder<#if serialization>${'\n'}        java.io.Serializable</#if> {
<#if serialization>

<#if documentation>
    /**
     * Serialization.
     */
</#if>
    static final long serialVersionUID = 1L;
</#if>
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
        this.${parameter.fieldName}${proc.className} = ${parameter.fieldName};
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
    public ${proc.className}IN builder() {
<#if fullConstructor>
        return new ${proc.className}INImpl(${'\n'}            <#list proc.inputParameters as parameter>${parameter.fieldName}${proc.className}<#sep>,${'\n'}            </#sep></#list>${'\n'}        );
<#else>
        return this.input;
</#if>
    }
}
