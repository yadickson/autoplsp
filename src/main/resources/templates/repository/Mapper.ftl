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
package ${javaPackage}.repository.mapper;

import ${javaPackage}.domain.${parameter.javaTypeName};
import org.springframework.jdbc.core.RowMapper;

/**
 * Resultset mapper of ${parameter.name}.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
@SuppressWarnings({"rawtypes", "unchecked", "cast"})
public final class ${parameter.javaTypeName}RowMapper
        implements RowMapper<${parameter.javaTypeName}> {

    /**
     * Resultset mapper.
     *
     * @param resultSet resultset.
     * @param i row number.
     * @throws java.sql.SQLException if error.
     * @return object
     */
    @Override
    public ${parameter.javaTypeName} mapRow (
            final java.sql.ResultSet resultSet,
            final int i
    ) throws java.sql.SQLException {

        ${parameter.javaTypeName} result = new ${parameter.javaTypeName}();
        
        <#list parameter.parameters as paramrs>
        <#if paramrs.sqlTypeName == 'java.sql.Types.TIMESTAMP'>
        result.set${paramrs.propertyName}((${paramrs.javaTypeName}) resultSet.getTimestamp("${paramrs.name}"));
        <#elseif paramrs.sqlTypeName == 'java.sql.Types.CLOB'>
        result.set${paramrs.propertyName}((${paramrs.javaTypeName}) resultSet.getString("${paramrs.name}"));
        <#elseif paramrs.sqlTypeName == 'java.sql.Types.BLOB'>
        result.set${paramrs.propertyName}((${paramrs.javaTypeName}) resultSet.getBytes("${paramrs.name}"));
        <#else>
        result.set${paramrs.propertyName}((${paramrs.javaTypeName}) resultSet.getObject("${paramrs.name}"));
        </#if>
        </#list>

        return result;
    }
}
</#if>
