package com.dowell.admin.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;


/**
  * @package_name : com.dowell.admin.vo	
  * @FileName : CsSal01DtVO.java
  * @Date : 2022. 9. 12. 
  * @작성자 : 최유정
  * @변경이력 :
  * @프로그램 설명 : 고객판매상세
  */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CsSal01DtVO {
	
	
	private String RN; //rownum 순번
	
	private String PRT_CD; // 매장코드
	private String SAL_DT; // 판매일자
	
	private int SAL_NO; //판매번호
	private int SAL_SEQ; //판매일련번호
	private String PRD_CD; //상품코드
	private int PRD_CSMR_UPR; // 소비자 단가
	private int SAL_QTY; //판매수량
	private int SAL_AMT; //판매금액
	private int SAL_VOS_AMT; // 판매공급가액
	private int SAL_VAT_AMT; // 판매부가세액
	private String FST_REG_DT; // 최초등록일자
	private String FST_USER_ID; // 최초등록자
	private String LST_UPD_DT; // 최종수정일자
	private String LST_UPD_ID;// 최종수정자
	
	private String PRD_NM; //상품명

//	private startDate;
//	private endDate;
}
