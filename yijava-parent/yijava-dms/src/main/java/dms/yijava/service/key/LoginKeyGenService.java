package dms.yijava.service.key;

import java.text.ParseException;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang3.time.DateUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dms.yijava.api.web.key.UKeyController;
import dms.yijava.dao.key.LoginKeyGenDao;
import dms.yijava.entity.key.LoginKeyGen;

@Service
@Transactional
public class LoginKeyGenService {
	private static final Logger logger = LoggerFactory
			.getLogger(LoginKeyGenService.class);
	@Autowired
	private LoginKeyGenDao loginKeyGenDao;
	
	//清理过期的kegen
	public void clearKeyGen()
	{			
		List<LoginKeyGen> keygens = loginKeyGenDao.getAll();
		
		for(LoginKeyGen keygen:keygens)
		{
			String dateStr=keygen.getCreate_date();
			dateStr=dateStr.substring(0,dateStr.indexOf("."));
			try {
				Date createDate=DateUtils.parseDate(dateStr,"yyyy-MM-dd HH:mm:ss");
				long sq=new Date().getTime()-createDate.getTime();
				if(sq>30*1000)
				{
					removeEntityById(keygen.getId().toString());
					logger.debug("clear keygen"+keygen.getKeygen());
				}
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				logger.debug("clear keygen error:"+keygen.getKeygen());
			}
		}
	}
	

	public LoginKeyGen getEntity(String id) {
		return loginKeyGenDao.get(id);
	}
	
	public void saveEntity(LoginKeyGen entity) {
		loginKeyGenDao.insert(entity);
	}
	
	
	
	
	public List<LoginKeyGen>  getKeyGen(String keygen)
	{			
		return loginKeyGenDao.find(".selectByKeyGen", keygen);		
	}
	
	
	public void removeEntityById(String id) {
		loginKeyGenDao.removeById( id);
	}
}
