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
 * Bean objet for datatype ${parameter.realObjectName}
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
public class ${parameter.javaTypeName} implements java.io.Serializable {

    private static final long serialVersionUID = 1L;

    <#list parameter.parameters as parameter2>
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
     * @param ${parameter2.fieldName} set value of ${parameter2.fieldName}
    </#list>
     */
    public ${parameter.javaTypeName}(<#list parameter.parameters as parameter2>${parameter2.javaTypeName} ${parameter2.fieldName}<#sep>, </#sep></#list>) {
        <#list parameter.parameters as parameter2>
        this.${parameter2.fieldName} = ${parameter2.fieldName};
        </#list>
    }

    <#list parameter.parameters as parameter2>
    /**
     * Getter for ${parameter2.fieldName}
     *
     * @return ${parameter2.fieldName}
     */
    public ${parameter2.javaTypeName} get${parameter2.propertyName}() {
        return ${parameter2.fieldName};
    }

    /**
     * Setter for ${parameter2.fieldName}
     *
     * @param ${parameter2.fieldName} ${parameter2.fieldName}
     */
    public void set${parameter2.propertyName}(${parameter2.javaTypeName} ${parameter2.fieldName}) {
        this.${parameter2.fieldName} = ${parameter2.fieldName};
    }

    </#list>
    /**
     * Getter data object type
     *
     * @param connection Database connection
     * @return object
     * @throws Exception
     */
    @SuppressWarnings("deprecation")
    public Object getObject(java.sql.Connection connection) throws Exception {
        oracle.sql.StructDescriptor descriptor = oracle.sql.StructDescriptor.createDescriptor("${parameter.realObjectName}", connection);
        return new oracle.sql.STRUCT(descriptor, connection, new Object[]{<#list parameter.parameters as parameter>get${parameter.propertyName}()<#sep>, </#sep></#list>});
    }

    /**
     * Getter to string
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
