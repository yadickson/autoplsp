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
<#assign importList = ["java.util.Map", ""org.springframework.stereotype.Repository", "org.springframework.jdbc.object.GenericSqlQuery", "java.util.Objects", "org.springframework.beans.factory.annotation.Qualifier", "org.springframework.jdbc.core.JdbcTemplate"]>
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
public final class ${proc.className}SqlQueryImpl${'\n'}        extends GenericSqlQuery${'\n'}        implements ${proc.className}SqlQuery {

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
    public ${proc.className}SqlQueryImpl(${'\n'}        @Qualifier("${jdbcTemplate}") final JdbcTemplate jdbcTemplate${'\n'}    ) {
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
            setRowMapperClass(new ${parameter.javaTypeName}RowMapperImpl().getClass());
        } catch (Exception ex) {
            // do nothing
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
