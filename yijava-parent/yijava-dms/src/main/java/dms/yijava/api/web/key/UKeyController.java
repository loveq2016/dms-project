package dms.yijava.api.web.key;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yijava.common.utils.EncodeUtils;
import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;
import com.yijava.orm.core.PropertyFilters;
import com.yijava.web.vo.ErrorCode;
import com.yijava.web.vo.Result;

import dms.yijava.entity.key.UKey;
import dms.yijava.entity.system.SysUser;
import dms.yijava.service.key.UKeyService;
import dms.yijava.service.system.SysUserService;

@Controller
@RequestMapping("/api/ukey")
public class UKeyController {

	private static final Logger logger = LoggerFactory
			.getLogger(UKeyController.class);
	@Autowired
	private UKeyService uKeyService;
	@Autowired
	public SysUserService sysUserService;
	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<UKey> paging(PageRequest pageRequest,HttpServletRequest request) {
		try {
			List<PropertyFilter> filters = PropertyFilters.build(request);
			return uKeyService.paging(pageRequest,filters);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
	}
	
	
	@ResponseBody
	@RequestMapping("save")
	public Result<String> save(@ModelAttribute("entity") UKey entity,HttpServletRequest request) {
		Result<String> result=new Result<String>("0", 0);
		try {
			uKeyService.saveEntity(entity);
			
			SysUser sysUser=sysUserService.getEntity(entity.getUserId().toString());
			
			String keycontent=sysUser.getId()+","+sysUser.getAccount();
			String writecontent=sysUser.getId();
			String md5key=EncodeUtils.encoderByMd5(keycontent);
			writecontent+=","+md5key;
			result.setData(writecontent);
			result.setState(1);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			
			logger.error("error" + e);
			result.setError(new ErrorCode("请检查u盾"));
		}
		return result;
	}
	
	
	
	@ResponseBody
	@RequestMapping("remove")
	public Result<Integer> remove(String key_id) {	
		Result<Integer> result=new Result<Integer>(0, 0);
		try {
			uKeyService.removeEntityById(key_id);
			result.setData(1);
			result.setState(1);
		} catch (Exception e) {
			logger.error("error" + e);
			result.setError(new ErrorCode(e.toString()));
		}
		
		return result;
	}
}
