package dms.yijava.api.web.hospital;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import dms.yijava.entity.hospital.HospitalLevel;
import dms.yijava.service.hospital.HospitalLevelService;

@Controller
@RequestMapping("/api/hospitalLevel")
public class HospitalLevelController {
	

	@Autowired
	private HospitalLevelService hospitalLevelService;
	
	@ResponseBody
	@RequestMapping("list")
	public List<HospitalLevel> list() {
		return hospitalLevelService.getList();
	}
	
}
