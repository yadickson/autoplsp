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
package com.github.yadickson.autoplsp.db.support.mssql;

import com.github.yadickson.autoplsp.db.common.Direction;
import com.github.yadickson.autoplsp.db.common.Procedure;
import com.github.yadickson.autoplsp.db.parameter.ReturnResultSetParameter;
import com.github.yadickson.autoplsp.handler.BusinessException;
import java.sql.Connection;

/**
 * SQL Server Table parameter class
 *
 * @author Yadickson Soto
 */
public class MsSqlResultSetParameter extends ReturnResultSetParameter {

    static final long serialVersionUID = 1;

    /**
     * Class constructor.
     *
     * @param name The parameter name
     * @param prefix The prefix
     * @param procedure Procedure
     * @param connection Database connection
     * @param objectSuffix Object suffix name
     * @param arraySuffix Array suffix name
     * @throws BusinessException If create parameter process throws an error
     */
    public MsSqlResultSetParameter(
            final String name,
            final String prefix,
            final Procedure procedure,
            final Connection connection,
            final String objectSuffix,
            final String arraySuffix)
            throws BusinessException {
        super(-1, name, Direction.OUTPUT, prefix, procedure);
    }

    /**
     * Getter the sql type.
     *
     * @return The sql type
     * @throws BusinessException if error
     */
    @Override
    public int getSqlType() throws BusinessException {
        return java.sql.Types.OTHER;
    }

    /**
     * Getter the sql type name.
     *
     * @return the sql type name
     * @throws BusinessException if error
     */
    @Override
    public String getSqlTypeName() throws BusinessException {
        return "java.sql.Types.OTHER";
    }

}
