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
package ${javaPackage}.${repositoryFolderName};

<#if proc.hasInput>
import ${javaPackage}.${domainFolderName}.${proc.className}IN;
</#if>
<#if proc.hasOutput>
import ${javaPackage}.${domainFolderName}.${proc.className}OUT;
</#if>
<#list proc.parameters as parameter>
<#if parameter.resultSet || parameter.returnResultSet>
import ${javaPackage}.${domainFolderName}.${parameter.javaTypeName};
</#if>
</#list>
import ${javaPackage}.${repositoryFolderName}.sp.${proc.className}SP;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

<#if documentation>
/**
 * Mapper implementation for <#if proc.function>function<#else>stored procedure</#if>.
 *
 * ${proc.fullName}
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
</#if>
@Repository
@SuppressWarnings({"rawtypes", "unchecked", "deprecated"})
final class ${proc.className}MapperImpl implements ${proc.className}Mapper {

    private final ${proc.className}SP sp;

<#if documentation>
    /**
     * Setter for jdbcTemplate.
     *
     * @param pjdbcTemplate jdbcTemplate
     */
</#if>
    public ${proc.className}MapperImpl(@Qualifier("${jdbcTemplate}") final ${proc.className}SP sp) {
        this.sp = sp;
    }

<#if documentation>
    /**
     * Execute stored procedure.
     *
     * <#if proc.hasInput>@param params input parameters</#if>
     * <#if proc.hasOutput>@return output parameters</#if>
     * @throws SQLException if error.
     */
</#if>
    @Override
    public <#if proc.hasOutput>${proc.className}OUT<#else>void</#if> execute(<#if proc.hasInput>final ${proc.className}IN params</#if>) throws SQLException {

        java.util.Map mparams = new java.util.HashMap();
        <#if proc.hasOutput>
        java.util.Map r;
        </#if>

        try {
        <#list proc.inputParameters as parameter>
        <#if parameter.object || parameter.array>
            mparams.put("${parameter.prefix}${parameter.name}", params.get${parameter.propertyName}().processObject(org.springframework.jdbc.datasource.DataSourceUtils.getConnection(jdbcTemplate.getDataSource())));
        <#else>
            mparams.put("${parameter.prefix}${parameter.name}", params.get${parameter.propertyName} ());
        </#if>
        </#list>
        <#if !proc.hasOutput>
            this.sp.execute(mparams);
        } catch ( Exception ex ) {
            throw new java.sql.SQLException(ex);
        }
        </#if>
        <#if proc.hasOutput>
            r = this.sp.runExecute(mparams);
        } catch ( Exception ex ) {
            throw new java.sql.SQLException(ex);
        }

        java.util.Map m = evaluateResult(r);

        ${proc.className}OUT result = new ${proc.className}OUT();

        try {
        <#list proc.outputParameters as parameter>
        <#if parameter.clob >
            java.sql.Clob clob${parameter.propertyName} = ( java.sql.Clob ) m.get("${parameter.prefix}${parameter.name}");
            String string${parameter.propertyName} = null;

            if (clob${parameter.propertyName} != null) {
                java.io.Reader reader${parameter.propertyName} = clob${parameter.propertyName}.getCharacterStream();
                java.io.StringWriter writer${parameter.propertyName} = new java.io.StringWriter();
                org.apache.commons.io.IOUtils.copy(reader${parameter.propertyName}, writer${parameter.propertyName});
                string${parameter.propertyName} = writer${parameter.propertyName}.toString();
                clob${parameter.propertyName}.free();
            }

            result.set${parameter.propertyName}( string${parameter.propertyName} );
        <#elseif parameterblob >
            java.sql.Blob blob${parameter.propertyName} = ( java.sql.Blob ) m.get("${parameter.prefix}${parameter.name}");
            byte [] bytes${parameter.propertyName} = null;

            if (blob${parameter.propertyName} != null) {
                java.io.InputStream input${parameter.propertyName} = blob${parameter.propertyName}.getBinaryStream();
                java.io.ByteArrayOutputStream output${parameter.propertyName} = new java.io.ByteArrayOutputStream();
                org.apache.commons.io.IOUtils.copy(input${parameter.propertyName}, output${parameter.propertyName});
                bytes${parameter.propertyName} = output${parameter.propertyName}.toByteArray("${encode}");
                blob${parameter.propertyName}.free();
            }

            result.set${parameter.propertyName}( bytes${parameter.propertyName} );
        <#elseif parameter.resultSet || parameter.returnResultSet>
            result.set${parameter.propertyName}((java.util.List<${parameter.javaTypeName}>) m.get("${parameter.prefix}${parameter.name}"));
        <#else>
            result.set${parameter.propertyName}((${parameter.javaTypeName}) m.get("${parameter.prefix}${parameter.name}"));
        </#if>
        </#list>
        } catch ( Exception ex ) {
            throw new java.sql.SQLException(ex);
        }

        return result;
        </#if>
    }
    <#if proc.hasOutput>

<#if documentation>
    /**
     * Evaluate output parameters from database.
     *
     * @param result map to evaluate.
     * @throws SQLException if error.
     */
</#if>
    private java.util.Map evaluateResult(final java.util.Map result) throws SQLException {

        if (result == null) {
            return null;
        }
        <#list proc.outputParameters as parameter>
          <#if parameter.number && (parameter.position > 0) && parameter.name == outParameterCode >
          <#assign pCode="${parameter.name}">
          </#if>
        </#list>
        <#list proc.outputParameters as parameter>
          <#if parameter.string && (parameter.position > 0) && parameter.name == outParameterMessage >
          <#assign pMessage="${parameter.name}">
          </#if>
        </#list>
        <#if pCode?? && pMessage?? >

        Number code;
        String description;
        int val;

        try {
            code = (Number) result.get("${pCode}");
            description = (String) result.get("${pMessage}");
            val = code.intValue();
        } catch ( Exception ex ) {
            throw new java.sql.SQLException(ex);
        }

        if (val != 0) {
            throw new java.sql.SQLException(description, null, val);
        }
        </#if>

        return result;
    }
    </#if>
}
