package com.dowell.admin.vo;

import lombok.Data;

@Data
public class CodeNameVO {
	private String PRT_CD; //거래처 코드
	private String PRT_NM; //거래처명
	
	private String USER_ID;//사용자아이디
	private String USER_NM; //사용자명
	private String USER_DT_CD; //사용자 구분코드
}
