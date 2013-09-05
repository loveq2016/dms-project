package dms.yijava.api.web.product;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;
import com.yijava.orm.core.PropertyFilters;
import com.yijava.web.vo.Result;

import dms.yijava.entity.product.Product;
import dms.yijava.service.product.ProductService;

@Controller
@RequestMapping("/api/product")
public class ProductController {
	

	@Autowired
	private ProductService productService;
	

	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<Product> paging(PageRequest pageRequest,HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return productService.paging(pageRequest,filters);
	}
	
	
	@ResponseBody
	@RequestMapping("save")
	public Result<String> save(@ModelAttribute("entity") Product entity) {
		productService.saveEntity(entity);
		return new Result<String>(entity.getItem_number(), 1);
	}
	
	
	@ResponseBody
	@RequestMapping("update")
	public Result<String> update(@ModelAttribute("entity") Product entity) {
		productService.updateEntity(entity);
		return new Result<String>(entity.getItem_number(), 1);
	}
	
	
	@ResponseBody
	@RequestMapping("delete")
	public Result<String> delete(@RequestParam(value = "id", required = true) String id) {
		productService.deleteEntity(id);
		return new Result<String>(id, 1);
	}
	
	
	
}