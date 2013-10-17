package dms.yijava.api.web.dealer;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
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
import com.yijava.web.vo.ErrorCode;
import com.yijava.web.vo.Result;

import dms.yijava.entity.dealer.DealerAuthHospital;
import dms.yijava.entity.system.SysUser;
import dms.yijava.entity.user.UserDealer;
import dms.yijava.service.dealer.DealerAuthHospitalService;

@Controller
@RequestMapping("/api/dealerAuthHospital")
public class DealerAuthHospitalController {
	

	@Autowired
	private DealerAuthHospitalService dealerAuthHospitalService;
	

	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<DealerAuthHospital> paging(PageRequest pageRequest,HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return dealerAuthHospitalService.paging(pageRequest,filters);
	}
	
	
	/*@ResponseBody
	@RequestMapping("save")
	public Result<String> save(@ModelAttribute("entity") DealerAuthHospital entity) {
		try {
			dealerAuthHospitalService.saveEntity(entity);
			return new Result<String>(entity.getDealer_id(), 1);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>(entity.getDealer_id(), 0);
	}*/
	
	@ResponseBody
	@RequestMapping("save")
	public Result<Integer> save(@RequestParam(value = "ids", required = true) String ids,
			@RequestParam(value = "dealer_id", required = true) String dealer_id,
			@RequestParam(value = "category_id", required = true) String category_id) {
		
		Result<Integer> result=new Result<Integer>(0, 0);
		try {
			if(ids!=null && !ids.equals(""))
			{
				String[] idArray=ids.split(",");
				
				for(String id:idArray)
				{
					DealerAuthHospital entity=new DealerAuthHospital();
					entity.setCategory_id(category_id);
					entity.setDealer_id(dealer_id);
					entity.setHospital_id(id);
					dealerAuthHospitalService.saveEntity(entity);
				}
				result.setData(1);
				result.setState(1);
			}else
			{
				result.setError(new ErrorCode("error,请选择数据"));
			}
			
			
			
		} catch (Exception e) {
			result.setError(new ErrorCode("error,请检查您的数据"));
		}
		return result;
	}
	
	@ResponseBody
	@RequestMapping("savebyhospital")
	public Result<Integer> savebyhospital(@RequestParam(value = "ids", required = true) String ids,
			@RequestParam(value = "dealer_id", required = true) String dealer_id,
			@RequestParam(value = "category_id", required = true) String category_id) {
		Result<Integer> result=new Result<Integer>(0, 0);
		
		return result;
	}
	
	
	@ResponseBody
	@RequestMapping("update")
	public Result<String> update(@ModelAttribute("entity") DealerAuthHospital entity) {
		try {
			dealerAuthHospitalService.updateEntity(entity);
			return new Result<String>(entity.getDealer_id(), 1);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>(entity.getDealer_id(), 0);
	}
	
	
	@ResponseBody
	@RequestMapping("delete")
	public Result<Integer> delete(@RequestParam(value = "ids", required = true) String ids) {
		Result<Integer> result=new Result<Integer>(0, 0);
		try {
			dealerAuthHospitalService.deleteEntityByIds(ids);
			result.setData(1);
			result.setState(1);
			return result;
		} catch (Exception e) {
			e.printStackTrace();
			result.setError(new ErrorCode(e.toString()));
		}
		return result;
	}
	
	@ResponseBody
	@RequestMapping("deleteAll")
	public Result<String> deleteAll(@ModelAttribute("entity") DealerAuthHospital entity) {
		try {
			dealerAuthHospitalService.deleteAllEntity(entity);
			return new Result<String>("1", 1);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>("1", 0);
	}
	
	@ResponseBody
	@RequestMapping("api_list")
	public List<DealerAuthHospital> getList(HttpServletRequest request){
		SysUser sysUser = (SysUser) request.getSession().getAttribute("user");
		List<PropertyFilter> filters = PropertyFilters.build(request);
		boolean isDealerId=false;
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			if(propertyKey.equals("dealer_id") || 
					propertyKey.equals("dealer_ids")){
				isDealerId=true;
			}
		}
		if (null != sysUser && !isDealerId) {
			//经销商
			if (!StringUtils.equals("0", sysUser.getFk_dealer_id())) {
				filters.add(PropertyFilters.build("ANDS_dealer_id",sysUser.getFk_dealer_id()));
			}else if(StringUtils.isNotEmpty(sysUser.getTeams())){
				filters.add(PropertyFilters.build("ANDS_dealer_ids", this.listString(sysUser.getUserDealerList())));
			}
		}
		return dealerAuthHospitalService.getList(filters);
	}
	
	/**
	 * 把一个list转换为String返回过去
	 */
	public String listString(List<UserDealer> list) {
		String listString = "";
		for (int i = 0; i < list.size(); i++) {
			try {
				if (i == list.size() - 1) {
					UserDealer ud = list.get(i);
					listString += ud.getDealer_id();
				} else {
					UserDealer ud = list.get(i);
					listString += ud.getDealer_id() + ",";
				}
			} catch (Exception e) {
			}
		}
		return listString;
	}
}
