package dms.yijava.service.product;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;

import dms.yijava.dao.product.ProductDao;
import dms.yijava.entity.product.Product;

@Service
@Transactional
public class ProductService {

	@Autowired
	private ProductDao productDao;
	
	
	public JsonPage<Product> paging(PageRequest pageRequest,List<PropertyFilter> filters) {
		Map<String,String> parameters = new HashMap<String,String>();
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			parameters.put(propertyKey, propertyFilter.getMatchValue());
		}
		return productDao.getScrollData(parameters, pageRequest.getOffset(),
				pageRequest.getPageSize(), pageRequest.getOrderBy(),
				pageRequest.getOrderDir());
	}

	public Product getEntity(String id) {
		return productDao.get(id);
	}
	
	public void saveEntity(Product entity) {
		productDao.insert(entity);
	}
	
	public void updateEntity(Product entity) {
			productDao.update( entity);
	}
	
	public void deleteEntity(String id) {
			productDao.remove(id);
	}
		

	
	
}
