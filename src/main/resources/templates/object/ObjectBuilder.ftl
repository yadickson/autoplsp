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
package ${javaPackage}.${objectFolderName};
<#assign importList = ["java.sql.Connection", "java.sql.SQLException"]>

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
 * Interface to build object for datatype ${parameter.realObjectName}.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
</#if>
public interface ${parameter.javaTypeName}Builder {

<#if documentation>
    /**
     * Getter data object type.
     *
     * @param connection database connection.
     * @param object object to process.
     * @return object processed.
     * @throws SQLException if error
     */
</#if>
    Object process(${'\n'}            Connection connection,${'\n'}            ${parameter.javaTypeName} object${'\n'}    ) throws SQLException;
}
