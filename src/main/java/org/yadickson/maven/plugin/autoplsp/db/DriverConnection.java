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

import org.yadickson.maven.plugin.autoplsp.logger.LoggerManager;
import java.sql.Connection;
import java.sql.DriverManager;

/**
 * Database connection manager
 *
 * @author Yadickson Soto
 */
public class DriverConnection {

    private final String connectionString;
    private final String driver;
    private final String pass;
    private final String user;
    private Connection connection;

    /**
     * Class constructor
     *
     * @param driver Database connection driver
     * @param connectionString Database connection string
     * @param user Database username
     * @param pass Database password
     */
    public DriverConnection(String driver, String connectionString, String user, String pass) {
        this.driver = driver;
        this.connectionString = connectionString;
        this.user = user;
        this.pass = pass;
        connection = null;
    }

    /**
     * Open database connection
     *
     * @return @throws Exception Launch if the open connection process throws an
     * error
     */
    public Connection getConnection() throws Exception {

        if (connection != null) {
            return connection;
        }

        Class.forName(this.driver);

        connection = DriverManager.getConnection(
                this.connectionString,
                this.user,
                this.pass);

        return connection;
    }

    /**
     * Close database connection
     */
    public void closeConnection() {

        try {
            if (connection != null) {
                connection.close();
            }
        } catch (Exception ex) {
            LoggerManager.getInstance().info("[DriverConnection] Error: " + ex.getMessage());
        } finally {
            connection = null;
        }
    }
}
