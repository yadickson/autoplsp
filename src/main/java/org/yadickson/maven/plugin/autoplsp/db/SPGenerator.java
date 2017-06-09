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
package org.yadickson.maven.plugin.autoplsp.db;

import org.yadickson.maven.plugin.autoplsp.db.common.Procedure;
import java.sql.Connection;
import java.util.List;

/**
 * Store procedure and function generator interface
 *
 * @author Yadickson Soto
 */
public interface SPGenerator {

    /**
     * Find all procedure from database
     *
     * @param connection Database connection
     * @return procedure list
     * @throws Exception If error
     */
    List<Procedure> findProcedures(Connection connection) throws Exception;

    /**
     * Fill parameters of procedure from database
     *
     * @param connection Database connection
     * @param procedure procedure
     * @throws Exception If error
     */
    void fillProcedure(Connection connection, Procedure procedure) throws Exception;
}
