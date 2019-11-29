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
package ${javaPackage}.domain;

<#if lombok><#if proc.hasInput>import lombok.AllArgsConstructor;</#if>
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

</#if>
<#if jsonNonNull>import com.fasterxml.jackson.annotation.JsonInclude;

</#if>
/**
 * DataSet parameter for <#if proc.function>function<#else>stored procedure</#if>.
 *
 * ${proc.fullName}
 *
 * ${parameter.name}
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */<#if lombok>
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter</#if><#if jsonNonNull>
@JsonInclude(JsonInclude.Include.NON_NULL)</#if>
public final class ${parameter.javaTypeName}<#if serialization> implements java.io.Serializable</#if> {
<#if serialization> 

    /**
     * Serialization.
     */
    static final long serialVersionUID = 1L;
</#if>
<#list parameter.parameters as parameter2>

    /**
     * Field parameter ${parameter2.fieldName}.
     */<#if lombok && parameter2.date>
    @Getter(lombok.AccessLevel.NONE)
    @Setter(lombok.AccessLevel.NONE)</#if>
    private ${parameter2.javaTypeName} ${parameter2.fieldName} = null;
</#list>
<#if !lombok>

    /**
     * Class constructor ${parameter.javaTypeName}.
     */
    public ${parameter.javaTypeName}() {

    }

    /**
     * Class constructor ${parameter.javaTypeName}.
     *
    <#list parameter.parameters as parameter2>
     * @param p${parameter2.fieldName} set value of ${parameter2.fieldName}
    </#list>
     */
    public ${parameter.javaTypeName}(${'\n'}            <#list parameter.parameters as parameter2>final ${parameter2.javaTypeName} p${parameter2.fieldName}<#sep>,${'\n'}            </#sep></#list>
    ) {
        <#list parameter.parameters as parameter2>
        this.${parameter2.fieldName} = p${parameter2.fieldName};
        </#list>
    }
</#if>
<#list parameter.parameters as parameter2>
<#if !lombok || parameter2.date>

    /**
     * Getter for ${parameter2.fieldName}.
     *
     * @return ${parameter2.fieldName}
     */
    public ${parameter2.javaTypeName} get${parameter2.propertyName}() {
        return <#if parameter2.date>${javaPackage}.util.DateUtil.process(</#if>${parameter2.fieldName}<#if parameter2.date>)</#if>;
    }

    /**
     * Setter for ${parameter2.fieldName}.
     *
     * @param p${parameter2.fieldName} ${parameter2.fieldName}
     */
    public void set${parameter2.propertyName}(final ${parameter2.javaTypeName} p${parameter2.fieldName}) {
        this.${parameter2.fieldName} = <#if parameter2.date>${javaPackage}.util.DateUtil.process(</#if>p${parameter2.fieldName}<#if parameter2.date>)</#if>;
    }
</#if>
</#list>
}
