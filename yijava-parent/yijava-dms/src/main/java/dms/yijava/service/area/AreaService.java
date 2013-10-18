package dms.yijava.service.area;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dms.yijava.dao.area.AreaDao;
import dms.yijava.entity.area.Area;

@Service
@Transactional
public class AreaService {
	
	@Autowired
	private AreaDao  areaDao ;
	
	/**
	 * 根据父得到所有子
	 * @param parentid
	 * @return
	 */
	public List<Area> getList(String parentid){
		HashMap<String,String> parameters = new HashMap<String,String>();
		parameters.put("parentid", parentid);
		return areaDao.find(parameters);
	}
}
