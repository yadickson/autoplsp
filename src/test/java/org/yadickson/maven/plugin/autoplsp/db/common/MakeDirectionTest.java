/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.yadickson.maven.plugin.autoplsp.db.common;

import org.junit.Test;
import static org.junit.Assert.*;
import org.junit.Before;
import org.yadickson.maven.plugin.autoplsp.db.MakeDirection;
import org.yadickson.maven.plugin.autoplsp.db.common.Direction;

/**
 * Make direction test
 *
 * @author Yadickson Soto
 */
public class MakeDirectionTest {

    private MakeDirection direction;

    public MakeDirectionTest() {
    }

    @Before
    public void setup() {
        direction = new MakeDirection();
    }

    @Test
    public void testInputDirection() throws Exception {
        Direction d = direction.getDirection("In");
        assertEquals(Direction.Input, d);
    }

    @Test
    public void testOutputDirection() throws Exception {
        Direction d = direction.getDirection("oUt");
        assertEquals(Direction.Output, d);
    }

    @Test
    public void testInputOutputDirection() throws Exception {
        Direction d = direction.getDirection("IN/OUT");
        assertEquals(Direction.InputOutput, d);
    }

    @Test(expected = Exception.class)
    public void testNullDirection() throws Exception {
        direction.getDirection(null);
    }

    @Test(expected = Exception.class)
    public void testUnknowDirection() throws Exception {
        direction.getDirection("xx");
    }
}
