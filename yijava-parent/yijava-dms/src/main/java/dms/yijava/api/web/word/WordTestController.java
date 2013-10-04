package dms.yijava.api.web.word;

import java.io.BufferedOutputStream;
import java.io.IOException;
import java.io.OutputStream;

import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import dms.yijava.api.web.word.util.TheFreemarker;

@Controller
@RequestMapping("/api/word")
public class WordTestController {

	@RequestMapping("down")
	public void down(final HttpServletResponse response) throws IOException {
		
		String fileName = String.valueOf(System.currentTimeMillis())+".doc";
		response.reset();  
	    response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");  
	   // response.addHeader("Content-Length", "" + wordByte.length);  
	    response.setContentType("application/octet-stream;charset=UTF-8");  
		
		OutputStream outputStream = response.getOutputStream();
		TheFreemarker freemarker = new TheFreemarker();
		freemarker.createWord(outputStream);
		//byte[] wordByte = out.toString().getBytes();
	    OutputStream down = new BufferedOutputStream(outputStream);  
	    // down.write(wordByte);  
	    down.flush();  
	    down.close();  
		
		
	}

}
