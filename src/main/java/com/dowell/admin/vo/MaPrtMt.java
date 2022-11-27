package com.dowell.admin.vo;

import java.util.Date;

import lombok.Data;

/**
  * @package_name : com.dowell.admin.vo	
  * @FileName : MaPrtMt.java
  * @Date : 2022. 8. 27. 
  * @작성자 : 최유정
  * @변경이력 :
  * @프로그램 설명 : MA_PRT_MT 거래처관리 테이블 
  */
@Data
public class MaPrtMt {
	
	private String PRT_CD; //거래처코드
	private String PRT_NM; //거래처명
	private String PRT_DT_CD; //거래처구분코드
	private String RPSV_NM; //대표자명
	private String BSN_NO; //사업자등록번호
	private String ZIP_NO; //우편번호
	private String ADDR; //주소
	private String ADDR_DTL; //상세주소
	private String TEL_NO; //전화번호
	private String MBL_NO; //핸드폰번호
	private String PRT_SS_CD; //거래처상태코드
	private String MBZ_ST_DT; //영업개시일자
	private String STP_DT; //중지일자
	private String CNCL_DT; //해지일자
	private int ORD_LMT_AMT; //여신한도금액
	private int FST_REG_DT; //최초등록일자
	private String FST_USER_ID; //최초등록자
	private Date LST_UPD_DT; //최종수정일자
	private String LST_UPD_ID; //최종수정자



}
