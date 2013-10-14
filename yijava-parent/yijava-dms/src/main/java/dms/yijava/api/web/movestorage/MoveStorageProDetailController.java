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
import dms.yijava.entity.pullstorage.PullStorageDetail;
import dms.yijava.service.movestorage.MoveStorageDetailService;
import dms.yijava.service.movestorage.MoveStorageProDetailService;
import dms.yijava.service.movestorage.MoveStorageService;
import dms.yijava.service.storage.StorageDetailService;

@Controller
@RequestMapping("/api/movestorageprodetail")
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
		List<MoveStorageProDetail> psd= moveStorageProDetailService.getMoveStorageProDetail(entity);
		if(null==psd || psd.size()<=0){
			String [] product_sns=entity.getProduct_sns();
			String [] batch_nos=entity.getBatch_nos();
			List<MoveStorageProDetail> list = new ArrayList<MoveStorageProDetail>();
			for (int i=0;i<product_sns.length;i++) {
				MoveStorageProDetail mp=new MoveStorageProDetail();
				mp.setBatch_no(batch_nos[i]);
				mp.setProduct_sn(product_sns[i]);
				mp.setFk_move_storage_detail_id(entity.getFk_move_storage_detail_id());
				mp.setFk_move_storage_id(entity.getFk_move_storage_id());
				mp.setFk_move_to_storage_id(entity.getFk_move_to_storage_id());
				mp.setMove_storage_code(entity.getMove_storage_code());
				list.add(mp);
			}
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
