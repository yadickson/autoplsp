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
package com.github.yadickson.autoplsp.db.support.oracle.parameter;

import com.github.yadickson.autoplsp.db.common.Direction;
import com.github.yadickson.autoplsp.db.common.Parameter;
import com.github.yadickson.autoplsp.db.parameter.BlobParameter;
import com.github.yadickson.autoplsp.db.parameter.CharParameter;
import com.github.yadickson.autoplsp.db.parameter.ClobParameter;
import com.github.yadickson.autoplsp.db.parameter.DateParameter;
import com.github.yadickson.autoplsp.db.parameter.NumberParameter;
import org.junit.Test;
import static org.junit.Assert.*;
import org.junit.Before;
import com.github.yadickson.autoplsp.db.common.Procedure;
import com.github.yadickson.autoplsp.handler.BusinessException;

/**
 *
 * @author Yadickson Soto
 */
public class OracleMakeParameterTest {

    OracleMakeParameter maker;

    @Before
    public void setup() {
        maker = new OracleMakeParameter();
    }

    @Test(expected = Exception.class)
    public void testNullType() throws BusinessException {
        maker.create(null, 0, null, Direction.INPUT, null, null, null);
    }

    @Test(expected = Exception.class)
    public void testUnknowType() throws BusinessException {
        maker.create("xx", 0, null, Direction.INPUT, null, null, null);
    }

    @Test
    public void testChar() throws BusinessException {
        Parameter parameter = maker.create("char", 1, "charName", Direction.INPUT, null, null, null);
        assertNotNull(parameter);
        assertTrue(parameter instanceof CharParameter);
        assertEquals(new Integer(1), parameter.getPosition());
        assertEquals("charName", parameter.getName());
        assertEquals(Direction.INPUT, parameter.getDirection());
    }

    @Test
    public void testVarchar2() throws BusinessException {
        Parameter parameter = maker.create("varchar2", 2, "vcName", Direction.OUTPUT, null, null, null);
        assertNotNull(parameter);
        assertTrue(parameter instanceof CharParameter);
        assertEquals(new Integer(2), parameter.getPosition());
        assertEquals("vcName", parameter.getName());
        assertEquals(Direction.OUTPUT, parameter.getDirection());
    }

    @Test
    public void testNumber() throws BusinessException {
        Parameter parameter = maker.create("number", 1, "numberName", Direction.INPUT, null, null, null);
        assertNotNull(parameter);
        assertTrue(parameter instanceof NumberParameter);
        assertEquals(new Integer(1), parameter.getPosition());
        assertEquals("numberName", parameter.getName());
        assertEquals(Direction.INPUT, parameter.getDirection());
    }

    @Test
    public void testDecimal() throws BusinessException {
        Parameter parameter = maker.create("decimal", 2, "decimalName", Direction.OUTPUT, null, null, null);
        assertNotNull(parameter);
        assertTrue(parameter instanceof NumberParameter);
        assertEquals(new Integer(2), parameter.getPosition());
        assertEquals("decimalName", parameter.getName());
        assertEquals(Direction.OUTPUT, parameter.getDirection());
    }

    @Test
    public void testClob() throws BusinessException {
        Parameter parameter = maker.create("clob", 1, "clobName", Direction.INPUT, null, null, null);
        assertNotNull(parameter);
        assertTrue(parameter instanceof ClobParameter);
        assertEquals(new Integer(1), parameter.getPosition());
        assertEquals("clobName", parameter.getName());
        assertEquals(Direction.INPUT, parameter.getDirection());
    }

    @Test
    public void testBlob() throws BusinessException {
        Parameter parameter = maker.create("blob", 1, "blobName", Direction.INPUT, null, null, null);
        assertNotNull(parameter);
        assertTrue(parameter instanceof BlobParameter);
        assertEquals(new Integer(1), parameter.getPosition());
        assertEquals("blobName", parameter.getName());
        assertEquals(Direction.INPUT, parameter.getDirection());
    }

    @Test
    public void testDate() throws BusinessException {
        Parameter parameter = maker.create("date", 1, "dateName", Direction.INPUT, null, null, null);
        assertNotNull(parameter);
        assertTrue(parameter instanceof DateParameter);
        assertEquals(new Integer(1), parameter.getPosition());
        assertEquals("dateName", parameter.getName());
        assertEquals(Direction.INPUT, parameter.getDirection());
    }

    @Test
    public void testTimestamp() throws BusinessException {
        Parameter parameter = maker.create("timestamp", 2, "tsName", Direction.OUTPUT, null, null, null);
        assertNotNull(parameter);
        assertTrue(parameter instanceof DateParameter);
        assertEquals(new Integer(2), parameter.getPosition());
        assertEquals("tsName", parameter.getName());
        assertEquals(Direction.OUTPUT, parameter.getDirection());
    }

    @Test
    public void testRowId() throws BusinessException {
        Parameter parameter = maker.create("rowid", 1, "rowName", Direction.INPUT, null, null, null);
        assertNotNull(parameter);
        assertTrue(parameter instanceof OracleRowIdParameter);
        assertEquals(new Integer(1), parameter.getPosition());
        assertEquals("rowName", parameter.getName());
        assertEquals(Direction.INPUT, parameter.getDirection());
    }

    @Test(expected = Exception.class)
    public void testRefCursorInputError() throws BusinessException {
        maker.create("ref cursor", 1, "rcName", Direction.INPUT, null, null, null);
    }

    @Test
    public void testRefCursor() throws BusinessException {
        Parameter parameter = maker.create("ref cursor", 1, "rc_name", Direction.OUTPUT, null, null, new Procedure("package", "test"));
        assertNotNull(parameter);
        assertTrue(parameter instanceof OracleDataSetParameter);
        assertEquals(new Integer(1), parameter.getPosition());
        assertEquals("rc_name", parameter.getName());
        assertEquals("rcName", parameter.getFieldName());
        assertEquals(Direction.OUTPUT, parameter.getDirection());
        assertEquals("PackageTestRcNameRS", parameter.getJavaTypeName());
    }

    @Test(expected = Exception.class)
    public void testObjectOutputError() throws BusinessException {
        maker.create("object", 1, "objName", Direction.OUTPUT, null, null, null);
    }

    @Test
    public void testObject() throws BusinessException {
        Parameter parameter = maker.create("object", 1, "objName", Direction.INPUT, null, null, null);
        assertNotNull(parameter);
        assertTrue(parameter instanceof OracleObjectParameter);
        assertEquals(new Integer(1), parameter.getPosition());
        assertEquals("objName", parameter.getName());
        assertEquals(Direction.INPUT, parameter.getDirection());
        assertNotNull(parameter.getParameters());
    }

    @Test(expected = Exception.class)
    public void testTableOutputError() throws BusinessException {
        maker.create("table", 1, "tName", Direction.OUTPUT, null, null, null);
    }

    @Test
    public void testTable() throws BusinessException {
        Parameter parameter = maker.create("table", 1, "tName", Direction.INPUT, null, null, null);
        assertNotNull(parameter);
        assertTrue(parameter instanceof OracleTableParameter);
        assertEquals(new Integer(1), parameter.getPosition());
        assertEquals("tName", parameter.getName());
        assertEquals(Direction.INPUT, parameter.getDirection());
        assertNotNull(parameter.getParameters());
    }
}
