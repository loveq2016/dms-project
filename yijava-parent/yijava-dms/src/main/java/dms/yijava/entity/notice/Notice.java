package dms.yijava.entity.notice;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Notice {
	
	private String notice_id;
	private String title;
	private String content;
	private String level_id;
	private String level_name;
	private String validity_date;
	private String publish_date;
	private String status_id;
	private String status_name;
	private String user_id;
	private String realname;
	
	private String category_ids;
	private String dealer_category_id;
	
	private String dealer_id;
	
}
