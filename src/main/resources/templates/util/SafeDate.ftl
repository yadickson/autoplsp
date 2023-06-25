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
package ${javaPackage}.${utilFolderName};

import java.util.Date;

<#if documentation>
/**
 * Utility to process date class.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
</#if>
public final class ${prefixUtilityName}SafeDate {

<#if documentation>
    /**
     * Class constructor.
     */
</#if>
    protected ${prefixUtilityName}SafeDate() {

    }

<#if documentation>
    /**
     * Process date.
     *
     * @param <#if prefixUtilityName??>${prefixUtilityName?uncap_first}Input<#else>input</#if> input date to process.
     * @return date.
     */
</#if>
    public static Date process(final Date <#if prefixUtilityName??>${prefixUtilityName?uncap_first}Input<#else>input</#if>) {

        if (<#if prefixUtilityName??>${prefixUtilityName?uncap_first}Input<#else>input</#if> == null) {
            return null;
        }

        return (Date) <#if prefixUtilityName??>${prefixUtilityName?uncap_first}Input<#else>input</#if>.clone();
    }

}
