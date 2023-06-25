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
package ${javaPackage}.${arrayFolderName};
<#assign importList = ["java.util.ArrayList"]>
<#list parameter.parameters as parameter2>
<#if parameter2.date>
<#assign importSafeDate = 1>
</#if>
</#list>
<#if importSafeDate??>
<#assign importList = importList + ["java.util.Date"]>
</#if>
<#if parameter.parameters[parameter.parameters?size - 1].object && objectFolderName != arrayFolderName>
<#assign importList = importList + ["${javaPackage}.${objectFolderName}.${parameter.parameters[parameter.parameters?size - 1].javaTypeName}"]>
</#if>
<#if jsonNonNull>
<#assign importList = importList + ["com.fasterxml.jackson.annotation.JsonInclude"]>
</#if>
<#if serialization>
<#assign importList = importList + ["java.io.Serializable"]>
</#if>

<#list importSort(importList) as import>
<#if previousImportMatch?? && !import?starts_with(previousImportMatch)>

</#if>
import ${import};
<#assign previousImportMatch = import?keep_before_last(".") >
</#list>
<#if importList?has_content>

</#if>
<#if documentation>
/**
 * Bean array for datatype ${parameter.realObjectName}.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
</#if>
<#if jsonNonNull>
@JsonInclude(JsonInclude.Include.NON_NULL)
</#if>
<#if !serialization>
@SuppressWarnings({"serial"})
</#if>
public class ${parameter.javaTypeName}${'\n'}        extends ArrayList<${parameter.parameters[parameter.parameters?size - 1].javaTypeName}><#if serialization>${'\n'}        implements Serializable</#if> {
<#if serialization> 

<#if documentation>
    /**
     * Serialization.
     */
</#if>
    static final long serialVersionUID = 1L;
</#if>
}
