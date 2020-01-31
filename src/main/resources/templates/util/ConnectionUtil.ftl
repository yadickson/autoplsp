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

/**
 * Interface to process connection transaction.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
public interface ${prefixUtilityName}ConnectionUtil {

    /**
     * Getter current connection.
     *
     * @return Connection class.
     */
    Connection process();

    /**
     * Release connection.
     *
     * @param connection connection.
     * @return true if connection were closed.
     */
    boolean release(Connection connection);

}
