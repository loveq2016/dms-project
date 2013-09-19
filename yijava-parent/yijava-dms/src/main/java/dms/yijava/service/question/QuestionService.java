package dms.yijava.service.question;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;

import dms.yijava.dao.question.QuestionDao;
import dms.yijava.entity.question.Question;

@Service
@Transactional
public class QuestionService {

	@Autowired
	private QuestionDao  questionDao ;
	

	public JsonPage<Question> paging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return questionDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}

	public Question getEntity(String id) {
		return questionDao.get(id);
	}
	
	public void saveEntity(Question entity) {
		questionDao.insert(entity);
	}
	
	public void updateEntity(Question entity) {
		questionDao.update(entity);
	}
	
	
	public void updateQuestionEntity(Question entity) {
		questionDao.updateObject(".updateQuestion", entity);
	}
	
	
	public void deleteEntity(String id) {
		questionDao.removeById(id);
	}
}
