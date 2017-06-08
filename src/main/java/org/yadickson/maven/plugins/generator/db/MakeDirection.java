/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.yadickson.maven.plugins.generator.db;

import org.yadickson.maven.plugins.generator.db.common.Direction;

/**
 * @author Yadickson Soto
 */
public class MakeDirection {

    /**
     *
     * @param value
     * @return
     * @throws Exception
     */

    public Direction getDirection(String value) throws Exception {
        if (value == null) {
            throw new Exception("Direction is null");
        }

        if (value.equalsIgnoreCase("IN")) {
            return Direction.Input;
        }

        if (value.equalsIgnoreCase("OUT")) {
            return Direction.Output;
        }

        if (value.equalsIgnoreCase("IN/OUT")) {
            return Direction.InputOutput;
        }

        throw new Exception("Direction [" + value + "] not implement");
    }

}
