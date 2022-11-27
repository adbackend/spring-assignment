package com.dowell.admin.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CustPntD {
	
	
	private String CUST_NO;
	private String ST_DT;
	private int PNT_SEQ;
	private int PNT_DS_CD;
	private int PNT_DS_DT_CD;
	private int PNT;
	private String FST_REG_DT;
	private String FST_USER_ID;
	private String LST_UPD_DT;
	private String LST_UPD_ID;
}
