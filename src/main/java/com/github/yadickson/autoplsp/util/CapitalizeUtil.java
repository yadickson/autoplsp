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
package com.github.yadickson.autoplsp.util;

import org.apache.commons.lang.WordUtils;

/**
 * Capitalize util class
 *
 * @author Yadickson Soto
 */
public class CapitalizeUtil {

    /**
     * Process string to capitalize
     *
     * @param value value to capitalize
     * @return capitalize fully
     */
    public static String capitalize(String value) {
        return WordUtils.capitalizeFully(value, new char[]{'_'}).replaceAll("_", "");
    }

    /**
     * Process string to uncapitalize
     *
     * @param value value to uncapitalize
     * @return uncapitalize representation
     */
    public static String uncapitalize(String value) {
        return WordUtils.uncapitalize(capitalize(value));
    }

}
