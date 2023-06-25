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

import java.sql.Connection;

<#if documentation>
/**
 * Interface to process blob element.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
</#if>
public interface ${prefixUtilityName}BlobUtil {

<#if documentation>
    /**
     * Process blob parameter from database.
     *
     * @param object to process.
     * @return byte array representation.
     */
</#if>
    byte[] process(Object object);

<#if documentation>
    /**
     * Process blob parameter from database.
     *
     * @param connection database connection.
     * @param param to process.
     * @return blob representation.
     */
</#if>
    Object process(Connection connection, byte[] param);

}
