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

import com.github.yadickson.autoplsp.db.bean.ProcedureBean;
import com.github.yadickson.autoplsp.db.common.Function;
import com.github.yadickson.autoplsp.db.common.Procedure;
import com.github.yadickson.autoplsp.db.util.FindProcedureImpl;
import com.github.yadickson.autoplsp.handler.BusinessException;
import com.github.yadickson.autoplsp.logger.LoggerManager;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;

/**
 * Store procedure and function generator interface
 *
 * @author Yadickson Soto
 */
public abstract class SPGenerator {

    private final String name;

    /**
     * Class constructor
     *
     * @param name sp generator name
     */
    public SPGenerator(String name) {
        this.name = name;
    }

    /**
     * Get generator name
     *
     * @return procedure list
     */
    public String getName() {
        return name;
    }

    /**
     * Method getter sql procedures
     *
     * @return sql to find procedures
     */
    public abstract String getProcedureQuery();

    /**
     * Find all procedure from database
     *
     * @param connection Database connection
     * @return procedure list
     * @throws BusinessException If error
     */
    public final List<Procedure> findProcedures(Connection connection) throws BusinessException {
        LoggerManager.getInstance().info("[SPGenerator] Find all procedure by name");

        List<Procedure> list = new ArrayList<Procedure>();

        List<ProcedureBean> procedures = new FindProcedureImpl().getProcedures(connection, getProcedureQuery());

        for (ProcedureBean p : procedures) {
            Procedure procedure = p.getType().equalsIgnoreCase("PROCEDURE") ? new Procedure(p.getPkg(), p.getName()) : new Function(p.getPkg(), p.getName());
            LoggerManager.getInstance().info("[SPGenerator] Found (" + p.getType() + ") " + procedure.getFullName());
            list.add(procedure);
        }

        LoggerManager.getInstance().info("[SPGenerator] Found " + list.size() + " procedures");

        return list;
    }

    /**
     * Fill parameters of procedure from database
     *
     * @param connection Database connection
     * @param procedure procedure
     * @throws BusinessException If error
     */
    public abstract void fillProcedure(Connection connection, Procedure procedure) throws BusinessException;
}
