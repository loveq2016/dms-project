package dms.yijava.api.web.product;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
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
import dms.yijava.entity.system.SysUser;
import dms.yijava.entity.user.UserDealer;
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
		//filters.add(PropertyFilters.build("ANDS_dealer_id", "9"));
		return productService.paging(pageRequest,filters);
	}
	
	@ResponseBody
	@RequestMapping("api_paging")
	public JsonPage<Product> api_paging(PageRequest pageRequest,HttpServletRequest request) {
		SysUser sysUser = (SysUser) request.getSession().getAttribute("user");
		List<PropertyFilter> filters = PropertyFilters.build(request);
		boolean isDealerId=false;
		for (PropertyFilter propertyFilter : filters) {
			String propertyKey = propertyFilter.getPropertyNames()[0];
			if(propertyKey.equals("dealer_id") || 
					propertyKey.equals("dealer_ids")){
				isDealerId=true;
			}
		}
		if (null != sysUser && !isDealerId) {
			//经销商
			if (!StringUtils.equals("0", sysUser.getFk_dealer_id())) {
				filters.add(PropertyFilters.build("ANDS_dealer_id",sysUser.getFk_dealer_id()));
			}else if(StringUtils.isNotEmpty(sysUser.getTeams())){
				filters.add(PropertyFilters.build("ANDS_dealer_ids", this.listString(sysUser.getUserDealerList())));
			}
		}
		return productService.paging(pageRequest, filters);
	}
	
	@ResponseBody
	@RequestMapping("list")
	public List<Product> list(@RequestParam(value = "category_id", required = false) String id) {
		return productService.getList(id);
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
	
	/**
	 * 把一个list转换为String返回过去
	 */
	public String listString(List<UserDealer> list) {
		String listString = "";
		for (int i = 0; i < list.size(); i++) {
			try {
				if (i == list.size() - 1) {
					UserDealer ud = list.get(i);
					listString += ud.getDealer_id();
				} else {
					UserDealer ud = list.get(i);
					listString += ud.getDealer_id() + ",";
				}
			} catch (Exception e) {
			}
		}
		return listString;
	}
	
}
