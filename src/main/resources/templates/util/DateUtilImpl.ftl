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

import java.util.Date; 
<#if logger>

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
</#if>
<#if driverName == 'oracle'>

import oracle.sql.DATE;
</#if>

import org.springframework.stereotype.Component;

<#if documentation>
/**
 * Utility to process date class.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
</#if>
@Component
public final class ${prefixUtilityName}DateUtilImpl
        implements ${prefixUtilityName}DateUtil {
<#if logger>

<#if documentation>
    /**
     * Logger.
     */
</#if>
    private static final Logger LOGGER
            = LoggerFactory.getLogger(${prefixUtilityName}DateUtilImpl.class);
</#if>

<#if documentation>
    /**
     * {@inheritDoc}
     */
</#if>
    @Override
    public Object process(final Date param) {
<#if driverName != 'oracle' >
        return param;
<#else>

        if (param == null) {
            return null;
        }

        DATE <#if prefixUtilityName??>${prefixUtilityName?uncap_first}Date<#else>date</#if>;

        try {
            <#if prefixUtilityName??>${prefixUtilityName?uncap_first}Date<#else>date</#if> = new DATE(new java.sql.Date(param.getTime()));
        } catch (Exception ex) {
<#if logger>
            LOGGER.error(ex.getMessage(), ex);
</#if>
            <#if prefixUtilityName??>${prefixUtilityName?uncap_first}Date<#else>date</#if> = null;
        }

        return <#if prefixUtilityName??>${prefixUtilityName?uncap_first}Date<#else>date</#if>;
</#if>
    }

}
