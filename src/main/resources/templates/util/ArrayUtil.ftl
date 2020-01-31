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

/**
 * Interface to create array.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
public interface ${prefixUtilityName}ArrayUtil {

    /**
     * Getter database array type.
     *
     * @param connection database connection.
     * @param name array database name.
     * @param objects objects to set in array.
     * @return array.
     * @throws SQLException if error
     */
    Object process(
            Connection connection,
            String name,
            Object[] objects
    ) throws SQLException;
}
