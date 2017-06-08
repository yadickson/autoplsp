package org.yadickson.maven.plugins.generator.db;

import org.yadickson.maven.plugins.generator.logger.LoggerManager;
import java.sql.Connection;
import java.sql.DriverManager;

/**
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
     *
     * @param driver
     * @param connectionString
     * @param user
     * @param pass
     */
    public DriverConnection(String driver, String connectionString, String user, String pass) {
        this.driver = driver;
        this.connectionString = connectionString;
        this.user = user;
        this.pass = pass;
        connection = null;
    }

    /**
     *
     * @return
     * @throws Exception
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
     *
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
