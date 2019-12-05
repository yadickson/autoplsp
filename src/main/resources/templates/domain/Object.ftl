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
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

</#if>
<#if jsonNonNull>
import com.fasterxml.jackson.annotation.JsonInclude;

</#if>
/**
 * Bean object for datatype ${parameter.realObjectName}
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
<#if lombok>
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
</#if>
<#if jsonNonNull>
@JsonInclude(JsonInclude.Include.NON_NULL)
</#if>
@SuppressWarnings({"deprecation"})
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
    @Getter(AccessLevel.NONE)
    @Setter(AccessLevel.NONE)</#if>
    private ${parameter2.javaTypeName} ${parameter2.fieldName} = null;
</#list>
<#if !lombok>

    /**
     * Class Constructor ${parameter.javaTypeName}.
     */
    public ${parameter.javaTypeName}() {
    }

    /**
     * Class Constructor ${parameter.javaTypeName}.
     *
    <#list parameter.parameters as parameter2>
     * @param p${parameter2.propertyName} set value of ${parameter2.fieldName}
    </#list>
     */
    public ${parameter.javaTypeName}(${'\n'}            <#list parameter.parameters as parameter2>final ${parameter2.javaTypeName} p${parameter2.propertyName}<#sep>,${'\n'}            </#sep></#list>
    ) {
        <#list parameter.parameters as parameter2>
        this.${parameter2.fieldName} = p${parameter2.propertyName};
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
        return <#if parameter2.date>DateUtil.process(</#if>${parameter2.fieldName}<#if parameter2.date>)</#if>;
    }

    /**
     * Setter for ${parameter2.fieldName}.
     *
     * @param p${parameter2.propertyName} ${parameter2.fieldName} to set
     */
    public void set${parameter2.propertyName}(final ${parameter2.javaTypeName} p${parameter2.propertyName}) {
        this.${parameter2.fieldName} = <#if parameter2.date>DateUtil.process(</#if>p${parameter2.propertyName}<#if parameter2.date>)</#if>;
    }
</#if>
</#list>

    /**
     * Getter data object type.
     *
     * @param connection Database connection
     * @return object
     * @throws Exception
     */
    public Object processObject(final java.sql.Connection connection) throws Exception {
<#list parameter.parameters as parameter>
<#if parameter.clob>
        oracle.sql.CLOB clob${parameter.propertyName} = oracle.sql.CLOB.createTemporary(connection, false, oracle.sql.CLOB.DURATION_SESSION);
        java.io.Writer clobWriter${parameter.propertyName} = clob${parameter.propertyName}.getCharacterOutputStream();
        if (get${parameter.propertyName}() != null) {
            clobWriter${parameter.propertyName}.write(get${parameter.propertyName}().toCharArray());
        }
        clobWriter${parameter.propertyName}.flush();
        clobWriter${parameter.propertyName}.close();
<#elseif parameterblob>
        oracle.sql.BLOB blob${parameter.propertyName} = oracle.sql.BLOB.createTemporary(connection, false, oracle.sql.BLOB.DURATION_SESSION);
        blob${parameter.propertyName}.getBinaryOutputStream().write(get${parameter.propertyName}());
<#elseif parameter.date>
        oracle.sql.DATE date${parameter.propertyName} = get${parameter.propertyName}() == null ? null : new oracle.sql.DATE(new java.sql.Date(get${parameter.propertyName}().getTime()));
</#if>
</#list>

        Object[] objs = new Object[]{
<#list parameter.parameters as parameter>            <#if parameter.clob>clob${parameter.propertyName}<#elseif parameterblob>blob${parameter.propertyName}<#elseif parameter.date>date${parameter.propertyName}<#else>get${parameter.propertyName}()</#if><#sep>,</#sep>
</#list>        };

<#if driverName == 'oracle' >
        oracle.sql.StructDescriptor descriptor = oracle.sql.StructDescriptor.createDescriptor("${parameter.realObjectName}", connection);
        return new oracle.sql.STRUCT(descriptor, connection, objs);
<#else>
        throw new Exception("driver ${driverName} not supported");
</#if>
    }
}
