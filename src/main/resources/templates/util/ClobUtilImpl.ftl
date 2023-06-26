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
<#assign importList = ["java.io.InputStream", "java.sql.Connection", "java.sql.Clob", "org.apache.commons.io.IOUtils", "org.springframework.stereotype.Component"]>
<#if logger>
<#assign importList = importList + ["org.slf4j.Logger", "org.slf4j.LoggerFactory"]>
</#if>
<#if driverName == 'oracle'>
<#assign importList = importList + ["java.io.Writer", "oracle.jdbc.OracleConnection"]>
<#if driverVersionName == 'ojdbc6' >
<#assign importList = importList + ["oracle.sql.CLOB"]>
</#if>
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
 * Class to process clob element.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
</#if>
@Component
<#if driverVersionName == 'ojdbc6' >
@SuppressWarnings({"deprecation"})
</#if>
final class ${prefixUtilityName}ClobUtilImpl
        implements ${prefixUtilityName}ClobUtil {
<#if logger>

<#if documentation>
    /**
     * Logger.
     */
</#if>
    private static final Logger LOGGER
            = LoggerFactory.getLogger(${prefixUtilityName}ClobUtilImpl.class);
</#if>

<#if documentation>
    /**
     * {@inheritDoc}
     */
</#if>
    @Override
    public String process(final Object object) {

        if (object == null) {
            return null;
        }

        Clob clob = (Clob) object;
        String result;

        try (InputStream stream = clob.getAsciiStream()) {
            result = IOUtils.toString(stream, "${encode}");
        } catch (Exception ex) {
<#if logger>
            LOGGER.error(ex.getMessage(), ex);
</#if>
            result = null;
        }

        return result;
    }
    
<#if documentation>
    /**
     * {@inheritDoc}
     */
</#if>
    @Override
    public Object process(
        final Connection connection,
        final String param
    ) {
<#if driverName != 'oracle' >
        return param;
<#else>

        <#if driverVersionName == 'ojdbc6' >CLOB<#else>Clob</#if> clob;

        try {

            OracleConnection <#if prefixUtilityName??>${prefixUtilityName?uncap_first}Conn<#else>conn</#if>;
            <#if prefixUtilityName??>${prefixUtilityName?uncap_first}Conn<#else>conn</#if> = connection.unwrap(OracleConnection.class);

<#if driverVersionName != 'ojdbc6' >
            clob = <#if prefixUtilityName??>${prefixUtilityName?uncap_first}Conn<#else>conn</#if>.createClob();
<#else>
            clob = CLOB.createTemporary(
                    <#if prefixUtilityName??>${prefixUtilityName?uncap_first}Conn<#else>conn</#if>,
                    false,
                    CLOB.DURATION_SESSION
            );
</#if>

            try (Writer <#if prefixUtilityName??>${prefixUtilityName?uncap_first}Writer<#else>writer</#if> = clob.<#if driverVersionName != 'ojdbc6' >setCharacterStream(0)<#else>getCharacterOutputStream()</#if>) {
                <#if prefixUtilityName??>${prefixUtilityName?uncap_first}Writer<#else>writer</#if>.write(param.toCharArray());
            } catch (Exception ex) {
<#if logger>
                LOGGER.error(ex.getMessage(), ex);
</#if>
                clob = null;
            }

        } catch (Exception ex) {
<#if logger>
            LOGGER.error(ex.getMessage(), ex);
</#if>
            clob = null;
        }

        return clob;
</#if>
    }
}
