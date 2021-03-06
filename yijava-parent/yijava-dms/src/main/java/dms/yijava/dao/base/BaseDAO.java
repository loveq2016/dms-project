package dms.yijava.dao.base;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

import com.yijava.orm.core.JsonPage;

public interface BaseDAO<T> {

	/**
	 * 根据ID获取对象
	 * 
	 * @param <T>
	 * @param entityClass
	 * @param id
	 * @return
	 */
	@SuppressWarnings("hiding")
	public <T> T get(Serializable id);

	/**
	 * 获取全部对象
	 * 
	 * @param <T>
	 * @param entityClass
	 * @return
	 */
	@SuppressWarnings("hiding")
	public <T> List<T> getAll();

	/**
	 * 新增对象
	 * 
	 * @param o
	 * @return 
	 */
	public int insert(Object o);

	/**
	 * 修改对象
	 * 
	 * @param o
	 */
	public int update(Object o);

	/**
	 * 删除对象
	 * 
	 * @param o
	 */
	public int remove(Object o);

	/**
	 * 根据ID删除对象
	 * 
	 * @param <T>
	 * @param entityClass
	 * @param id
	 */
	
	public int removeById(Serializable id);
	
	/**
	 * 分页查询
	 * 
	 * @param statementId
	 * @param parameters
	 *            参数
	 * @param offset
	 *            开始索引
	 * @param pagesize
	 *            每页显示多少条记录
	 * @return
	 */
	JsonPage<T> getScrollData(int offset, int pagesize);

	/**
	 * 分页查询
	 * 
	 * @param statementId
	 * @param parameters
	 *            参数
	 * @param offset
	 *            开始索引
	 * @param pagesize
	 *            每页显示多少条记录
	 * @return
	 */
	JsonPage<T> getScrollData(Map parameters, int offset, int pagesize);
	
	/**
	 * 分页查询
	 * 
	 * @param statementId
	 * @param parameters
	 *            参数
	 * @param offset
	 *            开始索引
	 * @param pagesize
	 *            每页显示多少条记录
	 * @return
	 */
	JsonPage<T> getScrollData(Map parameters, int offset, int pagesize,String OrderBy,String OrderDir);

	

	/**
	 * sql 查询.
	 * 
	 * @param <T>
	 * @param entityClass
	 * @param sql
	 *            直接sql的语句(需要防止注入式攻击)
	 * @return
	 */
	public <T> List<T> find(String sql);
	
	public <T> List<T> find(Map parameters);
	
	public <T> List<T> find(String postfix_selectmap ,Object o);
	public <T> List<T> findNoParamer(String postfix_selectmap);
}
