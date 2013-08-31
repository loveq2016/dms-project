package dms.yijava.api.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;
import com.yijava.orm.core.PropertyFilters;
import com.yijava.web.vo.Result;

import dms.yijava.entity.Hospital;
import dms.yijava.entity.Product;
import dms.yijava.entity.ProductCategory;
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
	
	
	
	
}
