package dms.yijava.service.trial;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;

import dms.yijava.dao.trial.TrialDao;
import dms.yijava.entity.pullstorage.PullStorage;
import dms.yijava.entity.trial.Trial;

@Service
@Transactional
public class TrialService {

	@Autowired
	private TrialDao trialDao;

	/**
	 * 分页得到试用列表
	 * @param pageRequest
	 * @param filters
	 * @return
	 */
	public JsonPage<Trial> paging(PageRequest pageRequest,
			List<PropertyFilter> filters) {
		Map<String, String> parameters = new HashMap<String, String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return trialDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}
	
	public Trial getEntity(Integer id) {
		return trialDao.get(id);
	}
	
	public void saveEntity(Trial entity) {
		trialDao.insert(entity);
	}
	
	public void updateEntity(Trial entity) {
		trialDao.update( entity);
	}
	
	public void updateEntityStatus(Integer trial_id,Integer status)
	{
		Trial entity = new Trial ();
		entity.setStatus(status);
		entity.setTrial_id(trial_id);
		trialDao.update( entity);
	}
	
	public void removeEntity(Integer trial_id) {
		trialDao.removeById(trial_id);
	}
	
	/**
	 * 返回出库单据
	 * @param pull_storage_party_id
	 * @return
	 */
	public Trial getTrialCode(String dealer_user_id) {
		Trial trial=trialDao.getObject(".selectTrialCode",dealer_user_id);
		if(null==trial || StringUtils.isEmpty(trial.getTrial_no())){
			trial=new Trial();
			trial.setTrial_no("001");
		}
		return trial;
	}
	
}
