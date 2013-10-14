package dms.yijava.service.exchanged;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.yijava.common.spring.SpringContextHolder;
import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;

import dms.yijava.dao.exchanged.ExchangedDao;
import dms.yijava.dao.exchanged.ExchangedDetailDao;
import dms.yijava.dao.exchanged.ExchangedProDetailDao;
import dms.yijava.entity.exchanged.Exchanged;
import dms.yijava.entity.exchanged.ExchangedDetail;
import dms.yijava.entity.exchanged.ExchangedProDetail;
import dms.yijava.entity.storage.StorageDetail;
import dms.yijava.entity.storage.StorageProDetail;
import dms.yijava.service.storage.StorageDetailService;
@Service
@Transactional
public class ExchangedService{
	@Autowired
	private ExchangedDao exchangedDao;
	@Autowired
	private ExchangedDetailDao exchangedDetailDao;
	@Autowired
	private ExchangedProDetailDao exchangedProDetailDao;
	

	public JsonPage<Exchanged> paging(PageRequest pageRequest,List<PropertyFilter> filters) {
		//DateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			String propertyValue = propertyFilter.getMatchValue();
			parameters.put(propertyKey, propertyValue);
		}
		return exchangedDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}


	public void saveEntity(Exchanged entity) {
		exchangedDao.insert(entity);
	}
	public void updateEntity(Exchanged entity) {
		exchangedDao.update(entity);
	}
	
	public void submitExchanged(Exchanged entity) {
		exchangedDao.updateObject(".submitExchanged",entity);
	}
	
	
	public void updateExchangedStatus(String id,String status){
		Exchanged entity = new Exchanged();
		entity.setId(id);
		entity.setStatus(status);
		exchangedDao.updateObject(".updateExchangedStatus", entity);
	}
	
	@Transactional(readOnly = false, propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public void removeEntity(String id,String exchanged_code) {
		exchangedDao.removeById(id);
		exchangedDetailDao.removeObject(".deleteByExchangedCode", exchanged_code);
		exchangedProDetailDao.removeObject(".deleteByExchangedCode", exchanged_code);
	}

	public synchronized Exchanged getExchangedCode(String dealer_id) {
		Exchanged exchanged = exchangedDao.getObject(".selectExchangedCode",dealer_id);
		if(null== exchanged || StringUtils.isEmpty(exchanged.getExchanged_no())){
			exchanged = new Exchanged();
			exchanged.setExchanged_no("001");
		}
		return exchanged;
	}
	
	
	public Exchanged getEntity(String id) {
		return exchangedDao.get(id);
	}

	
	//驳回
	public void backFlow(String bussiness_id){
		this.updateExchangedStatus(bussiness_id,"2");
		List<Object> list = this.processExchanged(bussiness_id);
		SpringContextHolder.getApplicationContext().getBean(StorageDetailService.class).rollBackStorageUnLockSn(
				(List<StorageDetail>)list.get(0),(List<StorageProDetail>)list.get(1));//流程失败，回滚库存与sn
	}
	
	
	
	public List<Object> processExchanged(String exchanged_id){

		List<Object> returnList = new ArrayList<Object>();
		//库存减少。。锁定Sn
		Exchanged entity = SpringContextHolder.getApplicationContext().getBean(ExchangedService.class).getEntity(exchanged_id);
		//库存表
		List<StorageDetail> storageDetailList = new ArrayList<StorageDetail>();
		//sn表
		List<StorageProDetail> StorageProDetailList =  new ArrayList<StorageProDetail>();
		if (entity != null) {
			List<ExchangedDetail>  exchangedDetails =  SpringContextHolder.getApplicationContext().getBean(ExchangedDetailService.class).getExchangedDetailList(entity.getExchanged_code());
			List<ExchangedProDetail>  exchangedProDetails =  SpringContextHolder.getApplicationContext().getBean(ExchangedProDetailService.class).getExchangedProDetailList(entity.getExchanged_code());
			for (ExchangedDetail exchangedDetail : exchangedDetails) {
				StorageDetail sd = new StorageDetail();
				sd.setFk_dealer_id(entity.getDealer_id());
				sd.setFk_storage_id(exchangedDetail.getFk_storage_id());
				sd.setProduct_item_number(exchangedDetail.getProduct_item_number());
				sd.setBatch_no(exchangedDetail.getBatch_no());
				sd.setInventory_number(exchangedDetail.getExchanged_number());
				storageDetailList.add(sd);
			}
			for (ExchangedProDetail exchangedProDetail : exchangedProDetails) {
				StorageProDetail spd1 = new StorageProDetail();
				spd1.setFk_dealer_id(entity.getDealer_id());
				spd1.setFk_storage_id(exchangedProDetail.getFk_storage_id());
				spd1.setBatch_no(exchangedProDetail.getBatch_no());
				spd1.setProduct_sn(exchangedProDetail.getProduct_sn());
				StorageProDetailList.add(spd1);
			}
		}
		returnList.add(storageDetailList);
		returnList.add(StorageProDetailList);
		return returnList;
	}
	
	
}
