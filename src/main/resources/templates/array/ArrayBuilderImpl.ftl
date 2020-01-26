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
<#if parameter.parameters[parameter.parameters?size - 1].object>
<#assign importObjectBuilder = 1>
</#if>

import java.sql.Connection;
import java.sql.SQLException;

<#if importObjectBuilder??>
import ${javaPackage}.object.${parameter.parameters[parameter.parameters?size - 1].javaTypeName};
import ${javaPackage}.object.${parameter.parameters[parameter.parameters?size - 1].javaTypeName}Builder;

</#if>
import ${javaPackage}.util.ArrayUtil;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * Builder class to make array for datatype ${parameter.realObjectName}.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
@Component
public final class ${parameter.javaTypeName}BuilderImpl
        implements ${parameter.javaTypeName}Builder {

    /**
     * Array utility.
     */
    @Autowired
    private ArrayUtil arrayUtil;
<#if importObjectBuilder??>

    /**
     * Object utility to build ${parameter.parameters[parameter.parameters?size - 1].realObjectName}.
     */
    @Autowired
    private ${parameter.parameters[parameter.parameters?size - 1].javaTypeName}Builder objectBuilder;
</#if>

    /**
     * {@inheritDoc}
     */
    @Override
    public Object process(
            final Connection connection,
            final ${parameter.javaTypeName} array
    ) throws SQLException {

        Object[] input = new Object[array.size()];

        int i = 0;

        for (${parameter.parameters[parameter.parameters?size - 1].javaTypeName} obj : array) {
<#if importObjectBuilder??>
            input[i++] = objectBuilder.process(connection, obj);
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
