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
package ${javaPackage}.domain;

<#if jsonNonNull>import com.fasterxml.jackson.annotation.JsonInclude;

</#if><#if lombok><#if proc.hasInput>import lombok.AllArgsConstructor;</#if>
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;

</#if>
/**
 * Input parameters for stored procedure ${proc.fullName}.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */<#if lombok>
<#if proc.hasInput>@AllArgsConstructor</#if>
@Getter
@Setter
@NoArgsConstructor</#if><#if jsonNonNull>
@JsonInclude(JsonInclude.Include.NON_NULL)</#if>
@SuppressWarnings({"deprecation"})
public final class ${proc.className}IN
        implements java.io.Serializable {

    /**
     * Serialization.
     */
    static final long serialVersionUID = 1L;

<#list proc.inputParameters as parameter>
    /**
     * Input parameter ${parameter.fieldName}.
     */<#if lombok && parameter.date>
    @Getter(lombok.AccessLevel.NONE)
    @Setter(lombok.AccessLevel.NONE)</#if>
    private ${parameter.javaTypeName} ${parameter.fieldName} = null;

</#list><#if !lombok>
    /**
     * Class constructor ${proc.className}IN.
     */
    public ${proc.className}IN() {
    }

    /**
     * Class constructor ${proc.className}IN.
     *
    <#list proc.inputParameters as parameter>
     * @param p${parameter.propertyName} set value of ${parameter.fieldName}
    </#list>
     */
    public ${proc.className}IN(<#if proc.hasInput>${'\n'}            </#if><#list proc.inputParameters as parameter>final ${parameter.javaTypeName} p${parameter.propertyName}<#sep>,${'\n'}            </#sep></#list>
    ) {
        <#list proc.inputParameters as parameter>
        this.${parameter.fieldName} = p${parameter.propertyName};
        </#list>
    }</#if><#list proc.inputParameters as parameter><#if !lombok || parameter.date>

    /**
     * Getter for ${parameter.fieldName}.
     *
     * @return ${parameter.fieldName}
     */
    public ${parameter.javaTypeName} get${parameter.propertyName}() {
        return ${parameter.fieldName};
    }

    /**
     * Setter for ${parameter.fieldName}.
     *
     * @param p${parameter.propertyName} ${parameter.fieldName} to set
     */
    public void set${parameter.propertyName}(final ${parameter.javaTypeName} p${parameter.propertyName}) {
        this.${parameter.fieldName} = p${parameter.propertyName};
    }</#if></#list>}
