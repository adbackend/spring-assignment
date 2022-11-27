package com.dowell.admin.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CustPntM {
	
	private String CUST_NO;
	private int TOT_PNT;
	private int RSVG_PNT;
	private int US_PNT;
	private int AVB_PNT;
	private int HNDC_PNT;
	private String FST_REG_DT;
	private String FST_USER_ID;
	private String LST_UPD_DT;
	private String LST_UPD_ID;
	
	private int plusPoint;
	private int minusPoint;
}
