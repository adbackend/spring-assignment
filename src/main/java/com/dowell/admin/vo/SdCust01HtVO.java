package com.dowell.admin.vo;



import java.util.Date;

import lombok.Data;

/**
  * @package_name : com.dowell.admin.vo	
  * @FileName : SdCust01HtVO.java
  * @Date : 2022. 9. 2. 
  * @작성자 : 최유정
  * @변경이력 :
  * @프로그램 설명 : 고객이력 테이블(SD_CUST01_HT)
  */
@Data
public class SdCust01HtVO extends CodeMtDt{
	
	private String CUST_NO;//고객번호
	private String CHG_DT;//변경일자
	private int CHG_SEQ;//일련번호
	private String CHG_CD;//변경코드
	private String CHG_BF_CNT;//변경전내용
	private String CHG_AFT_CNT;//변경후내용
	private String FST_REG_DT;//최초등록일자
	private String FST_USER_ID;//최초등록자
	private String LST_UPD_DT;//최종수정일자
	private String LST_UPD_ID;//최종수정자

	
	private String CUST_NM; //고객이름 - CS_CUST01_MT
	private String USER_NM; //사용자명 - MA_USER_MT
}
