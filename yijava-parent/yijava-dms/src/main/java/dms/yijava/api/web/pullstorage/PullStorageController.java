package dms.yijava.api.web.pullstorage;

import java.text.SimpleDateFormat;
import java.util.Date;
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
import com.yijava.web.vo.Result;

import dms.yijava.entity.order.Order;
import dms.yijava.entity.pullstorage.PullStorage;
import dms.yijava.entity.system.SysUser;
import dms.yijava.entity.user.UserDealer;
import dms.yijava.service.pullstorage.PullStorageService;
@Controller
@RequestMapping("/api/pullstorage")
public class PullStorageController {

	@Autowired
	private PullStorageService pullStorageService;
	
	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<PullStorage> paging(PageRequest pageRequest,HttpServletRequest request) {
		SysUser sysUser=(SysUser)request.getSession().getAttribute("user");
		List<PropertyFilter> filters = PropertyFilters.build(request);
		if(null!=sysUser){
			//经销商
			if(!StringUtils.equals("0",sysUser.getFk_dealer_id())){
				filters.add(PropertyFilters.build("ANDS_fk_pull_storage_party_id",sysUser.getFk_dealer_id()));
			}else if(!StringUtils.equals("0",sysUser.getFk_department_id())){
				filters.add(PropertyFilters.build("ANDS_fk_pull_storage_party_ids", this.listString(sysUser.getUserDealerList())));
			}
			return pullStorageService.paging(pageRequest,filters);
		}
		return null;
	}
	
	@ResponseBody
	@RequestMapping("list")
	public List<PullStorage> getList(HttpServletRequest request){
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return pullStorageService.getList(filters);
	}
	
	@ResponseBody
	@RequestMapping("save")
	public Result<Integer> save(@ModelAttribute("entity") PullStorage entity,HttpServletRequest request) {
		SysUser sysUser=(SysUser)request.getSession().getAttribute("user");
		SimpleDateFormat formatter = new SimpleDateFormat("yyMMdd");
		//必须是经销商才可以添加出货单
		if(StringUtils.isNotEmpty(sysUser.getFk_dealer_id())){
			PullStorage pullObj=pullStorageService.getPullStorageCode(sysUser.getFk_dealer_id());
			PullStorage putObj=pullStorageService.getPutStorageCode(entity.getFk_put_storage_party_id());
			//出货单
			entity.setPull_storage_code(sysUser.getDeliver_code()+"RN"+formatter.format(new Date())+pullObj.getPull_storage_no());
			entity.setPull_storage_no(String.valueOf((Integer.parseInt(pullObj.getPull_storage_no()))));
			entity.setFk_pull_storage_party_id(sysUser.getFk_dealer_id());
			//收货单
			entity.setPut_storage_code(entity.getPull_storage_party_code()+"PR"+formatter.format(new Date())+putObj.getPut_storage_no());
			entity.setPut_storage_no(String.valueOf((Integer.parseInt(putObj.getPull_storage_no()))));
			pullStorageService.saveEntity(entity);
			return new Result<Integer>(1, 1);
		}else{
			return new Result<Integer>(1, 0);
		}
	}
	@ResponseBody
	@RequestMapping("update")
	public Result<Integer> updateStatus(@ModelAttribute("entity") PullStorage entity) {
		pullStorageService.updateEntity(entity);
		return new Result<Integer>(1, 1);
	}
	
	@ResponseBody
	@RequestMapping("remove")
	public Result<Integer> remove(@RequestParam(value = "id", required = false) String id) {
		pullStorageService.removeEntity(id);
		return new Result<Integer>(1, 1);
	}

	/**
	 * 把一个list转换为String返回过去
	 */
	public String listString(List<UserDealer> list) {
		String listString = "";
		for (int i = 0; i < list.size(); i++) {
			try {
				if (i == list.size() - 1) {
					UserDealer ud=list.get(i);
					listString += ud.getDealer_id();
				} else {
					UserDealer ud=list.get(i);
					listString += ud.getDealer_id() + ",";
				}
			} catch (Exception e) {
			}
		}
		return listString;
	}
}
