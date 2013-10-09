package dms.yijava.api.web.movestorage;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;
import com.yijava.orm.core.PropertyFilters;
import com.yijava.web.vo.Result;

import dms.yijava.entity.movestorage.MoveStorage;
import dms.yijava.entity.movestorage.MoveStorageDetail;
import dms.yijava.entity.movestorage.MoveStorageProDetail;
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
		
	@ResponseBody
	@RequestMapping("submit")
	public Result<Integer> submitMoveStorage(@ModelAttribute("entity") MoveStorage entity,HttpServletRequest request) {
		SysUser sysUser=(SysUser)request.getSession().getAttribute("user");
		/**
		 * 添加产品SN明细
		 */
		List<PropertyFilter> filters = PropertyFilters.build(request);
		List<MoveStorageDetail> listMoveStorageDetail = moveStorageDetailService.getList(filters);
		if(null!=listMoveStorageDetail){
			List<StorageDetail> storageDetailList  = new ArrayList<StorageDetail>();
			for(int i=0;i<listMoveStorageDetail.size();i++){
				MoveStorageDetail psd=listMoveStorageDetail.get(i);
				StorageDetail sd = new StorageDetail();
				sd.setFk_dealer_id(sysUser.getFk_dealer_id());
				sd.setFk_storage_id(psd.getFk_move_storage_id());
				sd.setProduct_item_number(psd.getProduct_item_number());
				sd.setBatch_no(psd.getBatch_no());
				sd.setInventory_number("-"+psd.getMove_number());
				storageDetailList.add(sd);
			}
			PullStorageOpt moveStorageOpt=storageDetailService.updateStorageLockSn(storageDetailList,null); //获取sn（根据 批次，仓库，数量），更新仓库
			List<MoveStorageProDetail> listMoveStorageProDetail=new ArrayList<MoveStorageProDetail>();
			if(moveStorageOpt.getStatus().equals("success")){
				for(int i=0;i<moveStorageOpt.getList().size();i++){
					MoveStorageProDetail pspd=new MoveStorageProDetail();
					StorageProDetail spd=moveStorageOpt.getList().get(i);
					
					for(int j=0;j<listMoveStorageDetail.size();j++){
						MoveStorageDetail psd=listMoveStorageDetail.get(j);
						if(psd.getFk_move_storage_id().equals(spd.getFk_storage_id())&&
								psd.getBatch_no().equals(spd.getBatch_no())){
							///问题
						}
					}
					pspd.setBatch_no(spd.getBatch_no());
					pspd.setFk_move_storage_id(spd.getFk_storage_id());
					pspd.setProduct_sn(spd.getProduct_sn());
					pspd.setMove_storage_code(entity.getMove_storage_code());
					listMoveStorageProDetail.add(pspd);
				}
				//同一个仓库下的，同一个批次，同一个序号   不能重复添加
				moveStorageProDetailService.saveEntity(listMoveStorageProDetail);
			}
		}
		
//			/**
//			 * 出库明细
//			 */
//			List<PropertyFilter> filters = PropertyFilters.build(request);
//			List<MoveStorageDetail> listMoveStorageDetail = moveStorageDetailService.getList(filters);
//			List<StorageDetail> storageDetailList  = new ArrayList<StorageDetail>();
//			for(int i=0;i<listMoveStorageDetail.size();i++){
//				MoveStorageDetail psd=listMoveStorageDetail.get(i);
//				StorageDetail sd = new StorageDetail();
//				sd.setFk_dealer_id(sysUser.getFk_dealer_id());
//				sd.setFk_storage_id(psd.getFk_move_to_storage_id());
//				sd.setProduct_item_number(psd.getProduct_item_number());
//				sd.setBatch_no(psd.getBatch_no());
//				sd.setInventory_number(psd.getMove_number());
//				sd.setValid_date(psd.getValid_date());
//				storageDetailList.add(sd);
//			}
//			/**
//			 * 出库产品SN明细
//			 */
//			List<PropertyFilter> filters2 = PropertyFilters.build(request);
//			List<MoveStorageProDetail>  listMoveStorageProDetail = moveStorageProDetailService.getList(filters2); //sn list 需要回滚库存
//			List<StorageProDetail> storageProDetailList = new ArrayList<StorageProDetail>(); 
//			if(null!=listMoveStorageProDetail){
//				for(int i=0;i<listMoveStorageProDetail.size();i++){
//					MoveStorageProDetail pspd=(MoveStorageProDetail)listMoveStorageProDetail.get(i);
//					StorageProDetail spd = new StorageProDetail();
//					spd.setFk_dealer_id(sysUser.getFk_dealer_id());
//					spd.setFk_storage_id(pspd.getFk_move_to_storage_id());
//					spd.setBatch_no(pspd.getBatch_no());
//					spd.setProduct_sn(pspd.getProduct_sn());
//					storageProDetailList.add(spd);
//				}
//			}
//			boolean s =storageDetailService.updateStorageAndSnSub(null,storageDetailList,storageProDetailList);
//			if(s){
//				/**
//				 * 处理订单状态
//				 */
//				SimpleDateFormat time=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
//				entity.setStatus("1");//成功
//				entity.setMove_storage_date(time.format(new Date()));
//				moveStorageService.updateEntity(entity);
//				return new Result<Integer>(1, 1);
//			}
		return new Result<Integer>(1, 1);
	}

	@ResponseBody
	@RequestMapping("remove")
	public Result<Integer> remove(HttpServletRequest request,@ModelAttribute("entity") MoveStorage entity) {
		moveStorageDetailService.removeByMoveStorageCode(entity.getMove_storage_code());
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
