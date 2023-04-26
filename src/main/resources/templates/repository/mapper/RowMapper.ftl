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
package ${javaPackage}.repository.mapper;
<#list parameter.parameters as paramrs>
<#if paramrs.date>
<#assign importDate = 1>
</#if>
</#list>

import ${javaPackage}.cursor.${parameter.javaTypeName};

import java.sql.ResultSet;
import java.sql.SQLException;
<#if importDate??>

import java.util.Date;
</#if>

import org.springframework.jdbc.core.RowMapper;

<#if documentation>
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
</#if>
public final class ${parameter.javaTypeName}RowMapper
        implements RowMapper<${parameter.javaTypeName}> {

<#list parameter.parameters as paramrs>
<#if documentation>
    /**
     * Column <#if position>position<#else>name</#if>.
     */
</#if>
    private static final <#if position>int<#else>String</#if> ${paramrs.name} = <#if position>${paramrs.position}<#else>"${paramrs.name}"</#if>;

</#list>
<#if documentation>
    /**
     * Resultset mapper.
     *
     * @param resultSet resultset.
     * @param i row number.
     * @throws SQLException if error.
     * @return object
     */
</#if>
    @Override
    public ${parameter.javaTypeName} mapRow(
            final ResultSet resultSet,
            final int i
    ) throws SQLException {

        ${parameter.javaTypeName} row;
        row = new ${parameter.javaTypeName}();

<#if parameter.parameters?size <= 10 >
<#assign noFullChunk = 1>
<#list parameter.parameters as paramrs>
        ${paramrs.javaTypeName} ${paramrs.fieldName};
</#list>

<#list parameter.parameters as paramrs>
<#if paramrs.string || paramrs.clob>
        ${paramrs.fieldName} = resultSet.getString(${paramrs.name});
<#elseif paramrs.blob>
        ${paramrs.fieldName} = resultSet.getBytes(${paramrs.name});
<#elseif paramrs.date>
        ${paramrs.fieldName} = resultSet.getTimestamp(${paramrs.name});
<#else>
        ${paramrs.fieldName} = (${paramrs.javaTypeName}) resultSet.getObject(${paramrs.name});
</#if>
</#list>

<#list parameter.parameters as paramrs>
        row.set${paramrs.propertyName}(${paramrs.fieldName});
</#list>
<#else>
<#assign step = 0 >
<#list parameter.parameters?chunk(10) as childs>
<#assign step++ >
        fillStep${step}(resultSet, row);
</#list>
</#if>

        return row;
    }
<#if ! noFullChunk?? >
<#assign step = 0 >
<#list parameter.parameters?chunk(10) as childs>
<#assign step++ >

<#if documentation>
    /**
     * Fill row values for step ${step}.
     *
     * @param resultSet resultset.
     * @param row row to fill.
     * @throws SQLException if error.
     */
</#if>
    private void fillStep${step}(
        final ResultSet resultSet,
        final ${parameter.javaTypeName} row
    ) throws SQLException {

<#list childs as paramrs>
        ${paramrs.javaTypeName} ${paramrs.fieldName};
</#list>

<#list childs as paramrs>
<#if paramrs.string || paramrs.clob>
        ${paramrs.fieldName} = resultSet.getString(${paramrs.name});
<#elseif paramrs.blob>
        ${paramrs.fieldName} = resultSet.getBytes(${paramrs.name});
<#elseif paramrs.date>
        ${paramrs.fieldName} = resultSet.getTimestamp(${paramrs.name});
<#else>
        ${paramrs.fieldName} = (${paramrs.javaTypeName}) resultSet.getObject(${paramrs.name});
</#if>
</#list>

<#list childs as paramrs>
        row.set${paramrs.propertyName}(${paramrs.fieldName});
</#list>
    }
</#list>
</#if>
}
