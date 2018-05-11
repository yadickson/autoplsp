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
<#if parameter.resultSet>
package ${javaPackage}.domain;

/**
 * DataSet parameter <#if !parameter.superClass>${parameter.name} in ${proc.fullName}<#else>${parameter.hierarchyFieldName}</#if>
 *
<#if parameter.extend> * @see ${parameter.hierarchyFieldName}
</#if> * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
@SuppressWarnings("serial")
public class ${parameter.dataSetClassName} <#if parameter.extend>extends ${parameter.hierarchyFieldName} </#if>implements java.io.Serializable {

<#if !parameter.extend>
    <#list parameter.parameters as parameter2>
    private ${parameter2.javaTypeName} ${parameter2.fieldName} = null;
    </#list>
</#if>

    /**
     * Class constructor ${parameter.dataSetClassName}.
     */
    public ${parameter.dataSetClassName}() {
<#if parameter.extend>
        super();
</#if>
    }

    /**
     * Class constructor ${parameter.dataSetClassName}.
     *
    <#list parameter.parameters as parameter2>
     * @param ${parameter2.fieldName} set value of ${parameter2.fieldName}
    </#list>
     */
    public ${parameter.dataSetClassName}(<#list parameter.parameters as parameter2>${parameter2.javaTypeName} ${parameter2.fieldName}<#sep>, </#sep></#list>) {
<#if !parameter.extend>
        <#list parameter.parameters as parameter2>
        this.${parameter2.fieldName} = ${parameter2.fieldName};
        </#list>
<#else>
        super(<#list parameter.parameters as parameter2>${parameter2.fieldName}<#sep>, </#sep></#list>);
</#if>
    }

<#if !parameter.extend>
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
</#if>
}
</#if>
