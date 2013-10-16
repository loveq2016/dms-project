package dms.yijava.service.movestorage;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.yijava.common.spring.SpringContextHolder;
import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;
import com.yijava.orm.core.PropertyFilters;

import dms.yijava.dao.movestorage.MoveStorageDao;
import dms.yijava.entity.movestorage.MoveStorage;
import dms.yijava.entity.movestorage.MoveStorageDetail;
import dms.yijava.entity.movestorage.MoveStorageProDetail;
import dms.yijava.entity.pullstorage.PullStorage;
import dms.yijava.entity.pullstorage.PullStorageDetail;
import dms.yijava.entity.pullstorage.PullStorageProDetail;
import dms.yijava.entity.storage.StorageDetail;
import dms.yijava.entity.storage.StorageProDetail;
import dms.yijava.service.storage.StorageDetailService;
@Service
@Transactional
public class MoveStorageService{
	@Autowired
	private MoveStorageDao moveStorageDao;
	@Autowired
	private MoveStorageDetailService moveStorageDetailService;
	@Autowired
	private MoveStorageProDetailService moveStorageProDetailService;
	public JsonPage<MoveStorage> paging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		try{
			for (PropertyFilter propertyFilter : filters) {
				String propertyKey = propertyFilter.getPropertyNames()[0];
				String propertyValue = propertyFilter.getMatchValue();
				String hhmmss="";
				if(propertyKey.equals("move_start_date") || propertyKey.equals("move_end_date")){
					if(propertyKey.equals("move_start_date")&&!"".equals(propertyValue))
						hhmmss=" 00:00:00";
					if(propertyKey.equals("move_end_date")&&!"".equals(propertyValue))
						hhmmss=" 23:59:59";
					propertyValue=propertyValue + hhmmss;
				}
				parameters.put(propertyKey, propertyValue);
			}
		}catch(Exception ex){}
		return moveStorageDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}
	public List<MoveStorage> getList(List<PropertyFilter> filters){
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return moveStorageDao.find(parameters);
	}
	public MoveStorage getEntity(String id) {
		return moveStorageDao.get(id);
	}
	public void saveEntity(MoveStorage entity) {
		moveStorageDao.insert(entity);
	}
	public void updateEntity(MoveStorage entity) {
		moveStorageDao.update(entity);
	}
	public void updateStatus(String id,String status){
		MoveStorage entity=new MoveStorage();
		entity.setId(id);
		entity.setStatus(status);
		moveStorageDao.updateObject(".updateStatus", entity);
	}
	public void removeByMoveStorageCode(String move_storage_code) {
		moveStorageDetailService.removeByMoveStorageCode(move_storage_code);
		moveStorageDao.removeObject(".deleteByMoveStorageCode",move_storage_code);
	}
	public MoveStorage getStorageDetailTotalNumber(String move_storage_code) {
		MoveStorage moveStorage=moveStorageDao.getObject(".selectStorageDetailTotalNumber",move_storage_code);
		return moveStorage;
	}
	public MoveStorage getMoveStorageCode(String move_storage_party_id) {
		MoveStorage moveStorage=moveStorageDao.getObject(".selectMoveStorageCode",move_storage_party_id);
		if(null==moveStorage || StringUtils.isEmpty(moveStorage.getMove_storage_no())){
			moveStorage=new MoveStorage();
			moveStorage.setMove_storage_no("001");
		}
		return moveStorage;
	}
	/**
	 * 出库处理
	 * @param id
	 * @return
	 */
	public List<Object> processMoveStorage(String id){
		List<Object> returnList = new ArrayList<Object>();
		MoveStorage moveStorage = this.getEntity(id);//库存单据
		List<StorageDetail> storageDetailList = new ArrayList<StorageDetail>();//库存明细表
		List<StorageProDetail> storageProDetailList =  new ArrayList<StorageProDetail>();//sn表
		if (moveStorage != null) {
			//状态是否被修改
			if(!moveStorage.getStatus().equals("0"))
				return null;
			List<PropertyFilter> filters = new ArrayList<PropertyFilter>();
			filters.add(PropertyFilters.build("ANDS_move_storage_code",moveStorage.getMove_storage_code()));
			List<MoveStorageDetail> listMoveStorageDetail = moveStorageDetailService.getList(filters);
			List<MoveStorageProDetail> listMoveStorageProDetail = moveStorageProDetailService.getList(filters);
			for (MoveStorageDetail moveStorageDetail : listMoveStorageDetail) {
				StorageDetail sd = new StorageDetail();
				sd.setFk_dealer_id(moveStorage.getFk_move_storage_party_id());
				sd.setFk_storage_id(moveStorageDetail.getFk_move_storage_id());
				sd.setProduct_item_number(moveStorageDetail.getProduct_item_number());
				sd.setBatch_no(moveStorageDetail.getBatch_no());
				sd.setInventory_number(moveStorageDetail.getMove_number());
				storageDetailList.add(sd);
			}
			for (MoveStorageProDetail moveStorageProDetail : listMoveStorageProDetail) {
				StorageProDetail spd = new StorageProDetail();
				spd.setFk_dealer_id(moveStorage.getFk_move_storage_party_id());
				spd.setFk_storage_id(moveStorageProDetail.getFk_move_storage_id());
				spd.setBatch_no(moveStorageProDetail.getBatch_no());
				spd.setProduct_sn(moveStorageProDetail.getProduct_sn());
				storageProDetailList.add(spd);
			}
		}
		returnList.add(storageDetailList);
		returnList.add(storageProDetailList);
		return returnList;
	}
	/**
	 * 入库处理
	 * @param id
	 * @return
	 */
	public boolean processMoveToStorage(String id){
		boolean s=false;
		MoveStorage moveStorage = this.getEntity(id);//库存单据
		List<StorageDetail> storageDetailList = new ArrayList<StorageDetail>();//库存明细表
		List<StorageProDetail> storageProDetailList =  new ArrayList<StorageProDetail>();//sn表
		if (moveStorage != null && moveStorage.getStatus().equals("0")) {
			List<PropertyFilter> filters = new ArrayList<PropertyFilter>();
			filters.add(PropertyFilters.build("ANDS_move_storage_code",moveStorage.getMove_storage_code()));
			List<MoveStorageDetail> listMoveStorageDetail = moveStorageDetailService.getList(filters);
			List<MoveStorageProDetail> listMoveStorageProDetail = moveStorageProDetailService.getList(filters);
			for (MoveStorageDetail moveStorageDetail : listMoveStorageDetail) {
				StorageDetail sd = new StorageDetail();
				sd.setFk_dealer_id(moveStorage.getFk_move_storage_party_id());
				sd.setFk_storage_id(moveStorageDetail.getFk_move_to_storage_id());
				sd.setProduct_item_number(moveStorageDetail.getProduct_item_number());
				sd.setBatch_no(moveStorageDetail.getBatch_no());
				sd.setInventory_number(moveStorageDetail.getMove_number());
				sd.setValid_date(moveStorageDetail.getValid_date());
				storageDetailList.add(sd);
			}
			for (MoveStorageProDetail moveStorageProDetail : listMoveStorageProDetail) {
				StorageProDetail spd = new StorageProDetail();
				spd.setFk_dealer_id(moveStorage.getFk_move_storage_party_id());
				spd.setFk_storage_id(moveStorageProDetail.getFk_move_to_storage_id());
				spd.setBatch_no(moveStorageProDetail.getBatch_no());
				spd.setProduct_sn(moveStorageProDetail.getProduct_sn());
				storageProDetailList.add(spd);
			}
			s =SpringContextHolder.getApplicationContext().getBean(StorageDetailService.class)
					.updateStorageAndSnSub(null,storageDetailList,storageProDetailList);
		}
		return s;
	}
}
