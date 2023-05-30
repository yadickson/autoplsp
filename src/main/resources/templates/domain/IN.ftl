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
<#if lombok>
<#if importSafeDate??>
import lombok.AccessLevel;
</#if>
import lombok.Getter;
<#if fullConstructor>
import lombok.NoArgsConstructor;
</#if>
import lombok.Setter;

</#if>
<#if jsonNonNull>
import com.fasterxml.jackson.annotation.JsonInclude;

</#if>
<#if documentation>
/**
 * Input parameters for <#if proc.function>function<#else>stored procedure</#if>.
 *
 * ${proc.fullName}
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
 </#if>
<#if lombok>
<#if fullConstructor>
@NoArgsConstructor
</#if>
@Getter
@Setter
</#if>
<#if jsonNonNull>
@JsonInclude(JsonInclude.Include.NON_NULL)
</#if>
public class ${proc.className}IN<#if serialization> implements java.io.Serializable</#if> {
<#if serialization>

<#if documentation>
    /**
     * Serialization.
     */
</#if>
    static final long serialVersionUID = 1L;
</#if>
<#list proc.inputParameters as parameter>

<#if documentation>
    /**
     * Input parameter ${parameter.name}.
     *
     * ${proc.fullName}
     */
</#if>
<#if lombok && parameter.date>
    @Getter(AccessLevel.NONE)
    @Setter(AccessLevel.NONE)
</#if>
    private ${parameter.javaTypeName} ${parameter.fieldName};
</#list>
<#if !lombok || builder>

<#if documentation>
    /**
     * Class constructor ${proc.className}IN.
     *
     * ${proc.fullName}
     */
</#if>
    public ${proc.className}IN() {
    }
</#if>
<#if !builder && fullConstructor>

<#if documentation>
    /**
     * Class constructor ${proc.className}IN.
     *
     * ${proc.fullName}
     *
<#list proc.inputParameters as parameter>
     * @param ${parameter.fieldName} set value of ${parameter.name}
</#list>
     */
</#if>
    public ${proc.className}IN(${'\n'}            <#list proc.inputParameters as parameter>final ${parameter.javaTypeName} ${parameter.fieldName}<#sep>,${'\n'}            </#sep></#list>${'\n'}    ) {
<#list proc.inputParameters as parameter>
        set${parameter.propertyName}(${parameter.fieldName});
</#list>
    }
</#if>
<#list proc.inputParameters as parameter>
<#if builder>

<#if documentation>
    /**
     * Setter of ${parameter.name}.
     *
     * ${proc.fullName}
     *
     * @param ${parameter.fieldName} ${parameter.name} to set
     * @return The instance class
     */
</#if>
    public ${proc.className}IN ${parameter.fieldName}(final ${parameter.javaTypeName} ${parameter.fieldName}) {
        set${parameter.propertyName}(${parameter.fieldName});
        return this;
    }
</#if>
<#if !lombok || parameter.date>

<#if documentation>
    /**
     * Getter of ${parameter.name}.
     *
     * ${proc.fullName}
     *
     * @return The ${parameter.name} value
     */
</#if>
    public ${parameter.javaTypeName} get${parameter.propertyName}() {
<#if parameter.date>
        return ${prefixUtilityName}SafeDate.process(${parameter.fieldName});
<#elseif parameter.blob>
        return ${prefixUtilityName}SafeByteArray.process(${parameter.fieldName});
<#else>
        return ${parameter.fieldName};
</#if>
    }

<#if documentation>
    /**
    /**
     * Setter of ${parameter.name}.
     *
     * ${proc.fullName}
     *
     * @param ${parameter.fieldName} ${parameter.name} to set
     */
</#if>
    public void set${parameter.propertyName}(final ${parameter.javaTypeName} ${parameter.fieldName}) {
<#if parameter.date>
        this.${parameter.fieldName} = ${prefixUtilityName}SafeDate.process(${parameter.fieldName});
<#elseif parameter.blob>
        this.${parameter.fieldName} = ${prefixUtilityName}SafeByteArray.process(${parameter.fieldName});
<#else>
        this.${parameter.fieldName} = ${parameter.fieldName};
</#if>
    }
</#if>
</#list>
}
