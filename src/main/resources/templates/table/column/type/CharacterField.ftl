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
package ${javaPackage}.${tableFolderName}.column.type;

<#if documentation>
/**
 * Character Field.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
</#if>
public interface CharacterField {

<#if documentation>
    /**
     * @return the minSize
     */
</#if>
    int getMinSize();

<#if documentation>
    /**
     * @return the maxCharSize
     */
</#if>
    int getMaxCharSize();

<#if documentation>
    /**
     * @return the defaultValue
     */
</#if>
    String getDefaultValue();

<#if documentation>
    /**
     * @return the notNull
     */
</#if>
    Boolean getNotNull();
}
