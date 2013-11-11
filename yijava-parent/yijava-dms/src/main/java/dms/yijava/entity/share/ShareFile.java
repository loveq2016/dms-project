package dms.yijava.entity.share;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class ShareFile {

	private String id;



	private String filename;
	private String filedesc;
	private String filepath;
	private String filesize;
	private String create_date;
	private String last_date;
	
}
