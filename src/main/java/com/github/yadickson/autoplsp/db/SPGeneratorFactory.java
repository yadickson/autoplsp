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
package com.github.yadickson.autoplsp.db;

import com.github.yadickson.autoplsp.db.support.oracle.OracleSPGenerator;
import com.github.yadickson.autoplsp.handler.BusinessException;
import java.util.regex.Pattern;

/**
 * Store procedure and function generator factory from driver class name
 *
 * @author Yadickson Soto
 */
public class SPGeneratorFactory {

    /**
     * Create SP generator from driver class name
     *
     * @param driver Database driver class name
     * @return the sp generator
     * @throws BusinessException If driver not supported
     */
    public static SPGenerator getGenarator(String driver) throws BusinessException {

        Pattern oraclePattern = Pattern.compile(".*Oracle.*", Pattern.CASE_INSENSITIVE);

        if (oraclePattern.matcher(driver).matches()) {
            return new OracleSPGenerator();
        }

        throw new BusinessException("Driver [" + driver + "] not supported");
    }

}
