/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.yadickson.maven.plugin.autoplsp.db.support.oracle.parameter;

import org.yadickson.maven.plugin.autoplsp.db.support.oracle.parameter.OracleMakeParameter;
import org.yadickson.maven.plugin.autoplsp.db.support.oracle.parameter.OracleObjectParameter;
import org.yadickson.maven.plugin.autoplsp.db.support.oracle.parameter.OracleTableParameter;
import org.yadickson.maven.plugin.autoplsp.db.support.oracle.parameter.OracleDataSetParameter;
import org.yadickson.maven.plugin.autoplsp.db.support.oracle.parameter.OracleRowIdParameter;
import org.yadickson.maven.plugin.autoplsp.db.common.Direction;
import org.yadickson.maven.plugin.autoplsp.db.common.Parameter;
import org.yadickson.maven.plugin.autoplsp.db.parameter.BlobParameter;
import org.yadickson.maven.plugin.autoplsp.db.parameter.CharParameter;
import org.yadickson.maven.plugin.autoplsp.db.parameter.ClobParameter;
import org.yadickson.maven.plugin.autoplsp.db.parameter.DateParameter;
import org.yadickson.maven.plugin.autoplsp.db.parameter.NumberParameter;
import org.junit.Test;
import static org.junit.Assert.*;
import org.junit.Before;

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
    public void testNullType() throws Exception {
        maker.create(null, 0, null, Direction.Input, null, null);
    }

    @Test(expected = Exception.class)
    public void testUnknowType() throws Exception {
        maker.create("xx", 0, null, Direction.Input, null, null);
    }

    @Test
    public void testChar() throws Exception {
        Parameter parameter = maker.create("char", 1, "charName", Direction.Input, null, null);
        assertNotNull(parameter);
        assertTrue(parameter instanceof CharParameter);
        assertEquals(new Integer(1), parameter.getPosition());
        assertEquals("charName", parameter.getName());
        assertEquals(Direction.Input, parameter.getDirection());
    }

    @Test
    public void testVarchar2() throws Exception {
        Parameter parameter = maker.create("varchar2", 2, "vcName", Direction.Output, null, null);
        assertNotNull(parameter);
        assertTrue(parameter instanceof CharParameter);
        assertEquals(new Integer(2), parameter.getPosition());
        assertEquals("vcName", parameter.getName());
        assertEquals(Direction.Output, parameter.getDirection());
    }

    @Test
    public void testNumber() throws Exception {
        Parameter parameter = maker.create("number", 1, "numberName", Direction.Input, null, null);
        assertNotNull(parameter);
        assertTrue(parameter instanceof NumberParameter);
        assertEquals(new Integer(1), parameter.getPosition());
        assertEquals("numberName", parameter.getName());
        assertEquals(Direction.Input, parameter.getDirection());
    }

    @Test
    public void testDecimal() throws Exception {
        Parameter parameter = maker.create("decimal", 2, "decimalName", Direction.Output, null, null);
        assertNotNull(parameter);
        assertTrue(parameter instanceof NumberParameter);
        assertEquals(new Integer(2), parameter.getPosition());
        assertEquals("decimalName", parameter.getName());
        assertEquals(Direction.Output, parameter.getDirection());
    }

    @Test
    public void testClob() throws Exception {
        Parameter parameter = maker.create("clob", 1, "clobName", Direction.Input, null, null);
        assertNotNull(parameter);
        assertTrue(parameter instanceof ClobParameter);
        assertEquals(new Integer(1), parameter.getPosition());
        assertEquals("clobName", parameter.getName());
        assertEquals(Direction.Input, parameter.getDirection());
    }

    @Test
    public void testBlob() throws Exception {
        Parameter parameter = maker.create("blob", 1, "blobName", Direction.Input, null, null);
        assertNotNull(parameter);
        assertTrue(parameter instanceof BlobParameter);
        assertEquals(new Integer(1), parameter.getPosition());
        assertEquals("blobName", parameter.getName());
        assertEquals(Direction.Input, parameter.getDirection());
    }

    @Test
    public void testDate() throws Exception {
        Parameter parameter = maker.create("date", 1, "dateName", Direction.Input, null, null);
        assertNotNull(parameter);
        assertTrue(parameter instanceof DateParameter);
        assertEquals(new Integer(1), parameter.getPosition());
        assertEquals("dateName", parameter.getName());
        assertEquals(Direction.Input, parameter.getDirection());
    }

    @Test
    public void testTimestamp() throws Exception {
        Parameter parameter = maker.create("timestamp", 2, "tsName", Direction.Output, null, null);
        assertNotNull(parameter);
        assertTrue(parameter instanceof DateParameter);
        assertEquals(new Integer(2), parameter.getPosition());
        assertEquals("tsName", parameter.getName());
        assertEquals(Direction.Output, parameter.getDirection());
    }

    @Test
    public void testRowId() throws Exception {
        Parameter parameter = maker.create("rowid", 1, "rowName", Direction.Input, null, null);
        assertNotNull(parameter);
        assertTrue(parameter instanceof OracleRowIdParameter);
        assertEquals(new Integer(1), parameter.getPosition());
        assertEquals("rowName", parameter.getName());
        assertEquals(Direction.Input, parameter.getDirection());
    }

    @Test(expected = Exception.class)
    public void testRefCursorInputError() throws Exception {
        maker.create("ref cursor", 1, "rcName", Direction.Input, null, null);
    }

    @Test
    public void testRefCursor() throws Exception {
        Parameter parameter = maker.create("ref cursor", 1, "rcName", Direction.Output, null, null);
        assertNotNull(parameter);
        assertTrue(parameter instanceof OracleDataSetParameter);
        assertEquals(new Integer(1), parameter.getPosition());
        assertEquals("rcName", parameter.getName());
        assertEquals(Direction.Output, parameter.getDirection());
    }

    @Test(expected = Exception.class)
    public void testObjectOutputError() throws Exception {
        maker.create("object", 1, "objName", Direction.Output, null, null);
    }

    @Test
    public void testObject() throws Exception {
        Parameter parameter = maker.create("object", 1, "objName", Direction.Input, null, null);
        assertNotNull(parameter);
        assertTrue(parameter instanceof OracleObjectParameter);
        assertEquals(new Integer(1), parameter.getPosition());
        assertEquals("objName", parameter.getName());
        assertEquals(Direction.Input, parameter.getDirection());
        assertNull(parameter.getParameters());
    }

    @Test(expected = Exception.class)
    public void testTableOutputError() throws Exception {
        maker.create("table", 1, "tName", Direction.Output, null, null);
    }

    @Test
    public void testTable() throws Exception {
        Parameter parameter = maker.create("table", 1, "tName", Direction.Input, null, null);
        assertNotNull(parameter);
        assertTrue(parameter instanceof OracleTableParameter);
        assertEquals(new Integer(1), parameter.getPosition());
        assertEquals("tName", parameter.getName());
        assertEquals(Direction.Input, parameter.getDirection());
        assertNull(parameter.getParameters());
    }
}
