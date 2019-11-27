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
<#if parameter.resultSet || parameter.returnResultSet>
package ${javaPackage}.domain;

<#if jsonNonNull>import com.fasterxml.jackson.annotation.JsonInclude;

</#if>
/**
 * DataSet parameter ${parameter.name} in ${proc.fullName}.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */<#if jsonNonNull>
@JsonInclude(JsonInclude.Include.NON_NULL)</#if>
public final class ${parameter.javaTypeName}
        implements java.io.Serializable {

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
     * @param p${parameter2.fieldName} ${parameter2.fieldName}
     */
    public void set${parameter2.propertyName}(final ${parameter2.javaTypeName} p${parameter2.fieldName}) {
        this.${parameter2.fieldName} = p${parameter2.fieldName};
    }

    </#list>
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
        <#sep>str.append(", ");</#sep></#list>

        return str.toString();
    }
}
</#if>
