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
package ${javaPackage}.${utilFolderName};
<#list proc.parameters as parameter>
<#if parameter.object || parameter.array>
<#assign importDataSourceUtils = 1>
</#if>
</#list>

import java.sql.Connection;

import org.springframework.beans.factory.annotation.Qualifier;

<#if logger>

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
</#if>
<#if importDataSourceUtils??>

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DataSourceUtils;
</#if>

import org.springframework.stereotype.Component;

import java.util.Objects;

<#if documentation>
/**
 * Class to process connection transaction.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
</#if>
@Component
final class ${prefixUtilityName}ConnectionUtilImpl implements
        ${prefixUtilityName}ConnectionUtil {
<#if logger>

<#if documentation>
    /**
     * Logger.
     */
</#if>
    private static final Logger LOGGER
            = LoggerFactory.getLogger(${prefixUtilityName}ConnectionUtilImpl.class);
</#if>
<#if importDataSourceUtils??>

<#if documentation>
    /**
     * JDBC template to use.
     */
</#if>
    private final JdbcTemplate jdbcTemplate;
</#if>

<#if documentation>
    /**
     * Class constructor.
     * @param jdbcTemplate jdbcTemplate.
     */
</#if>
    public ${prefixUtilityName}ConnectionUtilImpl(@Qualifier("${jdbcTemplate}") final JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

<#if documentation>
    /**
     * {@inheritDoc}
     */
</#if>
    @Override
    public Connection process() {

        Connection <#if prefixUtilityName??>${prefixUtilityName?uncap_first}Conn<#else>conn</#if>;

        try {

            <#if prefixUtilityName??>${prefixUtilityName?uncap_first}Conn<#else>conn</#if> = DataSourceUtils.getConnection(
                    Objects.requireNonNull(jdbcTemplate.getDataSource())
            );

        } catch (Exception ex) {
<#if logger>
            LOGGER.error(ex.getMessage(), ex);
</#if>
            <#if prefixUtilityName??>${prefixUtilityName?uncap_first}Conn<#else>conn</#if> = null;
        }

        return <#if prefixUtilityName??>${prefixUtilityName?uncap_first}Conn<#else>conn</#if>;
    }

<#if documentation>
    /**
     * {@inheritDoc}
     */
</#if>
    @Override
    public boolean release(final Connection connection) {

        boolean <#if prefixUtilityName??>${prefixUtilityName?uncap_first}Result<#else>result</#if>;

        try {

            DataSourceUtils.releaseConnection(
                    connection,
                    jdbcTemplate.getDataSource()
            );

            <#if prefixUtilityName??>${prefixUtilityName?uncap_first}Result<#else>result</#if> = true;

        } catch (Exception ex) {
            <#if prefixUtilityName??>${prefixUtilityName?uncap_first}Result<#else>result</#if> = false;
        }

        return <#if prefixUtilityName??>${prefixUtilityName?uncap_first}Result<#else>result</#if>;
    }

}
