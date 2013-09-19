package dms.yijava.service.flow;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dms.yijava.api.web.flow.StepController;
import dms.yijava.dao.flow.StepDao;
import dms.yijava.entity.flow.Action;
import dms.yijava.entity.flow.Step;


@Service
@Transactional
public class StepService {

	private static final Logger logger = LoggerFactory.getLogger(StepService.class);
	
	@Autowired
	private StepDao stepDao;
	
	
	/**
	 * 根据流程id得到所有步骤
	 * @param flow_id
	 * @return
	 */
	public List<Step>  getStepByFlow(String flow_id)
	{
		Map<String ,String > map=new HashMap<String,String>();
		map.put("flow_id", flow_id);
		return stepDao.find(map);
	}
	
	public Step getEntity(String id) {
		return stepDao.get(id);
	}

	public void saveEntity(Step entity) {
		stepDao.insert(entity);
	}

	public void updateEntity(Step entity) {
		stepDao.update(entity);
	}

	public void removeEntity(Step entity) {
		stepDao.remove(entity);
	}
	
	/**
	 * 得到第一个步骤 
	 * @return
	 */
	public Step getFirstSetp(Integer flow_id)
	{
		//selectStepByFlowAndOrder
		Step step=new Step();
		step.setFlow_id(flow_id);
		step.setStep_order_no(1);
		
		Step newstep=null;
		try {
			newstep = stepDao.getObject(".selectStepByFlowAndOrder",step);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			logger.error("error"+e.toString());
		}
		return newstep;
		//stepDao.getObject();
	}
	/**
	 * 得到下一个步骤，如果没有返回空，表示流程结束
	 * @param step_order_no
	 * @return
	 */
	public Step getNextSetp(Integer flow_id,Integer step_order_no)
	{
		Step step=new Step();
		step.setFlow_id(flow_id);
		step.setStep_order_no(step_order_no);
		
		Step newstep=null;
		try {
			newstep = stepDao.getObject(".selectStepByFlowAndOrder",step);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			logger.error("error"+e.toString());
		}
		return newstep;
	}
}
