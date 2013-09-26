package dms.yijava.api.web.deliver;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;
import com.yijava.orm.core.PropertyFilters;
import com.yijava.web.vo.Result;

import dms.yijava.entity.deliver.DeliverExpressDetail;
import dms.yijava.service.deliver.DeliverExpressDetailService;

@Controller
@RequestMapping("/api/deliverExpress")
public class DeliverExpressController {
	
	@Autowired
	private DeliverExpressDetailService deliverExpressDetailService;
	
	
	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<DeliverExpressDetail> paging(PageRequest pageRequest,HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return deliverExpressDetailService.paging(pageRequest,filters);
	}
	
	
	@ResponseBody
	@RequestMapping("save")
	public Result<String> save(@ModelAttribute("entity") DeliverExpressDetail entity) {
		entity.setUser_id("13");
		try {
			DeliverExpressDetail tempDeliverExpressDetail =  deliverExpressDetailService.selectSumById(entity.getDelivery_detail_id());
			if(tempDeliverExpressDetail ==null){//产品空
				if(Integer.parseInt(entity.getExprees_num()) <=  Integer.parseInt(entity.getDeliver_number_sum())){
					deliverExpressDetailService.saveEntity(entity);
					return new Result<String>(entity.getId(), 1);
				}else{
					return new Result<String>(entity.getId(), 2);
				}
			}else{
				int count = Integer.parseInt(tempDeliverExpressDetail.getExprees_num()) + Integer.parseInt(entity.getExprees_num());
				if(count <=  Integer.parseInt(entity.getDeliver_number_sum())){
					DeliverExpressDetail existsDeliverExpressDetail = deliverExpressDetailService.selectSn(entity);
					if (existsDeliverExpressDetail == null) {
						deliverExpressDetailService.saveEntity(entity);
					}else{
						entity.setId(existsDeliverExpressDetail.getId());
						deliverExpressDetailService.updateEntity(entity);
					}
					return new Result<String>(entity.getId(), 1);
				}else{
					return new Result<String>(entity.getId(), 2);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>(entity.getId(),0);
	}

	
	@ResponseBody
	@RequestMapping("delete")
	public Result<String> delete(@RequestParam(value = "id", required = true) String id) {
		try {
			deliverExpressDetailService.deleteEntity(id);
			return new Result<String>(id, 1);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>(id, 0);
	}
	
}
