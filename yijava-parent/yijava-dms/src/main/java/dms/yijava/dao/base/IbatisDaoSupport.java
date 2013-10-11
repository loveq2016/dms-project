package dms.yijava.dao.base;

import java.io.Serializable;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.ObjectRetrievalFailureException;

import com.yijava.common.utils.ReflectionUtils;
import com.yijava.orm.core.JsonPage;

public class IbatisDaoSupport<T> extends SqlSessionDaoSupport implements
		BaseDAO<T> {

	public static final String POSTFIX_INSERT = ".insert";
	public static final String POSTFIX_UPDATE = ".update";
	public static final String POSTFIX_DELETE = ".delete";
	public static final String POSTFIX_SELECTALL = ".selectAll";
	
	public static final String POSTFIX_DELETE_PRIAMARYKEY = ".deleteByPrimaryKey";
	public static final String POSTFIX_SELECT = ".select";
	
	public static final String POSTFIX_SELECTMAP = ".selectByMap";
	public static final String POSTFIX_SELECTMAP_COUNT = ".selectByMap.count";
	public static final String POSTFIX_SELECTOBJECT = ".selectByObject";
	public static final String POSTFIX_SELECTOBJECT_COUNT = ".selectByObjectcount";
	public static final String POSTFIX_SELECTSQL = ".selectBySql";
	public static final String POSTFIX_COUNT = ".count";

	
	protected Class<T> entityClass;	

	/**
	 * ���췽��
	 */
	public IbatisDaoSupport() {
		entityClass = ReflectionUtils.getSuperClassGenricType(getClass());
	}

	/**
	 * ���췽��
	 * 
	 * @param entityClass ormʵ������class
	 */
	public IbatisDaoSupport(Class<T> entityClass) {
		this.entityClass = entityClass;
	}	
	

	@Autowired
	public void setSqlSessionFactory(SqlSessionFactory sqlSessionFactory) {
		super.setSqlSessionFactory(sqlSessionFactory);
	}

	@Override
	public <T> T get(Serializable id) {
		@SuppressWarnings("unchecked")
		T o = (T) this.getSqlSession().selectOne(entityClass.getSimpleName() + POSTFIX_SELECT, id);		
		if (o == null) {
			throw new ObjectRetrievalFailureException(entityClass, id);
		}
		return o;
	}

	@Override
	public <T> List<T> getAll() {		
		return getSqlSession().selectList(entityClass.getSimpleName() + POSTFIX_SELECTALL);		
	}

	@Override
	public int insert(Object o) {		
		return getSqlSession().insert(entityClass.getSimpleName() + POSTFIX_INSERT, o);  
	}

	

	@Override
	public int remove(Object o) {		
		 return getSqlSession().delete(entityClass.getSimpleName() + POSTFIX_DELETE, o);  
	}

	@Override
	public int removeById(Serializable id) {		
		return getSqlSession().delete(entityClass.getSimpleName() + POSTFIX_DELETE_PRIAMARYKEY, id);  
	}
	

	@Override
	public int update(Object o) {		
		 return getSqlSession().update(entityClass.getSimpleName() + POSTFIX_UPDATE, o);  
	}
	
	@Override
	public JsonPage<T> getScrollData(int offset, int pagesize) {		
		return this.getScrollData(new HashMap(), offset, pagesize, null,null);
		//return null;
	}
	@Override
	public JsonPage<T> getScrollData(Map parameters, int offset, int pagesize) {		
		return this.getScrollData(parameters, offset, pagesize, null,null);
		//return null;
	}
	@Override
	public JsonPage<T> getScrollData(Map parameters, int offset, int pagesize,String OrderBy,String OrderDir) {		
		Long total = (Long) getSqlSession().selectOne(entityClass.getSimpleName() + POSTFIX_SELECTOBJECT_COUNT,parameters);		
		parameters.put("offset", offset);
		parameters.put("pagesize", pagesize);
		parameters.put("orderSql", OrderBy + " " + OrderDir);
		List<T> datas = getSqlSession().selectList(entityClass.getSimpleName() + POSTFIX_SELECTOBJECT, parameters);
		return new JsonPage<T>(datas,total);
		//return null;
	}
	
	



	@Override
	public <T> List<T> find(String sql) {
		return getSqlSession().selectList(sql);
	}
	@Override
	public <T> List<T> find(Map parameters) {
		return getSqlSession().selectList(entityClass.getSimpleName() + POSTFIX_SELECTMAP,parameters);
	}
	public <T> List<T> findObject(String postfix_selectmap,Object o) {
		return getSqlSession().selectList(entityClass.getSimpleName() + postfix_selectmap,o);
	}
	

	public <T> T getObject(String postfix_selectmap ,Object o) {
		@SuppressWarnings("unchecked")
		T obj = (T) this.getSqlSession().selectOne(entityClass.getSimpleName() + postfix_selectmap,o);		
		return obj;
	}
	public <T> T getObject(String postfix_selectmap ,String o) {
		@SuppressWarnings("unchecked")
		T obj = (T) this.getSqlSession().selectOne(entityClass.getSimpleName() + postfix_selectmap,o);		
		return obj;
	}
	public int removeObject(String postfix_selectmap ,Object o) {		
		 return getSqlSession().delete(entityClass.getSimpleName() + postfix_selectmap, o);  
	}
	public int updateObject(String postfix_selectmap ,Object o) {		
		 return getSqlSession().update(entityClass.getSimpleName() + postfix_selectmap, o);  
	}
	public int insertObject(String postfix_selectmap ,Object o) {		
		 return getSqlSession().insert(entityClass.getSimpleName() + postfix_selectmap, o);  
	}

	@Override
	public <T> List<T> find(String postfix_selectmap, Object o) {
		// TODO Auto-generated method stub
		return getSqlSession().selectList(entityClass.getSimpleName() + postfix_selectmap,o);
	}

	public <T> List<T> findNoParamer(String postfix_selectmap)
	{
		return getSqlSession().selectList(entityClass.getSimpleName() + postfix_selectmap);
	}

}
