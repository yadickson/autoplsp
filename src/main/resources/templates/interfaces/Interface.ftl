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
package ${javaPackage}.interfaces;

<#if parameter.date>
<#assign importSafeDate = 1>
</#if>
<#if importSafeDate??>

import java.util.Date;

</#if>
<#if documentation>
/**
 * ${parameter.javaFileNameInterface}Interface.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
</#if>
public interface ${parameter.javaFileNameInterface}Interface {

<#if documentation>
    /**
     * Getter of ${parameter.name}.
     *
     * ${parameter.name}
     *
     * @return The ${parameter.name} value.
     */
</#if>
    ${parameter.javaTypeName} get${parameter.propertyName}();
<#if fullConstructor>

<#if documentation>
    /**
     * Setter of ${parameter.name}.
     *
     * ${parameter.name}
     *
     * @param ${parameter.fieldName} ${parameter.name} to set
     */
</#if>
    void set${parameter.propertyName}(${parameter.javaTypeName} ${parameter.fieldName});
</#if>
}
