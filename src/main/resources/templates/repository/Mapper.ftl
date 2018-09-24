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
 * Resultset mapper of ${parameter.name}.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
@SuppressWarnings({"rawtypes","unchecked"})
public class ${parameter.javaTypeName}RowMapper implements org.springframework.jdbc.core.RowMapper, java.io.Serializable {

    /**
     * Serialization.
     */
    static final long serialVersionUID = 1L;

    /**
     * Resultset mapper.
     *
     * @param resultSet resultset.
     * @param i row number.
     * @throws java.sql.SQLException if error.
     * @return object
     */
    @Override
    public Object mapRow (java.sql.ResultSet resultSet, int i) throws java.sql.SQLException
    {
        ${parameter.javaTypeName} result = new ${parameter.javaTypeName}();
        
        <#list parameter.parameters as paramrs>
        <#if paramrs.sqlTypeName == 'java.sql.Types.TIMESTAMP'>
        result.set${paramrs.propertyName} ((${paramrs.javaTypeName})resultSet.getTimestamp("${paramrs.name}"));
        <#elseif paramrs.sqlTypeName == 'java.sql.Types.CLOB'>
        java.sql.Clob clob${paramrs.propertyName} = (java.sql.Clob) resultSet.getObject("${paramrs.name}");
        String string${paramrs.propertyName} = null;

        if (clob${paramrs.propertyName} != null) {
            try {
                java.io.Reader reader${paramrs.propertyName} = clob${paramrs.propertyName}.getCharacterStream();
                java.io.StringWriter writer${paramrs.propertyName} = new java.io.StringWriter();
                org.apache.commons.io.IOUtils.copy(reader${paramrs.propertyName}, writer${paramrs.propertyName});
                string${paramrs.propertyName} = writer${paramrs.propertyName}.toString();
                clob${paramrs.propertyName}.free();
            } catch (java.io.IOException ex) {
                throw new java.sql.SQLException(ex);
            }
        }

        result.set${paramrs.propertyName} (string${paramrs.propertyName});
        <#elseif paramrs.sqlTypeName == 'java.sql.Types.BLOB'>
        java.sql.Blob blob${paramrs.propertyName} = (java.sql.Blob) resultSet.getObject("${paramrs.name}");
        byte [] bytes${paramrs.propertyName} = null;

        if (blob${paramrs.propertyName} != null) {
            try {
                java.io.InputStream input${paramrs.propertyName} = blob${paramrs.propertyName}.getBinaryStream();
                java.io.ByteArrayOutputStream output${paramrs.propertyName} = new java.io.ByteArrayOutputStream();
                org.apache.commons.io.IOUtils.copy(input${paramrs.propertyName}, output${paramrs.propertyName});
                bytes${paramrs.propertyName} = output${paramrs.propertyName}.toByteArray();
                blob${paramrs.propertyName}.free();
            } catch (java.io.IOException ex) {
                throw new java.sql.SQLException(ex);
            }
        }

        result.set${paramrs.propertyName} (bytes${paramrs.propertyName});
        <#else>
        result.set${paramrs.propertyName} ((${paramrs.javaTypeName})resultSet.getObject("${paramrs.name}"));
        </#if>
        </#list>

        return result;
    }
}
</#if>
