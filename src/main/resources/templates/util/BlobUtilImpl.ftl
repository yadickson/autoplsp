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

import java.sql.Blob;
import java.io.InputStream;

import org.apache.commons.io.IOUtils;
<#if logger>

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
</#if>

import org.springframework.stereotype.Component;

/**
 * Class to process blob element.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
@Component
public final class BlobUtilImpl implements BlobUtil {
<#if logger>

    /**
     * Logger.
     */
    private static final Logger LOGGER
            = LoggerFactory.getLogger(BlobUtilImpl.class);
</#if>

    /**
     * {@inheritDoc}
     */
    @Override
    public byte[] process(final Object object) {

        if (object == null) {
            return null;
        }

        Blob blob = (Blob) object;
        byte[] result;

        try (InputStream stream = blob.getBinaryStream()) {
            result = IOUtils.toByteArray(stream, blob.length());
        } catch (Exception ex) {
<#if logger>
            LOGGER.error(ex.getMessage(), ex);
</#if>
            result = null;
        }

        return result;
    }

}
