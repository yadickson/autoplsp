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

import java.sql.SQLException;
import java.util.Map;

import org.springframework.stereotype.Component;

/**
 * Check result from store procedure or function.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
@Component
public final class CheckResultImpl implements CheckResult {

    /**
     * Success constant value.
     */
    private static final String SUCCESS_CODE = "${successCode}";

    /**
     * {@inheritDoc}
     */
    @Override
    public void check(final Map<String, Object> map) throws SQLException {

        if (map == null) {
            return;
        }

        Number code = (Number) map.get("${outParameterCode}");

        if (code == null) {
            return;
        }

        if (!SUCCESS_CODE.equals(code.toString())) {
            String description = (String) map.get("${outParameterMessage}");
            throw new SQLException(description, null, code.intValue());
        }
    }

}
