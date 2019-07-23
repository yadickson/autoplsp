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

import com.github.yadickson.autoplsp.handler.BusinessException;
import com.github.yadickson.autoplsp.logger.LoggerManager;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import org.apache.commons.dbutils.DbUtils;

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

    private String name;
    private String version;

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
     * @return Database connection
     * @throws BusinessException Launch if the open connection process throws an
     * error
     */
    public Connection getConnection() throws BusinessException {

        if (connection != null) {
            return connection;
        }

        try {

            Class.forName(this.driver);

            connection = DriverManager.getConnection(
                    this.connectionString,
                    this.user,
                    this.pass);

            name = connection.getMetaData().getDriverName();
            version = "" + connection.getMetaData().getDriverMajorVersion();

            LoggerManager.getInstance().info("Driver Name: " + name);
            LoggerManager.getInstance().info("Driver Version: " + connection.getMetaData().getDriverVersion());

            return connection;

        } catch (SQLException ex) {
            throw new BusinessException("", ex);
        } catch (ClassNotFoundException ex) {
            throw new BusinessException("", ex);
        }
    }

    /**
     * Close database connection
     */
    public void closeConnection() {

        try {
            DbUtils.close(connection);
        } catch (SQLException ex) {
            LoggerManager.getInstance().error(ex);
        }
    }

    public String getName() {
        return name;
    }

    public String getVersion() {
        return version;
    }
}
