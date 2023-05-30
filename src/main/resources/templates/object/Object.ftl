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
package ${javaPackage}.object;

<#list parameter.parameters as parameter2>
<#if parameter2.date>
<#assign importSafeDate = 1>
</#if>
<#if parameter2.blob>
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

import java.util.Date;

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
 * Bean object for datatype ${parameter.realObjectName}.
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
public class ${parameter.javaTypeName}<#if serialization>
        implements java.io.Serializable</#if> {
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
<#if lombok && parameter2.date>
    @Getter(AccessLevel.NONE)
    @Setter(AccessLevel.NONE)
</#if>
    private ${parameter2.javaTypeName} ${parameter2.fieldName} = null;
</#list>
<#if !lombok>

<#if documentation>
    /**
     * Class Constructor ${parameter.javaTypeName}.
     */
</#if>
    public ${parameter.javaTypeName}() {
    }
</#if>
<#if fullConstructor>

<#if documentation>
    /**
     * Class Constructor ${parameter.javaTypeName}.
     *
<#list parameter.parameters as parameter2>
     * @param ${parameter2.fieldName} set value of ${parameter2.fieldName}
</#list>
     */
</#if>
    public ${parameter.javaTypeName}(${'\n'}            <#list parameter.parameters as parameter2>final ${parameter2.javaTypeName} ${parameter2.fieldName}<#sep>,${'\n'}            </#sep></#list>
    ) {
<#list parameter.parameters as parameter2>
        set${parameter2.propertyName}(${parameter2.fieldName});
</#list>
    }
</#if>
<#list parameter.parameters as parameter2>
<#if !lombok || parameter2.date>

<#if documentation>
    /**
     * Getter for ${parameter2.fieldName}.
     *
     * @return ${parameter2.fieldName}
     */
</#if>
    public ${parameter2.javaTypeName} get${parameter2.propertyName}() {
<#if parameter2.date>
        return ${prefixUtilityName}SafeDate.process(${parameter2.fieldName});
<#elseif parameter2.blob>
        return ${prefixUtilityName}SafeByteArray.process(${parameter2.fieldName});
<#else>
        return ${parameter2.fieldName};
</#if>
    }

<#if documentation>
    /**
     * Setter for ${parameter2.fieldName}.
     *
     * @param ${parameter2.fieldName} ${parameter2.fieldName} to set
     */
</#if>
    public void set${parameter2.propertyName}(final ${parameter2.javaTypeName} ${parameter2.fieldName}) {
<#if parameter2.date>
        this.${parameter2.fieldName} = ${prefixUtilityName}SafeDate.process(${parameter2.fieldName});
<#elseif parameter2.blob>
        this.${parameter2.fieldName} = ${prefixUtilityName}SafeByteArray.process(${parameter2.fieldName});
<#else>
        this.${parameter2.fieldName} = ${parameter2.fieldName};
</#if>
    }
</#if>
</#list>
}
