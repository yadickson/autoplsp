package com.github.yadickson.autoplsp;

import freemarker.template.DefaultObjectWrapper;

public class TemplateObjectWrapper extends DefaultObjectWrapper {
    TemplateObjectWrapper() {
        super(new TemplateVersion().version());
    }
}
