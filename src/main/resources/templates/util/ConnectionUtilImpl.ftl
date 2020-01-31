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
package ${javaPackage}.util;
<#list proc.parameters as parameter>
<#if parameter.object || parameter.array>
<#assign importDataSourceUtils = 1>
</#if>
</#list>

import java.sql.Connection;

import javax.annotation.Resource;
<#if logger>

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
</#if>
<#if importDataSourceUtils??>

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DataSourceUtils;
</#if>

import org.springframework.stereotype.Component;

/**
 * Class to process connection transaction.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
@Component
public final class ${prefixUtilityName}ConnectionUtilImpl implements
        ${prefixUtilityName}ConnectionUtil {
<#if logger>

    /**
     * Logger.
     */
    private static final Logger LOGGER
            = LoggerFactory.getLogger(ConnectionUtilImpl.class);
</#if>
<#if importDataSourceUtils??>

    /**
     * JDBC template to use.
     */
    @Resource(name = "${jdbcTemplate}")
    private JdbcTemplate jdbcTemplate;
</#if>

    /**
     * {@inheritDoc}
     */
    @Override
    public Connection process() {

        Connection connection;

        try {

            connection = DataSourceUtils.getConnection(
                 jdbcTemplate.getDataSource()
            );

        } catch (Exception ex) {
<#if logger>
            LOGGER.error(ex.getMessage(), ex);
</#if>
            connection = null;
        }

        return connection;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public boolean release(final Connection connection) {

        boolean result;

        try {

            DataSourceUtils.releaseConnection(
                connection,
                jdbcTemplate.getDataSource()
            );

            result = true;

        } catch (Exception ex) {
            result = false;
        }

        return result;
    }

}
