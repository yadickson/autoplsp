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

import java.sql.Connection;

import java.util.ArrayList;
<#if driverName == 'oracle' >

import oracle.jdbc.OracleConnection;
</#if>

<#if jsonNonNull>
import com.fasterxml.jackson.annotation.JsonInclude;

</#if>
/**
 * Bean object for datatype ${parameter.realObjectName}.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
<#if jsonNonNull>
@JsonInclude(JsonInclude.Include.NON_NULL)
</#if>
@SuppressWarnings({"deprecation"})
public final class ${parameter.javaTypeName}
        extends ArrayList<${parameter.parameters[parameter.parameters?size - 1].javaTypeName}><#if serialization>
        implements java.io.Serializable</#if> {
<#if serialization> 

    /**
     * Serialization.
     */
    static final long serialVersionUID = 1L;
</#if>

    /**
     * Getter data object type.
     *
     * @param connection Database connection
     * @return object object processed.
     * @throws Exception if error
     */
    public Object process(
            final Connection connection
    ) throws Exception {

        Object[] input = new Object[size()];

        int i = 0;

        for (${parameter.parameters[parameter.parameters?size - 1].javaTypeName} obj : this) {
<#if parameter.parameters[parameter.parameters?size - 1].object>
            input[i++] = obj.process(connection);
<#else>
            input[i++] = obj;
</#if>
        }

<#if driverName == 'oracle' >
        return ((OracleConnection)connection).createARRAY("${parameter.realObjectName}", input);
<#else>
        throw new Exception("driver ${driverName} not supported");
</#if>
    }
}
