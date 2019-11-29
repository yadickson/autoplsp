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
package ${javaPackage}.repository;

<#list proc.parameters as parameter>
<#if parameter.resultSet || parameter.returnResultSet>
import ${javaPackage}.domain.${parameter.javaTypeName};
</#if>
</#list>
<#if proc.hasInput>
import ${javaPackage}.domain.${proc.className}IN;
</#if>
<#if proc.hasOutput>
import ${javaPackage}.domain.${proc.className}OUT;
</#if>
import ${javaPackage}.repository.sp.${proc.className}SP;
<#if proc.checkResult>
import ${javaPackage}.util.CheckResult;
</#if>

import java.sql.SQLException;

import java.util.HashMap;
import java.util.Map;

<#if proc.hasObject || proc.hasArray>
import javax.annotation.Resource;

</#if>
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

<#if proc.hasObject || proc.hasArray>
import org.springframework.jdbc.core.JdbcTemplate;
</#if>
import org.springframework.stereotype.Repository;

/**
 * DAO implementation for <#if proc.function>function<#else>stored procedure</#if>.
 *
 * ${proc.fullName}
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
@Repository
public final class ${proc.className}DAOImpl implements ${proc.className}DAO {

<#if proc.hasObject || proc.hasArray>
    /**
     * JDBC template to use.
     */
    @Resource(name="${jdbcTemplate}")
    private JdbcTemplate jdbcTemplate;

</#if>
<#if proc.checkResult>
    /**
     * Check result utility.
     */
    @Autowired
    private CheckResult checkResult;

</#if>
    /**
     * <#if proc.function>Function<#else>Stored procedure</#if> ${proc.fullName}.
     */
    @Autowired
    @Qualifier(value = "${proc.className}<#if !proc.functionInline>SP<#else>SqlQuery</#if>")
    private ${proc.className}<#if !proc.functionInline>SP<#else>SqlQuery</#if> <#if proc.function>function<#else>procedure</#if>;

    /**
     * Execute <#if proc.function>function<#else>stored procedure</#if> ${proc.fullName}.
     *
<#if proc.hasInput>
     * @param params input parameters
</#if>
<#if proc.hasOutput>
     * @return output parameters
</#if>
     * @throws java.sql.SQLException if error.
     */
    @Override
    public <#if proc.hasOutput>${proc.className}OUT<#else>void</#if> execute(<#if proc.hasInput>
            final ${proc.className}IN params</#if>
    ) throws SQLException {

        Map<String, Object> mparams = new HashMap<String, Object>();
<#if proc.hasOutput>
        Map<String, Object> outparams;
</#if>

        try {
<#list proc.inputParameters as parameter>
<#if parameter.object || parameter.array>
            mparams.put("${parameter.prefix}${parameter.name}", params.get${parameter.propertyName}().processObject(org.springframework.jdbc.datasource.DataSourceUtils.getConnection(jdbcTemplate.getDataSource())));
<#else>
            mparams.put("${parameter.prefix}${parameter.name}", params.get${parameter.propertyName}());
</#if>
</#list>
<#if !proc.hasOutput>
            <#if proc.function>function<#else>procedure</#if>.execute(mparams);
        } catch (Exception ex) {
            throw new SQLException(ex);
        }
</#if>
<#if proc.hasOutput>
            outparams = <#if proc.function>function<#else>procedure</#if>.execute(mparams);
        } catch (Exception ex) {
            throw new SQLException(ex);
        }
<#if proc.checkResult>

        checkResult.check(outparams);
</#if>

        ${proc.className}OUT result;
        result = new ${proc.className}OUT();

        try {

<#list proc.outputParameters as parameter>
<#if parameter.sqlTypeName == 'java.sql.Types.CLOB' >
            java.sql.Clob clob${parameter.propertyName};
            clob${parameter.propertyName} = (java.sql.Clob) outparams.get("${parameter.prefix}${parameter.name}");
            String string${parameter.propertyName} = null;

            if (clob${parameter.propertyName} != null) {
                java.io.Reader reader${parameter.propertyName} = clob${parameter.propertyName}.getCharacterStream();
                java.io.StringWriter writer${parameter.propertyName} = new java.io.StringWriter();
                org.apache.commons.io.IOUtils.copy(reader${parameter.propertyName}, writer${parameter.propertyName});
                string${parameter.propertyName} = writer${parameter.propertyName}.toString();
                clob${parameter.propertyName}.free();
            }

<#elseif parameter.sqlTypeName == 'java.sql.Types.BLOB' >
            java.sql.Blob blob${parameter.propertyName} = (java.sql.Blob) outparams.get("${parameter.prefix}${parameter.name}");
            byte [] bytes${parameter.propertyName} = null;

            if (blob${parameter.propertyName} != null) {
                java.io.InputStream input${parameter.propertyName} = blob${parameter.propertyName}.getBinaryStream();
                java.io.ByteArrayOutputStream output${parameter.propertyName} = new java.io.ByteArrayOutputStream();
                org.apache.commons.io.IOUtils.copy(input${parameter.propertyName}, output${parameter.propertyName});
                bytes${parameter.propertyName} = output${parameter.propertyName}.toByteArray();
                blob${parameter.propertyName}.free();
            }

<#elseif parameter.resultSet || parameter.returnResultSet>
            Object object${parameter.propertyName} = outparams.get("${parameter.prefix}${parameter.name}");
<#else>
            ${parameter.javaTypeName} object${parameter.propertyName} = (${parameter.javaTypeName}) outparams.get("${parameter.prefix}${parameter.name}");
</#if>
</#list>

<#list proc.outputParameters as parameter>
<#if parameter.sqlTypeName == 'java.sql.Types.CLOB' >
            result.set${parameter.propertyName}(string${parameter.propertyName});
<#elseif parameter.sqlTypeName == 'java.sql.Types.BLOB' >
            result.set${parameter.propertyName}(bytes${parameter.propertyName});
<#elseif parameter.resultSet || parameter.returnResultSet>
            if (object${parameter.propertyName} instanceof java.util.List) {
                result.set${parameter.propertyName}((java.util.List<${parameter.javaTypeName}>) object${parameter.propertyName});
            }
<#else>
            result.set${parameter.propertyName}(object${parameter.propertyName});
</#if>
</#list>

        } catch (Exception ex) {
            throw new SQLException(ex);
        }

        return result;
</#if>
    }

}
