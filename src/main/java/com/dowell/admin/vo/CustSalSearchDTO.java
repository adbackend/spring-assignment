package com.dowell.admin.vo;

import lombok.Data;
import lombok.Getter;

@Data
public class CustSalSearchDTO {
	
	private String startDate; //시작일자
	private String endDate; //종료일자
	private String PRT_CD; //매장코드
	private String PRT_NM; //매장명
	private String CUST_NO; //고객번호
	private String CUST_NM; //고객명
	
	@Override
	public String toString() {
		return "CustSalSearchDTO [startDate=" + startDate + ", endDate=" + endDate + ", PRT_CD=" + PRT_CD + ", PRT_NM="
				+ PRT_NM + ", CUST_NO=" + CUST_NO + ", CUST_NM=" + CUST_NM + "]";
	}
	
	
	
}
