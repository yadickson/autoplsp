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
 * Output parameters for stored procedure ${proc.fullName}.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */<#if lombok>
@NoArgsConstructor
<#if proc.hasOutput>@AllArgsConstructor</#if>
@Getter
@Setter</#if><#if jsonNonNull>
@JsonInclude(JsonInclude.Include.NON_NULL)</#if>
public final class ${proc.className}OUT<#if serialization> implements java.io.Serializable</#if> {
<#if serialization> 

    /**
     * Serialization.
     */
    static final long serialVersionUID = 1L;
</#if>
<#list proc.outputParameters as parameter>

    /**
     * Output parameter ${parameter.fieldName}.
     */<#if lombok && parameter.date>
    @Getter(lombok.AccessLevel.NONE)
    @Setter(lombok.AccessLevel.NONE)</#if>
    private <#if parameter.resultSet || parameter.returnResultSet>java.util.List<${parameter.javaTypeName}><#else>${parameter.javaTypeName}</#if> ${parameter.fieldName} = null;
</#list>
<#if !lombok>

    /**
     * Class constructor ${proc.className}OUT.
     */
    public ${proc.className}OUT() {
    }

    /**
     * Class constructor ${proc.className}OUT.
     *
    <#list proc.outputParameters as parameter>
     * @param p${parameter.propertyName} set value of ${parameter.fieldName}
    </#list>
     */
    public ${proc.className}OUT(<#if proc.hasOutput>${'\n'}            </#if><#list proc.outputParameters as parameter>final <#if parameter.resultSet || parameter.returnResultSet>java.util.List<${parameter.javaTypeName}><#else>${parameter.javaTypeName}</#if> p${parameter.propertyName}<#sep>,${'\n'}            </#sep></#list>
    ) {
        <#list proc.outputParameters as parameter>
        this.${parameter.fieldName} = p${parameter.propertyName};
        </#list>
    }
</#if>
<#list proc.outputParameters as parameter>
<#if !lombok || parameter.date>

    /**
     * Getter for ${parameter.fieldName}.
     *
     * @return ${parameter.fieldName}
     */
    public <#if parameter.resultSet || parameter.returnResultSet>java.util.List<${parameter.javaTypeName}><#else>${parameter.javaTypeName}</#if> get${parameter.propertyName}() {
        return <#if parameter.date>${javaPackage}.util.DateUtil.process(</#if>${parameter.fieldName}<#if parameter.date>)</#if>;
    }

    /**
     * Setter for ${parameter.fieldName}.
     *
     * @param p${parameter.propertyName} ${parameter.fieldName} to set
     */
    public void set${parameter.propertyName}(final <#if parameter.resultSet || parameter.returnResultSet>java.util.List<${parameter.javaTypeName}><#else>${parameter.javaTypeName}</#if> p${parameter.propertyName}) {
        this.${parameter.fieldName} = <#if parameter.date>${javaPackage}.util.DateUtil.process(</#if>p${parameter.propertyName}<#if parameter.date>)</#if>;
    }
</#if>
</#list>
}
