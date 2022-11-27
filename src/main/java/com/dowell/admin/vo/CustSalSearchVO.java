package com.dowell.admin.vo;

import lombok.Data;

/**
  * @package_name : com.dowell.admin.vo	
  * @FileName : CustSalSearchVO.java
  * @Date : 2022. 9. 27. 
  * @작성자 : 최유정
  * @변경이력 :
  * @프로그램 설명 :
  */

@Data
public class CustSalSearchVO {
	
	private String PRT_CD; 		//매장코드
	private String SAL_DT; 		//판매일자
	private int SAL_NO; 		//판매번호
	private String SAL_TP_CD; 	//판매구분코드
	
	private int SAL_QTY;  //판매수량
	private int SAL_AMT;  //판매금액
	
	
	private int TOT_SAL_QTY; 	//총판매수량
	private int TOT_SAL_AMT; 	//총판매금액
	private int TOT_VOS_AMT; 	//총공급가액
	private int TOT_VAT_AMT; 	//총부가세액
	private int CSH_STLM_AMT; 	//현금결제금액
	private int CRD_STLM_AMT; 	//카드결제금액
	private int PNT_STLM_AMT; 	//포인트 사용금액
	private String CUST_NO; 	//고객번호
	private String CRD_NO; 		//카드번호
	private String VLD_YM; 		//유효년월
	private String CRD_CO_CD;	//카드회사
	private String FST_REG_DT; 	//최초등록일자
	private String FST_USER_ID; //최초등록자
	private String LST_UPD_DT; 	//최종수정일자
	private String LST_UPD_ID; 	//최종수정자

	private String CUST_NM; 	//고객명
	
	private String PRT_NM;  	//매장명
	private String USER_NM; 	//최초등록자
	private int SUM_SAL_QTY; 	//총판매수량
	private int SUM_SAL_AMT; 	//총판매금액
}
