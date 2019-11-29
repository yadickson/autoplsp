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

<#if proc.hasInput>
import ${javaPackage}.domain.${proc.className}IN;
</#if>
<#if proc.hasOutput>
import ${javaPackage}.domain.${proc.className}OUT;
</#if>
<#list proc.parameters as parameter>
<#if parameter.resultSet || parameter.returnResultSet>
import ${javaPackage}.domain.${parameter.javaTypeName};
</#if>
</#list>
import ${javaPackage}.repository.sp.${proc.className}SP;
import javax.annotation.Resource;
import org.springframework.stereotype.Repository;

/**
 * JDBCTemplate implementation for <#if proc.function>function<#else>stored procedure</#if> ${proc.fullName}.
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
    private org.springframework.jdbc.core.JdbcTemplate jdbcTemplate;
</#if>
    /**
     * <#if proc.function>Function<#else>Stored procedure</#if> ${proc.fullName}.
     */
    private ${proc.className}SP sp = null;

    /**
     * Setter for jdbcTemplate.
     *
     * @param pjdbcTemplate jdbcTemplate
     */
    @Resource(name="${jdbcTemplate}")
    public void setJdbcTemplate(final org.springframework.jdbc.core.JdbcTemplate pjdbcTemplate) {
<#if proc.hasObject || proc.hasArray>
        this.jdbcTemplate = pjdbcTemplate;
</#if>
        this.sp = new ${proc.className}SP(pjdbcTemplate);
    }

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
    @SuppressWarnings({"unchecked"})
    public <#if proc.hasOutput>${proc.className}OUT<#else>void</#if> execute(<#if proc.hasInput>final ${proc.className}IN params</#if>) throws java.sql.SQLException {

        java.util.Map<String, Object> mparams = new java.util.HashMap<String, Object>();
<#if proc.hasOutput>
        java.util.Map<String, Object> r;
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
            this.sp.execute(mparams);
        } catch (Exception ex) {
            throw new java.sql.SQLException(ex);
        }
</#if>
<#if proc.hasOutput>
            r = this.sp.runExecute(mparams);
        } catch (Exception ex) {
            throw new java.sql.SQLException(ex);
        }

        java.util.Map<String, Object> m = <#if proc.checkResult >${javaPackage}.util.CheckResult.check(r)<#else>r</#if>;

        ${proc.className}OUT result = new ${proc.className}OUT();

        try {
<#list proc.outputParameters as parameter>
<#if parameter.sqlTypeName == 'java.sql.Types.CLOB' >
            java.sql.Clob clob${parameter.propertyName};
            clob${parameter.propertyName} = (java.sql.Clob) m.get("${parameter.prefix}${parameter.name}");
            String string${parameter.propertyName} = null;

            if (clob${parameter.propertyName} != null) {
                java.io.Reader reader${parameter.propertyName} = clob${parameter.propertyName}.getCharacterStream();
                java.io.StringWriter writer${parameter.propertyName} = new java.io.StringWriter();
                org.apache.commons.io.IOUtils.copy(reader${parameter.propertyName}, writer${parameter.propertyName});
                string${parameter.propertyName} = writer${parameter.propertyName}.toString();
                clob${parameter.propertyName}.free();
            }

            result.set${parameter.propertyName}(string${parameter.propertyName});
<#elseif parameter.sqlTypeName == 'java.sql.Types.BLOB' >
            java.sql.Blob blob${parameter.propertyName} = (java.sql.Blob) m.get("${parameter.prefix}${parameter.name}");
            byte [] bytes${parameter.propertyName} = null;

            if (blob${parameter.propertyName} != null) {
                java.io.InputStream input${parameter.propertyName} = blob${parameter.propertyName}.getBinaryStream();
                java.io.ByteArrayOutputStream output${parameter.propertyName} = new java.io.ByteArrayOutputStream();
                org.apache.commons.io.IOUtils.copy(input${parameter.propertyName}, output${parameter.propertyName});
                bytes${parameter.propertyName} = output${parameter.propertyName}.toByteArray();
                blob${parameter.propertyName}.free();
            }

            result.set${parameter.propertyName}(bytes${parameter.propertyName});
<#elseif parameter.resultSet || parameter.returnResultSet>
            result.set${parameter.propertyName}((java.util.List<${parameter.javaTypeName}>) m.get("${parameter.prefix}${parameter.name}"));
<#else>
            result.set${parameter.propertyName}((${parameter.javaTypeName}) m.get("${parameter.prefix}${parameter.name}"));
</#if>
</#list>
        } catch (Exception ex) {
            throw new java.sql.SQLException(ex);
        }

        return result;
</#if>
    }

}
