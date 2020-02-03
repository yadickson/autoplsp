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

<#list parameter.parameters as parameter2>
<#if parameter2.date>
<#assign importSafeDate = 1>
</#if>
</#list>
<#if importSafeDate??>
import java.util.Date;

</#if>
import java.util.ArrayList;

<#if parameter.parameters[parameter.parameters?size - 1].object>
import ${javaPackage}.object.${parameter.parameters[parameter.parameters?size - 1].javaTypeName};

</#if>
<#if jsonNonNull>
import com.fasterxml.jackson.annotation.JsonInclude;

</#if>
/**
 * Bean array for datatype ${parameter.realObjectName}.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
<#if jsonNonNull>
@JsonInclude(JsonInclude.Include.NON_NULL)
</#if>
<#if !serialization>
@SuppressWarnings({"serial"})
</#if>
public final class ${parameter.javaTypeName}
        extends ArrayList<${parameter.parameters[parameter.parameters?size - 1].javaTypeName}><#if serialization>
        implements java.io.Serializable</#if> {
<#if serialization> 

    /**
     * Serialization.
     */
    static final long serialVersionUID = 1L;
</#if>
}
