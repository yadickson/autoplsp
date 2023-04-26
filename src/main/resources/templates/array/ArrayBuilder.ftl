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
package ${javaPackage}.array;

import java.sql.Connection;
import java.sql.SQLException;

<#if documentation>
/**
 * Interface array for build datatype ${parameter.realObjectName}.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
</#if>
public interface ${parameter.javaTypeName}Builder {

<#if documentation>
    /**
     * Getter data object type.
     *
     * @param connection database connection.
     * @param array array object to process.
     * @return array object processed.
     * @throws SQLException if error
     */
</#if>
    Object process(
            Connection connection,
            ${parameter.javaTypeName} array
    ) throws SQLException;
}
