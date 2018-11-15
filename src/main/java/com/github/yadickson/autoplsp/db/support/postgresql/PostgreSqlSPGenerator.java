/*
 * Copyright (C) 2017 Yadickson Soto
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
package com.github.yadickson.autoplsp.db.support.postgresql;

import com.github.yadickson.autoplsp.db.MakeParameter;
import com.github.yadickson.autoplsp.db.SPGenerator;
import com.github.yadickson.autoplsp.db.common.Procedure;

/**
 * Oracle Store procedure and function generator class
 *
 * @author Yadickson Soto
 */
public class PostgreSqlSPGenerator extends SPGenerator {

    /**
     * Class constructor
     *
     * @param name sp generator
     */
    public PostgreSqlSPGenerator(String name) {
        super(name);
    }

    /**
     * Method getter sql procedures
     *
     * @return sql to find procedures
     */
    @Override
    public String getProcedureQuery() {
        return "SELECT null as PKG, CASE WHEN pg_catalog.format_type(p.prorettype, NULL) = 'void' or pg_catalog.format_type(p.prorettype, NULL) = 'record' THEN 'PROCEDURE' ELSE 'FUNCTION' END as type, p.proname as name FROM pg_catalog.pg_namespace n JOIN pg_catalog.pg_proc p ON pronamespace = n.oid WHERE nspname = 'public' AND pg_catalog.pg_function_is_visible(p.oid)";
    }

    /**
     * Method getter sql parameters.
     *
     * @param procedure procedure
     * @return sql to find parameters
     */
    @Override
    public String getParameterQuery(final Procedure procedure) {

        String sql = "select p[1] as position, p[2] as direction, p[3] as name, p[4] as dtype\n"
                + "from (\n"
                + "SELECT regexp_split_to_array(param, ':') from \n"
                + "(\n"
                + "SELECT\n"
                + "CASE WHEN p.proretset THEN 'setof ' ELSE '' END ||\n"
                + "pg_catalog.format_type(p.prorettype, NULL) as \"out\",\n"
                + "CASE WHEN proallargtypes IS NOT NULL THEN\n"
                + "pg_catalog.array_to_string(ARRAY(\n"
                + "SELECT\n"
                + "s.i || ':' ||\n"
                + "CASE\n"
                + "WHEN p.proargmodes[s.i] = 'i' THEN 'IN:'\n"
                + "WHEN p.proargmodes[s.i] = 'o' THEN 'OUT:'\n"
                + "WHEN p.proargmodes[s.i] = 'b' THEN 'INOUT:'\n"
                + "END ||\n"
                + "CASE\n"
                + "WHEN COALESCE(p.proargnames[s.i], '') = '' THEN ''\n"
                + "ELSE p.proargnames[s.i] || ':'\n"
                + "END ||\n"
                + "pg_catalog.format_type(p.proallargtypes[s.i], NULL)\n"
                + "FROM\n"
                + "pg_catalog.generate_series(1,\n"
                + "pg_catalog.array_upper(p.proallargtypes, 1)) AS s(i)\n"
                + "), ',')\n"
                + "ELSE\n"
                + "pg_catalog.array_to_string(ARRAY(\n"
                + "SELECT\n"
                + "s.i+1 || ':IN:' ||\n"
                + "CASE\n"
                + "WHEN COALESCE(p.proargnames[s.i+1], '') = '' THEN ''\n"
                + "ELSE p.proargnames[s.i+1] || ':'\n"
                + "END ||\n"
                + "pg_catalog.format_type(p.proargtypes[s.i], NULL)\n"
                + "FROM\n"
                + "pg_catalog.generate_series(0,\n"
                + "pg_catalog.array_upper(p.proargtypes, 1)) AS s(i)\n"
                + "), ', ')\n"
                + "END AS \"input\"\n"
                + "FROM pg_catalog.pg_proc p\n"
                + "LEFT JOIN pg_catalog.pg_namespace n ON n.oid = p.pronamespace\n"
                + "LEFT JOIN pg_catalog.pg_language l ON l.oid = p.prolang\n"
                + "JOIN pg_catalog.pg_roles r ON r.oid = p.proowner\n"
                + "WHERE p.prorettype <> 'pg_catalog.cstring'::pg_catalog.regtype\n"
                + "AND (p.proargtypes[0] IS NULL\n"
                + "OR p.proargtypes[0] <> 'pg_catalog.cstring'::pg_catalog.regtype)\n"
                + "AND NOT p.proisagg\n"
                + "AND pg_catalog.pg_function_is_visible(p.oid)\n"
                + "AND p.proname ilike ?\n"
                + ") as t, unnest(string_to_array(input, ',')) s(param)\n"
                + ") as dt(p)";

        return sql;
    }

    /**
     * Method getter all sql parameters objects
     *
     * @param procedure procedure
     * @return sql objects to find parameters
     */
    @Override
    public Object[] getParameterObjects(final Procedure procedure) {
        return new Object[]{procedure.getName()};
    }

    /**
     * Method getter maker.
     *
     * @return maker
     */
    @Override
    public MakeParameter getMakeParameter() {
        return new PostgreSqlMakeParameter();
    }

}
