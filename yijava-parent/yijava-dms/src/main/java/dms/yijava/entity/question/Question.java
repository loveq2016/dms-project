package dms.yijava.entity.question;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class Question {

	private String id;
	private String q_text;
	private String dealer_id;
	private String dealer_name;
	private String a_text;
	private String user_id;

}
