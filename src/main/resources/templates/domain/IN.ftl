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
<#if proc.hasInput>
package ${javaPackage}.domain;

/**
 * Input parameters for stored procedure ${proc.fullName}.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
public final class ${proc.className}IN implements java.io.Serializable {

    /**
     * Serialization.
     */
    static final long serialVersionUID = 1L;
    <#list proc.inputParameters as parameter>

    /**
     * Input parameter ${parameter.fieldName}.
     */
    private ${parameter.javaTypeName} ${parameter.fieldName} = null;
    </#list>

    /**
     * Class constructor ${proc.className}IN.
     */
    public ${proc.className}IN() {
    }

    /**
     * Class constructor ${proc.className}IN.
     *
    <#list proc.inputParameters as parameter>
     * @param p${parameter.fieldName} set value of ${parameter.fieldName}
    </#list>
     */
    public ${proc.className}IN(<#list proc.inputParameters as parameter>final ${parameter.javaTypeName} p${parameter.fieldName}<#sep>, </#sep></#list>) {
        <#list proc.inputParameters as parameter>
        this.${parameter.fieldName} = p${parameter.fieldName};
        </#list>
    }

    <#list proc.inputParameters as parameter>
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
     * @param p${parameter.fieldName} ${parameter.fieldName}
     */
    public void set${parameter.propertyName}(final ${parameter.javaTypeName} p${parameter.fieldName}) {
        this.${parameter.fieldName} = p${parameter.fieldName};
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

        str.append("[${proc.className}IN]");
        <#list proc.inputParameters as parameter>
        str.append(" ${parameter.fieldName}=");
        str.append(${parameter.fieldName});
        <#sep>str.append(", ");</#sep>
        </#list>

        return str.toString();
    }
}
</#if>
