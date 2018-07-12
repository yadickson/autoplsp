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
package ${javaPackage}.domain;

/**
 * Output parameters for stored procedure ${proc.fullName}.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
public final class ${proc.className}OUT implements java.io.Serializable {

    /**
     * Serialization.
     */
    static final long serialVersionUID = 1L;
    <#list proc.outputParameters as parameter>

    /**
     * Output parameter ${parameter.fieldName}.
     */
    private <#if parameter.resultSet>java.util.List<${parameter.javaTypeName}><#else>${parameter.javaTypeName}</#if> ${parameter.fieldName} = null;
    </#list>

    /**
     * Class constructor ${proc.className}IN.
     */
    public ${proc.className}OUT() {
    }

    /**
     * Class constructor ${proc.className}OUT.
     *
    <#list proc.outputParameters as parameter>
     * @param _${parameter.fieldName} set value of ${parameter.fieldName}
    </#list>
     */
    public ${proc.className}OUT(<#list proc.outputParameters as parameter>final <#if parameter.resultSet>java.util.List<${parameter.javaTypeName}><#else>${parameter.javaTypeName}</#if> _${parameter.fieldName}<#sep>, </#sep></#list>) {
        <#list proc.outputParameters as parameter>
        this.${parameter.fieldName} = _${parameter.fieldName};
        </#list>
    }

    <#list proc.outputParameters as parameter>
    /**
     * Getter for ${parameter.fieldName}.
     *
     * @return ${parameter.fieldName}
     */
    public <#if parameter.resultSet>java.util.List<${parameter.javaTypeName}><#else>${parameter.javaTypeName}</#if> get${parameter.propertyName}() {
        return this.${parameter.fieldName};
    }

    /**
     * Setter for ${parameter.fieldName}.
     *
     * @param _${parameter.fieldName} ${parameter.fieldName}
     */
    public void set${parameter.propertyName}(final <#if parameter.resultSet>java.util.List<${parameter.javaTypeName}><#else>${parameter.javaTypeName}</#if> _${parameter.fieldName}) {
        this.${parameter.fieldName} = _${parameter.fieldName};
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

        str.append("[${proc.className}OUT]");
        <#list proc.outputParameters as parameter>
        str.append(" ${parameter.fieldName}=");
        str.append(${parameter.fieldName});
        <#sep>str.append(", ");</#sep>
        </#list>

        return str.toString();
    }
}
