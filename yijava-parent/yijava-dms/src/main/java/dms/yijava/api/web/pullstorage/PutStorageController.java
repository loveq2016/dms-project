package dms.yijava.api.web.pullstorage;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;
import com.yijava.orm.core.PropertyFilters;
import com.yijava.web.vo.Result;

import dms.yijava.entity.pullstorage.PullStorage;
import dms.yijava.entity.pullstorage.PullStorageDetail;
import dms.yijava.entity.pullstorage.PullStorageProDetail;
import dms.yijava.entity.storage.StorageDetail;
import dms.yijava.entity.storage.StorageProDetail;
import dms.yijava.entity.system.SysUser;
import dms.yijava.entity.user.UserDealer;
import dms.yijava.service.flow.FlowRecordService;
import dms.yijava.service.pullstorage.PullStorageDetailService;
import dms.yijava.service.pullstorage.PullStorageProDetailService;
import dms.yijava.service.pullstorage.PullStorageService;
import dms.yijava.service.storage.StorageDetailService;
import dms.yijava.service.storage.StorageDetailService.PullStorageOpt;
@Controller
@RequestMapping("/api/putstorage")
public class PutStorageController {
	//借贷提醒
	@Value("#{properties['loansproduct_identifier_num']}")   	
	private String loansproduct_identifier_num;
	//分销提醒
	@Value("#{properties['salesproduct_identifier_num']}")   	
	private String salesproduct_identifier_num;
	@Autowired
	private PullStorageService pullStorageService;
	@Autowired
	private PullStorageDetailService pullStorageDetailService;
	@Autowired
	private PullStorageProDetailService pullStorageProDetailService;
	@Autowired
	private StorageDetailService storageDetailService;
	@Autowired
	private FlowRecordService flowRecordService;
	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<PullStorage> paging(PageRequest pageRequest,HttpServletRequest request) {
		SysUser sysUser=(SysUser)request.getSession().getAttribute("user");
		List<PropertyFilter> filters = PropertyFilters.build(request);
		if(null!=sysUser){
			//经销商
			if(!StringUtils.equals("0",sysUser.getFk_dealer_id())){
				filters.add(PropertyFilters.build("ANDS_fk_put_storage_party_id",sysUser.getFk_dealer_id()));
			}else if(StringUtils.isNotEmpty(sysUser.getTeams())){
				filters.add(PropertyFilters.build("ANDS_fk_put_storage_party_ids", this.listString(sysUser.getUserDealerList())));
			}
			filters.add(PropertyFilters.build("ANDS_statuses","3,4"));
			return pullStorageService.paging(pageRequest,filters);
		}
		return null;
	}
		
	@ResponseBody
	@RequestMapping("submit")
	public Result<Integer> submitPutStorage(@ModelAttribute("entity") PullStorage entity,HttpServletRequest request) {
		SysUser sysUser=(SysUser)request.getSession().getAttribute("user");
		boolean s =pullStorageService.processPutStorage(entity.getId());
		if(s){
			/**
			 * 处理订单状态
			 */
			SimpleDateFormat time=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
			entity.setStatus("4");//成功
			entity.setPut_storage_date(time.format(new Date()));
			pullStorageService.updateEntity(entity);
			
			//关闭提醒
			String identifier_num;
			if(entity.getType().equals("1"))
				identifier_num=salesproduct_identifier_num;
			else
				identifier_num=loansproduct_identifier_num;
			flowRecordService.updateFlowByFlowUB(identifier_num,sysUser.getId(), entity.getId(), "", "1");
			return new Result<Integer>(1, 1);
		}
		return new Result<Integer>(1, 2);		
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
