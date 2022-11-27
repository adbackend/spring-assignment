package com.dowell.admin.dto;

import java.util.List;

import lombok.Getter;

public class SalInsertDTO {

	@Getter
	public static class Request {
		
		private String salDt; 		//판매일자
		private String salTpCd; 	//판매구분
		private String custNo; 		//고객번호
		
		private Integer cshStlmAmt; //현금결제금액
		private Integer crdStlmAmt; //카드결제금액
		
		private Integer pntStlmAmt; //포인트사용금액
		private String vldYm; 		//카드유효일자
		private String crdCoCd; 	//카드회사
		
		private String crdNo; 		//카드번호
		
		private String totSalAmt; 	//총결제금액
		
		private List<Product> products;
	}
	
	@Getter
	public static class Product{
		private String prdCd; 		//상품코드
		private Integer qty;  		//수량
	}
	
}
