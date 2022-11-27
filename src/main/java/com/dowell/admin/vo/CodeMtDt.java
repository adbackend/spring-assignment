package com.dowell.admin.vo;



/**
  * @package_name : com.dowell.admin.vo	
  * @FileName : CodeMtDt.java
  * @Date : 2022. 9. 12. 
  * @작성자 : 최유정
  * @변경이력 :
  * @프로그램 설명 : 코드마스터(MA_CODE_MT) + 코드상세(MA_CODE_DT)
  */
public class CodeMtDt {
	
	private String CODE_CD; //공통코드
	private String CODE_NM; //공통코드명
	private String FST_REG_DT; //최초등록일자
	private String FST_USER_ID; //최초등록자
	private String LST_UPD_DT; //최종수정일자
	private String LST_UPD_ID; //최종수정자
	
	
	private String DTL_CD; //세부코드
	private String DTL_CD_NM; //세부코드명
	private String USE_YN; //사용여부
	private String USE_ST_DT; //사용시작일자
	private String USE_ED_DT; //사용종료일자
	private int SRT_SEQ; //정렬순서
	private String ETC_CD; //기타코드
	
	public String getCODE_CD() {
		return CODE_CD;
	}
	public void setCODE_CD(String cODE_CD) {
		CODE_CD = cODE_CD;
	}
	public String getCODE_NM() {
		return CODE_NM;
	}
	public void setCODE_NM(String cODE_NM) {
		CODE_NM = cODE_NM;
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
	public String getDTL_CD() {
		return DTL_CD;
	}
	public void setDTL_CD(String dTL_CD) {
		DTL_CD = dTL_CD;
	}
	public String getDTL_CD_NM() {
		return DTL_CD_NM;
	}
	public void setDTL_CD_NM(String dTL_CD_NM) {
		DTL_CD_NM = dTL_CD_NM;
	}
	public String getUSE_YN() {
		return USE_YN;
	}
	public void setUSE_YN(String uSE_YN) {
		USE_YN = uSE_YN;
	}
	public String getUSE_ST_DT() {
		return USE_ST_DT;
	}
	public void setUSE_ST_DT(String uSE_ST_DT) {
		USE_ST_DT = uSE_ST_DT;
	}
	public String getUSE_ED_DT() {
		return USE_ED_DT;
	}
	public void setUSE_ED_DT(String uSE_ED_DT) {
		USE_ED_DT = uSE_ED_DT;
	}
	public int getSRT_SEQ() {
		return SRT_SEQ;
	}
	public void setSRT_SEQ(int sRT_SEQ) {
		SRT_SEQ = sRT_SEQ;
	}
	public String getETC_CD() {
		return ETC_CD;
	}
	public void setETC_CD(String eTC_CD) {
		ETC_CD = eTC_CD;
	}

	
	

}
