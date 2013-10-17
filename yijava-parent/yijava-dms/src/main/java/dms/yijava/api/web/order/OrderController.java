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
import dms.yijava.entity.order.OrderDetail;
import dms.yijava.entity.system.SysUser;
import dms.yijava.entity.user.UserDealer;
import dms.yijava.service.flow.FlowBussService;
import dms.yijava.service.flow.FlowRecordService;
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
		List<PropertyFilter> filters = PropertyFilters.build(request);
		if(null!=sysUser){
			//经销商
			if(!StringUtils.equals("0",sysUser.getFk_dealer_id())){
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
			entity.setOrder_code("JRKL-"+sysUser.getDealer_code()+"-"+formatter.format(new Date())+"-"+order.getOrder_no());
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
	public Result<Integer> updatetocheck(@ModelAttribute("entity") Order entity,HttpServletRequest request) {
		Result<Integer> result=new Result<Integer>(0, 0);
		try {
			List<OrderDetail> list=orderDetailService.getOrderDetailList(entity.getOrder_code());
			if(null!=list && list.size()>0){
				///以下开始走流程处理
				SysUser sysUser=(SysUser)request.getSession().getAttribute("user");
				if(flowBussService.processFlow(Integer.parseInt(entity.getId()),sysUser,flowIdentifierNumber))
				{
					//更新状态
					orderService.updateStatus(entity.getId(),"1");
					result.setData(1);
					result.setState(1);;
				}else
				{
					return new Result<Integer>(1, 3);
				}
			}else{
				return new Result<Integer>(1, 2);
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
			Order order = orderService.getEntity(Integer.toString(order_id));
			if(Integer.parseInt(order.getOrder_status())<3)
			{
				result.setError(new ErrorCode("单据不正确，无法生成文档"));
				return result;
			}
			TheFreemarker freemarker = new TheFreemarker();		
			Map<String,Object> dataMap = new HashMap<String, Object>();			
			dataMap.put("order_number", order.getOrder_code());
			dataMap.put("order_date",order.getOrder_date());
			dataMap.put("order_region", "");
			dataMap.put("dealer_name", order.getDealer_name());
			dataMap.put("contact_name", order.getBusiness_contacts());
			dataMap.put("contact_phone", order.getBusiness_phone());			
			dataMap.put("accept_address", order.getReceive_addess());
			dataMap.put("accept_name", order.getReceive_linkman());
			dataMap.put("accept_phone",order.getReceive_linkphone());		
			List<OrderDetail> listOrderDetail=orderDetailService.getOrderDetailList(order.getOrder_code());
			List<OrderProdcut> list = new ArrayList<OrderProdcut>();
			for (int j = 0; j<listOrderDetail.size(); j++) {
				OrderDetail orderDetail = listOrderDetail.get(j);
				OrderProdcut orderpro=new OrderProdcut();
				orderpro.setProductname(orderDetail.getProduct_name());
				orderpro.setProductmodel(orderDetail.getModels());
				orderpro.setPrice(orderDetail.getOrder_price());
				orderpro.setSumnumber(orderDetail.getOrder_number_sum());
				orderpro.setSumprice(orderDetail.getOrder_money_sum());
				orderpro.setRemark(orderDetail.getRemark());
				list.add(orderpro);
			}
			dataMap.put("table", list);
			freemarker.createOrderWord(new FileOutputStream(outFile),dataMap);
			result.setData(fileName);
			result.setState(1);
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