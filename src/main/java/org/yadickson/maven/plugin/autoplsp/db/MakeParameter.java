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
package org.yadickson.maven.plugin.autoplsp.db;

import org.yadickson.maven.plugin.autoplsp.db.common.Direction;
import org.yadickson.maven.plugin.autoplsp.db.common.Parameter;
import org.yadickson.maven.plugin.autoplsp.db.parameter.BlobParameter;
import org.yadickson.maven.plugin.autoplsp.db.parameter.CharParameter;
import org.yadickson.maven.plugin.autoplsp.db.parameter.ClobParameter;
import org.yadickson.maven.plugin.autoplsp.db.parameter.DateParameter;
import org.yadickson.maven.plugin.autoplsp.db.parameter.NumberParameter;
import java.sql.Connection;
import org.yadickson.maven.plugin.autoplsp.db.common.Procedure;

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
     * @return the new parameter
     * @throws Exception If create psrameter process throws an error
     */
    public Parameter create(String type, int position, String name, Direction direction, Connection connection, String typeName, Procedure procedure) throws Exception {

        if (type == null) {
            throw new Exception("Parameter type is null");
        }

        if (type.equalsIgnoreCase("CHAR")) {
            return new CharParameter(position, name, direction);
        }
        if (type.equalsIgnoreCase("NUMBER") || type.equalsIgnoreCase("DECIMAL") || type.equalsIgnoreCase("FLOAT")) {
            return new NumberParameter(position, name, direction);
        }
        if (type.equalsIgnoreCase("CLOB")) {
            return new ClobParameter(position, name, direction);
        }
        if (type.equalsIgnoreCase("BLOB")) {
            return new BlobParameter(position, name, direction);
        }
        if (type.equalsIgnoreCase("DATE") || type.equalsIgnoreCase("TIMESTAMP")) {
            return new DateParameter(position, name, direction);
        }

        return getOwnerParameter(type, position, name, direction, connection, typeName, procedure);
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
     * @return the new parameter
     * @throws Exception If create psrameter process throws an error
     */
    public abstract Parameter getOwnerParameter(String type, int position, String name, Direction direction, Connection connection, String typeName, Procedure procedure) throws Exception;
}
