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
package com.github.yadickson.autoplsp.db.support.postgresql.parameter;

import com.github.yadickson.autoplsp.db.common.Direction;
import com.github.yadickson.autoplsp.db.common.Parameter;
import com.github.yadickson.autoplsp.db.parameter.CharParameter;
import com.github.yadickson.autoplsp.db.MakeParameter;
import java.sql.Connection;
import com.github.yadickson.autoplsp.db.common.Procedure;
import com.github.yadickson.autoplsp.db.parameter.NumberParameter;
import com.github.yadickson.autoplsp.handler.BusinessException;

/**
 * PostgreSQL parameter create class
 *
 * @author Yadickson Soto
 */
public class PostgreSqlMakeParameter extends MakeParameter {

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
     * @return the new parameter
     * @throws BusinessException If create psrameter process throws an error
     */
    @Override
    public Parameter getOwnerParameter(String type, int position, String name, Direction direction, Connection connection, String typeName, Procedure procedure) throws BusinessException {
        if (type.equalsIgnoreCase("TEXT") || type.equalsIgnoreCase("character varying")) {
            return new CharParameter(position, name, direction);
        }
        if (type.equalsIgnoreCase("INTEGER")  || type.equalsIgnoreCase("REAL") ) {
            return new NumberParameter(position, name, direction);
        }

        throw new BusinessException("Type [" + type + " " + name + "] not supported");
    }
}
