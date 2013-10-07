package dms.yijava.service.trial;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dms.yijava.dao.trial.TrialDetailDao;
import dms.yijava.entity.trial.TrialDetail;

@Service
@Transactional
public class TrialDetailService {

	@Autowired
	private TrialDetailDao trialDetailDao;

	public List<TrialDetail> getTrialDetailByTrialId(String trial_id) {
		HashMap<String, String> parameters = new HashMap<String, String>();
		parameters.put("trial_id", trial_id);
		return trialDetailDao.find(parameters);
		// flowRecordDao.find(parameters)
	}

	public TrialDetail getEntity(String id) {
		return trialDetailDao.get(id);
	}

	public void saveEntity(TrialDetail entity) {
		trialDetailDao.insert(entity);
	}

	public void updateEntity(TrialDetail entity) {
		trialDetailDao.update(entity);
	}

	public void removeEntity(TrialDetail entity) {
		trialDetailDao.remove(entity);
	}
}
