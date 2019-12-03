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

<#list parameter.parameters as parameter2>
<#if parameter2.date>
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
 * DataSet parameter for <#if proc.function>function<#else>stored procedure</#if>.
 *
 * ${proc.fullName}
 *
 * ${parameter.name}
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
public final class ${parameter.javaTypeName}<#if serialization> implements java.io.Serializable</#if> {
<#if serialization> 

    /**
     * Serialization.
     */
    static final long serialVersionUID = 1L;
</#if>
<#list parameter.parameters as parameter2>

    /**
     * Column ${parameter2.name}.
     *
     * ${proc.fullName}
     *
     * ${parameter.name}
     */
<#if lombok && parameter2.date>
    @Getter(AccessLevel.NONE)
    @Setter(AccessLevel.NONE)
</#if>
    private ${parameter2.javaTypeName} ${parameter2.fieldName};
</#list>
<#if !lombok>

    /**
     * Class constructor ${parameter.javaTypeName}.
     *
     * ${proc.fullName}
     *
     * ${parameter.name}
     */
    public ${parameter.javaTypeName}() {

    }
</#if>
<#if fullConstructor>

    /**
     * Class constructor ${parameter.javaTypeName}.
     *
     * ${proc.fullName}
     *
     * ${parameter.name}
     *
    <#list parameter.parameters as parameter2>
     * @param c${parameter2.propertyName} set value of ${parameter2.name}
    </#list>
     */
    public ${parameter.javaTypeName}(${'\n'}            <#list parameter.parameters as parameter2>final ${parameter2.javaTypeName} c${parameter2.propertyName}<#sep>,${'\n'}            </#sep></#list>${'\n'}    ) {
<#list parameter.parameters as parameter2>
        set${parameter2.propertyName}(c${parameter2.propertyName});
</#list>
    }
</#if>
<#list parameter.parameters as parameter2>
<#if !lombok || parameter2.date>

    /**
     * Getter of ${parameter2.name}.
     *
     * ${proc.fullName}
     *
     * ${parameter.name}
     *
     * @return The ${parameter2.name} value.
     */
    public ${parameter2.javaTypeName} get${parameter2.propertyName}() {
        return <#if parameter2.date>DateUtil.process(</#if>${parameter2.fieldName}<#if parameter2.date>)</#if>;
    }

    /**
     * Setter of ${parameter2.name}.
     *
     * ${proc.fullName}
     *
     * ${parameter.name}
     *
     * @param c${parameter2.propertyName} ${parameter2.name} to set
     */
    public void set${parameter2.propertyName}(final ${parameter2.javaTypeName} c${parameter2.propertyName}) {
        this.${parameter2.fieldName} = <#if parameter2.date>DateUtil.process(</#if>c${parameter2.propertyName}<#if parameter2.date>)</#if>;
    }
</#if>
</#list>
}
