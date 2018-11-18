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
package com.github.yadickson.autoplsp.db.support.oracle;

import com.github.yadickson.autoplsp.db.MakeParameter;
import com.github.yadickson.autoplsp.db.SPGenerator;
import com.github.yadickson.autoplsp.db.common.Procedure;

/**
 * Oracle Store procedure and function generator class.
 *
 * @author Yadickson Soto
 */
public class OracleSPGenerator extends SPGenerator {

    /**
     * Class constructor.
     *
     * @param name sp generator
     */
    public OracleSPGenerator(String name) {
        super(name);
    }

    /**
     * Method getter sql procedures.
     *
     * @return sql to find procedures
     */
    @Override
    public String getProcedureQuery() {
        return "SELECT OBJECT_NAME as PKG, PROCEDURE_NAME as NAME, case when (SELECT count(position) as type FROM all_arguments WHERE OWNER=USER AND object_name = allp.PROCEDURE_NAME AND package_name = allp.OBJECT_NAME and position = 0) = 0 then 'PROCEDURE' else 'FUNCTION' end as type FROM ALL_PROCEDURES allp WHERE OWNER=USER and OBJECT_TYPE ='PACKAGE' and PROCEDURE_NAME is not null union SELECT null as PKG, OBJECT_NAME AS NAME, OBJECT_TYPE as TYPE FROM ALL_PROCEDURES WHERE OWNER=USER and (OBJECT_TYPE = 'FUNCTION' or OBJECT_TYPE='PROCEDURE')";
    }

    /**
     * Method getter sql parameters.
     *
     * @param procedure procedure
     * @return sql to find parameters
     */
    @Override
    public String getParameterQuery(final Procedure procedure) {
        String pkg = procedure.getPackageName() == null ? "" : "AND package_name = ?";
        String sql = "SELECT NVL(argument_name, 'return_value') as name, position, in_out as direction, DECODE(data_type, 'REF CURSOR', 'CURSOR', data_type) as dtype, type_name as ntype FROM all_arguments WHERE OWNER=USER AND object_name = ? " + pkg + " order by position asc, argument_name asc nulls first";
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
        if (procedure.getPackageName() == null) {
            return new Object[]{procedure.getName()};
        } else {
            return new Object[]{procedure.getName(), procedure.getPackageName()};
        }
    }

    /**
     * Method getter maker.
     *
     * @return maker
     */
    @Override
    public MakeParameter getMakeParameter() {
        return new OracleMakeParameter();
    }

}
