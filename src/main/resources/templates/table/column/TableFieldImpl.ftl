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
<#if field.maxSize??>

    /**
     * Field minSize.
     */
    private final int minSize = ${field.minSize};

    /**
     * Field maxSize.
     */
    private final int maxSize = ${field.maxSize};
</#if>
<#if field.type == 'NUMERIC'>
<#if field.maxNumberValue??>
    /**
     * Field scale.
     */
    private final int scale = ${field.scale};

    /**
     * Field maxNumberValue.
     */
    private final Long maxNumberValue = ${field.maxNumberValue}L;
</#if>
</#if>

    /**
     * Field notNull.
     */
    private final Boolean notNull = ${field.notNull?c};
<#if field.defaultValue?? && field.type == 'STRING' && field.type == 'NUMERIC'>

    /**
     * Field defaultValue.
     */
    private final <#if field.type == 'STRING'>String<#elseif field.type == 'NUMERIC'>Number<#elseif field.type == 'DATE'>java.lang.Date<#else>Object</#if> defaultValue = <#if field.type == 'STRING'>"${field.defaultValue}"<#elseif field.type == 'NUMERIC'>${field.defaultValue}<#elseif field.type == 'DATE'>new java.lang.Date()<#else>null</#if>;
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
<#if field.maxSize??>

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
    public int getMaxCharSize() {
        return maxSize;
    }
</#if>
<#elseif field.type == 'NUMERIC'>
<#if field.maxNumberValue??>
    /**
     * @return the maxSize
     */
    @Override
    public int getMaxSize() {
        return maxSize;
    }

    /**
     * @return the maxNumberValue
     */
    @Override
    public Long getMaxNumberValue() {
        return maxNumberValue;
    }

    /**
     * @return the scale
     */
    @Override
    public int getScale() {
        return scale;
    }
</#if>
</#if>
</#if>

    /**
     * @return the notNull
     */
    @Override
    public Boolean getNotNull() {
        return notNull;
    }
<#if field.defaultValue?? && field.type == 'STRING' && field.type == 'NUMERIC'>

    /**
     * @return the defaultValue
     */
    @Override
    public <#if field.type == 'STRING'>String<#elseif field.type == 'NUMERIC'>Number<#elseif field.type == 'DATE'>java.lang.Date<#else>Object</#if> getDefaultValue() {
        return defaultValue;
    }
</#if>

}
