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
<#if logger>

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.Marker;
</#if>

import org.springframework.stereotype.Component;

/**
 * Check result from store procedure or function.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
@Component
public final class ${prefixUtilityName}CheckResultImpl
        implements ${prefixUtilityName}CheckResult {
<#if logger>

    /**
     * Logger.
     */
    private static final Logger LOGGER
            = LoggerFactory.getLogger(${prefixUtilityName}CheckResultImpl.class);
</#if>

    /**
     * Success constant value.
     */
    private static final String <#if prefixUtilityName??>${prefixUtilityName?upper_case}_</#if>SUCCESS_CODE = "${successCode}";

    /**
     * Code to check.
     */
    private static final String <#if prefixUtilityName??>${prefixUtilityName?upper_case}_</#if>CODE = "${outParameterCode}";

    /**
     * Message to check.
     */
    private static final String <#if prefixUtilityName??>${prefixUtilityName?upper_case}_</#if>MESSAGE = "${outParameterMessage}";

    /**
     * {@inheritDoc}
     */
    @Override
    public void check(final Map<String, Object> map) throws SQLException {

        if (map == null) {
            return;
        }

        Number <#if prefixUtilityName??>${prefixUtilityName?uncap_first}Code<#else>code</#if> = (Number) map.get(<#if prefixUtilityName??>${prefixUtilityName?upper_case}_</#if>CODE);

        if (<#if prefixUtilityName??>${prefixUtilityName?uncap_first}Code<#else>code</#if> == null) {
            return;
        }

        if (!<#if prefixUtilityName??>${prefixUtilityName?upper_case}_</#if>SUCCESS_CODE.equals(<#if prefixUtilityName??>${prefixUtilityName?uncap_first}Code<#else>code</#if>.toString())) {
            String description = (String) map.get(<#if prefixUtilityName??>${prefixUtilityName?upper_case}_</#if>MESSAGE);
<#if logger>
            LOGGER.error(Marker.ANY_MARKER, "${outParameterCode}: {}", <#if prefixUtilityName??>${prefixUtilityName?uncap_first}Code<#else>code</#if>);
            LOGGER.error(Marker.ANY_MARKER, "${outParameterMessage}: {}", description);
</#if>
            throw new SQLException(description, <#if prefixUtilityName??>${prefixUtilityName?uncap_first}Code<#else>code</#if>.toString());
        }
    }

}
