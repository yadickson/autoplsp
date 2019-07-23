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

    /**
     * Field minSize.
     */
    private final int minSize = ${field.minSize};

    /**
     * Field maxSize.
     */
    private final int maxSize = ${field.maxSize};

    /**
     * Field notNull.
     */
    private final Boolean notNull = ${field.notNull?c};

    /**
     * Field defaultValue.
     */
    private final String defaultValue = <#if field.defaultValue??>"${field.defaultValue}"<#else>null</#if>;

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

    /**
     * @return the minSize
     */
    @Override
    public int getMinSize() {
        return minSize;
    }

    /**
     * @return the maxSize
     */
    @Override
    public int getMaxSize() {
        return maxSize;
    }

    /**
     * @return the notNull
     */
    @Override
    public Boolean getNotNull() {
        return notNull;
    }

    /**
     * @return the defaultValue
     */
    @Override
    public String getDefaultValue() {
        return defaultValue;
    }

}
