package dms.yijava.web;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.yijava.common.utils.CaptchaUtils;

import dms.yijava.common.SysConstant;
import dms.yijava.entity.key.LoginKeyGen;
import dms.yijava.service.key.LoginKeyGenService;

@Controller
public class SystemCommonController {

	@Autowired
	private LoginKeyGenService loginKeyGenService;

	@RequestMapping("/index")
	public String index() {
		return "redirect:main.jsp";
	}

	@RequestMapping("/login")
	public String login(HttpServletRequest request,HttpServletResponse response,Model model) {
		LoginKeyGen entity = new LoginKeyGen();

		UUID uuid = UUID.randomUUID();
		String str = uuid.toString();
		// 去掉"-"符号
		String temp = str.substring(0, 8) + str.substring(9, 13)
				+ str.substring(14, 18) + str.substring(19, 23)
				+ str.substring(24);

		entity.setKeygen(temp);
		model.addAttribute("keygen", temp);
		loginKeyGenService.saveEntity(entity);
		return "autologin";
	}

	/**
	 * 生成验证码
	 * 
	 * @return byte[]
	 * @throws IOException
	 */
	@RequestMapping("/getCaptcha")
	public ResponseEntity<byte[]> getCaptcha(HttpSession session)
			throws IOException {

		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.IMAGE_GIF);

		ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
		String captcha = CaptchaUtils.getGifCaptcha(84, 32, 4, outputStream,
				120).toLowerCase();

		session.setAttribute(SysConstant.DEFAULT_CAPTCHA_PARAM, captcha);
		byte[] bs = outputStream.toByteArray();
		outputStream.close();

		return new ResponseEntity<byte[]>(bs, headers, HttpStatus.OK);
	}
}
