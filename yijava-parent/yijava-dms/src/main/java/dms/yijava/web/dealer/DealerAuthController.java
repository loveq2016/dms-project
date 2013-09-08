package dms.yijava.web.dealer;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/web/dealer")
public class DealerAuthController {

	@RequestMapping("authView")
	public String view(String dealer, HttpServletRequest request,
			HttpServletResponse response, Model model) {
		model.addAttribute("dealer", dealer);
		return "dealer/auth/viewdetail";
	}
}
