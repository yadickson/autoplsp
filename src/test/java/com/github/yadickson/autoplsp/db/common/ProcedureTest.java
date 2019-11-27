/*
 * Copyright (C) 2019 Yadickson Soto
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


import static org.junit.Assert.*;
import org.junit.Test;

/**
 * Class Procedure test
 *
 * @author Yadickson Soto
 */
public class ProcedureTest {

    public ProcedureTest() {
    }

    @Test
    public void testProcedureAddPackageName() {

        Procedure procedure = new Procedure(true, "packageName", "procedureName");

        assertNotNull(procedure.getPackageName());
        assertNotNull(procedure.getName());
        assertEquals("packageName", procedure.getPackageName());
        assertEquals("procedureName", procedure.getName());
        assertFalse(procedure.isFunction());
        assertEquals("packageName.procedureName", procedure.getFullName());
        assertEquals("PackageNameProcedureName", procedure.getClassName());
    }

    @Test
    public void testProcedureDisableAddPackageName() {

        Procedure procedure = new Procedure(false, "packageName", "procedureName");

        assertNotNull(procedure.getPackageName());
        assertNotNull(procedure.getName());
        assertEquals("packageName", procedure.getPackageName());
        assertEquals("procedureName", procedure.getName());
        assertFalse(procedure.isFunction());
        assertEquals("packageName.procedureName", procedure.getFullName());
        assertEquals("ProcedureName", procedure.getClassName());
    }

    @Test
    public void testProcedureWithoutPackageName() {

        Procedure procedure = new Procedure(false, null, "procedureName");

        assertNull(procedure.getPackageName());
        assertNotNull(procedure.getName());
        assertNull(procedure.getPackageName());
        assertEquals("procedureName", procedure.getName());
        assertFalse(procedure.isFunction());
        assertEquals("procedureName", procedure.getFullName());
        assertEquals("ProcedureName", procedure.getClassName());
    }

    @Test
    public void testProcedureForceAddWithoutPackageName() {

        Procedure procedure = new Procedure(true, null, "procedureName");

        assertNull(procedure.getPackageName());
        assertNotNull(procedure.getName());
        assertNull(procedure.getPackageName());
        assertEquals("procedureName", procedure.getName());
        assertFalse(procedure.isFunction());
        assertEquals("procedureName", procedure.getFullName());
        assertEquals("ProcedureName", procedure.getClassName());
    }
}
