package dms.yijava.api.web.word.util;

import java.util.List;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class TrialModel {

	private String hospital;
	private String requesttime;
	private String reason;
	private String regionsign;
	private String principalsign;
	
	private List<TrialProduct> trialProducts;

}
