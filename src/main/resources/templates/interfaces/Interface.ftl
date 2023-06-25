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
package ${javaPackage}.${interfaceFolderName};

<#if parameter.array>
import ${javaPackage}.${arrayFolderName}.${parameter.javaTypeName};

<#elseif parameter.object>
import ${javaPackage}.${objectFolderName}.${parameter.javaTypeName};

<#elseif parameter.resultSet || parameter.returnResultSet>
import ${javaPackage}.${cursorFolderName}.${parameter.javaTypeName};

<#elseif parameter.date>
import java.util.Date;

</#if>
<#if documentation>
/**
 * ${parameter.javaFileNameInterface}.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
</#if>
public interface ${parameter.javaFileNameInterface} {

<#if documentation>
    /**
     * Getter of ${parameter.name}.
     *
     * ${parameter.name}
     *
     * @return The ${parameter.name} value.
     */
</#if>
    <#if parameter.resultSet || parameter.returnResultSet>java.util.List<${parameter.javaTypeName}><#else>${parameter.javaTypeName}</#if> get${parameter.propertyName}();
}
