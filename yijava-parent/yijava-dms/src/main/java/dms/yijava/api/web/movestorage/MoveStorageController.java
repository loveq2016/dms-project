package dms.yijava.api.web.movestorage;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;
import com.yijava.orm.core.PropertyFilters;
import com.yijava.web.vo.ErrorCode;
import com.yijava.web.vo.Result;

import dms.yijava.api.web.pullstorage.SalesStorageController;
import dms.yijava.entity.movestorage.MoveStorage;
import dms.yijava.entity.movestorage.MoveStorageDetail;
import dms.yijava.entity.movestorage.MoveStorageProDetail;
import dms.yijava.entity.pullstorage.PullStorage;
import dms.yijava.entity.pullstorage.PullStorageDetail;
import dms.yijava.entity.pullstorage.PullStorageProDetail;
import dms.yijava.entity.storage.StorageDetail;
import dms.yijava.entity.storage.StorageProDetail;
import dms.yijava.entity.system.SysUser;
import dms.yijava.entity.user.UserDealer;
import dms.yijava.service.movestorage.MoveStorageDetailService;
import dms.yijava.service.movestorage.MoveStorageProDetailService;
import dms.yijava.service.movestorage.MoveStorageService;
import dms.yijava.service.storage.StorageDetailService;
import dms.yijava.service.storage.StorageDetailService.PullStorageOpt;
@Controller
@RequestMapping("/api/movestorage")
public class MoveStorageController {
	private static final Logger logger = LoggerFactory.getLogger(MoveStorageController.class);
	@Autowired
	private MoveStorageService moveStorageService;
	@Autowired
	private MoveStorageDetailService moveStorageDetailService;
	@Autowired
	private MoveStorageProDetailService moveStorageProDetailService;
	@Autowired
	private StorageDetailService storageDetailService;
	
	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<MoveStorage> paging(PageRequest pageRequest,HttpServletRequest request) {
		SysUser sysUser=(SysUser)request.getSession().getAttribute("user");
		List<PropertyFilter> filters = PropertyFilters.build(request);
		if(null!=sysUser){
			//经销商
			if(!StringUtils.equals("0",sysUser.getFk_dealer_id())){
				filters.add(PropertyFilters.build("ANDS_fk_move_storage_party_id",sysUser.getFk_dealer_id()));
			}else if(StringUtils.isNotEmpty(sysUser.getTeams())){
				filters.add(PropertyFilters.build("ANDS_fk_move_storage_party_ids", this.listString(sysUser.getUserDealerList())));
			}
			return moveStorageService.paging(pageRequest,filters);
		}
		return null;
	}
	
	@ResponseBody
	@RequestMapping("list")
	public List<MoveStorage> getList(HttpServletRequest request){
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return moveStorageService.getList(filters);
	}
	
	@ResponseBody
	@RequestMapping("save")
	public Result<Integer> save(@ModelAttribute("entity") MoveStorage entity,HttpServletRequest request) {
		SysUser sysUser=(SysUser)request.getSession().getAttribute("user");
		SimpleDateFormat formatter = new SimpleDateFormat("yyMMdd");
		//必须是经销商才可以添加移库单
		if(!StringUtils.equals("0",sysUser.getFk_dealer_id())){
			MoveStorage moveObj=moveStorageService.getMoveStorageCode(sysUser.getFk_dealer_id());
			//移库货单
			entity.setMove_storage_code(sysUser.getDealer_code()+"RN"+formatter.format(new Date())+moveObj.getMove_storage_no());
			entity.setMove_storage_no(String.valueOf((Integer.parseInt(moveObj.getMove_storage_no()))));
			entity.setFk_move_storage_party_id(sysUser.getFk_dealer_id());
			moveStorageService.saveEntity(entity);
			return new Result<Integer>(1, 1);
		}else{
			return new Result<Integer>(1, 0);
		}
	}
	
	/**
	 * 提交单据，处理库存，(无流程)
	 * @param entity
	 * @param request
	 * @return
	 */
	@ResponseBody
	@RequestMapping("submitMoveStorage")
	public Result<Integer> submitPullStorage(@ModelAttribute("entity") MoveStorage entity,HttpServletRequest request) {
		Result<Integer> result=new Result<Integer>(0, 0);
		try{
			//移除
			List<Object> list = moveStorageService.processMoveStorage(entity.getId());//获取产品明细，SN明显
			if(((List<StorageDetail>)list.get(0)).size()>0 &&
					((List<StorageProDetail>)list.get(1)).size()>0){
				PullStorageOpt pullStorageOpt = storageDetailService.updateStorageLockSn((List<StorageDetail>)list.get(0),(List<StorageProDetail>)list.get(1));//锁定库存
				if(pullStorageOpt!=null && "success".equals(pullStorageOpt.getStatus()) 
						&& pullStorageOpt.getList().size() > 0){
						//移入
						boolean s =moveStorageService.processMoveToStorage(entity.getId());
						if(s){
							/**
							 * 处理订单状态
							 */
							SimpleDateFormat time=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
							entity.setStatus("1");
							entity.setMove_storage_date(time.format(new Date()));
							moveStorageService.updateEntity(entity);
							result.setData(1);
							result.setState(1);
						}
				}else{
					result.setState(4);
					result.setError(new ErrorCode("出现库存错误，库存不足!"));
				}
			}else{
				if(((List<StorageProDetail>)list.get(1)).size()<=0){
					result.setState(2);
				}
				if(((List<StorageDetail>)list.get(0)).size()<=0){
					result.setState(3);
				}
			}
		} catch (Exception e) {
			logger.error("error" + e);
		}
		return result;
	}

	@ResponseBody
	@RequestMapping("remove")
	public Result<Integer> remove(HttpServletRequest request,@ModelAttribute("entity") MoveStorage entity) {
		moveStorageService.removeByMoveStorageCode(entity.getMove_storage_code());
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
