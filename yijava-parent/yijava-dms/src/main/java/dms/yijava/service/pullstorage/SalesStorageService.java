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

import dms.yijava.dao.pullstorage.SalesStorageDao;
import dms.yijava.entity.pullstorage.PullStorage;
import dms.yijava.entity.pullstorage.PullStorageDetail;
import dms.yijava.entity.pullstorage.PullStorageProDetail;
import dms.yijava.entity.pullstorage.SalesStorage;
import dms.yijava.entity.storage.StorageDetail;
import dms.yijava.entity.storage.StorageProDetail;
import dms.yijava.entity.system.SysUser;
import dms.yijava.service.storage.StorageDetailService;
import dms.yijava.service.storage.StorageDetailService.PullStorageOpt;
@Service
@Transactional
public class SalesStorageService{
	@Autowired
	private SalesStorageDao salesStorageDao;
	@Autowired
	private PullStorageDetailService pullStorageDetailService;
	@Autowired
	private PullStorageProDetailService pullStorageProDetailService;
	
	public JsonPage<SalesStorage> paging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		try{
			for (PropertyFilter propertyFilter : filters) {
				String propertyKey = propertyFilter.getPropertyNames()[0];
				String propertyValue = propertyFilter.getMatchValue();
				String hhmmss="";
				if(propertyKey.equals("pull_start_date") || propertyKey.equals("pull_end_date")||
						propertyKey.equals("sales_start_date") || propertyKey.equals("sales_end_date")){
					if(propertyKey.equals("pull_start_date")&&!"".equals(propertyValue))
						hhmmss=" 00:00:00";
					if(propertyKey.equals("pull_end_date")&&!"".equals(propertyValue))
						hhmmss=" 23:59:59";
					if(propertyKey.equals("sales_start_date")&&!"".equals(propertyValue))
						hhmmss=" 00:00:00";
					if(propertyKey.equals("sales_end_date")&&!"".equals(propertyValue))
						hhmmss=" 23:59:59";
					propertyValue=propertyValue + hhmmss;
				}
				parameters.put(propertyKey, propertyValue);
			}
		}catch(Exception ex){}
		return salesStorageDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}
	public List<SalesStorage> getList(List<PropertyFilter> filters){
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return salesStorageDao.find(parameters);
	}
	public PullStorage getEntity(String id) {
		return salesStorageDao.get(id);
	}
	public void saveEntity(SalesStorage entity) {
		salesStorageDao.insert(entity);
	}
	public void updateEntity(SalesStorage entity) {
		salesStorageDao.update(entity);
	}
	public void updateStatus(String id,String status){
		PullStorage entity=new PullStorage();
		entity.setId(id);
		entity.setStatus(status);
		salesStorageDao.updateObject(".updateStatus", entity);
	}	
	public void removeEntity(String id) {
		salesStorageDao.removeById(id);
	}
	public void removeByPullStorageCode(String pull_storage_code) {
		pullStorageDetailService.removeByPullStorageCode(pull_storage_code);
		salesStorageDao.removeObject(".deleteByPullStorageCode",pull_storage_code);
	}
	public SalesStorage getStorageDetailTotalNumber(String pull_storage_code) {
		SalesStorage pullStorage=salesStorageDao.getObject(".selectStorageDetailTotalNumber",pull_storage_code);
		return pullStorage;
	}
	public SalesStorage getPullStorageCode(SalesStorage entity) {
		SalesStorage pullStorage=salesStorageDao.getObject(".selectPullStorageCode",entity);
		if(null==pullStorage || StringUtils.isEmpty(pullStorage.getPull_storage_no())){
			pullStorage=new SalesStorage();
			pullStorage.setPull_storage_no("001");
		}
		return pullStorage;
	}
	//驳回
	public void backFlow(String id){
		this.updateStatus(id,"2");
		List<Object> list = this.processSalesStorage(id);
		SpringContextHolder.getApplicationContext().getBean(StorageDetailService.class).rollBackStorageUnLockSn(
				(List<StorageDetail>)list.get(0),(List<StorageProDetail>)list.get(1));//流程失败，回滚库存与sn
	}
	/**
	 * 出库处理
	 * @param id
	 * @return
	 */
	public List<Object> processSalesStorage(String id){
		List<Object> returnList = new ArrayList<Object>();
		PullStorage pullStorage = this.getEntity(id);//库存单据
		List<StorageDetail> storageDetailList = new ArrayList<StorageDetail>();//库存明细表
		List<StorageProDetail> storageProDetailList =  new ArrayList<StorageProDetail>();//sn表
		if (pullStorage != null) {
			//状态被修改
			if(!pullStorage.getStatus().equals("0"))
				return null;
			List<PropertyFilter> filters = new ArrayList<PropertyFilter>();
			filters.add(PropertyFilters.build("ANDS_pull_storage_code",pullStorage.getPull_storage_code()));
			List<PullStorageDetail> listPullStorageDetail = pullStorageDetailService.getList(filters);
			List<PullStorageProDetail> listPullStorageProDetail = pullStorageProDetailService.getList(filters);
			for (PullStorageDetail pullStorageDetail : listPullStorageDetail) {
				StorageDetail sd = new StorageDetail();
				sd.setFk_dealer_id(pullStorage.getFk_pull_storage_party_id());
				sd.setFk_storage_id(pullStorageDetail.getFk_storage_id());
				sd.setProduct_item_number(pullStorageDetail.getProduct_item_number());
				sd.setBatch_no(pullStorageDetail.getBatch_no());
				sd.setInventory_number(pullStorageDetail.getSales_number());
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
		}
		returnList.add(storageDetailList);
		returnList.add(storageProDetailList);
		return returnList;
	}
	
}
