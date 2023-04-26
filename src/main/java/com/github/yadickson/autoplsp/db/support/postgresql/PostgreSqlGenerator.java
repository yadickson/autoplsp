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
package com.github.yadickson.autoplsp.db.support.postgresql;

import com.github.yadickson.autoplsp.db.Generator;
import com.github.yadickson.autoplsp.db.MakeParameter;
import com.github.yadickson.autoplsp.db.common.Procedure;

/**
 * Oracle Store procedure and function generator class
 *
 * @author Yadickson Soto
 */
public class PostgreSqlGenerator extends Generator {

    /**
     * Class constructor
     *
     * @param name sp generator
     */
    public PostgreSqlGenerator(String name) {
        super(name);
    }

    /**
     * Method getter sql procedures
     *
     * @return sql to find procedures
     */
    @Override
    public String getProcedureQuery() {
        return "SELECT null as PKG, CASE WHEN p.prokind = 'p' THEN 'PROCEDURE' ELSE 'FUNCTION' END as type, p.proname as name"
                + " FROM pg_catalog.pg_namespace n JOIN pg_catalog.pg_proc p ON pronamespace = n.oid"
                + " WHERE nspname = 'public' AND pg_catalog.pg_function_is_visible(p.oid)";
    }

    /**
     * Method getter sql parameters.
     *
     * @param procedure procedure
     * @return sql to find parameters
     */
    @Override
    public String getParameterQuery(final Procedure procedure) {

        String sql = "select px[1] as position, px[4] as direction, px[2] as name, px[3] as dtype\n"
                + "from (\n"
                + "SELECT regexp_split_to_array(param, ':') from \n"
                + "(\n"
                + "select pg_catalog.array_to_string(ARRAY(select s.i+1 || ':' || case when p.proargnames[s.i+1] is null or p.proargnames[s.i+1] = '' then '$p' || s.i+1 else p.proargnames[s.i+1] end || ':' || pg_catalog.format_type(p.proargtypes[s.i], NULL) || ':' || case WHEN p.proargmodes[s.i] = 'o' THEN 'OUT' WHEN p.proargmodes[s.i] = 'b' THEN 'IN/OUT' ELSE 'IN' END from pg_catalog.generate_series(0, pg_catalog.array_upper(p.proargtypes, 1)) AS s(i)), ',') || case when p.pronargs > 0 and p.prokind = 'f' and pg_catalog.format_type(p.prorettype, NULL) != 'void' then ',' else '' end || case when p.prokind = 'f' and pg_catalog.format_type(p.prorettype, NULL) != 'void' then '0:return_value:' || pg_catalog.format_type(p.prorettype, NULL) || ':OUT' else '' end as input\n"
                + "FROM pg_catalog.pg_proc p\n"
                + "LEFT JOIN pg_catalog.pg_namespace n ON n.oid = p.pronamespace\n"
                + "where p.proname ilike ?\n"
                + ") as t, unnest(string_to_array(input, ',')) s(param)\n"
                + ") as dt(px)\n"
                + "order by 1 asc";

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

    /**
     * Getter Sql open and close keys.
     *
     * @return keys
     */
    @Override
    public String[] getSqlKeys() {
        return new String[]{"", ""};
    }

}
