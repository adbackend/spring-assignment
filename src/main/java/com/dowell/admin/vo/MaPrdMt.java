package com.dowell.admin.vo;

import lombok.Data;

@Data
public class MaPrdMt {
	
	private String PRD_CD; //	상품코드
	private String PRD_NM	; //상품명
	private String PRD_TP_CD	; //상품유형코드
	private Integer PRD_CSMR_UPR; //	상품소비자단가
	
	private Integer PRD_PCH_UPR	; //상품매입단가
	private String TAX_CS_CD	; //세금분류코드
	private String PRD_SS_CD	; //상품상태코드
	private String FST_REG_DT	; //최초등록일자
	private String FST_USER_ID	; //최초등록자
	private String LST_UPD_DT	; //최종수정일자
	private String LST_UPD_ID	; //최종수정자


}
