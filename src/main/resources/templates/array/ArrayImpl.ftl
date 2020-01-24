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
package ${javaPackage}.array;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;

<#if parameter.parameters[parameter.parameters?size - 1].object>
import ${javaPackage}.object.${parameter.parameters[parameter.parameters?size - 1].javaTypeName};
<#assign importObjectUtil = 1>
</#if>
import ${javaPackage}.util.ArrayUtil;
<#if importObjectUtil??>
import ${javaPackage}.util.ObjectUtil;
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
<#if !serialization>
@SuppressWarnings({"serial"})
</#if>
public final class ${parameter.javaTypeName}Impl
        extends ArrayList<${parameter.parameters[parameter.parameters?size - 1].javaTypeName}>
        implements ${parameter.javaTypeName}<#if serialization>, java.io.Serializable</#if> {
<#if serialization> 

    /**
     * Serialization.
     */
    static final long serialVersionUID = 1L;
</#if>

    /**
     * {@inheritDoc}
     */
    @Override
    public Object process(
            final Connection connection,
            final ArrayUtil arrayUtil<#if importObjectUtil??>,${'\n'}            final ObjectUtil objectUtil</#if>
    ) throws SQLException {

        Object[] input = new Object[size()];

        int i = 0;

        for (${parameter.parameters[parameter.parameters?size - 1].javaTypeName} obj : this) {
<#if importObjectUtil??>
            input[i++] = obj.process(connection, objectUtil);
<#else>
            input[i++] = obj;
</#if>
        }

        return arrayUtil.process(
                connection,
                "${parameter.realObjectName}",
                input
        );
    }
}
