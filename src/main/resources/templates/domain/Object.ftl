/*
 * Copyright (C) 2017 Yadickson Soto
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
<#if parameter.object>
package ${javaPackage}.domain;

/**
 * Bean object for datatype ${parameter.realObjectName}
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
public final class ${parameter.javaTypeName} implements java.io.Serializable {

    /**
     * Serialization.
     */
    static final long serialVersionUID = 1L;
    <#list parameter.parameters as parameter2>

    /**
     * Field parameter ${parameter2.fieldName}.
     */
    private ${parameter2.javaTypeName} ${parameter2.fieldName} = null;
    </#list>

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
    public ${parameter.javaTypeName}(<#list parameter.parameters as parameter2>final ${parameter2.javaTypeName} p${parameter2.propertyName}<#sep>, </#sep></#list>) {
        <#list parameter.parameters as parameter2>
        this.${parameter2.fieldName} = p${parameter2.propertyName};
        </#list>
    }

    <#list parameter.parameters as parameter2>
    /**
     * Getter for ${parameter2.fieldName}.
     *
     * @return ${parameter2.fieldName}
     */
    public ${parameter2.javaTypeName} get${parameter2.propertyName}() {
        return ${parameter2.fieldName};
    }

    /**
     * Setter for ${parameter2.fieldName}.
     *
     * @param p${parameter2.propertyName} ${parameter2.fieldName} to set
     */
    public void set${parameter2.propertyName}(final ${parameter2.javaTypeName} p${parameter2.propertyName}) {
        this.${parameter2.fieldName} = p${parameter2.propertyName};
    }

    </#list>
    /**
     * Getter data object type.
     *
     * @param connection Database connection
     * @return object
     * @throws Exception
     */
    public Object getObject(final java.sql.Connection connection) throws Exception {
<#list parameter.parameters as parameter>
<#if parameter.sqlTypeName == 'java.sql.Types.CLOB'>
        oracle.sql.CLOB clob${parameter.propertyName} = oracle.sql.CLOB.createTemporary(connection, false, oracle.sql.CLOB.DURATION_SESSION);
        java.io.Writer clobWriter${parameter.propertyName} = clob${parameter.propertyName}.getCharacterOutputStream();
        clobWriter${parameter.propertyName}.write(get${parameter.propertyName}().toCharArray(););
        clobWriter${parameter.propertyName}.flush();
        clobWriter${parameter.propertyName}.close();
<#elseif parameter.sqlTypeName == 'java.sql.Types.BLOB'>
        oracle.sql.BLOB blob${parameter.propertyName} = oracle.sql.BLOB.createTemporary(connection, false, oracle.sql.BLOB.DURATION_SESSION);
        blob${parameter.propertyName}.getBinaryOutputStream().write(get${parameter.propertyName}());
<#elseif parameter.sqlTypeName == 'java.sql.Types.TIMESTAMP'>
        oracle.sql.DATE date${parameter.propertyName} = get${parameter.propertyName}() == null ? null : new oracle.sql.DATE(new java.sql.Date(get${parameter.propertyName}().getTime()));
</#if>
</#list>

        Object[] objs = new Object[]{
<#list parameter.parameters as parameter>            <#if parameter.sqlTypeName == 'java.sql.Types.CLOB'>clob${parameter.propertyName}<#elseif parameter.sqlTypeName == 'java.sql.Types.BLOB'>blob${parameter.propertyName}<#elseif parameter.sqlTypeName == 'java.sql.Types.TIMESTAMP'>date${parameter.propertyName}<#else>get${parameter.propertyName}()</#if><#sep>,</#sep>
</#list>        };

<#if driverName == 'oracle' >
        oracle.sql.StructDescriptor descriptor = oracle.sql.StructDescriptor.createDescriptor("${parameter.realObjectName}", connection);
        return new oracle.sql.STRUCT(descriptor, connection, objs);
<#else>
        return throw new Exception("driver ${driverName} not supported");
</#if>
    }

    /**
     * Getter to string.
     *
     * @return to string
     */
    @Override
    public String toString() {
        StringBuilder str = new StringBuilder();

        str.append("[${parameter.javaTypeName}]");
        <#list parameter.parameters as parameter2>
        str.append(" ${parameter2.fieldName}=");
        str.append(${parameter2.fieldName});
        <#sep>str.append(", ");</#sep>
        </#list>
        return str.toString();
    }
}
</#if>
