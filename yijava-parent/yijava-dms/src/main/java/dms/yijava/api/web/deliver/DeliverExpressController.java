package dms.yijava.api.web.deliver;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yijava.common.utils.DateUtils;
import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;
import com.yijava.orm.core.PropertyFilters;
import com.yijava.web.vo.Result;

import dms.yijava.entity.deliver.Deliver;
import dms.yijava.entity.deliver.DeliverExpressDetail;
import dms.yijava.entity.flow.FlowRecord;
import dms.yijava.entity.order.Order;
import dms.yijava.entity.system.SysUser;
import dms.yijava.service.deliver.DeliverExpressDetailService;
import dms.yijava.service.deliver.DeliverService;
import dms.yijava.service.flow.FlowRecordService;
import dms.yijava.service.order.OrderService;
import dms.yijava.service.system.SysUserService;

@Controller
@RequestMapping("/api/deliverExpress")
public class DeliverExpressController {
	@Autowired
	private DeliverService deliverService;
	@Autowired
	private OrderService orderService;
	@Autowired
	private DeliverExpressDetailService deliverExpressDetailService;
	
	@Autowired
	private FlowRecordService flowRecordService;
	@Autowired
	private SysUserService sysUserService;
	//发货提醒
	@Value("#{properties['sendproduct_identifier_num']}")   	
	private String sendproduct_identifier_num;
	
	//收货提醒
	@Value("#{properties['reciveproduct_identifier_num']}")   	
	private String reciveproduct_identifier_num;
	
	
	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<DeliverExpressDetail> paging(PageRequest pageRequest,HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		return deliverExpressDetailService.paging(pageRequest,filters);
	}
	
	@ResponseBody
	@RequestMapping("save")
	public Result<String> save(@ModelAttribute("entity") DeliverExpressDetail entity) {
		entity.setUser_id("13");
		try {
			DeliverExpressDetail tempDeliverExpressDetail =  deliverExpressDetailService.selectSumById(entity.getDelivery_detail_id());
			if(tempDeliverExpressDetail ==null){//产品空
				if(Integer.parseInt(entity.getExpress_num()) <=  Integer.parseInt(entity.getDeliver_number_sum())){
					deliverExpressDetailService.saveEntity(entity);
					return new Result<String>(entity.getId(), 1);
				}else{
					return new Result<String>(entity.getId(), 2);
				}
			}else{
				int count = Integer.parseInt(tempDeliverExpressDetail.getExpress_num()) + Integer.parseInt(entity.getExpress_num());
				if(count <=  Integer.parseInt(entity.getDeliver_number_sum())){
					DeliverExpressDetail existsDeliverExpressDetail = deliverExpressDetailService.selectSn(entity);
					if (existsDeliverExpressDetail == null) {
						deliverExpressDetailService.saveEntity(entity);
					}else{
						entity.setId(existsDeliverExpressDetail.getId());
						deliverExpressDetailService.updateEntity(entity);
					}
					return new Result<String>(entity.getId(), 1);
				}else{
					return new Result<String>(entity.getId(), 2);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>(entity.getId(),0);
	}

	
	@ResponseBody
	@RequestMapping("delete")
	public Result<String> delete(@RequestParam(value = "id", required = true) String id) {
		try {
			deliverExpressDetailService.deleteEntity(id);
			return new Result<String>(id, 1);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>(id, 0);
	}
	
	
	@ResponseBody
	@RequestMapping("submitExpress")
	public Result<String> submitExpress(@ModelAttribute("entity") DeliverExpressDetail entity) {
		
		try {
			Deliver deliver =   deliverService.getEntity(Integer.parseInt(entity.getDeliver_id()));
			DeliverExpressDetail checkDeliverExpressDetail =  deliverExpressDetailService.checkSn(entity.getDeliver_code());
			if (checkDeliverExpressDetail == null) {
				return new Result<String>("1", 2);
			}
			if(checkDeliverExpressDetail.getExprees_total().equals(checkDeliverExpressDetail.getSn_total())){
				Deliver deliverEntity = new Deliver();
				deliverEntity.setDeliver_code(entity.getDeliver_code());
				deliverEntity.setExpress_code(entity.getExpress_code());
				deliverEntity.setExpress_date(entity.getExpress_date());
				deliverService.submitExpress(deliverEntity);
				Order orderEntity = new Order();
				orderEntity.setOrder_code(entity.getOrder_code());
				orderEntity.setOrder_status(entity.getDeliver_status());
				orderEntity.setExpress_code(entity.getExpress_code());
				orderService.submitExpress(orderEntity);
				
				try {
					if (deliver.getConsignee_status() == null) {
						List<SysUser> users = sysUserService.getListByDepartmentId("86");
						//关闭发货提醒
						flowRecordService.updateFlowByFlowUB(sendproduct_identifier_num, users.get(0).getId(), entity.getDeliver_id(), "", "1");
						//开始收货提醒
						 if(users!=null && users.size()>0)
						 {
							FlowRecord flowRecord = new FlowRecord();
							flowRecord.setFlow_id(reciveproduct_identifier_num);
							flowRecord.setBussiness_id(entity.getDeliver_id());		
							flowRecord.setTitle("待收货");
							flowRecord.setSend_id("0000000000");//只做提醒，所以此处设置了全0
							flowRecord.setCheck_id(deliver.getDealer_id());//经销商id 取登录人的id
							flowRecord.setSend_time(DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
							flowRecord.setCreate_time(DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));			
							flowRecord.setStatus("0");
							//entity.setStep_order_no(step_order_no);
							flowRecordService.saveEntity(flowRecord);
						 }
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
				
				
				return new Result<String>("1", 1);
			}else{
				return new Result<String>("1", 2);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return new Result<String>("1", 0);
	}
	
	
	
	
	
	
}
