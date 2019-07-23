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
package ${javaPackage}.repository;

<#if proc.hasInput>
import ${javaPackage}.domain.${proc.className}IN;
</#if>
<#if proc.hasOutput>
import ${javaPackage}.domain.${proc.className}OUT;
</#if>

/**
 * Mapper interface to stored procedure ${proc.fullName}.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
public interface ${map.className}Mapper {

    /**
     * Process mapper for stored procedure.
     *
     * <#if proc.hasInput>@param params input parameters</#if>
     * <#if proc.hasOutput>@return output parameters</#if>
     */
    ${map.className}OUT process(<#if proc.hasInput>final ${proc.className}IN params</#if>);
}
