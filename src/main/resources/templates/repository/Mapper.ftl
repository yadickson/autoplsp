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
<#if parameter.resultSet>
package ${javaPackage}.repository.mapper;

import ${javaPackage}.domain.${parameter.javaTypeName};

/**
 * Resultset mapper of ${parameter.name}
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
@SuppressWarnings({"rawtypes","unchecked"})
public class ${parameter.javaTypeName}RowMapper implements org.springframework.jdbc.core.RowMapper, java.io.Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * Resultset mapper
     *
     * @param resultSet resultset
     * @param i row number
     * @throws java.sql.SQLException
     * @return object
     */
    @Override
    public Object mapRow (java.sql.ResultSet resultSet, int i) throws java.sql.SQLException
    {
        ${parameter.javaTypeName} result = new ${parameter.javaTypeName}();
        
        <#list parameter.parameters as paramrs>
        <#if paramrs.sqlTypeName == 'java.sql.Types.TIMESTAMP'>
        result.set${paramrs.propertyName} ((${paramrs.javaTypeName})resultSet.getTimestamp(${paramrs.position}));
        <#elseif paramrs.sqlTypeName == 'java.sql.Types.CLOB'>
        java.sql.Clob clob${paramrs.propertyName} = (java.sql.Clob) resultSet.getObject(${paramrs.position});
        result.set${paramrs.propertyName}( clob${paramrs.propertyName} == null ? null : clob${paramrs.propertyName}.getSubString(1, (int) clob${paramrs.propertyName}.length()));
        <#else>
        result.set${paramrs.propertyName} ((${paramrs.javaTypeName})resultSet.getObject(${paramrs.position}));
        </#if>
        </#list>

        return result;
    }
}
</#if>
