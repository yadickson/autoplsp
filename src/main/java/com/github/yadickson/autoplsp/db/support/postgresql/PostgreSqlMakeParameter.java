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

import java.sql.Connection;

import com.github.yadickson.autoplsp.db.MakeParameter;
import com.github.yadickson.autoplsp.db.common.Direction;
import com.github.yadickson.autoplsp.db.common.Parameter;
import com.github.yadickson.autoplsp.db.common.Procedure;
import com.github.yadickson.autoplsp.db.parameter.BooleanParameter;
import com.github.yadickson.autoplsp.db.parameter.CharParameter;
import com.github.yadickson.autoplsp.db.parameter.NumberParameter;
import com.github.yadickson.autoplsp.db.parameter.ReturnResultSetParameter;
import com.github.yadickson.autoplsp.db.parameter.VoidParameter;
import com.github.yadickson.autoplsp.handler.BusinessException;

/**
 * PostgreSQL parameter create class
 *
 * @author Yadickson Soto
 */
public class PostgreSqlMakeParameter extends MakeParameter {

    static final long serialVersionUID = 1;
    static final String PREFIX = "";

    /**
     * PostgreSQL method to create parameter class from database information
     *
     * @param type Parameter type
     * @param position Parameter position
     * @param name Parameter name
     * @param direction Parameter direction
     * @param connection Database connection
     * @param typeName Particular parameter type name
     * @param procedure The procedure owner
     * @param objectSuffix Object suffix name
     * @param arraySuffix Array suffix name
     * @return the new parameter
     * @throws BusinessException If create parameter process throws an error
     */
    @Override
    public Parameter getOwnerParameter(
            final String type,
            final int position,
            final String name,
            final Direction direction,
            final Connection connection,
            final String typeName,
            final Procedure procedure,
            final String objectSuffix,
            final String arraySuffix) throws BusinessException {
        if (findParameterType(type, "TEXT", "CHARACTER")) {
            return new CharParameter(position, name, direction, PREFIX, procedure);
        }
        if (findParameterType(type, "INT4", "FLOAT4", "INTEGER", "REAL")) {
            return new NumberParameter(position, name, direction, PREFIX, procedure);
        }
        if (findParameterType(type, "BOOLEAN")) {
            return new BooleanParameter(position, name, direction, PREFIX, procedure);
        }
        if (findParameterType(type, "VOID")) {
            return new VoidParameter(position, name, direction, PREFIX, procedure);
        }

        throw new BusinessException("Type [" + type + " " + name + "] not supported");
    }

    /**
     * Getter return result set parameter.
     *
     * @param position The position
     * @param name The name
     * @param procedure The procedure owner
     * @param connection Database connection
     * @param objectSuffix Object suffix name
     * @param arraySuffix Array suffix name
     * @return the new parameter
     * @throws BusinessException If create parameter process throws an error
     */
    @Override
    public Parameter getReturnResultSet(
            final int position,
            final String name,
            final Procedure procedure,
            final Connection connection,
            final String objectSuffix,
            final String arraySuffix)
            throws BusinessException {
        return new ReturnResultSetParameter(position, name, PREFIX, procedure);
    }
}
