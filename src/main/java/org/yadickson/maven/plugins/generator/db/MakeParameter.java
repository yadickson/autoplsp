/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.yadickson.maven.plugins.generator.db;

import org.yadickson.maven.plugins.generator.db.common.Direction;
import org.yadickson.maven.plugins.generator.db.common.Parameter;
import org.yadickson.maven.plugins.generator.db.parameter.BlobParameter;
import org.yadickson.maven.plugins.generator.db.parameter.CharParameter;
import org.yadickson.maven.plugins.generator.db.parameter.ClobParameter;
import org.yadickson.maven.plugins.generator.db.parameter.DateParameter;
import org.yadickson.maven.plugins.generator.db.parameter.NumberParameter;
import java.sql.Connection;

/**
 * Clase base para construir un parametro
 *
 * @author Yadickson Soto
 */
public abstract class MakeParameter {

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
    public Parameter create(String type, int position, String name, Direction direction, Connection connection, String typeName) throws Exception {

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

        return getOwnerParameter(type, position, name, direction, connection, typeName);
    }

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
    public abstract Parameter getOwnerParameter(String type, int position, String name, Direction direction, Connection connection, String typeName) throws Exception;
}
