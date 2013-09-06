package dms.yijava.api.web.flow;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import dms.yijava.service.flow.ActionService;

@Controller
@RequestMapping("/api/action")
public class ActionController {

	@Autowired
	private ActionService actionService;
}
