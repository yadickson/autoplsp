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
package ${javaPackage}.repository.sp;

<#list proc.parameters as parameter>
<#if parameter.inputOutput>
<#assign fillInOut = 1>
<#elseif parameter.output>
<#assign fillOut = 1>
<#elseif parameter.input>
<#assign fillIn = 1>
<#elseif parameter.returnResultSet>
<#assign fillResultSet = 1>
</#if>
<#if parameter.resultSet || parameter.returnResultSet>
<#assign fillSpace = 1>
import ${javaPackage}.repository.mapper.${parameter.javaTypeName}RowMapper;
</#if>
</#list>
<#if fillSpace??>

</#if>
import java.util.Map;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.jdbc.core.JdbcTemplate;
<#if fillInOut??>
import org.springframework.jdbc.core.SqlInOutParameter;
</#if>
<#if fillOut??>
import org.springframework.jdbc.core.SqlOutParameter;
</#if>
<#if fillIn??>
import org.springframework.jdbc.core.SqlParameter;
</#if>
<#if fillResultSet??>
import org.springframework.jdbc.core.SqlReturnResultSet;
</#if>
import org.springframework.jdbc.object.GenericSqlQuery;
import org.springframework.stereotype.Repository;

<#if documentation>
/**
 * DAO for <#if proc.function>function<#else>stored procedure</#if>.
 *
 * ${proc.fullName}
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
</#if>
@Repository
public final class ${proc.className}SqlQueryImpl
        extends GenericSqlQuery
        implements ${proc.className}SqlQuery {

<#if documentation>
    /**
     * Full <#if proc.function>function<#else>stored procedure</#if> name.
     */
</#if>
    public static final String SPROC_NAME
            = "${proc.fullName}";

<#if documentation>
    /**
     * Class constructor from jdbcTemplate.
     *
     * @param jdbcTemplate jdbcTemplate
     */
</#if>
    public ${proc.className}SqlQueryImpl(@Qualifier("${jdbcTemplate}") final JdbcTemplate jdbcTemplate) {
        super();

        setDataSource(Objects.requireNonNull(jdbcTemplate.getDataSource()));

        setSql("select * from ${proc.fullName}(<#list proc.inputParameters as parameter>?<#sep>, </#sep></#list>)");

<#list proc.parameters as parameter>
<#if !parameter.returnResultSet>
        Sql<#if parameter.inputOutput>InOut<#elseif parameter.output>Out</#if>Parameter sql${parameter.propertyName}${proc.className};
</#if>
</#list>

<#list proc.parameters as parameter>
<#if !parameter.returnResultSet>
        sql${parameter.propertyName}${proc.className} = new Sql<#if parameter.inputOutput>InOut<#elseif parameter.output>Out</#if>Parameter(
                "${parameter.prefix}${parameter.name}",
                ${parameter.sqlTypeName}
        );

</#if>
</#list>

<#list proc.parameters as parameter>
<#if !parameter.returnResultSet>
        declareParameter(sql${parameter.propertyName}${proc.className});
<#else>
        try {
            setRowMapperClass(new ${parameter.javaTypeName}RowMapper().getClass());
        } catch (Exception ex) {

        }
</#if>
</#list>

        compile();
    }

<#if documentation>
    /**
     * Execute the <#if proc.function>function<#else>stored procedure</#if>.
     *
     * @return response.
     * @param params input parameters.
     */
</#if>
    public Map<String, Object> execute(final Map<String, Object> params) {
        Map map<String, Object> = new HashMap<<#if !diamond>String, Object</#if>>();
<#list proc.parameters as parameter>
<#if parameter.returnResultSet>
        map.put("${parameter.prefix}${parameter.name}", super.execute(params.values().toArray()));
</#if>
</#list>
        return map;
    }
}
