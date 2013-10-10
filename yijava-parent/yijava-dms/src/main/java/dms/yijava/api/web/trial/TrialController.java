package dms.yijava.api.web.trial;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;
import com.yijava.orm.core.PropertyFilters;
import com.yijava.web.vo.ErrorCode;
import com.yijava.web.vo.Result;

import dms.yijava.api.web.word.util.TheFreemarker;
import dms.yijava.api.web.word.util.TrialProduct;
import dms.yijava.entity.department.Department;
import dms.yijava.entity.pullstorage.PullStorage;
import dms.yijava.entity.system.SysUser;
import dms.yijava.entity.trial.Trial;
import dms.yijava.entity.trial.TrialDetail;
import dms.yijava.entity.user.UserDealer;
import dms.yijava.service.department.DepartmentService;
import dms.yijava.service.flow.FlowBussService;
import dms.yijava.service.flow.FlowLogService;
import dms.yijava.service.trial.TrialDetailService;
import dms.yijava.service.trial.TrialService;

@Controller
@RequestMapping("/api/protrial")
public class TrialController {

	private static final Logger logger = LoggerFactory
			.getLogger(TrialController.class);
	
	
	@Value("#{properties['trialflow_identifier_num']}")   	
	private String flowIdentifierNumber;
	
	
	@Value("#{properties['document_filepath']}")   	
	private String document_filepath;
	
	
	
	@Autowired
	private TrialService trialService;
	
	@Autowired
	private TrialDetailService trialDetailService;


	@Autowired
	private FlowBussService flowBussService;
	
	@Autowired
	private FlowLogService flowLogService;
	
	@Autowired
	private DepartmentService departmentService;
	

	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<Trial> paging(PageRequest pageRequest,
			HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		
		//找到当前登录用户所拥有的所有销售
		//如果是销售，只查询自己的试用
		//如果是其他用户，根据关系找到所有的销售
		SysUser sysUser=(SysUser)request.getSession().getAttribute("user");
		String currentUserId=sysUser.getId();
		List<Department> deparments=departmentService.getChildDeparmentById(sysUser.getFk_department_id());
		if(deparments==null || deparments.size()<=0)
		{
			//是销售
			filters.add(PropertyFilters.build("ANDS_sales_user_ids", currentUserId));
		}else
		{
			//不是销售，需要找到他对应的所有销售
			filters.add(PropertyFilters.build("ANDS_sales_user_ids", this.listString(sysUser.getUserDealerList())));
			
			filters.add(PropertyFilters.build("ANDS_statuses","1,2,3,4"));
			filters.add(PropertyFilters.build("ANDS_check_id",currentUserId));
			filters.add(PropertyFilters.build("ANDS_flow_id",flowIdentifierNumber));
			
		}
		
		
		
		return trialService.paging(pageRequest, filters);
	}

	@ResponseBody
	@RequestMapping("save")
	public Result<Integer> save(@ModelAttribute("entity") Trial entity,HttpServletRequest request) {
		Result<Integer> result=new Result<Integer>(0, 0);
		try {
			if(entity.getHospital_id()==null)
			{
				entity.setHospital_id(entity.getAddhospital_id());
			}
			
			SimpleDateFormat formatter = new SimpleDateFormat("yyMMdd");
			SysUser sysUser=(SysUser)request.getSession().getAttribute("user");
			String currentUserId=sysUser.getId();
			
			
			Trial trial=trialService.getTrialCode(entity.getDealer_user_id());
			entity.setTrial_code(entity.getDealer_user_id()+"TR"+formatter.format(new Date())+trial.getTrial_no());			
			entity.setTrial_no(String.valueOf((Integer.parseInt(trial.getTrial_no()))));		
			entity.setSales_user_id(currentUserId);			
			if(entity.getStatus()==null)
				entity.setStatus(0);
			trialService.saveEntity(entity);			
			result.setData(1);
			result.setState(1);;
		} catch (Exception e) {
			// TODO Auto-generated catch block
			logger.error("error" + e);
			result.setError(new ErrorCode(e.toString()));
		}

		return result;
	}
	
	
	
	
	
	
	/**
	 * 修改试用申请
	 * @param entity
	 * @return
	 */
	@ResponseBody
	@RequestMapping("update")
	public Result<Integer> update(@ModelAttribute("entity") Trial entity) {
		Result<Integer> result=new Result<Integer>(0, 0);
		try {
			entity.setHospital_id(entity.getAddhospital_id());
			trialService.updateEntity(entity);
			result.setData(1);
			result.setState(1);;
		} catch (Exception e) {
			logger.error("error" + e);
		}
		return result;
	}
	/**
	 * 删除
	 * @param trial_id
	 * @return
	 */
	@ResponseBody
	@RequestMapping("remove")
	public Result<Integer> remove(Integer trial_id) {
		Result<Integer> result=new Result<Integer>(0, 0);
		try {
			Trial entity=trialService.getEntity(trial_id);
			if(entity.getStatus()==0 || entity.getStatus()==2)
			{
				//先删除子
				trialDetailService.removeByTrialId(trial_id);
				trialService.removeEntity(trial_id);
				result.setData(1);
				result.setState(1);;
			}else
			{
				result.setError(new ErrorCode("此单据不可删除"));
			}
			
		} catch (Exception e) {
			logger.error("error" + e);
			result.setError(new ErrorCode(e.toString()));
		}
		return result;
	}

	/*!---------------------以下的方法，提供流程处理第一步骤-----------------------*/
	/**
	 * 修改状态 提交审核
	 * @param trial_id
	 * @param request
	 * @return
	 */
	@ResponseBody
	@RequestMapping("updatetocheck")
	public Result<Integer> updatetocheck(Integer trial_id,HttpServletRequest request) {
		Result<Integer> result=new Result<Integer>(0, 0);
		try {			
						
			///以下开始走流程处理
			SysUser sysUser=(SysUser)request.getSession().getAttribute("user");
			
			if(flowBussService.processFlow(trial_id,sysUser,flowIdentifierNumber))
			{
				
				//更新状态
				trialService.updateEntityStatus(trial_id,1);
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
	public Result<String> viewdocument (Integer trial_id,HttpServletRequest request,HttpServletResponse response) {
		Result<String> result=new Result<String>("0", 0);
		
		Trial entity=trialService.getEntity(trial_id);
		if(entity.getStatus()<3)
		{
			result.setError(new ErrorCode("单据不正确，无法生成文档"));
			return result;
		}
		try {
			String filePath=document_filepath;
			String fileName="trial"+File.separator+"trial-"+trial_id+".doc";
			File outFile = new File(filePath+fileName);			
			TheFreemarker freemarker = new TheFreemarker();
			
			
			Map<String,Object> dataMap = new HashMap<String, Object>();
			
			
			
			
			
			//查找试用明细
			
			 List<TrialDetail> trialDetail=trialDetailService.getTrialDetailByTrialId(trial_id.toString());
			
			
			List<TrialProduct> list = new ArrayList<TrialProduct>();
			int trialSumNum=0;
			for (int j = 0; j < trialDetail.size(); j++) {
				TrialProduct product = new TrialProduct();
				product.setProductname(trialDetail.get(j).getProduct_name());
				product.setProductmodel(trialDetail.get(j).getProduct_name());
				trialSumNum+=trialDetail.get(j).getTrial_num();
				product.setSumnumber(trialDetail.get(j).getTrial_num().toString());
				product.setRemark(trialDetail.get(j).getRemark());
				
				list.add(product);
			}
			dataMap.put("hospital", entity.getHospital_name());
			dataMap.put("requesttime", entity.getCreate_time());
			dataMap.put("reason", entity.getReason());
			dataMap.put("dealer_name", entity.getDealer_name());
			dataMap.put("regionsign", "沈强");
			dataMap.put("principalsign", "车海波");
			dataMap.put("trialSumNum", trialSumNum);
			
			dataMap.put("table", list);
			
			
			
			freemarker.createTrialWord(new FileOutputStream(outFile),dataMap);	
			result.setData(fileName);
			result.setState(1);
		} catch (IOException e) {
			logger.error("生成单据文件错误"+e.toString());
			result.setError(new ErrorCode(e.toString()));
		}  
	    
		return result;
	}
	
	public String listString(List<UserDealer> list) {
		String listString = "";
		for (int i = 0; i < list.size(); i++) {
			try {
				if (i == list.size() - 1) {
					UserDealer ud=list.get(i);
					listString += ud.getUser_id();
				} else {
					UserDealer ud=list.get(i);
					listString += ud.getUser_id() + ",";
				}
			} catch (Exception e) {
			}
		}
		return listString;
	}
	
	
	
	
}
