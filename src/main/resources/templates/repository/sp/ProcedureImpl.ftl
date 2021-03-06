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
import org.springframework.jdbc.object.StoredProcedure;

/**
 * DAO for <#if proc.function>function<#else>stored procedure</#if>.
 *
 * ${proc.fullName}
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
public final class ${proc.className}SPImpl
        extends StoredProcedure
        implements ${proc.className}SP {

    /**
     * Full <#if proc.function>function<#else>stored procedure</#if> name.
     */
    public static final String SPROC_NAME
            = "${proc.fullName}";

    /**
     * Class constructor from jdbcTemplate.
     *
     * @param jdbcTemplate jdbcTemplate
     */
    public ${proc.className}SPImpl(final JdbcTemplate jdbcTemplate) {

        super(jdbcTemplate.getDataSource(), SPROC_NAME);

        setFunction(<#if proc.function>true<#else>false</#if>);

<#if proc.parameters?size <= 10 >
<#assign noFullChunk = 1>
<#list proc.parameters as parameter>
        <#if parameter.returnResultSet>SqlReturnResultSet<#else>Sql<#if parameter.inputOutput>InOut<#elseif parameter.output>Out</#if>Parameter</#if> ${parameter.fieldName};
</#list>

<#list proc.parameters as parameter>
        ${parameter.fieldName} = new <#if parameter.returnResultSet>SqlReturnResultSet<#else>Sql<#if parameter.inputOutput>InOut<#elseif parameter.output>Out</#if>Parameter</#if>(
                "${parameter.prefix}${parameter.name}"<#if ! parameter.returnResultSet >,
                ${parameter.sqlTypeName}</#if><#if parameter.resultSet || parameter.returnResultSet >,
                new ${parameter.javaTypeName}RowMapper()</#if>
        );

</#list>
<#list proc.parameters as parameter>
        declareParameter(${parameter.fieldName});
</#list>
<#else>
<#assign step = 0 >
<#list proc.parameters?chunk(10) as childs>
<#assign step++ >
        fillStep${step}();
</#list>
</#if>

        compile();
    }
<#if ! noFullChunk?? >
<#assign step = 0 >
<#list proc.parameters?chunk(10) as childs>
<#assign step++ >

    /**
     * Fill parameters declaration for step ${step}.
     */
    private void fillStep${step}() {

<#list childs as paramrs>
        <#if paramrs.returnResultSet>SqlReturnResultSet<#else>Sql<#if paramrs.inputOutput>InOut<#elseif paramrs.output>Out</#if>Parameter</#if> ${paramrs.fieldName};
</#list>

<#list childs as paramrs>
        ${paramrs.fieldName} = new <#if paramrs.returnResultSet>SqlReturnResultSet<#else>Sql<#if paramrs.inputOutput>InOut<#elseif paramrs.output>Out</#if>Parameter</#if>(
                "${paramrs.prefix}${paramrs.name}"<#if ! paramrs.returnResultSet >,
                ${paramrs.sqlTypeName}</#if><#if paramrs.resultSet || paramrs.returnResultSet >,
                new ${paramrs.javaTypeName}RowMapper()</#if>
        );

</#list>
<#list childs as paramrs>
        declareParameter(${paramrs.fieldName});
</#list>
    }
</#list>
</#if>
}
