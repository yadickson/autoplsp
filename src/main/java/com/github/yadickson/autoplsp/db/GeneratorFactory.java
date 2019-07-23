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
package com.github.yadickson.autoplsp.db;

import com.github.yadickson.autoplsp.db.support.mssql.MsSqlGenerator;
import com.github.yadickson.autoplsp.db.support.oracle.OracleGenerator;
import com.github.yadickson.autoplsp.db.support.postgresql.PostgreSqlGenerator;
import com.github.yadickson.autoplsp.handler.BusinessException;
import java.util.regex.Pattern;

/**
 * Store procedure and function generator factory from driver class name
 *
 * @author Yadickson Soto
 */
public class GeneratorFactory {

    private GeneratorFactory() {
        throw new IllegalStateException("Utility class");
    }

    /**
     * Create SP generator from driver class name
     *
     * @param driver Database driver class name
     * @return the sp generator
     * @throws BusinessException If driver not supported
     */
    public static Generator getGenarator(String driver) throws BusinessException {

        if (Pattern.compile(".*Oracle.*", Pattern.CASE_INSENSITIVE).matcher(driver).matches()) {
            return new OracleGenerator("oracle");
        }

        if (Pattern.compile(".*PostgreSQL.*", Pattern.CASE_INSENSITIVE).matcher(driver).matches()) {
            return new PostgreSqlGenerator("potsgresql");
        }

        if (Pattern.compile(".*Jtds.*", Pattern.CASE_INSENSITIVE).matcher(driver).matches()) {
            return new MsSqlGenerator("mssql");
        }

        throw new BusinessException("Driver [" + driver + "] not supported");
    }

}
