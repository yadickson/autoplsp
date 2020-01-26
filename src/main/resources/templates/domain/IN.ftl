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
package ${javaPackage}.domain;

<#list proc.arrayImports as parameter>
import ${javaPackage}.array.${parameter.javaTypeName};
</#list>
<#list proc.objectImports as parameter>
import ${javaPackage}.object.${parameter.javaTypeName};
</#list>
<#list proc.inputParameters as parameter>
<#if parameter.date>
<#assign importDateUtil = 1>
</#if>
</#list>
<#if importDateUtil??>
import ${javaPackage}.util.DateUtil;

import java.util.Date;

</#if>
<#if lombok>
<#if importDateUtil??>
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
/**
 * Input parameters for <#if proc.function>function<#else>stored procedure</#if>.
 *
 * ${proc.fullName}
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
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
public final class ${proc.className}IN<#if serialization> implements java.io.Serializable</#if> {
<#if serialization>

    /**
     * Serialization.
     */
    static final long serialVersionUID = 1L;
</#if>
<#list proc.inputParameters as parameter>

    /**
     * Input parameter ${parameter.name}.
     *
     * ${proc.fullName}
     */
<#if lombok && parameter.date>
    @Getter(AccessLevel.NONE)
    @Setter(AccessLevel.NONE)
</#if>
    private ${parameter.javaTypeName} ${parameter.fieldName};
</#list>
<#if !lombok>

    /**
     * Class constructor ${proc.className}IN.
     *
     * ${proc.fullName}
     */
    public ${proc.className}IN() {
    }
</#if>
<#if fullConstructor>

    /**
     * Class constructor ${proc.className}IN.
     *
     * ${proc.fullName}
     *
<#list proc.inputParameters as parameter>
     * @param p${parameter.propertyName} set value of ${parameter.name}
</#list>
     */
    public ${proc.className}IN(${'\n'}            <#list proc.inputParameters as parameter>final ${parameter.javaTypeName} p${parameter.propertyName}<#sep>,${'\n'}            </#sep></#list>${'\n'}    ) {
<#list proc.inputParameters as parameter>
        set${parameter.propertyName}(p${parameter.propertyName});
</#list>
    }
</#if>
<#list proc.inputParameters as parameter>
<#if !lombok || parameter.date>

    /**
     * Getter of ${parameter.name}.
     *
     * ${proc.fullName}
     *
     * @return The ${parameter.name} value
     */
    public ${parameter.javaTypeName} get${parameter.propertyName}() {
        return <#if parameter.date>DateUtil.process(</#if>${parameter.fieldName}<#if parameter.date>)</#if>;
    }

    /**
     * Setter of ${parameter.name}.
     *
     * ${proc.fullName}
     *
     * @param p${parameter.propertyName} ${parameter.name} to set
     */
    public void set${parameter.propertyName}(final ${parameter.javaTypeName} p${parameter.propertyName}) {
        this.${parameter.fieldName} = <#if parameter.date>DateUtil.process(</#if>p${parameter.propertyName}<#if parameter.date>)</#if>;
    }
</#if>
</#list>
}
