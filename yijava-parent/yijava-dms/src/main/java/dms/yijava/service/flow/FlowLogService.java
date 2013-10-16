package dms.yijava.service.flow;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;

import dms.yijava.dao.flow.FlowLogDao;
import dms.yijava.entity.flow.FlowLog;

@Service
@Transactional
public class FlowLogService {

	@Autowired
	private FlowLogDao flowLogDao;

	public List<FlowLog> getLogByFlowAndBusId(String flow_id,String bussiness_id) {
		HashMap<String,String> parameters = new HashMap<String,String>();
		parameters.put("bussiness_id", bussiness_id);
		parameters.put("flow_id", flow_id);
		
		return flowLogDao.find(parameters);
	}
	//按照正序得到审核记录
	public List<FlowLog> getLogByFlowAndBusIdSq(String flow_id,String bussiness_id) {
		HashMap<String,String> parameters = new HashMap<String,String>();
		parameters.put("bussiness_id", bussiness_id);
		parameters.put("flow_id", flow_id);
		
		return flowLogDao.find(".selectByMapSq",parameters);
	}
	
	public int saveEntity(FlowLog entity) {
		return flowLogDao.insert(entity);
	}
}
