package dms.yijava.api.web.area;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import dms.yijava.entity.area.Area;
import dms.yijava.service.area.AreaService;

@Controller
@RequestMapping("/api/area")
public class AreaController {

	@Autowired
	private AreaService areaService;
	
	@ResponseBody
	@RequestMapping("getarea_api")
	public List<Area> getList(@RequestParam(value = "pid", required = false) String pid){
		try {
			if(pid==null || "".equals(pid))
				pid="0";
			return areaService.getList(pid);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
}
