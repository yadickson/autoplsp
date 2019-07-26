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

package ${javaPackage}.table;

<#list table.fields as field>
import ${javaPackage}.table.column.${table.propertyName}${field.propertyName};
</#list>

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * Table definitions for ${table.name}.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
@Component
public final class ${table.propertyName}Impl implements ${table.propertyName} {
<#list table.fields as field>
    /**
     * Field name ${field.name}.
     */
    @Autowired
    private ${table.propertyName}${field.propertyName} ${field.fieldName};

</#list>
<#list table.fields as field>
    /**
     * Getter field name definination for ${field.name}.
     *
     * @return the ${field.name}.
     */
    @Override
    public ${table.propertyName}${field.propertyName} get${field.propertyName}() {
        return ${field.fieldName};
    }

</#list>
}
