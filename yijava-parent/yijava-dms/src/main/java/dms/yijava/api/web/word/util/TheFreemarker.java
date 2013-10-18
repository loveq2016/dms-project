package dms.yijava.api.web.word.util;

import java.io.BufferedWriter;
import java.io.File;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import freemarker.template.Configuration;
import freemarker.template.Template;

public class TheFreemarker {

	private Configuration configuration = null;

	public TheFreemarker() {
		try {
			configuration = new Configuration();
			configuration.setDefaultEncoding("UTF-8");
			//configuration.setDirectoryForTemplateLoading(new File(classPath));
			//configuration.setObjectWrapper(new DefaultObjectWrapper());
		} catch (Exception e) {
		}

	}
	
	public Writer createTrialWord(OutputStream outputStream,Map<String ,Object> dataMap) {
		try {
			String classPath = new File(getClass().getResource("/").getFile()).getCanonicalPath();
			classPath += File.separator + "word" + File.separator + "ftl";
			configuration.setClassForTemplateLoading(this.getClass(), File.separator + "word" + File.separator + "ftl");
			// 获取模板
			Template temp = configuration.getTemplate("trialtemplete.ftl");
			temp.setEncoding("utf-8");			
			Writer out = null;
			out = new BufferedWriter(new OutputStreamWriter(outputStream,"UTF-8"));
			temp.process(dataMap, out);
			
			return out ;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	
	public Writer createDeliverWord(OutputStream outputStream,Map<String ,Object> dataMap) {
		try {
			String classPath = new File(getClass().getResource("/").getFile()).getCanonicalPath();
			classPath += File.separator + "word" + File.separator + "ftl";
			configuration.setClassForTemplateLoading(this.getClass(), File.separator + "word" + File.separator + "ftl");
			// 获取模板
			Template temp = configuration.getTemplate("deliver.ftl");
			temp.setEncoding("utf-8");			
			Writer out = null;
			out = new BufferedWriter(new OutputStreamWriter(outputStream,"UTF-8"));
			temp.process(dataMap, out);
			out.close();
			return null ;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public Writer createOrderWord(OutputStream outputStream,Map<String ,Object> dataMap) {
		try {
			String classPath = new File(getClass().getResource("/").getFile()).getCanonicalPath();
			classPath += File.separator + "word" + File.separator + "ftl";
			configuration.setClassForTemplateLoading(this.getClass(), File.separator + "word" + File.separator + "ftl");
			// 获取模板
			Template temp = configuration.getTemplate("ordertemplete.ftl");
			temp.setEncoding("utf-8");			
			Writer out = null;
			out = new BufferedWriter(new OutputStreamWriter(outputStream,"UTF-8"));
			temp.process(dataMap, out);
			
			return out ;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public Writer createWord(OutputStream outputStream) {
		try {
			String classPath = new File(getClass().getResource("/").getFile()).getCanonicalPath();
			classPath += File.separator + "word" + File.separator + "ftl";
			configuration.setClassForTemplateLoading(this.getClass(), File.separator + "word" + File.separator + "ftl");
			// 获取模板
			Template temp = configuration.getTemplate("demo.ftl");
			temp.setEncoding("utf-8");
			Map<String,Object> dataMap = new HashMap<String, Object>();
			List list = new ArrayList();
			for (int j = 1; j < 15; j++) {
				TableObj t = new TableObj();
				t.setId(String.valueOf(j));
				t.setMarks("测试啊" + j);
				list.add(t);
			}
			dataMap.put("table", list);
			
			Writer out = null;
			out = new BufferedWriter(new OutputStreamWriter(outputStream,"UTF-8"));
			temp.process(dataMap, out);
			//out.write(cbuf, off, len);
			return out ;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	
	
	
	
	
	
	

}
