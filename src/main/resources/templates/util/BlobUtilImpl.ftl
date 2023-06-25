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
<#assign importList = ["java.io.InputStream", "java.sql.Connection", "java.sql.Blob", "org.apache.commons.io.IOUtils", "org.springframework.stereotype.Component"]>
<#if logger>
<#assign importList = importList + ["org.slf4j.Logger", "org.slf4j.LoggerFactory"]>
</#if>
<#if driverName == 'oracle'>
<#assign importList = importList + ["java.io.OutputStream", "oracle.jdbc.OracleConnection"]>
<#if driverVersionName == 'ojdbc6' >
<#assign importList = importList + ["oracle.sql.BLOB"]>
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
 * Class to process blob element.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
</#if>
@Component
<#if driverVersionName == 'ojdbc6' >
@SuppressWarnings({"deprecation"})
</#if>
public final class ${prefixUtilityName}BlobUtilImpl
        implements ${prefixUtilityName}BlobUtil {
<#if logger>

<#if documentation>
    /**
     * Logger.
     */
</#if>
    private static final Logger LOGGER
            = LoggerFactory.getLogger(${prefixUtilityName}BlobUtilImpl.class);
</#if>

<#if documentation>
    /**
     * {@inheritDoc}
     */
</#if>
    @Override
    public byte[] process(final Object object) {

        if (object == null) {
            return new byte[0];
        }

        Blob blob = (Blob) object;
        byte[] result;

        try (InputStream stream = blob.getBinaryStream()) {
            result = IOUtils.toByteArray(stream, blob.length());
        } catch (Exception ex) {
<#if logger>
            LOGGER.error(ex.getMessage(), ex);
</#if>
            result = new byte[0];
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
        final byte[] param
    ) {
<#if driverName != 'oracle' >
        return param;
<#else>
        <#if driverVersionName == 'ojdbc6' >BLOB<#else>Blob</#if> blob = null;

        try {

            OracleConnection <#if prefixUtilityName??>${prefixUtilityName?uncap_first}Conn<#else>conn</#if>;
            <#if prefixUtilityName??>${prefixUtilityName?uncap_first}Conn<#else>conn</#if> = connection.unwrap(OracleConnection.class);

<#if driverVersionName != 'ojdbc6' >
            blob = <#if prefixUtilityName??>${prefixUtilityName?uncap_first}Conn<#else>conn</#if>.createBlob();
<#else>
            blob = BLOB.createTemporary(
                    <#if prefixUtilityName??>${prefixUtilityName?uncap_first}Conn<#else>conn</#if>,
                    false,
                    BLOB.DURATION_SESSION
            );
</#if>

            blob = write(blob, param);

        } catch (Exception ex) {
<#if logger>
            LOGGER.error(ex.getMessage(), ex);
</#if>
            blob = null;
        }

        return blob;
</#if>
    }

    private <#if driverVersionName == 'ojdbc6' >BLOB<#else>Blob</#if> write(final <#if driverVersionName == 'ojdbc6' >BLOB<#else>Blob</#if> blob, final byte[] param) {
        try (OutputStream <#if prefixUtilityName??>${prefixUtilityName?uncap_first}Stream<#else>stream</#if> = blob.<#if driverVersionName != 'ojdbc6' >setBinaryStream(0)<#else>getBinaryOutputStream()</#if>) {
            <#if prefixUtilityName??>${prefixUtilityName?uncap_first}Stream<#else>stream</#if>.write(param);
            return blob;
        } catch (Exception ex) {
<#if logger>
            LOGGER.error(ex.getMessage(), ex);
<#else>
            return null;
</#if>
        }
    }
}
