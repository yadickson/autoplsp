/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.yadickson.maven.plugins.generator.db.support.oracle.parameter;

import org.yadickson.maven.plugins.generator.db.common.Direction;
import org.yadickson.maven.plugins.generator.db.common.Parameter;
import org.yadickson.maven.plugins.generator.db.parameter.CharParameter;
import org.yadickson.maven.plugins.generator.db.support.oracle.parameter.OracleTableParameter;
import org.yadickson.maven.plugins.generator.db.support.oracle.parameter.OracleDataSetParameter;
import org.yadickson.maven.plugins.generator.db.support.oracle.parameter.OracleObjectParameter;
import org.yadickson.maven.plugins.generator.db.support.oracle.parameter.OracleRowIdParameter;
import org.yadickson.maven.plugins.generator.db.MakeParameter;
import java.sql.Connection;

/**
 * Creacion de parametros para oracle
 *
 * @author Yadickson Soto
 */
public class OracleMakeParameter extends MakeParameter {

    /**
     *
     * @param type
     * @param position
     * @param name
     * @param direction
     * @param connection
     * @param typeName
     * @return
     * @throws Exception
     */
    @Override
    public Parameter getOwnerParameter(String type, int position, String name, Direction direction, Connection connection, String typeName) throws Exception {
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

            return new OracleDataSetParameter(position, name);
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
