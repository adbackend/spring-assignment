package com.dowell.admin.dto;

import lombok.Getter;

//반품처리
public class SalReturnDTO {
	
	@Getter
	public static class Request{
		
		private String prtCd; //매장코드
		private String salDt; //판매일자
		private String salNo; //판매번호

	}
	

}
