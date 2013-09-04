package dms.yijava.entity.dealer;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data  
@NoArgsConstructor
public class Dealer {
	
	private String id;
	private String dealercode;
	private String cname;
	private String business_contacts;
	private String business_phone;
	private String financial_contacts;
	private String financial_phone;
	private String invoice_address;
	private String invoicea_postcode;
	private String settlement_time;
	private String attribute;
	private String status;
	private String register_address;
	private String company_type;
	private String found_time;
	private String corporate;
	private String corporate_phone;
	private String register_fund;
	private String operated_scope;
	private String addess;
	private String GM_name;
	private String GM_phone;
	private String BM_name;
	private String BM_phone;
	private String BM_telephone;
	private String BM_fax;
	private String email;
	private String category_id;//经销商分类
	
	
}
