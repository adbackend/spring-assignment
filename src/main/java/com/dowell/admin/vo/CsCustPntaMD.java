package com.dowell.admin.vo;


/**
  * @package_name : com.dowell.admin.vo	
  * @FileName : CsCustPntaMD.java
  * @Date : 2022. 9. 12. 
  * @작성자 : 최유정
  * @변경이력 :
  * @프로그램 설명 : 회원포인트
  */

public class CsCustPntaMD {
	
	
	private String CUST_NO; //고객번호
	private int TOT_PNT; //총포인트
	private int RSVG_PNT; //적립포인트
	private int US_PNT; //사용포인트
	private int AVB_PNT; //가용포인트
	private int HNDC_PNT; //수기포인트
	private String FST_REG_DT; //최초등록일자
	private String FST_USER_ID; //최초등록자
	private String LST_UPD_DT; //최종수정일자
	private String LST_UPD_ID; //최종수정자
	
	private String ST_DT; //기준일자
	private int PNT_SEQ; //일련번호
	private int PNT_DS_CD; //포인트구분코드
	private int PNT_DS_DT_CD; //포인트구분상세코드
	private int PNT; //포인트
	
	public String getCUST_NO() {
		return CUST_NO;
	}
	public void setCUST_NO(String cUST_NO) {
		CUST_NO = cUST_NO;
	}
	public int getTOT_PNT() {
		return TOT_PNT;
	}
	public void setTOT_PNT(int tOT_PNT) {
		TOT_PNT = tOT_PNT;
	}
	public int getRSVG_PNT() {
		return RSVG_PNT;
	}
	public void setRSVG_PNT(int rSVG_PNT) {
		RSVG_PNT = rSVG_PNT;
	}
	public int getUS_PNT() {
		return US_PNT;
	}
	public void setUS_PNT(int uS_PNT) {
		US_PNT = uS_PNT;
	}
	public int getAVB_PNT() {
		return AVB_PNT;
	}
	public void setAVB_PNT(int aVB_PNT) {
		AVB_PNT = aVB_PNT;
	}
	public int getHNDC_PNT() {
		return HNDC_PNT;
	}
	public void setHNDC_PNT(int hNDC_PNT) {
		HNDC_PNT = hNDC_PNT;
	}
	public String getFST_REG_DT() {
		return FST_REG_DT;
	}
	public void setFST_REG_DT(String fST_REG_DT) {
		FST_REG_DT = fST_REG_DT;
	}
	public String getFST_USER_ID() {
		return FST_USER_ID;
	}
	public void setFST_USER_ID(String fST_USER_ID) {
		FST_USER_ID = fST_USER_ID;
	}
	public String getLST_UPD_DT() {
		return LST_UPD_DT;
	}
	public void setLST_UPD_DT(String lST_UPD_DT) {
		LST_UPD_DT = lST_UPD_DT;
	}
	public String getLST_UPD_ID() {
		return LST_UPD_ID;
	}
	public void setLST_UPD_ID(String lST_UPD_ID) {
		LST_UPD_ID = lST_UPD_ID;
	}
	public String getST_DT() {
		return ST_DT;
	}
	public void setST_DT(String sT_DT) {
		ST_DT = sT_DT;
	}
	public int getPNT_SEQ() {
		return PNT_SEQ;
	}
	public void setPNT_SEQ(int pNT_SEQ) {
		PNT_SEQ = pNT_SEQ;
	}
	public int getPNT_DS_CD() {
		return PNT_DS_CD;
	}
	public void setPNT_DS_CD(int pNT_DS_CD) {
		PNT_DS_CD = pNT_DS_CD;
	}
	public int getPNT_DS_DT_CD() {
		return PNT_DS_DT_CD;
	}
	public void setPNT_DS_DT_CD(int pNT_DS_DT_CD) {
		PNT_DS_DT_CD = pNT_DS_DT_CD;
	}
	public int getPNT() {
		return PNT;
	}
	public void setPNT(int pNT) {
		PNT = pNT;
	}
	
	
}
