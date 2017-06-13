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
package com.github.yadickson.autoplsp.db.common;

import com.github.yadickson.autoplsp.db.common.Direction;
import org.junit.Test;
import static org.junit.Assert.*;
import org.junit.Before;
import com.github.yadickson.autoplsp.db.MakeDirection;

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
