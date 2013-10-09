package dms.yijava.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class ViewWordController {

	@RequestMapping("/word/view")
	public String main(String fileName,HttpServletResponse response,HttpServletRequest request,Model model)
	{
		model.addAttribute("filename", fileName);
		
		
		return "showword";
	}
	
}
