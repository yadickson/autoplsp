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
package org.yadickson.maven.plugin.autoplsp.db.support.oracle.parameter;

import org.yadickson.maven.plugin.autoplsp.db.common.Direction;
import org.yadickson.maven.plugin.autoplsp.db.common.Parameter;
import org.yadickson.maven.plugin.autoplsp.db.parameter.CharParameter;
import org.yadickson.maven.plugin.autoplsp.db.MakeParameter;
import java.sql.Connection;
import org.yadickson.maven.plugin.autoplsp.db.common.Procedure;

/**
 * Oracle parameter create class
 *
 * @author Yadickson Soto
 */
public class OracleMakeParameter extends MakeParameter {

    /**
     * Oracle method to create parameter class from database information
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
    @Override
    public Parameter getOwnerParameter(String type, int position, String name, Direction direction, Connection connection, String typeName, Procedure procedure) throws Exception {
        if (type.equalsIgnoreCase("VARCHAR2")) {
            return new CharParameter(position, name, direction);
        }
        if (type.equalsIgnoreCase("ROWID")) {
            return new OracleRowIdParameter(position, name, direction);
        }
        if (type.equalsIgnoreCase("REF CURSOR")) {
            if (direction != Direction.Output) {
                throw new Exception("Input REF CURSOR not supported");
            }

            return new OracleDataSetParameter(position, name, procedure.getClassName());
        }

        if (type.equalsIgnoreCase("OBJECT")) {
            if (direction != Direction.Input) {
                throw new Exception("Output OBJECT not supported");
            }

            return new OracleObjectParameter(position, name, direction, connection, typeName);
        }

        if (type.equalsIgnoreCase("TABLE")) {
            if (direction != Direction.Input) {
                throw new Exception("Output TABLE not supported");
            }

            return new OracleTableParameter(position, name, direction, connection, typeName);
        }

        throw new Exception("Type [" + type + " " + name + "] not supported");
    }
}
