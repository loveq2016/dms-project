package dms.yijava.service.flow;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.yijava.common.utils.DateUtils;
import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;

import dms.yijava.dao.flow.FlowRecordDao;
import dms.yijava.entity.flow.Flow;
import dms.yijava.entity.flow.FlowRecord;
import dms.yijava.entity.system.SysRoleFunction;


@Service
@Transactional
public class FlowRecordService {

	@Autowired
	private FlowRecordDao flowRecordDao;
	
	
	/**
	 * 得到待处理事项
	 * @param bussiness_id
	 * @param flow_id
	 * @param check_id
	 * @param status
	 */
	public List<FlowRecord>  getRequetCheck(HashMap<String,String> parameters)
	{
		/*HashMap<String,String> parameters = new HashMap<String,String>();
		parameters.put("bussiness_id", bussiness_id);
		parameters.put("flow_id", flow_id);
		parameters.put("check_id", check_id);
		parameters.put("status", status);*/
		return flowRecordDao.find(parameters);
		//flowRecordDao.find(parameters)
	}
	
	
	/**
	 * 得到待处理事项
	 * @param bussiness_id
	 * @param flow_id
	 * @param check_id
	 * @param status
	 */
	public List<FlowRecord>  getRequetCheck(String bussiness_id,String flow_id,String check_id,String status)
	{
		HashMap<String,String> parameters = new HashMap<String,String>();
		parameters.put("bussiness_id", bussiness_id);
		parameters.put("flow_id", flow_id);
		parameters.put("check_id", check_id);
		parameters.put("status", status);
		return flowRecordDao.find(parameters);
		//flowRecordDao.find(parameters)
	}
	/**
	 * 增加流程记录内容
	 * @param flow_id
	 * @param step_id
	 */
	public void saveFlowByFlowAndStep(String flow_id,String step_id)
	{
		FlowRecord entity=new FlowRecord();
		entity.flow_id=flow_id;
		entity.bussiness_id="1111";
		entity.setTitle("title");
		entity.setSend_id("1111");
		entity.setSend_time(DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
		entity.setCreate_time(DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
		entity.setRemark("提交订单");
		flowRecordDao.insert(entity);
		//entity.set
	}
	
	
	//更新流程记录内容
	public void updateFlowByFlowAndStep(String record_id,String bussiness_id)
	{
		FlowRecord entity=new FlowRecord();
		entity.setRecord_id("2");
		entity.setStatus("1");
		entity.setCheck_time(DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
		entity.setCheck_reason("同意");
		flowRecordDao.update(entity);
	}
	
	
	/*public List<FlowRecord> getList(String bussiness_id){
		HashMap<String,String> parameters = new HashMap<String,String>();
		parameters.put("bussiness_id", bussiness_id);
		return flowRecordDao.find(parameters);
	}*/

	public FlowRecord getEntity(String id) {
		return flowRecordDao.get(id);
	}
	
	public void saveEntity(FlowRecord entity) {
		flowRecordDao.insert(entity);
	}
	
	public void updateEntity(FlowRecord entity) {
		flowRecordDao.update(entity);
	}
	
	public void removeEntity(FlowRecord entity) {
		flowRecordDao.remove( entity);
	}
}
