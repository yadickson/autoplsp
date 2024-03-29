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
package com.github.yadickson.autoplsp.db.support.mssql;

import com.github.yadickson.autoplsp.db.Generator;
import com.github.yadickson.autoplsp.db.MakeParameter;
import com.github.yadickson.autoplsp.db.common.Procedure;

/**
 * SQL Server procedure and function generator class
 *
 * @author Yadickson Soto
 */
public class MsSqlGenerator extends Generator {

    /**
     * Class constructor
     *
     * @param name sp generator
     */
    public MsSqlGenerator(String name) {
        super(name);
    }

    /**
     * Method getter sql procedures
     *
     * @return sql to find procedures
     */
    @Override
    public String getProcedureQuery() {
        return "SELECT sys.objects.name as name, case when sys.objects.type = 'P' then 'PROCEDURE' when type = 'IF' then 'FUNCTION_INLINE' else 'FUNCTION' end as type, sys.schemas.name as pkg\n"
                + "FROM sys.objects\n"
                + "INNER JOIN sys.schemas ON sys.objects.schema_id = sys.schemas.schema_id\n"
                + "WHERE sys.objects.type IN (\n"
                + "    'P', -- stored procedures\n"
                + "    'FN', -- scalar functions\n"
                + "    'IF', -- inline table-valued functions\n"
                + "    'TF', -- table-valued functions\n"
                + "    'FT'\n"
                + ")\n"
                + "ORDER BY type, name";
    }

    /**
     * Method getter sql parameters.
     *
     * @param procedure procedure
     * @return sql to find parameters
     */
    @Override
    public String getParameterQuery(final Procedure procedure) {
        String sql = "( select  \n"
                + "   'name' = case when parameter_id = 0 then 'return_value' else name end,  \n"
                + "   'dtype'   = case when is_cursor_ref = 1 then 'cursor' else type_name(system_type_id) end,  \n"
                + "   'position'  = parameter_id,\n"
                + "   'direction' = case when is_output = 0 then 'IN' else 'OUT' end\n"
                + "  from sys.parameters where object_id = object_id(?) )\n";

        return sql;
    }

    /**
     * Method getter sql objects and tableObjets.
     *
     * @return sql to find parameters
     */
    @Override
    public String getObjetsQuery() {
        return null;
    }

    /**
     * Method getter sql tables.
     *
     * @return sql to find tables
     */
    @Override
    public String getTablesQuery() {
        return null;
    }

    /**
     * Method getter all sql parameters objects
     *
     * @param procedure procedure
     * @return sql objects to find parameters
     */
    @Override
    public Object[] getParameterObjects(final Procedure procedure) {
        return new Object[]{procedure.getFullName()};
    }

    /**
     * Method getter maker.
     *
     * @return maker
     */
    @Override
    public MakeParameter getMakeParameter() {
        return new MsSqlMakeParameter();
    }

}
