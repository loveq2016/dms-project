package dms.yijava.service.system;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;

import dms.yijava.dao.system.SysLogDao;
import dms.yijava.entity.system.SysLog;
@Service
@Transactional
public class SysLogService {
	@Autowired
	public SysLogDao sysLogDao;
	
	public JsonPage<SysLog> paging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			  SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
			  Date d2=null;
			  try {
				  d2 = sdf.parse(propertyFilter.getMatchValue());
			  } catch (ParseException e) {}
			parameters.put(propertyKey,Long.toString(d2.getTime()));
		}
		return sysLogDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}
	
}
