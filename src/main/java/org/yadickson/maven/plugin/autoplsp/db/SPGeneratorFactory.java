/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.yadickson.maven.plugin.autoplsp.db;

import org.yadickson.maven.plugin.autoplsp.db.support.oracle.OracleSPGenerator;
import java.util.regex.Pattern;

/**
 * Permite crear un generador de SP segun driver
 *
 * @author Yadickson Soto
 */
public class SPGeneratorFactory {

    /**
     *
     * @param driver
     * @return
     * @throws Exception
     */
    public static SPGenerator getGenaratorConnection(String driver) throws Exception {

        Pattern oraclePattern = Pattern.compile(".*Oracle.*", Pattern.CASE_INSENSITIVE);

        if (oraclePattern.matcher(driver).matches()) {
            return new OracleSPGenerator();
        }

        throw new Exception("Driver [" + driver + "] not supported");
    }

}
