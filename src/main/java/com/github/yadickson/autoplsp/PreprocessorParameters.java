/*
 * Copyright (C) 2018 Yadickson Soto
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
package com.github.yadickson.autoplsp;

import com.github.yadickson.autoplsp.db.common.Parameter;
import com.github.yadickson.autoplsp.db.common.Procedure;
import com.github.yadickson.autoplsp.db.parameter.DataSetParameter;
import com.github.yadickson.autoplsp.handler.BusinessException;
import com.github.yadickson.autoplsp.logger.LoggerManager;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

public class PreprocessorParameters {

    /**
     * Preprocessor of parameters to reused declarations.
     *
     * @param procedures The procedures to generate
     * @throws BusinessException Launch if the generation process throws an
     * error
     */
    public void process(List<Procedure> procedures) throws BusinessException {

        LoggerManager.getInstance().info("[PreprocessorParameters] Process " + procedures.size() + " procedures");

        List<DataSetParameter> rsParameters = new ArrayList<DataSetParameter>();

        for (Procedure procedure : procedures) {
            if (procedure.getHasResultSet()) {
                for (Parameter param : procedure.getParameters()) {
                    if (param.isOutput() && param.isResultSet()) {
                        rsParameters.add((DataSetParameter) param);
                    }
                }
            }
        }

        Map<Integer, List<DataSetParameter>> relations = new TreeMap<Integer, List<DataSetParameter>>();

        for (int i = 0; i < rsParameters.size(); i++) {
            DataSetParameter parami = rsParameters.get(i);

            relations.put(i, new ArrayList<DataSetParameter>());
            relations.get(i).add(parami);

            for (int j = i + 1; j < rsParameters.size(); j++) {
                DataSetParameter paramj = rsParameters.get(j);
                if (isEquals(parami, paramj)) {
                    relations.get(i).add(paramj);
                    rsParameters.remove(j--);
                }
            }
        }

        Map<String, Integer> baseNames = new TreeMap<String, Integer>();

        for (Map.Entry<Integer, List<DataSetParameter>> entry : relations.entrySet()) {

            if (entry.getValue().size() == 1) {
                continue;
            }

            List<DataSetParameter> parameters = entry.getValue();
            String baseName = parameters.get(0).getName();

            if (!baseNames.containsKey(baseName)) {
                baseNames.put(baseName, 0);
            }

            baseNames.put(baseName, baseNames.get(baseName) + 1);
        }

        for (Map.Entry<Integer, List<DataSetParameter>> entry : relations.entrySet()) {

            if (entry.getValue().size() == 1) {
                continue;
            }

            List<DataSetParameter> parameters = entry.getValue();

            String baseName = parameters.get(0).getName();
            String name = "RS_COMMON_" + baseName + baseNames.get(baseName);
            baseNames.put(baseName, baseNames.get(baseName) - 1);

            for (DataSetParameter parameter : parameters) {
                parameter.setHierarchyName(name);
                parameter.setExtend(true);
                LoggerManager.getInstance().info("[PreprocessorParameters] Reuse" + parameter.getJavaTypeName() + " -> " + parameter.getHierarchyFieldName());
            }
        }

        LoggerManager.getInstance().info("[PreprocessorParameters] Reuse" + relations.keySet().size() + " parameteres ");

    }

    private boolean isEquals(DataSetParameter dataSeti, DataSetParameter dataSetj) throws BusinessException {

        List<Parameter> listi = dataSeti.getParameters();
        List<Parameter> listj = dataSetj.getParameters();

        if (listi.size() != listj.size()) {
            return false;
        }

        for (int i = 0; i < listi.size() && i < listj.size(); i++) {
            Parameter parami = listi.get(i);
            Parameter paramj = listj.get(i);

            if (!parami.getName().equals(paramj.getName()) || !parami.getJavaTypeName().equals(paramj.getJavaTypeName())) {
                return false;
            }
        }

        return true;
    }
}
