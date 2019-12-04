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
package ${javaPackage}.repository;

<#list proc.outputParameters as parameter>
<#if parameter.date>
<#assign importDate = 1>
<#elseif parameter.clob>
<#assign importClobUtil = 1>
<#elseif parameter.blob>
<#assign importBlobUtil = 1>
</#if>
</#list>
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
<#if !proc.functionInline>
import ${javaPackage}.repository.sp.${proc.className}SP;
<#else>
import ${javaPackage}.repository.sp.${proc.className}SqlQuery;
</#if>
<#if importBlobUtil??>
import ${javaPackage}.util.BlobUtil;
</#if>
<#if proc.checkResult>
import ${javaPackage}.util.CheckResult;
</#if>
<#if importClobUtil??>
import ${javaPackage}.util.ClobUtil;
</#if>

import java.sql.SQLException;

<#if importDate??>
import java.util.Date;
</#if>
import java.util.HashMap;
<#if proc.hasResultSet>
import java.util.List;
</#if>
import java.util.Map;

import javax.annotation.Resource;

<#if logger>
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

</#if>
import org.springframework.beans.factory.annotation.Autowired;

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
@SuppressWarnings({"unchecked"})
public final class ${proc.className}DAOImpl
        implements ${proc.className}DAO {

<#if logger>
    /**
     * Logger.
     */
    private static final Logger LOGGER
            = LoggerFactory.getLogger(${proc.className}DAOImpl.class);

</#if>
<#if proc.hasObject || proc.hasArray>
    /**
     * JDBC template to use.
     */
    @Resource(name = "${jdbcTemplate}")
    private JdbcTemplate jdbcTemplate;

</#if>
<#if importBlobUtil??>
    /**
     * Blob utility.
     */
    @Autowired
    private BlobUtil blobUtil;

</#if>
<#if proc.checkResult>
    /**
     * Check result utility.
     */
    @Autowired
    private CheckResult checkResult;

</#if>
<#if importClobUtil??>
    /**
     * Clob utility.
     */
    @Autowired
    private ClobUtil clobUtil;

</#if>
    /**
     * <#if proc.function>Function<#else>Stored procedure</#if>.
     *
     * ${proc.fullName}
     *
     */
    @Resource(name = "${proc.className}<#if !proc.functionInline>SP<#else>SqlQuery</#if>")
    private ${proc.className}<#if !proc.functionInline>SP<#else>SqlQuery</#if> <#if proc.function>function<#else>procedure</#if>;

    /**
     * Execute <#if proc.function>function<#else>stored procedure</#if>.
     *
     * ${proc.fullName}
     *
<#if proc.hasInput>
     * @param params input parameters
</#if>
<#if proc.hasOutput>
     * @return output parameters
</#if>
     * @throws SQLException if error.
     */
    @Override
    public <#if proc.hasOutput>${proc.className}OUT<#else>void</#if> execute(<#if proc.hasInput>
            final ${proc.className}IN params
    </#if>) throws SQLException {

        Map<String, Object> in = new HashMap<<#if !diamond>String, Object</#if>>();
<#if proc.hasOutput>
        Map<String, Object> out;
</#if>

<#list proc.inputParameters as parameter>
<#if parameter.object || parameter.array>
        in.put("${parameter.prefix}${parameter.name}", params.get${parameter.propertyName}().processObject(org.springframework.jdbc.datasource.DataSourceUtils.getConnection(jdbcTemplate.getDataSource())));
<#else>
        in.put("${parameter.prefix}${parameter.name}", params.get${parameter.propertyName}());
</#if>
</#list>
<#if proc.hasInput>

</#if>
        try {
            <#if proc.hasOutput>out = </#if><#if proc.function>function<#else>procedure</#if>.execute(in);
        } catch (Exception ex) {
<#if logger>
            LOGGER.error(ex.getMessage(), ex);
</#if>
            throw new SQLException(ex.getMessage(), "${successCode}", ex);
        }
<#if proc.hasOutput>
<#if proc.checkResult>

        checkResult.check(out);
</#if>

        ${proc.className}OUT result;
        result = new ${proc.className}OUT();

<#list proc.outputParameters as parameter>
<#if parameter.resultSet || parameter.returnResultSet>
        List<${parameter.javaTypeName}> obj${parameter.propertyName};
<#else>
        ${parameter.javaTypeName} obj${parameter.propertyName};
</#if>
</#list>

<#list proc.outputParameters as parameter>
<#if parameter.resultSet || parameter.returnResultSet>
        obj${parameter.propertyName} = (List) out.get("${parameter.prefix}${parameter.name}");
<#elseif parameter.clob>
        obj${parameter.propertyName} = clobUtil.process(out.get("${parameter.prefix}${parameter.name}"));
<#elseif parameter.blob>
        obj${parameter.propertyName} = blobUtil.process(out.get("${parameter.prefix}${parameter.name}"));
<#else>
        obj${parameter.propertyName} = (${parameter.javaTypeName}) out.get("${parameter.prefix}${parameter.name}");
</#if>
</#list>

<#list proc.outputParameters as parameter>
        result.set${parameter.propertyName}(obj${parameter.propertyName});
</#list>

        return result;
</#if>
    }

}
