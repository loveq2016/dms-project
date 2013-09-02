package dms.yijava.api.web;

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yijava.web.vo.Result;

import dms.yijava.entity.product.ProductCategory;
import dms.yijava.service.productCategory.ProductCategoryService;

@Controller
@RequestMapping("/api/productCategory")
public class ProductCategoryController {

	@Autowired
	private ProductCategoryService productCategoryService;
	

	@ResponseBody
	@RequestMapping("list")
	public List<ProductCategory> list(@RequestParam(value = "id", required = false) String id) {
		id = StringUtils.isBlank(id) == true ? "-1" : id;
		return productCategoryService.getList(id);
	}
	
	
	@ResponseBody
	@RequestMapping("save")
	public Result<String> save(@ModelAttribute("entity") ProductCategory entity) {
		productCategoryService.saveEntity(entity);
		return new Result<String>(entity.getParent_id(), 1);
	}
	
	
	@ResponseBody
	@RequestMapping("remove")
	public Result<String> remove(@ModelAttribute("entity") ProductCategory entity) {
		productCategoryService.deleteEntity(entity);
		return new Result<String>(entity.getId(), 1);
	}
	
	
}
