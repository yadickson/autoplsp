<#if header>/*
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
package ${javaPackage}.repository.mapper;

import ${javaPackage}.domain.${parameter.javaTypeName};

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

/**
 * Resultset mapper for <#if proc.function>function<#else>stored procedure</#if>.
 *
 * ${proc.fullName}
 *
 * ${parameter.name}
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
public final class ${parameter.javaTypeName}RowMapper
        implements RowMapper<${parameter.javaTypeName}> {

<#list parameter.parameters as paramrs>
    /**
     * Paramater <#if position>position<#else>name</#if>.
     */
    private static final <#if position>int<#else>String</#if> ${paramrs.name} = <#if position>${paramrs.position}<#else>"${paramrs.name}"</#if>;

</#list>
    /**
     * Resultset mapper.
     *
     * @param resultSet resultset.
     * @param i row number.
     * @throws java.sql.SQLException if error.
     * @return object
     */
    @Override
    public ${parameter.javaTypeName} mapRow(
            final ResultSet resultSet,
            final int i
    ) throws SQLException {

        ${parameter.javaTypeName} result;
        result = new ${parameter.javaTypeName}();

<#list parameter.parameters as paramrs>
<#if paramrs.sqlTypeName == 'java.sql.Types.TIMESTAMP'>
        result.set${paramrs.propertyName}((${paramrs.javaTypeName}) resultSet.getTimestamp(${paramrs.name}));
<#elseif paramrs.sqlTypeName == 'java.sql.Types.VARCHAR'>
        result.set${paramrs.propertyName}(resultSet.getString(${paramrs.name}));
<#elseif paramrs.sqlTypeName == 'java.sql.Types.CLOB'>
        result.set${paramrs.propertyName}(resultSet.getString(${paramrs.name}));
<#elseif paramrs.sqlTypeName == 'java.sql.Types.BLOB'>
        result.set${paramrs.propertyName}(resultSet.getBytes(${paramrs.name}));
<#else>
        result.set${paramrs.propertyName}((${paramrs.javaTypeName}) resultSet.getObject(${paramrs.name}));
</#if>
</#list>

        return result;
    }
}
