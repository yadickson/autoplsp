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
package org.yadickson.maven.plugin.autoplsp.db.parameter;

import org.yadickson.maven.plugin.autoplsp.db.common.Parameter;
import org.yadickson.maven.plugin.autoplsp.db.common.Direction;

/**
 *
 * @author Yadickson Soto
 */
public abstract class RowIdParameter extends Parameter {

    /**
     *
     * @param position
     * @param pname
     * @param pdirection
     */
    public RowIdParameter(int position, String pname, Direction pdirection) {
        super(position, pname, pdirection);
    }

    /**
     *
     * @return
     */
    @Override
    public int getSqlType() {
        return java.sql.Types.OTHER;
    }

    /**
     *
     * @return
     */
    @Override
    public String getSqlTypeName() {
        return "java.sql.Types.OTHER";
    }
}
