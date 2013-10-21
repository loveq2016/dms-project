package dms.yijava.service.pullstorage;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.ModelAttribute;

import com.yijava.common.spring.SpringContextHolder;
import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;
import com.yijava.orm.core.PropertyFilters;
import com.yijava.web.vo.Result;

import dms.yijava.dao.pullstorage.PullStorageDao;
import dms.yijava.entity.adjuststorage.AdjustStorageDetail;
import dms.yijava.entity.adjuststorage.AdjustStorageProDetail;
import dms.yijava.entity.pullstorage.PullStorage;
import dms.yijava.entity.pullstorage.PullStorageDetail;
import dms.yijava.entity.pullstorage.PullStorageProDetail;
import dms.yijava.entity.storage.StorageDetail;
import dms.yijava.entity.storage.StorageProDetail;
import dms.yijava.entity.system.SysUser;
import dms.yijava.service.adjuststorage.AdjustStorageProDetailService;
import dms.yijava.service.storage.StorageDetailService;
import dms.yijava.service.storage.StorageDetailService.PullStorageOpt;
@Service
@Transactional
public class PullStorageService{
	@Autowired
	private PullStorageDao pullStorageDao;
	@Autowired
	private PullStorageDetailService pullStorageDetailService;
	@Autowired
	private PullStorageProDetailService pullStorageProDetailService;
	
	public JsonPage<PullStorage> paging(PageRequest pageRequest,List<PropertyFilter> filters) {
		DateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Map<String,String> parameters = new HashMap<String,String>();
		try{
			for (PropertyFilter propertyFilter : filters) {
				String propertyKey = propertyFilter.getPropertyNames()[0];
				String propertyValue = propertyFilter.getMatchValue();
				String hhmmss="";
				if(propertyKey.equals("pull_start_date") || propertyKey.equals("pull_end_date")||
						propertyKey.equals("put_start_date") || propertyKey.equals("put_end_date")){
					if(propertyKey.equals("pull_start_date")&&!"".equals(propertyValue))
						hhmmss=" 00:00:00";
					if(propertyKey.equals("pull_end_date")&&!"".equals(propertyValue))
						hhmmss=" 23:59:59";
					if(propertyKey.equals("put_start_date")&&!"".equals(propertyValue))
						hhmmss=" 00:00:00";
					if(propertyKey.equals("put_end_date")&&!"".equals(propertyValue))
						hhmmss=" 23:59:59";
					propertyValue=propertyValue + hhmmss;
				}
				parameters.put(propertyKey, propertyValue);
			}
		}catch(Exception ex){}
		return pullStorageDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}
	public List<PullStorage> getList(List<PropertyFilter> filters){
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return pullStorageDao.find(parameters);
	}
	public PullStorage getEntity(String id) {
		return pullStorageDao.get(id);
	}
	public void saveEntity(PullStorage entity) {
		pullStorageDao.insert(entity);
	}
	public void updateEntity(PullStorage entity) {
		pullStorageDao.update(entity);
	}
	public void updateStatus(String id,String status){
		PullStorage entity=new PullStorage();
		entity.setId(id);
		entity.setStatus(status);
		pullStorageDao.updateObject(".updateStatus", entity);
	}
	public void removeByPullStorageCode(String pull_storage_code) {
		pullStorageDetailService.removeByPullStorageCode(pull_storage_code);
		pullStorageDao.removeObject(".deleteByPullStorageCode",pull_storage_code);
	}
	public PullStorage getStorageDetailTotalNumber(String pull_storage_code) {
		PullStorage pullStorage=pullStorageDao.getObject(".selectStorageDetailTotalNumber",pull_storage_code);
		return pullStorage;
	}
	/**
	 * 返回入库单据
	 * @param put_storage_party_id
	 * @return
	 */
	public PullStorage getPutStorageCode(String put_storage_party_id) {
		PullStorage pullStorage=pullStorageDao.getObject(".selectPutStorageCode",put_storage_party_id);
		if(null==pullStorage || StringUtils.isEmpty(pullStorage.getPut_storage_no())){
			pullStorage=new PullStorage();
			pullStorage.setPut_storage_no("001");
		}
		return pullStorage;
	}
	/**
	 * 返回出库单据
	 * @param pull_storage_party_id
	 * @return
	 */
	public PullStorage getPullStorageCode(String pull_storage_party_id) {
		PullStorage pullStorage=pullStorageDao.getObject(".selectPullStorageCode",pull_storage_party_id);
		if(null==pullStorage || StringUtils.isEmpty(pullStorage.getPull_storage_no())){
			pullStorage=new PullStorage();
			pullStorage.setPull_storage_no("001");
		}
		return pullStorage;
	}
	//驳回
	public void backFlow(String id){
			this.updateStatus(id,"2");
			List<Object> list = this.processPullStorage(id);
			SpringContextHolder.getApplicationContext().getBean(StorageDetailService.class).rollBackStorageUnLockSn(
					(List<StorageDetail>)list.get(0),(List<StorageProDetail>)list.get(1));//流程失败，回滚库存与sn
	}
	/**
	 * 出库处理
	 * @param id
	 * @return
	 */
	public List<Object> processPullStorage(String id){
		List<Object> returnList = new ArrayList<Object>();
		PullStorage pullStorage = this.getEntity(id);//库存单据
		List<StorageDetail> storageDetailList = new ArrayList<StorageDetail>();//库存明细表
		List<StorageProDetail> storageProDetailList =  new ArrayList<StorageProDetail>();//sn表
		if (pullStorage != null) {
			//状态是否被修改
			if(pullStorage.getStatus().equals("0") || pullStorage.getStatus().equals("2")){
				List<PropertyFilter> filters = new ArrayList<PropertyFilter>();
				filters.add(PropertyFilters.build("ANDS_pull_storage_code",pullStorage.getPull_storage_code()));
				filters.add(PropertyFilters.build("ANDS_put_storage_code",pullStorage.getPut_storage_code()));
				List<PullStorageDetail> listPullStorageDetail = pullStorageDetailService.getList(filters);
				List<PullStorageProDetail> listPullStorageProDetail = pullStorageProDetailService.getList(filters);
				for (PullStorageDetail pullStorageDetail : listPullStorageDetail) {
					StorageDetail sd = new StorageDetail();
					sd.setFk_dealer_id(pullStorage.getFk_pull_storage_party_id());
					sd.setFk_storage_id(pullStorageDetail.getFk_storage_id());
					sd.setProduct_item_number(pullStorageDetail.getProduct_item_number());
					sd.setBatch_no(pullStorageDetail.getBatch_no());
					sd.setInventory_number(pullStorageDetail.getSales_number());
					sd.setModels(pullStorageDetail.getModels());
					storageDetailList.add(sd);
				}
				for (PullStorageProDetail pullStorageProDetail : listPullStorageProDetail) {
					StorageProDetail spd = new StorageProDetail();
					spd.setFk_dealer_id(pullStorage.getFk_pull_storage_party_id());
					spd.setFk_storage_id(pullStorageProDetail.getFk_storage_id());
					spd.setBatch_no(pullStorageProDetail.getBatch_no());
					spd.setProduct_sn(pullStorageProDetail.getProduct_sn());
					storageProDetailList.add(spd);
				}
			}else{
				return null;
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
	public boolean processPutStorage(String id){
		boolean s=false;
		PullStorage pullStorage = this.getEntity(id);//库存单据
		List<StorageDetail> storageDetailList = new ArrayList<StorageDetail>();//库存明细表
		List<StorageProDetail> storageProDetailList =  new ArrayList<StorageProDetail>();//sn表
		if (pullStorage != null && (pullStorage.getStatus().equals("3")||pullStorage.getStatus().equals("0"))) {
			List<PropertyFilter> filters = new ArrayList<PropertyFilter>();
			filters.add(PropertyFilters.build("ANDS_pull_storage_code",pullStorage.getPull_storage_code()));
			filters.add(PropertyFilters.build("ANDS_put_storage_code",pullStorage.getPut_storage_code()));
			List<PullStorageDetail> listPullStorageDetail = pullStorageDetailService.getList(filters);
			List<PullStorageProDetail> listPullStorageProDetail = pullStorageProDetailService.getList(filters);
			for (PullStorageDetail pullStorageDetail : listPullStorageDetail) {
				StorageDetail sd = new StorageDetail();
				sd.setFk_dealer_id(pullStorage.getFk_put_storage_party_id());
				sd.setProduct_item_number(pullStorageDetail.getProduct_item_number());
				sd.setBatch_no(pullStorageDetail.getBatch_no());
				sd.setInventory_number(pullStorageDetail.getSales_number());
				sd.setValid_date(pullStorageDetail.getValid_date());
				sd.setModels(pullStorageDetail.getModels());
				storageDetailList.add(sd);
			}
			for (PullStorageProDetail pullStorageProDetail : listPullStorageProDetail) {
				StorageProDetail spd = new StorageProDetail();
				spd.setFk_dealer_id(pullStorage.getFk_put_storage_party_id());
				spd.setBatch_no(pullStorageProDetail.getBatch_no());
				spd.setProduct_sn(pullStorageProDetail.getProduct_sn());
				storageProDetailList.add(spd);
			}
			s =SpringContextHolder.getApplicationContext().getBean(StorageDetailService.class)
					.updateStorageAndSnSub(pullStorage.getFk_put_storage_party_id(),storageDetailList,storageProDetailList);
		}
		return s;
	}
}
