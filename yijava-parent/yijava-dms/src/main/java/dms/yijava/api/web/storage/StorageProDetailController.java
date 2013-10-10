package dms.yijava.api.web.storage;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;
import com.yijava.orm.core.PropertyFilters;

import dms.yijava.entity.storage.StorageProDetail;
import dms.yijava.entity.system.SysUser;
import dms.yijava.entity.user.UserDealer;
import dms.yijava.service.storage.StorageProDetailService;

@Controller
@RequestMapping("/api/storageProDetail")
public class StorageProDetailController {

	@Autowired
	private StorageProDetailService storageProDetailService;

	public List<StorageProDetail> getList(HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		//HashMap<String,String> parameters = new HashMap<String,String>();
		return storageProDetailService.getList(filters);
	}
	
	
	
	@ResponseBody
	@RequestMapping("api_paging")
	public JsonPage<StorageProDetail> api_paging(PageRequest pageRequest,
			HttpServletRequest request) {
		SysUser sysUser = (SysUser) request.getSession().getAttribute("user");
		List<PropertyFilter> filters = PropertyFilters.build(request);
		if(filters.size()<=0)
			if (null != sysUser) {
				//经销商
				if (!StringUtils.equals("0", sysUser.getFk_dealer_id())) {
					filters.add(PropertyFilters.build("ANDS_dealer_id",sysUser.getFk_dealer_id()));
				}else if(StringUtils.isNotEmpty(sysUser.getTeams())){
					filters.add(PropertyFilters.build("ANDS_dealer_ids", this.listString(sysUser.getUserDealerList())));
				}
			}
		return storageProDetailService.paging(pageRequest, filters);
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
