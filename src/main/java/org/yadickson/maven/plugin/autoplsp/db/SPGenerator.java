package org.yadickson.maven.plugin.autoplsp.db;

import org.yadickson.maven.plugin.autoplsp.db.common.Procedure;
import java.sql.Connection;
import java.util.List;

/**
 *
 * @author Yadickson Soto
 */
public interface SPGenerator {

    /**
     *
     * @param connection
     * @return
     * @throws Exception
     */
    List<Procedure> findProcedures(Connection connection) throws Exception;

    /**
     *
     * @param connection
     * @param procedure
     * @throws Exception
     */
    void fillProcedure(Connection connection, Procedure procedure) throws Exception;
}
