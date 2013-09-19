package dms.yijava.service.notice;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;

import dms.yijava.dao.dealer.DealerCategoryFunDao;
import dms.yijava.dao.notice.NoticeDao;
import dms.yijava.entity.dealer.DealerCategoryFun;
import dms.yijava.entity.notice.Notice;

@Service
@Transactional
public class NoticeService {

	@Autowired
	private NoticeDao noticeDao;
	@Autowired
	private DealerCategoryFunDao dealerCategoryFunDao;
	

	public JsonPage<Notice> paging(PageRequest pageRequest,
			List<PropertyFilter> filters) {
		Map<String, String> parameters = new HashMap<String, String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return noticeDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}

	
	public List<Notice> getList(String notice_id){
		HashMap<String,String> parameters = new HashMap<String,String>();
		parameters.put("notice_id", notice_id);
		return noticeDao.find(parameters);
	}
	
	public Notice getEntity(String id) {
		return noticeDao.get(id);
	}
	
	
	@Transactional(readOnly = false, propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public void saveEntity(Notice entity) {
		if(StringUtils.isBlank(entity.getValidity_date())){
			entity.setValidity_date(null);
		}
		noticeDao.insert(entity);
		String[] category_ids = StringUtils.split(entity.getCategory_ids(), ",");
		for (int i = 0; i < category_ids.length; i++) {
			entity.setDealer_category_id(category_ids[i]);
			noticeDao.insertObject(".insertReceive", entity);
			if(entity.getStatus_id().equals("3")){//发布状态
				Map<String,String> parameters = new HashMap<String,String>();
				parameters.put("category_id", category_ids[i]);
				List<DealerCategoryFun> derlerList = dealerCategoryFunDao.find(parameters);
				for (DealerCategoryFun dealerCategoryFun : derlerList) {
					entity.setDealer_id(dealerCategoryFun.getDealer_id());
					noticeDao.insertObject(".insertDealer", entity);
				}
			}
		}
	}

	public void updateEntity(Notice entity) {
		if(StringUtils.isBlank(entity.getValidity_date())){
			entity.setValidity_date(null);
		}
		noticeDao.update(entity);
		noticeDao.removeObject(".deleteReceive",entity);
		String[] category_ids = StringUtils.split(entity.getCategory_ids(), ",");
		for (int i = 0; i < category_ids.length; i++) {
			entity.setDealer_category_id(category_ids[i]);
			noticeDao.insertObject(".insertReceive", entity);
			if(entity.getStatus_id().equals("3")){//发布状态
				Map<String,String> parameters = new HashMap<String,String>();
				parameters.put("category_id", category_ids[i]);
				List<DealerCategoryFun> derlerList = dealerCategoryFunDao.find(parameters);
				for (DealerCategoryFun dealerCategoryFun : derlerList) {
					entity.setDealer_id(dealerCategoryFun.getDealer_id());
					noticeDao.insertObject(".insertDealer", entity);
				}
			}
		}
	}



}
