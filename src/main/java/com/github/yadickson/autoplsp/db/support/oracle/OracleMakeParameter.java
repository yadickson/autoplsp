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

import java.sql.Connection;

import com.github.yadickson.autoplsp.db.MakeParameter;
import com.github.yadickson.autoplsp.db.common.Direction;
import com.github.yadickson.autoplsp.db.common.Parameter;
import com.github.yadickson.autoplsp.db.common.Procedure;
import com.github.yadickson.autoplsp.db.parameter.BlobParameter;
import com.github.yadickson.autoplsp.db.parameter.CharParameter;
import com.github.yadickson.autoplsp.db.parameter.ClobParameter;
import com.github.yadickson.autoplsp.db.parameter.DateParameter;
import com.github.yadickson.autoplsp.db.parameter.NumberParameter;
import com.github.yadickson.autoplsp.handler.BusinessException;

/**
 * Oracle parameter create class
 *
 * @author Yadickson Soto
 */
public class OracleMakeParameter extends MakeParameter {

    static final long serialVersionUID = 1;
    static final String PREFIX = "";

    /**
     * Oracle method to create parameter class from database information
     *
     * @param sqlNativeTypeName Parameter sqlNativeTypeName
     * @param position Parameter position
     * @param name Parameter name
     * @param direction Parameter direction
     * @param sqlNativeDirection The sql native direction.
     * @param connection Database connection
     * @param typeName Particular parameter sqlNativeTypeName name
     * @param procedure The procedure owner
     * @param objectSuffix Object suffix name
     * @param arraySuffix Array suffix name
     * @return the new parameter
     * @throws BusinessException If create psrameter process throws an error
     */
    @Override
    public Parameter getOwnerParameter(
            final String sqlNativeTypeName,
            final int position,
            final String name,
            final Direction direction,
            final String sqlNativeDirection,
            final Connection connection,
            final String typeName,
            final Procedure procedure,
            final String objectSuffix,
            final String arraySuffix)
            throws BusinessException {

        if (findParameterType(sqlNativeTypeName, "CHAR", "NCHAR", "VARCHAR", "VARCHAR2", "NVARCHAR2")) {
            return new CharParameter(position, name, direction, PREFIX, procedure, sqlNativeDirection, sqlNativeTypeName);
        }
        if (findParameterType(sqlNativeTypeName, "NUMBER", "DECIMAL", "FLOAT", "INTEGER", "REAL", "DEC", "INT", "SMALLINT", "BINARY_DOUBLE", "BINARY_FLOAT")) {
            return new NumberParameter(position, name, direction, PREFIX, procedure, sqlNativeDirection, sqlNativeTypeName);
        }
        if (findParameterType(sqlNativeTypeName, "CLOB", "NCLOB")) {
            return new ClobParameter(position, name, direction, PREFIX, procedure, sqlNativeDirection, sqlNativeTypeName);
        }
        if (findParameterType(sqlNativeTypeName, "BLOB")) {
            return new BlobParameter(position, name, direction, PREFIX, procedure, sqlNativeDirection, sqlNativeTypeName);
        }
        if (findParameterType(sqlNativeTypeName, "DATE", "TIMESTAMP")) {
            return new DateParameter(position, name, direction, PREFIX, procedure, sqlNativeDirection, sqlNativeTypeName);
        }
        if (findParameterType(sqlNativeTypeName, "ROWID", "UROWID")) {
            return new OracleRowIdParameter(position, name, direction, PREFIX, procedure, sqlNativeDirection, sqlNativeTypeName);
        }
        if (findParameterType(sqlNativeTypeName, "CURSOR")) {
            if (direction != Direction.OUTPUT) {
                throw new BusinessException("Input REF CURSOR not supported");
            }

            return new OracleDataSetParameter(position, name, PREFIX, procedure, "SYS_REFCURSOR");
        }

        if (findParameterType(sqlNativeTypeName, "OBJECT")) {
            if (direction != Direction.INPUT) {
                throw new BusinessException("Output OBJECT not supported");
            }

            return new OracleObjectParameter(position, name, direction, PREFIX, procedure, connection, typeName, objectSuffix, arraySuffix, sqlNativeDirection);
        }

        if (findParameterType(sqlNativeTypeName, "TABLE")) {
            if (direction != Direction.INPUT) {
                throw new BusinessException("Output TABLE not supported");
            }

            return new OracleTableParameter(position, name, direction, PREFIX, procedure, connection, typeName, objectSuffix, arraySuffix, sqlNativeDirection);
        }

        throw new BusinessException("Type [" + sqlNativeTypeName + " " + name + "] not supported");
    }
}
