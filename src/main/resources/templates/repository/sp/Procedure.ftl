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
package ${javaPackage}.repository.sp;

<#list proc.parameters as parameter>
<#if parameter.resultSet || parameter.returnResultSet>
import ${javaPackage}.repository.mapper.${parameter.javaTypeName}RowMapper;
</#if>
</#list>

/**
 * JDBC to <#if proc.function>function<#else>stored procedure</#if> ${proc.fullName}.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
public final class ${proc.className}SP extends org.springframework.jdbc.object.<#if !proc.functionInline>StoredProcedure<#else>GenericSqlQuery</#if> {

    /**
     * Full procedure name.
     */
    public static final String SPROC_NAME = "${proc.fullName}";

    /**
     * Class constructor from dataSource.
     *
     * @param jdbcTemplate jdbcTemplate
     */
    public ${proc.className}SP(final org.springframework.jdbc.core.JdbcTemplate jdbcTemplate) {
<#if !proc.functionInline>
        super(jdbcTemplate.getDataSource(), SPROC_NAME);

        setFunction(<#if proc.function>true<#else>false</#if>);

<#list proc.parameters as parameter>
        declareParameter(new org.springframework.jdbc.core.<#if parameter.returnResultSet>SqlReturnResultSet<#else>Sql<#if parameter.inputOutput>InOut<#elseif parameter.output>Out</#if>Parameter</#if>("${parameter.prefix}${parameter.name}"<#if ! parameter.returnResultSet >, ${parameter.sqlTypeName}</#if><#if parameter.resultSet || parameter.returnResultSet >, new ${parameter.javaTypeName}RowMapper()</#if>));
</#list>
<#else>
        super();

        setDataSource(jdbcTemplate.getDataSource());

        setSql("select * from ${proc.fullName}(<#list proc.inputParameters as parameter>?<#sep>, </#sep></#list>)");

<#list proc.parameters as parameter>
<#if !parameter.returnResultSet>
        declareParameter(new org.springframework.jdbc.core.<#if parameter.returnResultSet>SqlReturnResultSet<#else>Sql<#if parameter.inputOutput>InOut<#elseif parameter.output>Out</#if>Parameter</#if>("${parameter.prefix}${parameter.name}"<#if ! parameter.returnResultSet >, ${parameter.sqlTypeName}</#if><#if parameter.resultSet || parameter.returnResultSet >, new ${parameter.javaTypeName}RowMapper()</#if>));
<#else>
        try {
            setRowMapperClass(new ${parameter.javaTypeName}RowMapper().getClass());
        } catch (Exception ex) {

        }
</#if>
</#list>
</#if>

        compile();
    }

    /**
     * Execute the stored procedure.
     *
     * @return response.
     * @param params input parameters.
     */
    public java.util.Map<String, Object> runExecute(final java.util.Map<String, Object> params) {
<#if !proc.functionInline>
        return super.execute(params);
<#else>
        java.util.Map map<String, Object> = new java.util.HashMap<String, Object>();
<#list proc.parameters as parameter>
<#if parameter.returnResultSet>
        map.put("${parameter.prefix}${parameter.name}", super.execute(params.values().toArray()));
</#if>
</#list>
        return map;
</#if>
    }
}
