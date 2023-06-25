package com.github.yadickson.autoplsp;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

import edu.emory.mathcs.backport.java.util.Arrays;
import freemarker.template.SimpleSequence;
import freemarker.template.TemplateMethodModelEx;
import freemarker.template.TemplateModel;
import freemarker.template.TemplateModelException;
import freemarker.template.TemplateSequenceModel;

public class ImportSort implements TemplateMethodModelEx {
    @Override
    public TemplateModel exec(List list) throws TemplateModelException {
        TemplateSequenceModel sequence = (TemplateSequenceModel)list.get(0);
        Set<String> set = new TreeSet<>();

        for (int i = 0; i < sequence.size();i++ ) {
            TemplateModel value = sequence.get(i);
            set.add(value.toString());
        }

        List<String> toSort = new ArrayList<>(set);

        Collections.sort(toSort);

        return new SimpleSequence(toSort, new TemplateObjectWrapper());
    }
}
