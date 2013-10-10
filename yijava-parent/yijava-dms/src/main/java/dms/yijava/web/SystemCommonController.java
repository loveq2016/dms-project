package dms.yijava.web;


import java.io.ByteArrayOutputStream;
import java.io.IOException;

import javax.servlet.http.HttpSession;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.yijava.common.utils.CaptchaUtils;

import dms.yijava.common.SysConstant;



@Controller
public class SystemCommonController {

	/**
	 * 生成验证码
	 * 
	 * @return byte[]
	 * @throws IOException 
	 */
	@RequestMapping("/getCaptcha")
	public ResponseEntity<byte[]> getCaptcha(HttpSession session) throws IOException {
		
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.IMAGE_GIF);
		
		ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
		String captcha = CaptchaUtils.getGifCaptcha(70, 28, 4, outputStream,120).toLowerCase();
		
		session.setAttribute(SysConstant.DEFAULT_CAPTCHA_PARAM,captcha);
		byte[] bs = outputStream.toByteArray();
		outputStream.close();
		
		return new ResponseEntity<byte[]>(bs,headers, HttpStatus.OK);
	}
}
