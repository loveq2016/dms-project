package dms.yijava.service.repost;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;

import dms.yijava.dao.repost.RepostDao;

@Service
@Transactional
public class RepostService {

	@Autowired
	private RepostDao repostDao;
	
	public JsonPage<Map<String,Object>> proCateHospDetailsPaging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return repostDao.getScrollData("ProCateHospDetails",parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}
	
	public JsonPage<Map<String,Object>> salesHospitalReportPaging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return repostDao.getScrollData("SalesHospitalReport",parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}
	

	
	public JsonPage<Map<String,Object>> dealerPaging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return repostDao.getScrollData("DealerReport",parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}
	
	
	public JsonPage<Map<String,Object>> dealerAuthPaging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return repostDao.getScrollData("DealerAuthReport",parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}
	
	
	public JsonPage<Map<String,Object>> expressPaging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return repostDao.getScrollData("ExpressReport",parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}
	

	public JsonPage<Map<String,Object>> storageReportPaging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			String propertyValue = propertyFilter.getMatchValue();
			String hhmmss="";
			if(propertyKey.equals("start_last_time") || propertyKey.equals("end_last_time")){
				if(propertyKey.equals("start_last_time")&&!"".equals(propertyValue))
					hhmmss=" 00:00:00";
				if(propertyKey.equals("end_last_time")&&!"".equals(propertyValue))
					hhmmss=" 23:59:59";
				propertyValue=propertyValue + hhmmss;
			}
			parameters.put(propertyKey, propertyValue);
		}
		return repostDao.getScrollData("StorageReport",parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}
	
	public JsonPage<Map<String,Object>> salesReportPaging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		try{
			for (PropertyFilter propertyFilter : filters) {
				String propertyKey = propertyFilter.getPropertyNames()[0];
				String propertyValue = propertyFilter.getMatchValue();
				String hhmmss="";
				if(propertyKey.equals("start_sales_date") || propertyKey.equals("end_sales_date") || 
						propertyKey.equals("start_create_date") || propertyKey.equals("end_create_date")){
					if(propertyKey.equals("start_sales_date")&&!"".equals(propertyValue))
						hhmmss=" 00:00:00";
					if(propertyKey.equals("end_sales_date")&&!"".equals(propertyValue))
						hhmmss=" 23:59:59";
					if(propertyKey.equals("start_create_date")&&!"".equals(propertyValue))
						hhmmss=" 00:00:00";
					if(propertyKey.equals("end_create_date")&&!"".equals(propertyValue))
						hhmmss=" 23:59:59";
					propertyValue=propertyValue + hhmmss;
				}
				parameters.put(propertyKey, propertyValue);
			}
		}catch(Exception ex){}
		return repostDao.getScrollData("SalesReport",parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}
	
	public JsonPage<Map<String,Object>> orderReportPaging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		try{
			for (PropertyFilter propertyFilter : filters) {
				String propertyKey = propertyFilter.getPropertyNames()[0];
				String propertyValue = propertyFilter.getMatchValue();
				String hhmmss="";
				if(propertyKey.equals("start_order_date") || propertyKey.equals("end_order_date")){
					if(propertyKey.equals("start_order_date")&&!"".equals(propertyValue))
						hhmmss=" 00:00:00";
					if(propertyKey.equals("end_order_date")&&!"".equals(propertyValue))
						hhmmss=" 23:59:59";
					propertyValue=propertyValue + hhmmss;
				}
				parameters.put(propertyKey, propertyValue);
			}
		}catch(Exception ex){}
		return repostDao.getScrollData("OrderReport",parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}

}
