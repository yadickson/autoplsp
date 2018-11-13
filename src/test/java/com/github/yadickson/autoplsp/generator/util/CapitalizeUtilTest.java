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
package com.github.yadickson.autoplsp.generator.util;

import org.junit.Test;
import static org.junit.Assert.*;
import com.github.yadickson.autoplsp.util.CapitalizeUtil;

/**
 * Capitalize util test
 *
 * @author Yadickson Soto
 */
public class CapitalizeUtilTest {

    public CapitalizeUtilTest() {
    }

    @Test
    public void testCapitalize() {

        String result = CapitalizeUtil.capitalize("sp_test_capitalize");

        assertNotNull(result);
        assertEquals("SpTestCapitalize", result);

    }

    @Test
    public void testUncapitalize() {

        String result = CapitalizeUtil.uncapitalize("sp_test_capitalize");

        assertNotNull(result);
        assertEquals("spTestCapitalize", result);

    }

    @Test
    public void testCapitalizeFromNull() {

        String result = CapitalizeUtil.capitalize(null);

        assertNotNull(result);
        assertEquals("Null", result);

    }

    @Test
    public void testCapitalizeFromUppercase() {

        String result = CapitalizeUtil.capitalize("COMMON_CLASS_25");

        assertNotNull(result);
        assertEquals("CommonClass25", result);

    }

    @Test
    public void testCapitalizeFromUpperCaseMssqlNames() {

        String result = CapitalizeUtil.capitalize("FunctionGetNames");

        assertNotNull(result);
        assertEquals("FunctionGetNames", result);

    }
}
