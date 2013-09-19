package dms.yijava.entity.notice;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class NoticeDealer {

	private String id;
	private String dealer_id;
	private String dealer_name;
	private String dealer_code;
	private String is_read;
	private String read_date;
	private String notice_id;

}
