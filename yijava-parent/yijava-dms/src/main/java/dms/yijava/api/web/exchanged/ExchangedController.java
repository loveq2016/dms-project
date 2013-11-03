package dms.yijava.api.web.exchanged;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import sun.misc.BASE64Encoder;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;
import com.yijava.orm.core.PropertyFilters;
import com.yijava.web.vo.ErrorCode;
import com.yijava.web.vo.Result;

import dms.yijava.api.web.word.util.TheFreemarker;
import dms.yijava.entity.dealer.Dealer;
import dms.yijava.entity.exchanged.Exchanged;
import dms.yijava.entity.exchanged.ExchangedDetail;
import dms.yijava.entity.flow.FlowLog;
import dms.yijava.entity.storage.StorageDetail;
import dms.yijava.entity.storage.StorageProDetail;
import dms.yijava.entity.system.SysUser;
import dms.yijava.entity.user.UserDealer;
import dms.yijava.service.dealer.DealerService;
import dms.yijava.service.exchanged.ExchangedDetailService;
import dms.yijava.service.exchanged.ExchangedProDetailService;
import dms.yijava.service.exchanged.ExchangedService;
import dms.yijava.service.flow.FlowBussService;
import dms.yijava.service.flow.FlowLogService;
import dms.yijava.service.storage.StorageDetailService;
import dms.yijava.service.storage.StorageDetailService.PullStorageOpt;
import dms.yijava.service.system.SysUserService;
@Controller
@RequestMapping("/api/exchanged")
public class ExchangedController {

	@Autowired
	private ExchangedService exchangedService;
	@Autowired
	private ExchangedDetailService exchangedDetailService;
	@Autowired
	private ExchangedProDetailService exchangedProDetailService;
	@Autowired
	private StorageDetailService storageDetailService;
	@Autowired
	private FlowBussService flowBussService;
	@Value("#{properties['exchangedflow_identifier_num']}")   	
	private String flowIdentifierNumber;
	@Value("#{properties['document_filepath']}")   	
	private String document_filepath;
	@Autowired
	private FlowLogService flowLogService;
	@Autowired
	private DealerService dealerService;
	@Autowired
	public SysUserService sysUserService;
	
	
	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<Exchanged> paging(PageRequest pageRequest,HttpServletRequest request) {
		SysUser sysUser = (SysUser) request.getSession().getAttribute("user");
		String currentUserId = sysUser.getId();
		List<PropertyFilter> filters = PropertyFilters.build(request);
		if (null != sysUser) {
			//经销商
			if (!StringUtils.equals("0", sysUser.getFk_dealer_id())) {
				filters.add(PropertyFilters.build("ANDS_dealer_id",sysUser.getFk_dealer_id()));
			}else if(StringUtils.isNotEmpty(sysUser.getTeams())){
				filters.add(PropertyFilters.build("ANDS_statuses","1,2,3,4"));
				filters.add(PropertyFilters.build("ANDS_dealer_ids", this.listString(sysUser.getUserDealerList())));
			}
			filters.add(PropertyFilters.build("ANDS_check_id",currentUserId));
			filters.add(PropertyFilters.build("ANDS_flow_id",flowIdentifierNumber));
			return exchangedService.paging(pageRequest,filters);
		}
		return null;
	}
	
	
	@ResponseBody
	@RequestMapping("save")
	public  Result<String> save(@ModelAttribute("entity") Exchanged entity, HttpServletRequest request) {
		SysUser sysUser=(SysUser)request.getSession().getAttribute("user");
		SimpleDateFormat formatter = new SimpleDateFormat("yyMMdd");
		SimpleDateFormat formatter2 = new SimpleDateFormat("yyyy-MM-dd");
		//必须是经销商才可以添加出货单
		if(StringUtils.isNotEmpty(sysUser.getFk_dealer_id()) && !"0".equals(sysUser.getFk_dealer_id())){
			try {
				
				Exchanged exchanged =  exchangedService.getExchangedCode(sysUser.getFk_dealer_id());
				exchanged.setExchanged_code(sysUser.getDealer_code()+"AJ"+formatter.format(new Date())+exchanged.getExchanged_no());
				exchanged.setDealer_id(sysUser.getFk_dealer_id());
				exchanged.setType(entity.getType());
				exchanged.setExchanged_date(formatter2.format(new Date()));
				exchangedService.saveEntity(exchanged);
				return new Result<String>(exchanged.getId(), 1);
			} catch (Exception e) {
				e.printStackTrace();
				return new Result<String>("0", 0);
			}
		}else{
			return new Result<String>("2", 2);
		}
	}
	

	@ResponseBody
	@RequestMapping("delete")
	public Result<String> delete(@RequestParam(value = "id", required = true) String id,
			@RequestParam(value = "exchanged_code", required = true) String exchanged_code) {
		try {
			exchangedService.removeEntity(id,exchanged_code);
			return new Result<String>(id, 1);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>(id, 0);
	}
	
	
	
	@ResponseBody
	@RequestMapping("submit")
	public Result<String> submitExchanged(@ModelAttribute("entity") Exchanged entity,HttpServletRequest request) {
		try {
			exchangedService.submitExchanged(entity);
			return new Result<String>("1", 1);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new Result<String>("0", 0);
	}
	
	
	@ResponseBody
	@RequestMapping("updatetocheck")
	public Result<Integer> updatetocheck(Integer exchanged_id,HttpServletRequest request) {
		Result<Integer> result = new Result<Integer>(0, 0);
		try {				
				List<Object> list = exchangedService.processExchanged(String.valueOf(exchanged_id));
				PullStorageOpt pullStorageOpt = storageDetailService.updateStorageLockSn((List<StorageDetail>)list.get(0),(List<StorageProDetail>)list.get(1));
				if(pullStorageOpt!=null && "success".equals(pullStorageOpt.getStatus()) 
						&& pullStorageOpt.getList().size() > 0){//库存减少、锁定sn 返回状态
					//以下开始走流程处理
					SysUser sysUser = (SysUser) request.getSession().getAttribute("user");
					if(flowBussService.processFlow(exchanged_id,sysUser,flowIdentifierNumber)){//提交流程
					/*20131025zhjt修改，为自定义指定流程处理人*/
					//if(flowBussService.processAllocateFlow(exchanged_id,sysUser,flowIdentifierNumber)){//提交流程
					//更新状态
						exchangedService.updateExchangedStatus(String.valueOf(exchanged_id), "1");//流程成功、更新业务的状态为提交审核
						result.setData(1);
						result.setState(1);;
					}else{
						storageDetailService.rollBackStorageUnLockSn((List<StorageDetail>)list.get(0),(List<StorageProDetail>)list.get(1));//流程失败，回滚库存与sn
						result.setError(new ErrorCode("出现系统错误，处理流程节点"));
					}
				}else{
					result.setError(new ErrorCode("出现系统错误，处理流程节点"));
				}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	
	@ResponseBody
	@RequestMapping("viewdocument")
	public Result<String> viewdocument (String exchanged_id,HttpServletRequest request,HttpServletResponse response) {
		Result<String> result=new Result<String>("0", 0);
		
		
		Exchanged entity = exchangedService.getEntity(exchanged_id);
		

		if (Integer.parseInt(entity.getStatus()) < 3) {
			result.setError(new ErrorCode("单据不正确，无法生成文档"));
			return result;
		}
		try {
			DateFormat format2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String generatePath = request.getSession().getServletContext().getRealPath("generate");
			String fileName="exchanged/exchanged-"+exchanged_id+".doc";
			File outFile = new File(generatePath + File.separator + fileName);		
			TheFreemarker freemarker = new TheFreemarker();
			Map<String, Object> dataMap = new HashMap<String, Object>();
			
			Dealer dealer = dealerService.getEntity(entity.getDealer_id());
			//查找明细
			List<ExchangedDetail>	list = exchangedDetailService.selectExchangedDetailWordMap(entity.getExchanged_code());
			
			dataMap.put("dealer_name", dealer.getDealer_name());
			dataMap.put("remark", entity.getRemark()==null?"":entity.getRemark());
			dataMap.put("create_date",entity.getExchanged_date());
			dataMap.put("total","");
			
			//查找该流程的处理记录,找到签名文件
			List<FlowLog> flowlogs= flowLogService.getLogByFlowAndBusIdSq(flowIdentifierNumber, exchanged_id);
			String xiaoshou = "", jingli = "", lingdao = "";
			String xiaoshoudate="",jinglidate="",lingdaodate="";
			String sign_Path = request.getSession().getServletContext().getRealPath("resource");
			sign_Path+=File.separator+ "signimg";
			for (FlowLog flowLog : flowlogs) {
				
				if (flowLog.getSign() != null && !"".equals(flowLog.getSign())) {
					
					String userId = flowLog.getUser_id();
					SysUser sysUser = sysUserService.getEntity(userId);
					if (sysUser.getDepartment_name().indexOf("销售")>-1)
					{
						jinglidate = format2.format(format2.parse(flowLog.getCreate_date()));
						jingli= sign_Path+File.separator+flowLog.getSign();
					}
					if (sysUser.getDepartment_name().indexOf("大区")>-1)
					{
						xiaoshoudate = format2.format(format2.parse(flowLog.getCreate_date()));
						xiaoshou= sign_Path+File.separator+flowLog.getSign();

					}
					if (sysUser.getDepartment_name().indexOf("分管 负责人")>-1)
					{
						lingdaodate = format2.format(format2.parse(flowLog.getCreate_date()));
						lingdao= sign_Path+File.separator+flowLog.getSign();
					}
					
					
					/*
					if(flowLog.action_name.indexOf("销售代表审核")>-1)
					{
						xiaoshoudate = format2.format(format2.parse(flowLog.getCreate_date()));
						xiaoshou= sign_Path+File.separator+flowLog.getSign();
					}
					if (flowLog.action_name.indexOf("区域经理审核") > -1) {
						jinglidate = format2.format(format2.parse(flowLog.getCreate_date()));
						jingli= sign_Path+File.separator+flowLog.getSign();
						
					}
					if (flowLog.action_name.indexOf("分管领导审核") > -1) {
						lingdaodate = format2.format(format2.parse(flowLog.getCreate_date()));
						lingdao= sign_Path+File.separator+flowLog.getSign();
					}
					*/
				}
			}
			dataMap.put("xiaoshou", getImageStr(xiaoshou));
			dataMap.put("jingli", getImageStr(jingli));
			dataMap.put("lingdao", getImageStr(lingdao));
			dataMap.put("xiaoshoudate", xiaoshoudate);
			dataMap.put("jinglidate", jinglidate);
			dataMap.put("lingdaodate", lingdaodate);
			dataMap.put("table", list);
			freemarker.createExchangedWord(new FileOutputStream(outFile),dataMap);	

			result.setData(fileName);
			result.setState(1);
		} catch (Exception e) {
			e.printStackTrace();
			result.setError(new ErrorCode(e.toString()));
		}  
	    
		return result;
	}
	
	
	private String getImageStr(String imagename) {
		if(StringUtils.isEmpty(imagename))
			return "";
        String imgFile = imagename;//"d:/10049_qz.jpg";
        InputStream in = null;
        byte[] data = null;
        try {
            in = new FileInputStream(imgFile);
            data = new byte[in.available()];
            in.read(data);
            in.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        BASE64Encoder encoder = new BASE64Encoder();
        return encoder.encode(data);
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
