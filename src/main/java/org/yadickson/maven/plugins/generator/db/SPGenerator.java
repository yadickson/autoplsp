package org.yadickson.maven.plugins.generator.db;

import org.yadickson.maven.plugins.generator.db.common.Procedure;
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
    List<String> findStoredProcedureNames(Connection connection) throws Exception;

    /**
     *
     * @param connection
     * @param procedureName
     * @return
     * @throws Exception
     */
    Procedure findStoredProcedure(Connection connection, String procedureName) throws Exception;
}
