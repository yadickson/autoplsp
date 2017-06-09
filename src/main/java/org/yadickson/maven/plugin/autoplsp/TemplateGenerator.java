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
package org.yadickson.maven.plugin.autoplsp;

import org.yadickson.maven.plugin.autoplsp.logger.LoggerManager;
import java.io.File;

import freemarker.template.Configuration;
import freemarker.template.DefaultObjectWrapper;
import freemarker.template.Template;
import freemarker.template.Version;
import java.io.FileWriter;
import java.io.Writer;
import java.util.Map;

/**
 * Clase que permite invocar procedimientos para la generacion de archivos
 *
 * @author Yadickson Soto
 */
public class TemplateGenerator {
    
    private final String outputDir;
    private final Configuration cfg;

    /**
     * Constructor de la clase
     *
     * @param outputDir Directorio de salida de la solucion
     */
    public TemplateGenerator(String outputDir) {
        this.outputDir = outputDir;
        
        Version version = new Version(2, 3, 23);
        cfg = new Configuration(version);
        cfg.setObjectWrapper(new DefaultObjectWrapper(version));
        
        cfg.setClassForTemplateLoading(this.getClass(), "/templates");
        cfg.setDefaultEncoding("UTF-8");
    }
    
    protected void createTemplate(Map<String, Object> input, String templateFileName, String outputFileNamePath) throws Exception {
        
        LoggerManager.getInstance().info("[TemplateGenerator] Create template: from " + templateFileName + " to " + outputFileNamePath);
        
        Template template = getCfg().getTemplate(templateFileName);
        Writer out = new FileWriter(outputFileNamePath);
        template.process(input, out);
        out.flush();
        out.close();
    }
    
    protected String getOutputPath(String path) {
        String result = outputDir + File.separatorChar + path + File.separatorChar;
        new File(result).mkdirs();
        return result;
    }
    
    protected String getFileNamePath(String path, String fileName) {
        return getOutputPath(path) + fileName;
    }

    /**
     * @return the cfg
     */
    public Configuration getCfg() {
        return cfg;
    }
    
}
