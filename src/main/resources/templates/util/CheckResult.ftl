<#if header>/*
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

/**
 * Check result from store procedure or function.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
@SuppressWarnings({"rawtypes", "unchecked"})
public final class CheckResult {

    /**
     * Evaluate output parameters from database.
     *
     * @param result map to evaluate.
     * @throws java.sql.SQLException if error.
     */
    public static java.util.Map check(
            final java.util.Map result
    ) throws java.sql.SQLException {

        if (result == null) {
            return null;
        }

        Number code;
        String description;
        int val;

        try {
            code = (Number) result.get("${outParameterCode}");
            description = (String) result.get("${outParameterMessage}");
            val = code.intValue();
        } catch (Exception ex) {
            throw new java.sql.SQLException(ex);
        }

        if (val != 0) {
            throw new java.sql.SQLException(description, null, val);
        }

        return result;
    }

}
