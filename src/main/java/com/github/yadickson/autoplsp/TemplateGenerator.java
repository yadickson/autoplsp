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
package com.github.yadickson.autoplsp;

import com.github.yadickson.autoplsp.handler.BusinessException;
import com.github.yadickson.autoplsp.logger.LoggerManager;
import java.io.File;

import freemarker.template.Configuration;
import freemarker.template.DefaultObjectWrapper;
import freemarker.template.Template;
import freemarker.template.Version;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.nio.charset.Charset;
import java.util.Map;

/**
 * Template freemarker class manager
 *
 * @author Yadickson Soto
 */
public class TemplateGenerator {

    private final String outputDir;
    private final Configuration cfg;

    /**
     * Class constructor
     *
     * @param outputDir Output directory path result
     */
    public TemplateGenerator(String outputDir) {
        this.outputDir = outputDir;

        Version version = new Version(2, 3, 23);
        cfg = new Configuration(version);
        cfg.setObjectWrapper(new DefaultObjectWrapper(version));

        cfg.setClassForTemplateLoading(this.getClass(), "/templates");
        cfg.setDefaultEncoding("UTF-8");
    }

    /**
     * Create template
     *
     * @param input Mapper information
     * @param templateFileName template freemarker file name
     * @param outputFileNamePath output filename
     * @throws BusinessException If error
     */
    protected void createTemplate(Map<String, Object> input, String templateFileName, String outputFileNamePath) throws BusinessException {

        LoggerManager.getInstance().info("[TemplateGenerator] Create template: from " + templateFileName + " to " + outputFileNamePath);

        try {
            Template template = getCfg().getTemplate(templateFileName);
            File file = new File(outputFileNamePath);
            Writer out = new OutputStreamWriter(new FileOutputStream(file), Charset.forName("UTF-8"));
            template.process(input, out);
            out.flush();
            out.close();
        } catch (RuntimeException ex) {
            throw new BusinessException("", ex);
        } catch (Exception ex) {
            throw new BusinessException("", ex);
        }
    }

    /**
     * Get output directory path and make directory if not exist
     *
     * @param path path
     * @return full directory path
     * @exception BusinessException if error
     */
    protected String getOutputPath(String path) throws BusinessException {
        String result = outputDir + File.separatorChar + path + File.separatorChar;
        File file = new File(result);

        if (!file.exists() && !file.mkdirs()) {
            throw new BusinessException("Not was possible made the directory " + result);
        }

        return result;
    }

    /**
     * Get full filename path
     *
     * @param path directory path
     * @param fileName filename
     * @return full filename path
     * @exception BusinessException if error
     */
    protected String getFileNamePath(String path, String fileName) throws BusinessException {
        return getOutputPath(path) + fileName;
    }

    /**
     * @return the freemarker configuration
     */
    public Configuration getCfg() {
        return cfg;
    }

}
