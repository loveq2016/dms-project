package dms.yijava.api.web.system;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

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
import org.springframework.web.multipart.MultipartFile;

import com.yijava.common.utils.EncodeUtils;
import com.yijava.orm.core.JsonPage;
import com.yijava.orm.core.PageRequest;
import com.yijava.orm.core.PropertyFilter;
import com.yijava.orm.core.PropertyFilters;
import com.yijava.web.vo.ErrorCode;
import com.yijava.web.vo.Result;

import dms.yijava.entity.system.SysUser;
import dms.yijava.service.system.SysUserService;

@Controller
@RequestMapping("/api/sysuser")
public class SysUserController {
	private static final Logger logger = LoggerFactory.getLogger(SysUserController.class);
	
	@Value("#{properties['sign_filepath']}")   	
	private String sign_filepath;
	
	@Autowired
	public SysUserService sysUserService;
	
	@ResponseBody
	@RequestMapping("paging")
	public JsonPage<SysUser> paging(PageRequest pageRequest,HttpServletRequest request) {
		List<PropertyFilter> filters = PropertyFilters.build(request);
		logger.info("查询用户信息");
		return sysUserService.paging(pageRequest,filters);
	}
	
	@ResponseBody
	@RequestMapping("read")
	public SysUser read(@RequestParam(value = "id", required = false) String id) {
		SysUser sysUser=sysUserService.getEntity(id);
		return sysUser;
	}
	
	@ResponseBody
	@RequestMapping("save")
	public Result<String> save(@ModelAttribute("entity") SysUser entity) {
		
		String password=entity.getPassword();
		if(password!=null && StringUtils.isNotEmpty(password))
		{
			try {
				password=EncodeUtils.encoderByMd5(password);
				
			} catch (NoSuchAlgorithmException e1) {
				
				
			} catch (UnsupportedEncodingException e1) {
				
			}
		}
		entity.setPassword(password);
		sysUserService.saveEntity(entity);
		
		logger.info("保存用户信息");
		return new Result<String>(entity.getId(), 1);
	}
	
	@ResponseBody
	@RequestMapping("update")
	public Result<String> update(@ModelAttribute("entity") SysUser entity) {
		
		String password=entity.getPassword();
		if(password!=null && StringUtils.isNotEmpty(password))
		{
			try {
				password=EncodeUtils.encoderByMd5(password);
				
			} catch (NoSuchAlgorithmException e1) {
				
				
			} catch (UnsupportedEncodingException e1) {
				
			}
		}
		entity.setPassword(password);
		sysUserService.updateEntity(entity);
		logger.info("修改用户信息");
		return new Result<String>(entity.getId(), 1);
	}
	
	@ResponseBody
	@RequestMapping("remove")
	public Result<String> remove(@RequestParam(value = "id", required = false) String id) {
		sysUserService.deleteEntity(id);
		logger.info("删除用户信息");
		return new Result<String>(id, 1);
	}
	
	/**
	 * 修改密码
	 * @param currentpwd
	 * @param newpwd
	 * @param confirmpwd
	 * @return
	 */
	@ResponseBody
	@RequestMapping("updatepwd")
	public Result<Integer> updatepwd(@RequestParam(value = "currentpwd", required = true) String currentpwd,
			@RequestParam(value = "newpwd", required = true) String newpwd,
			@RequestParam(value = "confirmpwd", required = true) String confirmpwd,HttpServletRequest request) {
		Result<Integer> result=new Result<Integer>(0, 0);
		
		SysUser sessionUser=(SysUser)request.getSession().getAttribute("user");
		
		if(!StringUtils.equals(newpwd, confirmpwd)){
			//sysUserService.updateEntity(entity);
			result.setError(new ErrorCode("两次密码不相同"));
		}else
		{
			/**
			 * 校验老密码是否相同
			 */
			SysUser sysUser=new SysUser();
			sysUser.setAccount(sessionUser.getAccount());
			sysUser = sysUserService.getEntityByAccount(sysUser);
			try {
				currentpwd=EncodeUtils.encoderByMd5(currentpwd);
				newpwd=EncodeUtils.encoderByMd5(newpwd);
			} catch (NoSuchAlgorithmException e1) {
				result.setError(new ErrorCode(e1.toString()));
				return result;
			} catch (UnsupportedEncodingException e1) {
				result.setError(new ErrorCode(e1.toString()));
				return result;
			}
			if(isExsitUser(sysUser,currentpwd)){
				SysUser newSysUser=new SysUser();
				newSysUser.setId(sysUser.getId());
				newSysUser.setPassword(newpwd);
				
				try {
					sysUserService.updateUserPassword(newSysUser);
					result.setState(1);
					result.setData(1);
				} catch (Exception e) {
					result.setError(new ErrorCode(e.toString()));
				}
			}else
			{
				result.setError(new ErrorCode("密码错误"));
			}
			logger.info("修改用户密码");
		}
		
		
		return result;
	}
	
	
	private boolean isExsitUser(SysUser user,String password) {
		if (user != null && !"".equals(user)) {
			if (user.getPassword().equals(password)) {
				return true;
			} else {
				return false;
			}
		}
		return false;
	}
	/**
	 * 修改密码
	 * @param currentpwd
	 * @param newpwd
	 * @param confirmpwd
	 * @return
	 */
	@ResponseBody
	@RequestMapping("updateinfo")
	public Result<Integer> updateinfo(@ModelAttribute("entity") SysUser entity,HttpServletRequest request,@RequestParam("file") MultipartFile file) {
		Result<Integer> result=new Result<Integer>(0, 0);				
		try {
			SysUser sessionUser=(SysUser)request.getSession().getAttribute("user");
			entity.setId(sessionUser.getId());
			
			if (!file.isEmpty()) {
				String fileExtName=file.getOriginalFilename();
				fileExtName=fileExtName.substring(fileExtName.indexOf("."),fileExtName.length());
				String fileName=sessionUser.getId()+"_qz"+fileExtName;
				//byte[] bytes = file.getBytes();
				// 去理上传写文件代码  
				try {
					copyFile(file.getInputStream(),fileName);
					entity.setSign_img(fileName);
				} catch (Exception e) {
					logger.error("上传签名文件错误!"+e.toString());
				}
				
				  
			} 
			
			
			sysUserService.updateUserInfo(entity);
			result.setState(1);
			result.setData(1);
		} catch (Exception e) {
			result.setError(new ErrorCode(e.toString()));
		}
		return result;
	}
	
	
	 private void copyFile(InputStream in,String fileName) throws IOException{  
         FileOutputStream fs = new FileOutputStream(sign_filepath  
                   + fileName);  
           byte[] buffer = new byte[1024 * 1024];  
           int bytesum = 0;  
           int byteread = 0;  
           while ((byteread = in.read(buffer)) != -1) {  
               bytesum += byteread;  
               fs.write(buffer, 0, byteread);  
               fs.flush();  
           }  
           fs.close();  
           in.close();  
     }  
}
