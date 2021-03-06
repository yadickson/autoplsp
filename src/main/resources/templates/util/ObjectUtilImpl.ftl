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

import java.sql.Connection;
import java.sql.SQLException;
<#if logger>

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
</#if>
<#if driverName == 'oracle'>

import oracle.jdbc.OracleConnection;
<#if driverVersionName == 'ojdbc6' >
import oracle.sql.StructDescriptor;
import oracle.sql.STRUCT;
</#if>
</#if>

import org.springframework.stereotype.Component;

/**
 * Class to process object element.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
@Component
<#if driverVersionName == 'ojdbc6' >
@SuppressWarnings({"deprecation"})
</#if>
public final class ${prefixUtilityName}ObjectUtilImpl
        implements ${prefixUtilityName}ObjectUtil {
<#if logger>

    /**
     * Logger.
     */
    private static final Logger LOGGER
            = LoggerFactory.getLogger(${prefixUtilityName}ObjectUtilImpl.class);
</#if>

    /**
     * {@inheritDoc}
     */
    @Override
    public Object process(
            final Connection connection,
            final String name,
            final Object[] objects
    ) throws SQLException {

<#if driverName != 'oracle' >
        throw new SQLException(
                "Driver ${driverName} not supported",
                "${successCode}"
        );
<#else>
        try {

            OracleConnection <#if prefixUtilityName??>${prefixUtilityName?uncap_first}Conn<#else>conn</#if>;
            <#if prefixUtilityName??>${prefixUtilityName?uncap_first}Conn<#else>conn</#if> = connection.unwrap(OracleConnection.class);
<#if driverVersionName == 'ojdbc6' >

            StructDescriptor descriptor;
            descriptor = StructDescriptor.createDescriptor(
                    name,
                    <#if prefixUtilityName??>${prefixUtilityName?uncap_first}Conn<#else>conn</#if>
            );

            return new STRUCT(
                    descriptor,
                    <#if prefixUtilityName??>${prefixUtilityName?uncap_first}Conn<#else>conn</#if>,
                    objects
            );

<#else>
            return <#if prefixUtilityName??>${prefixUtilityName?uncap_first}Conn<#else>conn</#if>.createStruct(name, objects);
</#if>
        } catch (Exception ex) {
<#if logger>
            LOGGER.error(ex.getMessage(), ex);
</#if>
            throw new SQLException(ex.getMessage(), "${successCode}", ex);
        }
</#if>
    }
}
