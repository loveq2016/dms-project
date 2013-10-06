package dms.yijava.api.web.movestorage;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

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
import dms.yijava.service.movestorage.MoveStorageDetailService;
import dms.yijava.service.movestorage.MoveStorageProDetailService;
import dms.yijava.service.movestorage.MoveStorageService;
import dms.yijava.service.storage.StorageDetailService;

@Controller
@RequestMapping("/api/movestoragedetail")
public class MoveStorageDetailController {
	@Autowired
	private MoveStorageService moveStorageService;
	@Autowired
	private MoveStorageDetailService moveStorageDetailService;
	@Autowired
	private MoveStorageProDetailService moveStorageProDetailService;
	@Autowired
	private StorageDetailService storageDetailService;
	
	@ResponseBody
	@RequestMapping("detailpaging")
	public JsonPage<MoveStorageDetail> paging(PageRequest pageRequest,HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return moveStorageDetailService.paging(pageRequest,filters);
	}
	
	@ResponseBody
	@RequestMapping("savedetail")
	public Result<String> savedetail(@ModelAttribute("entity") MoveStorageDetail entity) {
		//同一个移库、移入库下、批次 、移库code  不能重复添加
		MoveStorageDetail psd= moveStorageDetailService.getMoveStorageDetail(entity);
		if(null==psd){
			moveStorageDetailService.saveEntity(entity);//保存产品
			MoveStorage moveStorage = moveStorageService.getStorageDetailTotalNumber(entity.getMove_storage_code());
			moveStorageService.updateEntity(moveStorage);//修改出库单据总数量
			return new Result<String>(entity.getId(), 1);
		}else{
			return new Result<String>(entity.getId(), 2);
		}
	}
	
	/**
	 * fk_move_storage_id=#{fk_move_storage_id} and 
   		 move_storage_code=#{move_storage_code} and 
   		 fk_move_to_storage_id=#{fk_move_to_storage_id} 
   		 and batch_no=#{batch_no}
	 * @param entity
	 * @param request
	 * @return
	 */
	@ResponseBody
	@RequestMapping("remove")
	public Result<Integer> remove(@ModelAttribute("entity") MoveStorageDetail entity,HttpServletRequest request) {
		moveStorageDetailService.removeByStorageOrBatchNo(entity);
		//修改总数
		MoveStorage moveStorage = moveStorageService.getStorageDetailTotalNumber(entity.getMove_storage_code());
		if(null==moveStorage){
			moveStorage=new MoveStorage();
			moveStorage.setMove_storage_code(entity.getMove_storage_code());
			moveStorage.setTotal_number("0");
		}
		moveStorageService.updateEntity(moveStorage);//修改单据总数
		return new Result<Integer>(1, 1);
	}
}
