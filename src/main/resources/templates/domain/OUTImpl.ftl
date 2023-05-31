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

<#list proc.outputParameters as parameter>
<#if parameter.date>
<#assign importSafeDate = 1>
</#if>
<#if parameter.blob>
<#assign importSafeByteArray = 1>
</#if>
</#list>
<#list proc.outputParameters as parameter>
<#if parameter.resultSet || parameter.returnResultSet>
import ${javaPackage}.cursor.${parameter.javaTypeName};
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
<#if jsonNonNull>

import com.fasterxml.jackson.annotation.JsonInclude;
</#if>

<#if documentation>
/**
 * Output parameters for <#if proc.function>function<#else>stored procedure</#if>.
 *
 * ${proc.fullName}
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
</#if>
<#if jsonNonNull>
@JsonInclude(JsonInclude.Include.NON_NULL)
</#if>
public class ${proc.className}OUTImpl implements${'\n'}        ${proc.className}OUT<#if serialization>,${'\n'}        java.io.Serializable</#if> {
<#if serialization> 

<#if documentation>
    /**
     * Serialization.
     */
</#if>
    static final long serialVersionUID = 1L;
</#if>
<#list proc.outputParameters as parameter>

<#if documentation>
    /**
     * Output parameter ${parameter.name}.
     *
     * ${proc.fullName}
     */
</#if>
    private <#if fullConstructor>final </#if><#if parameter.resultSet || parameter.returnResultSet>java.util.List<${parameter.javaTypeName}><#else>${parameter.javaTypeName}</#if> ${parameter.fieldName}${proc.className}<#if !fullConstructor> = null</#if>;
</#list>
<#if fullConstructor>

<#if documentation>
    /**
     * Class constructor ${proc.className}OUT.
     *
     * ${proc.fullName}
     *
    <#list proc.outputParameters as parameter>
     * @param ${parameter.fieldName} set value of ${parameter.name}
    </#list>
     */
</#if>
    public ${proc.className}OUTImpl(${'\n'}            <#list proc.outputParameters as parameter>final <#if parameter.resultSet || parameter.returnResultSet>java.util.List<${parameter.javaTypeName}><#else>${parameter.javaTypeName}</#if> ${parameter.fieldName}<#sep>,${'\n'}            </#sep></#list>${'\n'}    ) {
<#list proc.outputParameters as parameter>
<#if parameter.date>
        this.${parameter.fieldName}${proc.className} = ${prefixUtilityName}SafeDate.process(${parameter.fieldName});
<#elseif parameter.blob>
        this.${parameter.fieldName}${proc.className} = ${prefixUtilityName}SafeByteArray.process(${parameter.fieldName});
<#else>
        this.${parameter.fieldName}${proc.className} = ${parameter.fieldName};
</#if>
</#list>
    }
</#if>
<#list proc.outputParameters as parameter>

<#if documentation>
    /**
     * Getter of ${parameter.name}.
     *
     * ${proc.fullName}
     *
     * @return The ${parameter.name} value.
     */
</#if>
    @Override
    public <#if parameter.resultSet || parameter.returnResultSet>java.util.List<${parameter.javaTypeName}><#else>${parameter.javaTypeName}</#if> get${parameter.propertyName}() {
<#if parameter.date>
        return ${prefixUtilityName}SafeDate.process(${parameter.fieldName}${proc.className});
<#elseif parameter.blob>
        return ${prefixUtilityName}SafeByteArray.process(${parameter.fieldName}${proc.className});
<#else>
        return ${parameter.fieldName}${proc.className};
</#if>
    }
<#if !fullConstructor>

<#if documentation>
    /**
     * Setter of ${parameter.name}.
     *
     * ${proc.fullName}
     *
     * @param ${parameter.fieldName} ${parameter.name} to set
     */
</#if>
    public void set${parameter.propertyName}(final <#if parameter.resultSet || parameter.returnResultSet>java.util.List<${parameter.javaTypeName}><#else>${parameter.javaTypeName}</#if> ${parameter.fieldName}) {
<#if parameter.date>
        this.${parameter.fieldName}${proc.className} = ${prefixUtilityName}SafeDate.process(${parameter.fieldName});
<#elseif parameter.blob>
        this.${parameter.fieldName}${proc.className} = ${prefixUtilityName}SafeByteArray.process(${parameter.fieldName});
<#else>
        this.${parameter.fieldName}${proc.className} = ${parameter.fieldName};
</#if>
    }
</#if>
</#list>
}
