package com.dowell.admin.vo;


import java.sql.Date;

import lombok.Data;
import lombok.ToString;

/**
  * @package_name : com.dowell.admin.vo	
  * @FileName : CsCust01MtVO.java
  * @Date : 2022. 8. 26. 
  * @작성자 : 최유정
  * @변경이력 :
  * @프로그램 설명 : 고객관리 - CS_CUST01_MT 테이블
  */

@Data
public class CsCust01MtVO extends ConditionDTO{

	private String CUST_NO; //고객번호
	private String CUST_NM;  //고객명
	private String SEX_CD;  //성별코드
	private String SCAL_YN;  //양음력구분
	private String BRDY_DT;  //생년월일
	private String MRRG_DT;  //결혼기념일
	private String POC_CD;  //직업코드
	private String MBL_NO;  //휴대폰번호
	private String PSMT_GRC_CD;  //우편물수령코드
	private String EMAIL;  //우편번호코드
	private String ZIP_CD;  //우편번호코드
	private String ADDR;  //주소
	private String ADDR_DTL;  //상세주소
	private String CUST_SS_CD;  //고객상태코드 10 :정상, 80:중지, 90:해지
	private String CNCL_CNTS;  //해지사유내용
	private String JN_PRT_CD;  //가입매장코드
	private String EMAIL_RCV_YN;  //이메일수신동의여부
	private String SMS_RCV_YN;  //SMS수신동의여부
	private String TM_RCV_YN;  //TM수신동의여부
	private String DM_RCV_YN;  //DM수신동의여부
	private String FST_JS_DT;  //최초가입일자
	private String JS_DT;  //가입일자
	private String STP_DT;  //중지일자
	private String CNCL_DT;  //해지일자
	private String FST_REG_DT;  //최초등록일자
	private String FST_USER_ID;  //최초등록자
	private String LST_UPD_DT;  //최종수정일자
	private String LST_UPD_ID;  //최종수정자
	
	
	private String PRT_NM; //거래처명
	private String USER_NM; //사용자명
	
	private String CUST_CNT;
	
	
	//고객판매 합계낼때 사용
	private int TOT_SAL_AMT; //총구매금액
	private int TOT_SAL_MONTH; //당월구매금액
	private String SAL_DT; //판매일자
	
	
    private int TOT_PNT; 	/*총포인트*/
    private int RSVG_PNT; 	/*당월포인트*/
    private int US_PNT;  	/*당월사용포인트*/
    private int AVB_PNT;  //가용포인트
    
	@Override
	public String toString() {
		return "CsCust01MtVO [CUST_NO=" + CUST_NO + ", CUST_NM=" + CUST_NM + ", SEX_CD=" + SEX_CD + ", SCAL_YN="
				+ SCAL_YN + ", BRDY_DT=" + BRDY_DT + ", MRRG_DT=" + MRRG_DT + ", POC_CD=" + POC_CD + ", MBL_NO="
				+ MBL_NO + ", PSMT_GRC_CD=" + PSMT_GRC_CD + ", EMAIL=" + EMAIL + ", ZIP_CD=" + ZIP_CD + ", ADDR=" + ADDR
				+ ", ADDR_DTL=" + ADDR_DTL + ", CUST_SS_CD=" + CUST_SS_CD + ", CNCL_CNTS=" + CNCL_CNTS + ", JN_PRT_CD="
				+ JN_PRT_CD + ", EMAIL_RCV_YN=" + EMAIL_RCV_YN + ", SMS_RCV_YN=" + SMS_RCV_YN + ", TM_RCV_YN="
				+ TM_RCV_YN + ", DM_RCV_YN=" + DM_RCV_YN + ", FST_JS_DT=" + FST_JS_DT + ", JS_DT=" + JS_DT + ", STP_DT="
				+ STP_DT + ", CNCL_DT=" + CNCL_DT + ", FST_REG_DT=" + FST_REG_DT + ", FST_USER_ID=" + FST_USER_ID
				+ ", LST_UPD_DT=" + LST_UPD_DT + ", LST_UPD_ID=" + LST_UPD_ID + ", PRT_NM=" + PRT_NM + ", USER_NM="
				+ USER_NM + ", CUST_CNT=" + CUST_CNT + ", TOT_SAL_AMT=" + TOT_SAL_AMT + ", TOT_SAL_MONTH="
				+ TOT_SAL_MONTH + ", SAL_DT=" + SAL_DT + ", TOT_PNT=" + TOT_PNT + ", RSVG_PNT=" + RSVG_PNT + ", US_PNT="
				+ US_PNT + "]";
	}	
	
	
}


