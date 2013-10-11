package dms.yijava.api.web.hospital;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;
import com.yijava.orm.core.PropertyFilters;
import com.yijava.web.vo.Result;

import dms.yijava.entity.flow.FlowRecord;
import dms.yijava.entity.hospital.Hospital;
import dms.yijava.service.hospital.HospitalService;

@Controller
@RequestMapping("/api/hospital")
public class HospitalController {
	

	@Autowired
	private HospitalService hospitalService;
	
	@ResponseBody
	@RequestMapping("list")
	public List<Hospital> list() {
		return hospitalService.getList();
	}
	
	
	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<Hospital> paging(PageRequest pageRequest,HttpServletRequest request,Model model) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		pageRequest.setPageSize(13);
		model.addAttribute("pageSize", pageRequest.getPageSize());
		return hospitalService.paging(pageRequest,filters);
	}
	
	
	@ResponseBody
	@RequestMapping("save")
	public Result<String> save(@ModelAttribute("entity") Hospital entity) {
		try {
			hospitalService.saveEntity(entity);
			return new Result<String>(entity.getId(), 1);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>(entity.getId(), 0);
	}
	
	
	@ResponseBody
	@RequestMapping("update")
	public Result<String> update(@ModelAttribute("entity") Hospital entity) {
		try {
			hospitalService.updateEntity(entity);
			return new Result<String>(entity.getId(), 1);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>(entity.getId(), 0);
	}
	
	
	@ResponseBody
	@RequestMapping("delete")
	public Result<String> delete(@RequestParam(value = "id", required = true) String id) {
		try {
			hospitalService.deleteEntity(id);
			return new Result<String>(id, 1);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>(id, 0);
	}

	@ResponseBody
	@RequestMapping("readByName")
	public Hospital readByName(@RequestParam(value = "name", required = true) String name) {
		return hospitalService.getEntityByName(name);
	}
	
	
	@ResponseBody
	@RequestMapping("getprovince_api")
	public  List<String> getAllProvince() {
		
		try {
			return hospitalService.findAllProvincd();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
	}
}
