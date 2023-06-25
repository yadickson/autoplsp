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
package ${javaPackage}.${tableFolderName}.column;
<#assign importList = ["${javaPackage}.${tableFolderName}.column.type.FieldType", "org.springframework.stereotype.Component"]>
<#if field.type == 'DATE'>
<#assign importList = importList + ["java.util.Date"]>
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
 * Class definition for ${table.name} - ${field.name}.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
</#if>
@Component
public final class ${table.propertyName}${field.propertyName}Impl implements ${table.propertyName}${field.propertyName} {

<#if documentation>
    /**
     * Field type.
     */
</#if>
    private static final FieldType ${table.name}_${field.name}_TYPE = FieldType.${field.type};

<#if documentation>
    /**
     * Field position.
     */
</#if>
    private static final int ${table.name}_${field.name}_POSITION = ${field.position};
<#if field.type == 'STRING' || field.type == 'NUMERIC' >

<#if documentation>
    /**
     * Field minSize.
     */
</#if>
    private static final int ${table.name}_${field.name}_MIN_SIZE = <#if field.minSize??>${field.minSize}<#else>0</#if>;

<#if documentation>
    /**
     * Field maxSize.
     */
</#if>
    private static final int ${table.name}_${field.name}_MAX_SIZE = <#if field.maxSize??>${field.maxSize}<#else>Integer.MAX_VALUE</#if>;
</#if>

<#if documentation>
    /**
     * Field notNull.
     */
</#if>
    private static final boolean ${table.name}_${field.name}_NOT_NULL = ${field.notNull?c};
<#if field.type == 'STRING' || field.type == 'NUMERIC' || field.type == 'DATE'>

<#if documentation>
    /**
     * Field defaultValue.
     */
</#if>
    private static final <#if field.type == 'STRING'><#if field.charUsed == 'BYTE'>byte[]<#else>String</#if><#elseif field.type == 'NUMERIC'>Number<#elseif field.type == 'DATE'>Date<#else>Object</#if> ${table.name}_${field.name}_DEFAULT_VALUE = <#if field.defaultValue??><#if field.type == 'STRING'>"${field.defaultValue}"<#if field.charUsed == 'BYTE'>.getBytes("${encode}")</#if><#elseif field.type == 'NUMERIC'>${field.defaultValue}<#elseif field.type == 'DATE'>new Date()</#if><#else>null</#if>;
</#if>

<#if documentation>
    /**
     * @return the type
     */
</#if>
    @Override
    public FieldType getType() {
        return ${table.name}_${field.name}_TYPE;
    }

<#if documentation>
    /**
     * @return the position
     */
</#if>
    @Override
    public int getPosition() {
        return ${table.name}_${field.name}_POSITION;
    }
<#if field.type == 'STRING' || field.type == 'NUMERIC' >

<#if documentation>
    /**
     * @return the minSize
     */
</#if>
    @Override
    public int getMinSize() {
        return ${table.name}_${field.name}_MIN_SIZE;
    }
<#if field.charUsed??>
<#if field.charUsed == 'BYTE' >

<#if documentation>
    /**
     * @return the maxByteSize
     */
</#if>
    @Override
    public int getMaxByteSize() {
        return ${table.name}_${field.name}_MAX_SIZE;
    }
<#elseif field.charUsed == 'CHAR'>

<#if documentation>
    /**
     * @return the maxCharSize
     */
</#if>
    @Override
    public int getMaxCharSize() {
        return ${table.name}_${field.name}_MAX_SIZE;
    }
</#if>
<#elseif field.type == 'NUMERIC'>

<#if documentation>
    /**
     * @return the maxSize
     */
</#if>
    @Override
    public int getMaxSize() {
        return ${table.name}_${field.name}_MAX_SIZE;
    }
</#if>
</#if>

<#if documentation>
    /**
     * @return the notNull
     */
</#if>
    @Override
    public Boolean getNotNull() {
        return ${table.name}_${field.name}_NOT_NULL;
    }
<#if field.type == 'STRING' || field.type == 'NUMERIC' || field.type == 'DATE'>

<#if documentation>
    /**
     * @return the defaultValue
     */
</#if>
    @Override
    public <#if field.type == 'STRING'><#if field.charUsed == 'BYTE'>byte[]<#else>String</#if><#elseif field.type == 'NUMERIC'>Number<#elseif field.type == 'DATE'>Date<#else>Object</#if> getDefaultValue() {
        return ${table.name}_${field.name}_DEFAULT_VALUE;
    }
</#if>

}
