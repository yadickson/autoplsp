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
package com.github.yadickson.autoplsp.db.support.oracle;

import com.github.yadickson.autoplsp.db.MakeParameter;
import com.github.yadickson.autoplsp.db.Generator;
import com.github.yadickson.autoplsp.db.common.Procedure;

/**
 * Oracle Store procedure and function generator class.
 *
 * @author Yadickson Soto
 */
public class OracleGenerator extends Generator {

    /**
     * Class constructor.
     *
     * @param name sp generator
     */
    public OracleGenerator(String name) {
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
     * Method getter sql objects and tableObjets.
     *
     * @return sql to find parameters
     */
    @Override
    public String getObjetsQuery() {
        return "SELECT distinct data_type as dtype, type_name as ntype FROM all_arguments WHERE OWNER=USER AND data_type in ('OBJECT', 'TABLE') order by dtype asc, ntype asc";
    }

    /**
     * Method getter sql tables.
     *
     * @return sql to find tables
     */
    @Override
    public String getTablesQuery() {
        return "SELECT ut.table_name name,\n"
                + "utc.column_name fieldname,\n"
                + "CASE WHEN utc.data_type = 'CHAR' OR utc.data_type = 'NCHAR' OR utc.data_type = 'VARCHAR2' OR utc.data_type = 'VARCHAR' OR utc.data_type = 'NVARCHAR2' OR utc.data_type = 'CLOB' OR utc.data_type = 'NCLOB' OR utc.data_type = 'LONG'\n"
                + "     THEN 'String'\n"
                + "     WHEN utc.data_type = 'BLOB' OR utc.data_type = 'BFILE' OR utc.data_type = 'RAW' OR utc.data_type = 'LONG RAW'\n"
                + "     THEN 'Binary'\n"
                + "     WHEN utc.data_type = 'NUMBER' OR utc.data_type = 'DECIMAL' OR utc.data_type = 'FLOAT' OR utc.data_type = 'INTEGER' OR utc.data_type = 'REAL' OR utc.data_type = 'DEC' OR utc.data_type = 'INT' OR utc.data_type = 'SMALLINT' OR utc.data_type = 'BINARY_DOUBLE' OR utc.data_type = 'BINARY_FLOAT'\n"
                + "     THEN 'Numeric'\n"
                + "     WHEN utc.data_type = 'DATE' OR utc.data_type = 'TIMESTAMP'\n"
                + "     THEN 'Date'\n"
                + "     ELSE\n"
                + "     'Unknown'\n"
                + "     END fieldtype,\n"
                + "utc.column_id fieldposition,\n"
                + "DECODE(utc.nullable, 'Y', 0, 1) fieldminsize,\n"
                + "trunc(utc.data_length) fieldmaxsize,\n"
                + "DECODE(utc.nullable, 'N', 1, 0) fieldnotnull,\n"
                + "utc.data_default fielddefauldvalue\n"
                + "FROM user_tables ut\n"
                + "inner join USER_TAB_COLUMNS utc on (ut.table_name = utc.table_name)\n"
                + "order by ut.table_name asc, utc.column_id asc";
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
