package dms.yijava.api.web.order;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;
import com.yijava.orm.core.PropertyFilters;
import com.yijava.web.vo.ErrorCode;
import com.yijava.web.vo.Result;

import dms.yijava.api.web.word.util.OrderProdcut;
import dms.yijava.api.web.word.util.TheFreemarker;
import dms.yijava.entity.order.Order;
import dms.yijava.entity.system.SysUser;
import dms.yijava.entity.user.UserDealer;
import dms.yijava.service.flow.FlowBussService;
import dms.yijava.service.order.OrderDetailService;
import dms.yijava.service.order.OrderService;

@Controller
@RequestMapping("/api/order")
public class OrderController {
	private static final Logger logger = LoggerFactory.getLogger(OrderController.class);
	
	@Value("#{properties['orderflow_identifier_num']}")   	
	private String flowIdentifierNumber;
	@Autowired
	private OrderService orderService;
	@Autowired
	private OrderDetailService orderDetailService;
	@Autowired
	private FlowBussService flowBussService;
	
	@Value("#{properties['document_filepath']}")   	
	private String document_filepath;
	
	
	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<Order> paging(PageRequest pageRequest,HttpServletRequest request) {
		SysUser sysUser=(SysUser)request.getSession().getAttribute("user");
		String currentUserId=sysUser.getId();
		List<PropertyFilter> filters = PropertyFilters.build(request);
		if(null!=sysUser){
			//经销商
			if(!StringUtils.equals("0",sysUser.getFk_dealer_id())){
				filters.add(PropertyFilters.build("ANDS_dealer_id",sysUser.getFk_dealer_id()));
			}else if(StringUtils.isNotEmpty(sysUser.getTeams())){
				filters.add(PropertyFilters.build("ANDS_dealer_ids", this.listString(sysUser.getUserDealerList())));
				filters.add(PropertyFilters.build("ANDS_statuses","1,2,3,4,5,6"));
				filters.add(PropertyFilters.build("ANDS_check_id",currentUserId));
				filters.add(PropertyFilters.build("ANDS_flow_id",flowIdentifierNumber));
			}
			return orderService.paging(pageRequest,filters);
		}
		return null;
	}
	
	@ResponseBody
	@RequestMapping("api_paging")
	public JsonPage<Order> api_paging(PageRequest pageRequest,HttpServletRequest request) {
		SysUser sysUser=(SysUser)request.getSession().getAttribute("user");
		//String currentUserId=sysUser.getId();
		List<PropertyFilter> filters = PropertyFilters.build(request);
		if(null!=sysUser){
			//经销商
			if(!StringUtils.equals("0",sysUser.getFk_dealer_id())){
				//filters.add(PropertyFilters.build("ANDS_dealer_id",sysUser.getFk_dealer_id()));
				return null;
			}else if(StringUtils.isNotEmpty(sysUser.getTeams())){
				filters.add(PropertyFilters.build("ANDS_dealer_ids", this.listString(sysUser.getUserDealerList())));
				filters.add(PropertyFilters.build("ANDS_statuses","3,5"));
				return orderService.paging(pageRequest,filters);
			}
			
		}
		return null;
	}
	
	
	
	@ResponseBody
	@RequestMapping("list")
	public List<Order> getList(){
		return orderService.getList();
	}
	
	@ResponseBody
	@RequestMapping("save")
	public Result<Integer> save(@ModelAttribute("entity") Order entity,HttpServletRequest request) {
		SysUser sysUser=(SysUser)request.getSession().getAttribute("user");
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
		//必须是经销商才可以添加订单
		if(StringUtils.isNotEmpty(sysUser.getFk_dealer_id())){
			Order order=orderService.getOrderNum(sysUser.getFk_dealer_id());
			entity.setOrder_code("JRKL-"+formatter.format(new Date())+"-"+order.getOrder_no());
			entity.setOrder_no(String.valueOf((Integer.parseInt(order.getOrder_no()))));
			entity.setDealer_name(sysUser.getDealer_name());
			entity.setDealer_id(sysUser.getFk_dealer_id());
			orderService.saveEntity(entity);
			return new Result<Integer>(1, 1);
		}else{
			return new Result<Integer>(1, 0);
		}
	}
	
	@ResponseBody
	@RequestMapping("updateAddress")
	public Result<Integer> updateAddress(@ModelAttribute("entity") Order entity) {
		orderService.updateAddress(entity);
		return new Result<Integer>(1, 1);
	}
	
	@ResponseBody
	@RequestMapping("remove")
	public Result<Integer> remove(@RequestParam(value = "id", required = false) String id) {
		orderService.removeEntity(id);
		orderDetailService.removeByOrderCodeEntity(id);
		return new Result<Integer>(1, 1);
	}
	
	/**
	 * 修改状态 提交审核
	 * @param trial_id
	 * @param request
	 * @return
	 */
	@ResponseBody
	@RequestMapping("updatetocheck")
	public Result<Integer> updatetocheck(Integer order_id,HttpServletRequest request) {
		Result<Integer> result=new Result<Integer>(0, 0);
		try {
			///以下开始走流程处理
			SysUser sysUser=(SysUser)request.getSession().getAttribute("user");
			if(flowBussService.processFlow(order_id,sysUser,flowIdentifierNumber))
			{
				//更新状态
				orderService.updateStatus(order_id.toString(),"1");
				result.setData(1);
				result.setState(1);;
			}else
			{
				result.setError(new ErrorCode("出现系统错误，处理流程节点"));
			}
		} catch (Exception e) {
			logger.error("error" + e);
		}
		return result;
	}
	
	
	@ResponseBody
	@RequestMapping("viewdocument")
	public Result<String> viewdocument (Integer order_id,HttpServletRequest request,HttpServletResponse response) {
		Result<String> result=new Result<String>("0", 0);
		
		try {
			String filePath=document_filepath;
			String fileName="order"+File.separator+"order-"+order_id+".doc";
			File outFile = new File(filePath+fileName);		
			
			TheFreemarker freemarker = new TheFreemarker();		
			Map<String,Object> dataMap = new HashMap<String, Object>();			
			dataMap.put("order_number", "订单号");
			dataMap.put("order_date","日期");
			dataMap.put("order_region", "供货区域");
			dataMap.put("dealer_name", "经销商名字");
			dataMap.put("contact_name", "联系人名字");
			dataMap.put("contact_phone", "联系人电话");			
			dataMap.put("accept_address", "收货人地址");
			dataMap.put("accept_name", "收货人名字");
			dataMap.put("accept_phone", "收货人电话");			
			List<OrderProdcut> list = new ArrayList<OrderProdcut>();
			for (int j = 0; j < 2; j++) {
				OrderProdcut order=new OrderProdcut();
				order.setProductname("dd");
				order.setProductmodel("ee");
				order.setPrice("price");
				order.setSumnumber("10");
				order.setSumprice("1100");
				order.setRemark("beizhu");
				list.add(order);
			}			
			dataMap.put("table", list);
			freemarker.createOrderWord(new FileOutputStream(outFile),dataMap);
		} catch (FileNotFoundException e) {
			logger.error("生成单据文件错误"+e.toString());
			result.setError(new ErrorCode(e.toString()));
		}
		
		return result;
	}
	/**
	 * 把一个list转换为String返回过去
	 */
	public String listString(List<UserDealer> list) {
		String listString = "";
		for (int i = 0; i < list.size(); i++) {
			try {
				if (i == list.size() - 1) {
					UserDealer ud=list.get(i);
					listString += ud.getDealer_id();
				} else {
					UserDealer ud=list.get(i);
					listString += ud.getDealer_id() + ",";
				}
			} catch (Exception e) {
			}
		}
		return listString;
	}
}