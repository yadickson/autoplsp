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
<#if parameter.array>
package ${javaPackage}.domain;

/**
 * Bean object for datatype ${parameter.realObjectName}.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
public final class ${parameter.javaTypeName} extends java.util.ArrayList<${parameter.parameters[parameter.parameters?size - 1].javaTypeName}> implements java.io.Serializable {

    /**
     * Serialization.
     */
    static final long serialVersionUID = 1L;

    /**
     * Getter data object type.
     *
     * @param connection Database connection
     * @return object
     * @throws Exception
     */
    public Object processObject(final java.sql.Connection connection) throws Exception {

        Object[] input = new Object[size()];

        int i = 0;

        for (${parameter.parameters[parameter.parameters?size - 1].javaTypeName} obj : this) {
            <#if parameter.parameters[parameter.parameters?size - 1].object>
            input[i++] = obj.processObject(connection);
            <#else>
            input[i++] = obj;
            </#if>
        }

<#if driverName == 'oracle' >
        return ((oracle.jdbc.OracleConnection)(connection)).createARRAY("${parameter.realObjectName}", input);
<#else>
        throw new Exception("driver ${driverName} not supported");
</#if>
    }

    /**
     * Getter to string.
     *
     * @return to string
     */
    @Override
    public String toString() {
        return org.apache.commons.lang.builder.ToStringBuilder.reflectionToString(this);
    }
}
</#if>
