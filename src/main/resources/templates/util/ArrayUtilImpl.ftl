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
<#assign importList = ["java.sql.Connection", "java.sql.SQLException", "org.springframework.stereotype.Component"]>
<#if logger>
<#assign importList = importList + ["org.slf4j.Logger", "org.slf4j.LoggerFactory"]>
</#if>
<#if driverName == 'oracle'>
<#assign importList = importList + ["oracle.jdbc.OracleConnection"]>
</#if>

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
 * Class to process array element.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
</#if>
@Component
<#if driverVersionName == 'ojdbc6' >
@SuppressWarnings({"deprecation"})
</#if>
final class ${prefixUtilityName}ArrayUtilImpl${'\n'}        implements ${prefixUtilityName}ArrayUtil {
<#if logger>

<#if documentation>
    /**
     * Logger.
     */
</#if>
    private static final Logger LOGGER
            = LoggerFactory.getLogger(${prefixUtilityName}ArrayUtilImpl.class);
</#if>

<#if documentation>
    /**
     * {@inheritDoc}
     */
</#if>
    @Override
    public Object process(${'\n'}            final Connection connection,${'\n'}            final String name,${'\n'}            final Object[] objects${'\n'}    ) throws SQLException {

<#if driverName != 'oracle' >
        throw new SQLException(
                "Driver ${driverName} not supported",
                "${successCode}"
        );
<#else>
        try {

            OracleConnection <#if prefixUtilityName??>${prefixUtilityName?uncap_first}Conn<#else>conn</#if>;
            <#if prefixUtilityName??>${prefixUtilityName?uncap_first}Conn<#else>conn</#if> = connection.unwrap(OracleConnection.class);
            return <#if prefixUtilityName??>${prefixUtilityName?uncap_first}Conn<#else>conn</#if>.<#if driverVersionName == 'ojdbc6' >createARRAY<#else>createOracleArray</#if>(name, objects);

        } catch (Exception ex) {
<#if logger>
            LOGGER.error(ex.getMessage(), ex);
</#if>
            throw new SQLException(ex.getMessage(), "${successCode}", ex);
        }
</#if>
    }
}
