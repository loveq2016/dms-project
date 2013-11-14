package dms.yijava.api.web.share;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;
import com.yijava.orm.core.PropertyFilters;
import com.yijava.web.vo.ErrorCode;
import com.yijava.web.vo.Result;

import dms.yijava.entity.share.ShareFile;
import dms.yijava.service.share.ShareFileService;

@Controller
@RequestMapping("/api/sharefile")
public class ShareFileController {

	private static final Logger logger = LoggerFactory.getLogger(ShareFileController.class);
	
	
	@Autowired
	private ShareFileService shareFileService;

	@Value("#{properties['sharefilepath']}")   	
	private String sharefilepath;
	
	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<ShareFile> paging(PageRequest pageRequest,HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return shareFileService.paging(pageRequest,filters);
	}
	
	@ResponseBody
	@RequestMapping("save")
	public Result<Integer> save(@ModelAttribute("entity") ShareFile entity,@RequestParam("file") MultipartFile file,HttpServletRequest request) {
		Result<Integer> result=new Result<Integer>(0, 0);
		
		if (!file.isEmpty()) {  		
			String realFileName = createtFileName()+ "."+ getExtensionName(file.getOriginalFilename());	
			String realFilePath = realFileName.substring(0, 10)+ "/";
			processUpload(file,realFileName);			
			DecimalFormat df = new DecimalFormat( "0.## "); 
			Float si=file.getSize()/1024f/1024f;			
			entity.setFilesize(df.format(si));
			entity.setFilepath(realFilePath + realFileName);				
			try {			
				shareFileService.saveEntity(entity);
				result.setState(1);
				result.setData(1);
			} catch (Exception e) {
				logger.error("save share file error:"+e.toString());
			}
			
		}else
		{
			result.setError(new ErrorCode("请选择文件"));
		}
		
		return result;
	}
	
	
	@ResponseBody
	@RequestMapping("update")
	public Result<Integer> update(@ModelAttribute("entity") ShareFile entity,@RequestParam("file") MultipartFile file,HttpServletRequest request) {
		Result<Integer> result=new Result<Integer>(0, 0);
		
		if (!file.isEmpty()) {  		
			String realFileName = createtFileName()+ "."+ getExtensionName(file.getOriginalFilename());	
			String realFilePath = realFileName.substring(0, 10)+ "/";
			processUpload(file,realFileName);			
			DecimalFormat df = new DecimalFormat( "0.## "); 
			Float si=file.getSize()/1024f/1024f;			
			entity.setFilesize(df.format(si));
			entity.setFilepath(realFilePath + realFileName);	
		}
		
		try {			
			shareFileService.updateEntity(entity);
			result.setState(1);
			result.setData(1);
		} catch (Exception e) {
			logger.error("update share file error:"+e.toString());
		}
		return result;
	}
	
	@ResponseBody
	@RequestMapping("remove")
	public Result<Integer> remove(@RequestParam(value = "entity_id", required = false)  String entity_id) {
		Result<Integer> result=new Result<Integer>(0, 0);
		try {			
			shareFileService.removeEntity(entity_id);
			result.setState(1);
			result.setData(1);
		} catch (Exception e) {
			logger.error("remove share file error:"+e.toString());
		}
		return result;	
	}
	
	private boolean processUpload(MultipartFile file, String realFileName) {
		String ctxPath = sharefilepath;
		String subPath = File.separatorChar + realFileName.substring(0, 10);

		
		ctxPath += subPath;

		File dirPath = new File(ctxPath);
		if (!dirPath.exists()) {
			// dirPath.mkdir();
			dirPath.mkdirs();
		}
		try {
			copyFile(file.getInputStream(), ctxPath + File.separatorChar+ realFileName);
		} catch (IOException e) {
			return false;
		}
		return true;

	}

	private void copyFile(InputStream in, String fileName) throws IOException {
		FileOutputStream fs = new FileOutputStream(fileName);
		byte[] buffer = new byte[1024 * 1024];
		int bytesum = 0;
		int byteread = 0;
		while ((byteread = in.read(buffer)) != -1) {
			bytesum += byteread;
			fs.write(buffer, 0, byteread);
			fs.flush();
		}
		fs.close();
		in.close();
	}
	
	public String getExtensionName(String filename) {
		if ((filename != null) && (filename.length() > 0)) {
			int dot = filename.lastIndexOf('.');
			if ((dot > -1) && (dot < (filename.length() - 1))) {
				return filename.substring(dot + 1);
			}
		}
		return filename;
	}
	
	public synchronized String createtFileName() {
		java.util.Date dt = new java.util.Date(System.currentTimeMillis());
		SimpleDateFormat fmt = new SimpleDateFormat("yyyyMMddHHmmssSSS");
		String fileName = fmt.format(dt);
		return fileName;
	}
}
