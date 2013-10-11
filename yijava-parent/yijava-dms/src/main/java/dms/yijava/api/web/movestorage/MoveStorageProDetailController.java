package dms.yijava.api.web.movestorage;

import java.util.ArrayList;
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
import dms.yijava.entity.movestorage.MoveStorageProDetail;
import dms.yijava.service.movestorage.MoveStorageDetailService;
import dms.yijava.service.movestorage.MoveStorageProDetailService;
import dms.yijava.service.movestorage.MoveStorageService;
import dms.yijava.service.storage.StorageDetailService;

@Controller
@RequestMapping("/api/pullstorageprodetail")
public class MoveStorageProDetailController {
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
	public JsonPage<MoveStorageProDetail> paging(PageRequest pageRequest,HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return moveStorageProDetailService.paging(pageRequest,filters);
	}
	
	@ResponseBody
	@RequestMapping("save")
	public Result<String> savedetail(@ModelAttribute("entity") MoveStorageProDetail entity) {
		//同一个单据，同一个仓库下的，同一个批次，同一个序号   不能重复添加
		MoveStorageProDetail psd= moveStorageProDetailService.getMoveStorageProDetail(entity);
		if(null==psd){
			List<MoveStorageProDetail> list = new ArrayList<MoveStorageProDetail>();
			list.add(entity);
			moveStorageProDetailService.saveEntity(list);//保存SN
			MoveStorageDetail moveStorageDetail=moveStorageDetailService.getStorageProDetailMoveNumber(entity.getFk_move_storage_detail_id());//查询SN总数
			moveStorageDetailService.updateEntity(moveStorageDetail);//修改产品数量
			MoveStorage moveStorage = moveStorageService.getStorageDetailTotalNumber(entity.getMove_storage_code());//查询产品总数
			moveStorageService.updateEntity(moveStorage);//修改出库单据总数量
			return new Result<String>(entity.getId(), 1);
		}else{
			return new Result<String>(entity.getId(), 2);
		}
	}
	
	/**
	 * 删除SN
	 * id
	 * pull_storage_code
	 * batch_no
	 * fk_storage_id
	 * @param entity
	 * @param request
	 * @return
	 */
	@ResponseBody
	@RequestMapping("remove")
	public Result<Integer> remove(@ModelAttribute("entity") MoveStorageProDetail entity,HttpServletRequest request) {
		moveStorageProDetailService.removeByIdEntity(entity.getId());
		MoveStorageDetail moveStorageDetail=moveStorageDetailService.getStorageProDetailMoveNumber(entity.getFk_move_storage_detail_id());//查询SN总数
		moveStorageDetail.setId(entity.getFk_move_storage_detail_id());
		moveStorageDetailService.updateEntity(moveStorageDetail);//修改产品数量
		//修改总数
		MoveStorage moveStorage = moveStorageService.getStorageDetailTotalNumber(entity.getMove_storage_code());
		moveStorageService.updateEntity(moveStorage);//修改单据总数
		return new Result<Integer>(1, 1);
	}
}
