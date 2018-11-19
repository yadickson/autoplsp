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
package com.github.yadickson.autoplsp.db;

import com.github.yadickson.autoplsp.db.common.Direction;
import com.github.yadickson.autoplsp.db.common.Parameter;
import java.sql.Connection;
import com.github.yadickson.autoplsp.db.common.Procedure;
import com.github.yadickson.autoplsp.handler.BusinessException;

/**
 * Make parameter class
 *
 * @author Yadickson Soto
 */
public abstract class MakeParameter {

    /**
     * Generic method to create parameter class from database information
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
    public Parameter create(
            final String type,
            final int position,
            final String name,
            final Direction direction,
            final Connection connection,
            final String typeName,
            final Procedure procedure,
            final String objectSuffix,
            final String arraySuffix)
            throws BusinessException {

        if (type == null) {
            throw new BusinessException("Parameter type is null");
        }

        return getOwnerParameter(type, position, name, direction, connection, typeName, procedure, objectSuffix, arraySuffix);
    }

    /**
     * Custom method to create parameter class from database information
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
    public abstract Parameter getOwnerParameter(
            final String type,
            final int position,
            final String name,
            final Direction direction,
            final Connection connection,
            final String typeName,
            final Procedure procedure,
            final String objectSuffix,
            final String arraySuffix)
            throws BusinessException;

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
    public Parameter getReturnResultSet(
            final int position,
            final String name,
            final Procedure procedure,
            final Connection connection,
            final String objectSuffix,
            final String arraySuffix)
            throws BusinessException {
        throw new BusinessException("ReturnResultSet not support");
    }

    /**
     * Find type parameter from list.
     *
     * @param type Type to find
     * @param types Type list
     * @return true is found
     */
    public boolean findParameterType(final String type, String... types) {
        boolean result = false;

        for (String t : types) {
            if (type.equalsIgnoreCase(t)) {
                return true;
            }
        }
        return result;
    }
}
