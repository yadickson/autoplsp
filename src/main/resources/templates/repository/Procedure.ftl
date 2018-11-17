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
package ${javaPackage}.repository.sp;

<#list proc.parameters as parameter>
<#if parameter.resultSet || parameter.returnResultSet>
import ${javaPackage}.repository.mapper.${parameter.javaTypeName}RowMapper;
</#if>
</#list>

/**
 * JDBC Stored Procedure ${proc.fullName}.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
@SuppressWarnings({"rawtypes","unchecked"})
public class ${proc.className}SP extends org.springframework.jdbc.object.StoredProcedure implements java.io.Serializable {

    /**
     * Serialization.
     */
    static final long serialVersionUID = 1L;

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
        super(jdbcTemplate.getDataSource(), SPROC_NAME);
        setFunction(<#if proc.functionInline>false<#else><#if proc.function>true<#else>false</#if></#if>);
        <#list proc.parameters as parameter>
        declareParameter(new org.springframework.jdbc.core.<#if parameter.returnResultSet>SqlReturnResultSet<#else>Sql<#if parameter.inputOutput>InOut<#elseif parameter.output>Out</#if>Parameter</#if> ("${parameter.prefix}${parameter.name}"<#if ! parameter.returnResultSet >, ${parameter.sqlTypeName}</#if><#if parameter.resultSet || parameter.returnResultSet >, new ${parameter.javaTypeName}RowMapper ()</#if>));
        </#list>
        compile();
    }

    /**
     * Execute the stored procedure.
     *
     * @return response.
     * @param params input parameters.
     */
    @Override
    public java.util.Map execute(java.util.Map params) {
        return super.execute(params);
    }
}
