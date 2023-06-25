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
package ${javaPackage}.${repositoryFolderName}.sp;
<#assign importList = ["org.springframework.stereotype.Repository", "org.springframework.jdbc.object.StoredProcedure", "java.util.Objects", "org.springframework.beans.factory.annotation.Qualifier", "org.springframework.jdbc.core.JdbcTemplate"]>
<#list proc.parameters as parameter>
<#if parameter.inputOutput>
<#assign importList = importList + ["org.springframework.jdbc.core.SqlInOutParameter"]>
<#elseif parameter.output>
<#assign importList = importList + ["org.springframework.jdbc.core.SqlOutParameter"]>
<#elseif parameter.input>
<#assign importList = importList + ["org.springframework.jdbc.core.SqlParameter"]>
<#elseif parameter.returnResultSet>
<#assign importList = importList + ["org.springframework.jdbc.core.SqlReturnResultSet"]>
</#if>
<#if parameter.resultSet || parameter.returnResultSet>
<#assign importList = importList + ["${javaPackage}.${repositoryFolderName}.mapper.${parameter.javaTypeName}RowMapperImpl"]>
</#if>
</#list>

<#list importSort(importList) as import>
<#if previousImportMatch?? && !import?starts_with(previousImportMatch)>

</#if>
import ${import};
<#assign previousImportMatch = import?keep_before_last(".") >
</#list>
<#if importList?has_content>

</#if>
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
public final class ${proc.className}SPImpl${'\n'}        extends StoredProcedure${'\n'}        implements ${proc.className}SP {

<#if documentation>
    /**
     * Full <#if proc.function>function<#else>stored procedure</#if> name.
     */
</#if>
    public static final String SPROC_NAME = "${proc.fullName}";

<#if documentation>
    /**
     * Class constructor from jdbcTemplate.
     *
     * @param jdbcTemplate jdbcTemplate
     */
</#if>
    public ${proc.className}SPImpl(${'\n'}        @Qualifier("${jdbcTemplate}") final JdbcTemplate jdbcTemplate${'\n'}    ) {

        super(Objects.requireNonNull(jdbcTemplate.getDataSource()), SPROC_NAME);

        setFunction(<#if proc.function>true<#else>false</#if>);

<#if proc.parameters?size <= 10 >
<#assign noFullChunk = 1>
<#list proc.parameters as parameter>
        <#if parameter.returnResultSet>SqlReturnResultSet<#else>Sql<#if parameter.inputOutput>InOut<#elseif parameter.output>Out</#if>Parameter</#if> ${parameter.fieldName}${proc.className};
</#list>

<#list proc.parameters as parameter>
        ${parameter.fieldName}${proc.className} = new <#if parameter.returnResultSet>SqlReturnResultSet<#else>Sql<#if parameter.inputOutput>InOut<#elseif parameter.output>Out</#if>Parameter</#if>(
                "${parameter.prefix}${parameter.name}"<#if ! parameter.returnResultSet >,
                ${parameter.sqlTypeName}</#if><#if parameter.resultSet || parameter.returnResultSet >,
                new ${parameter.javaTypeName}RowMapperImpl()</#if>
        );

</#list>
<#list proc.parameters as parameter>
        declareParameter(${parameter.fieldName}${proc.className});
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

<#if documentation>
    /**
     * Fill parameters declaration for step ${step}.
     */
</#if>
    private void fillStep${step}() {

<#list childs as paramrs>
        <#if paramrs.returnResultSet>SqlReturnResultSet<#else>Sql<#if paramrs.inputOutput>InOut<#elseif paramrs.output>Out</#if>Parameter</#if> ${paramrs.fieldName}${proc.className};
</#list>

<#list childs as paramrs>
        ${paramrs.fieldName}${proc.className} = new <#if paramrs.returnResultSet>SqlReturnResultSet<#else>Sql<#if paramrs.inputOutput>InOut<#elseif paramrs.output>Out</#if>Parameter</#if>(
                "${paramrs.prefix}${paramrs.name}"<#if ! paramrs.returnResultSet >,
                ${paramrs.sqlTypeName}</#if><#if paramrs.resultSet || paramrs.returnResultSet >,
                new ${paramrs.javaTypeName}RowMapperImpl()</#if>
        );

</#list>
<#list childs as paramrs>
        declareParameter(${paramrs.fieldName}${proc.className});
</#list>
    }
</#list>
</#if>
}
