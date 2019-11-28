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
package ${javaPackage}.table.column;

import ${javaPackage}.table.column.type.FieldType;
import org.springframework.stereotype.Component;

/**
 * Class definition for ${table.name} - ${field.name}.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
@Component
public final class ${table.propertyName}${field.propertyName}Impl implements ${table.propertyName}${field.propertyName} {

    /**
     * Field type.
     */
    private final FieldType type = FieldType.${field.type};

    /**
     * Field position.
     */
    private final int position = ${field.position};
<#if field.type == 'STRING' || field.type == 'NUMERIC' >

    /**
     * Field minSize.
     */
    private final int minSize = <#if field.maxSize??>${field.minSize}<#else>0</#if>;

    /**
     * Field maxSize.
     */
    private final int maxSize = <#if field.maxSize??>${field.maxSize}<#else>Integer.MAX_VALUE</#if>;
</#if>

    /**
     * Field notNull.
     */
    private final Boolean notNull = ${field.notNull?c};
<#if field.defaultValue?? && (field.type == 'STRING' || field.type == 'NUMERIC' || field.type == 'DATE')>

    /**
     * Field defaultValue.
     */
    private final <#if field.type == 'STRING'><#if field.charUsed == 'BYTE'>byte[]<#else>String</#if><#elseif field.type == 'NUMERIC'>Number<#elseif field.type == 'DATE'>java.util.Date<#else>Object</#if> defaultValue = <#if field.type == 'STRING'>"${field.defaultValue}"<#if field.charUsed == 'BYTE'>.getBytes("${encode}")</#if><#elseif field.type == 'NUMERIC'>${field.defaultValue}<#elseif field.type == 'DATE'>new java.util.Date()<#else>null</#if>;
</#if>

    /**
     * @return the type
     */
    @Override
    public FieldType getType() {
        return type;
    }

    /**
     * @return the position
     */
    @Override
    public int getPosition() {
        return position;
    }
<#if field.type == 'STRING' || field.type == 'NUMERIC' >

    /**
     * @return the minSize
     */
    @Override
    public int getMinSize() {
        return minSize;
    }
<#if field.charUsed??>
<#if field.charUsed == 'BYTE' >

    /**
     * @return the maxByteSize
     */
    @Override
    public int getMaxByteSize() {
        return maxSize;
    }
<#elseif field.charUsed == 'CHAR'>

    /**
     * @return the maxCharSize
     */
    @Override
    public int getMaxCharSize() {
        return maxSize;
    }
</#if>
<#elseif field.type == 'NUMERIC'>

    /**
     * @return the maxSize
     */
    @Override
    public int getMaxSize() {
        return maxSize;
    }
</#if>
</#if>

    /**
     * @return the notNull
     */
    @Override
    public Boolean getNotNull() {
        return notNull;
    }
<#if field.type == 'STRING' || field.type == 'NUMERIC' || field.type == 'DATE'>

    /**
     * @return the defaultValue
     */
    @Override
    public <#if field.type == 'STRING'><#if field.charUsed == 'BYTE'>byte[]<#else>String</#if><#elseif field.type == 'NUMERIC'>Number<#elseif field.type == 'DATE'>java.util.Date<#else>Object</#if> getDefaultValue() {
        return <#if field.defaultValue??>defaultValue<#else>null</#if>;
    }
</#if>

}
