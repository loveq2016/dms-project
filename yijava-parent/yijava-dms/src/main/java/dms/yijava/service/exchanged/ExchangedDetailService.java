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

@Service
@Transactional
public class ExchangedDetailService {

	@Autowired
	private ExchangedDao exchangedDao;
	@Autowired
	private ExchangedDetailDao exchangedDetailDao;
	@Autowired
	private ExchangedProDetailDao exchangedProDetailDao;

	public JsonPage<ExchangedDetail> paging(PageRequest pageRequest,
			List<PropertyFilter> filters) {
		Map<String, String> parameters = new HashMap<String, String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return exchangedDetailDao.getScrollData(parameters,
				pageRequest.getOffset(), pageRequest.getPageSize(),
				pageRequest.getOrderBy(), pageRequest.getOrderDir());
	}

	public ExchangedDetail getExchangedDetail(ExchangedDetail entity) {
		return exchangedDetailDao.getObject(".selectExchangedDetail",entity);
	}
	
	public void saveEntity(ExchangedDetail entity) {
		
		exchangedDetailDao.insert(entity);
		//Exchanged exchanged = exchangedDao.getObject(".selectExchangedDetailTotalNumber",entity.getExchanged_code());
		//if (null != exchanged) {
		//	exchangedDao.updateObject(".updateTotalNumber", exchanged);
		//}
	}
	
	public List<ExchangedDetail> getExchangedDetailList(String exchanged_code) {
		return exchangedDetailDao.findObject(".selectExchangedDetailMap",exchanged_code);
	}
	
	public List<ExchangedDetail> selectExchangedDetailWordMap(String exchanged_code) {
		return exchangedDetailDao.findObject(".selectExchangedDetailWordMap",exchanged_code);
	}
	
	

	public void removeByIdEntity(String id,String exchanged_code) {
		exchangedDetailDao.removeById(id);
		exchangedProDetailDao.removeObject(".deleteByExchanged_detail_id", id);
		ExchangedDetail exchangedDetail = exchangedDetailDao.getObject(".selectExchangedProDetailTotalNumber",id);
		if (null != exchangedDetail ) {
			exchangedDetail.setId(id);
			exchangedDetailDao.updateObject(".updateTotalNumber", exchangedDetail);
		}else{
			exchangedDetail = new ExchangedDetail();
			exchangedDetail.setId(id);
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

}
