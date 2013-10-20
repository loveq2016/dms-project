package dms.yijava.service.exchanged;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;

import dms.yijava.dao.exchanged.ExchangedDao;
import dms.yijava.dao.exchanged.ExchangedDetailDao;
import dms.yijava.dao.exchanged.ExchangedProDetailDao;
import dms.yijava.entity.exchanged.Exchanged;
import dms.yijava.entity.exchanged.ExchangedDetail;
import dms.yijava.entity.exchanged.ExchangedProDetail;
@Service
@Transactional
public class ExchangedProDetailService{
	
	@Autowired
	private ExchangedDao exchangedDao;
	@Autowired
	private ExchangedDetailDao exchangedDetailDao;
	@Autowired
	private ExchangedProDetailDao exchangedProDetailDao;
	
	public JsonPage<ExchangedProDetail> paging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return exchangedProDetailDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}
	public List<ExchangedProDetail> getList(List<PropertyFilter> filters){
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return exchangedProDetailDao.find(parameters);
	}
	public ExchangedProDetail getEntity(String id) {
		return exchangedProDetailDao.get(id);
	}
	
	public List<ExchangedProDetail> getExchangedProDetailList(String exchanged_code) {
		return exchangedProDetailDao.find(".selectExchangedProDetailMap",exchanged_code);
	}

	public void saveEntity(ExchangedProDetail entity) {
		exchangedProDetailDao.insert(entity);
		ExchangedDetail exchangedDetail = exchangedDetailDao.getObject(".selectExchangedProDetailTotalNumber",entity.getExchanged_detail_id());
		if (null != exchangedDetail) {
			exchangedDetailDao.updateObject(".updateTotalNumber", exchangedDetail);
		}
		Exchanged exchanged = exchangedDao.getObject(".selectExchangedDetailTotalNumber",entity.getExchanged_code());
		if (null != exchanged) {
			exchangedDao.updateObject(".updateTotalNumber", exchanged);
		}
	}
	
	public void removeByIdEntity(String id,String exchanged_detail_id,String exchanged_code) {
		exchangedProDetailDao.removeById(id);
		ExchangedDetail exchangedDetail = exchangedDetailDao.getObject(".selectExchangedProDetailTotalNumber",exchanged_detail_id);
		if (null != exchangedDetail) {
			exchangedDetail.setId(exchanged_detail_id);
			exchangedDetailDao.updateObject(".updateTotalNumber", exchangedDetail);
		}else{
			exchangedDetail = new ExchangedDetail();
			exchangedDetail.setId(exchanged_detail_id);
			exchangedDetail.setExchanged_number("0");
			exchangedDao.updateObject(".updateTotalNumber", exchangedDetail);
		}
		Exchanged exchanged = exchangedDao.getObject(".selectExchangedDetailTotalNumber",exchanged_code);
		if (null != exchanged) {
			exchangedDao.updateObject(".updateTotalNumber", exchanged);
		}else{
			exchanged = new Exchanged();
			exchanged.setExchanged_code(exchanged_code);
			exchanged.setTotal_number("0");
			exchangedDao.updateObject(".updateTotalNumber", exchanged);
		}
	}

	
	public void setModelsBySn(ExchangedProDetail entity) {
		exchangedProDetailDao.updateObject(".setModelsBySn", entity);
	}

	

	
}
