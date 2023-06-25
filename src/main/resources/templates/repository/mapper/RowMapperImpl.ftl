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
package ${javaPackage}.${repositoryFolderName}.mapper;
<#assign importList = ["java.sql.ResultSet", "java.sql.SQLException"]>
<#if repositoryFolderName != cursorFolderName>
<#assign importList = importList + ["${javaPackage}.${cursorFolderName}.${parameter.javaTypeName}", "${javaPackage}.${cursorFolderName}.${parameter.javaTypeName}Impl"]>
</#if>
<#list parameter.parameters as paramrs>
<#if paramrs.date>
<#assign importList = importList + ["java.util.Date"]>
</#if>
</#list>

<#list importSort(importList) as import>
<#if previousImportMatch?? && !import?starts_with(previousImportMatch)>

</#if>
import ${import};
<#assign previousImportMatch = import?keep_before_last(".") >
</#list>
<#if importList?has_content>

</#if>
<#if documentation>
/**
 * ResultSet mapper for <#if proc.function>function<#else>stored procedure</#if>.
 *
 * ${proc.fullName}
 *
 * ${parameter.name}
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
</#if>
public final class ${parameter.javaTypeName}RowMapperImpl${'\n'}        implements ${parameter.javaTypeName}RowMapper {

<#list parameter.parameters as paramrs>
<#if documentation>
    /**
     * Column <#if position>position<#else>name</#if>.
     */
</#if>
    private static final <#if position>int<#else>String</#if> ${proc.constantFullName}_${paramrs.name} = <#if position>${paramrs.position}<#else>"${paramrs.name}"</#if>;

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
    public ${parameter.javaTypeName} mapRow(${'\n'}            final ResultSet resultSet,${'\n'}            final int i${'\n'}    ) throws SQLException {
<#if !fullConstructor>

        ${parameter.javaTypeName}Impl row;
        row = new ${parameter.javaTypeName}Impl();

<#if parameter.parameters?size <= 10 >
<#assign noFullChunk = 1>
<#list parameter.parameters as paramrs>
        ${paramrs.javaTypeName} ${paramrs.fieldName}${parameter.javaTypeName};
</#list>

<#list parameter.parameters as paramrs>
<#if paramrs.string || paramrs.clob>
        ${paramrs.fieldName}${parameter.javaTypeName} = resultSet.getString(${proc.constantFullName}_${paramrs.name});
<#elseif paramrs.blob>
        ${paramrs.fieldName}${parameter.javaTypeName} = resultSet.getBytes(${proc.constantFullName}_${paramrs.name});
<#elseif paramrs.date>
        ${paramrs.fieldName}${parameter.javaTypeName} = resultSet.getTimestamp(${proc.constantFullName}_${paramrs.name});
<#else>
        ${paramrs.fieldName}${parameter.javaTypeName} = (${paramrs.javaTypeName}) resultSet.getObject(${proc.constantFullName}_${paramrs.name});
</#if>
</#list>

<#list parameter.parameters as paramrs>
        row.set${paramrs.propertyName}(${paramrs.fieldName}${parameter.javaTypeName});
</#list>
<#else>
<#assign step = 0 >
<#list parameter.parameters?chunk(10) as childs>
<#assign step++ >
        fillStep${step}(resultSet, row);
</#list>
</#if>

        return row;
<#else>

<#list parameter.parameters as paramrs>
        ${paramrs.javaTypeName} ${paramrs.fieldName}${parameter.javaTypeName};
</#list>

<#list parameter.parameters as paramrs>
<#if paramrs.string || paramrs.clob>
        ${paramrs.fieldName}${parameter.javaTypeName} = resultSet.getString(${proc.constantFullName}_${paramrs.name});
<#elseif paramrs.blob>
        ${paramrs.fieldName}${parameter.javaTypeName} = resultSet.getBytes(${proc.constantFullName}_${paramrs.name});
<#elseif paramrs.date>
        ${paramrs.fieldName}${parameter.javaTypeName} = resultSet.getTimestamp(${proc.constantFullName}_${paramrs.name});
<#else>
        ${paramrs.fieldName}${parameter.javaTypeName} = (${paramrs.javaTypeName}) resultSet.getObject(${proc.constantFullName}_${paramrs.name});
</#if>
</#list>

        return new ${parameter.javaTypeName}Impl(${'\n'}            <#list parameter.parameters as parameter2>${parameter2.fieldName}${parameter.javaTypeName}<#sep>,${'\n'}            </#sep></#list>${'\n'}        );
</#if>
    }
<#if !fullConstructor>
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
        final ${parameter.javaTypeName}Impl row
    ) throws SQLException {

<#list childs as paramrs>
        ${paramrs.javaTypeName} ${paramrs.fieldName}${parameter.javaTypeName};
</#list>

<#list childs as paramrs>
<#if paramrs.string || paramrs.clob>
        ${paramrs.fieldName}${parameter.javaTypeName} = resultSet.getString(${proc.constantFullName}_${paramrs.name});
<#elseif paramrs.blob>
        ${paramrs.fieldName}${parameter.javaTypeName} = resultSet.getBytes(${proc.constantFullName}_${paramrs.name});
<#elseif paramrs.date>
        ${paramrs.fieldName}${parameter.javaTypeName} = resultSet.getTimestamp(${proc.constantFullName}_${paramrs.name});
<#else>
        ${paramrs.fieldName}${parameter.javaTypeName} = (${paramrs.javaTypeName}) resultSet.getObject(${proc.constantFullName}_${paramrs.name});
</#if>
</#list>

<#list childs as paramrs>
        row.set${paramrs.propertyName}(${paramrs.fieldName}${parameter.javaTypeName});
</#list>
    }
</#list>
</#if>
</#if>
}
