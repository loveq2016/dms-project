package dms.yijava.service.productCategory;

import java.util.HashMap;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dms.yijava.dao.productCategory.ProductCategoryDao;
import dms.yijava.entity.ProductCategory;

@Service
@Transactional
public class ProductCategoryService {

	@Autowired
	private ProductCategoryDao productCategoryDao;

	public List<ProductCategory> getList(String parent_id){
		HashMap<String,String> parameters = new HashMap<String,String>();
		parameters.put("parent_id", parent_id);
		return productCategoryDao.find(parameters);
	}
	
	public void saveEntity(ProductCategory productCategory) {
		if(StringUtils.isBlank(productCategory.getId())){
			productCategoryDao.insert(productCategory);
		}else{
			productCategoryDao.update(productCategory);
		}
	}
	
	public void deleteEntity(ProductCategory productCategory) {
		productCategoryDao.remove(productCategory);
	}

}
