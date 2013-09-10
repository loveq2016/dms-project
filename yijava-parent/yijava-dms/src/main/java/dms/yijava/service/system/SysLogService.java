package dms.yijava.service.system;

import java.text.DateFormat;
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
	
	public JsonPage<SysLog> paging(PageRequest pageRequest,List<PropertyFilter> filters){
		DateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");         
		Map<String,String> parameters = new HashMap<String,String>();
		try{
			for (PropertyFilter propertyFilter : filters) {
				String propertyKey = propertyFilter.getPropertyNames()[0];
				String propertyValue = propertyFilter.getMatchValue();
				String hhmmss="";
				if(propertyKey.equals("start_date"))
					hhmmss=" 00:00:00";
				if(propertyKey.equals("end_date"))
					hhmmss=" 23:59:59";
				Date d2= format.parse(propertyValue + hhmmss);
				parameters.put(propertyKey,Long.toString(d2.getTime()));
			}
		}catch(Exception ex){}
		return sysLogDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}
	
}
