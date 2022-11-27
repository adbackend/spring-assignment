package com.dowell.admin.vo;

import java.util.Date;

import lombok.Data;

/**
  * @package_name : com.dowell.admin.vo	
  * @FileName : MemberVO.java
  * @Date : 2022. 8. 27. 
  * @작성자 : 최유정
  * @변경이력 :
  * @프로그램 설명 : 사용자 - MA_USER_MT 테이블
  */

@Data
public class MemberVO {
	private String USER_ID; //사용자ID
	private String USER_NM; //사용자 명
	private String USER_DT_CD; //사용자구분코드 - 1:회사, 2:특약점
	private String USE_YN; //사용여부 - 0:사용, 1: 미사용
	private String USE_PWD; //비밀번호
	private String ST_DT; //시작일자
	private String ED_DT; //종료일자
	private String PRT_CD;//거래처코드
	private String PWD_UPD_DT; //비밀번호변경일자
	private Date FST_REG_DT;//최초등록일자
	private String FST_USER_ID;//최초등록자
	private Date LST_UPD_DT;//최종수정일자
	private String LST_UPD_ID;//최종수정자
	
	private String PRT_NM; //거래처 코드-MA_PRT_MT테이블
	
	
	@Override
	public String toString() {
		return "MemberVO [USER_ID=" + USER_ID + ", USER_NM=" + USER_NM + ", USER_DT_CD=" + USER_DT_CD + ", USE_YN="
				+ USE_YN + ", USE_PWD=" + USE_PWD + ", ST_DT=" + ST_DT + ", ED_DT=" + ED_DT + ", PRT_CD=" + PRT_CD
				+ ", PWD_UPD_DT=" + PWD_UPD_DT + ", FST_REG_DT=" + FST_REG_DT + ", FST_USER_ID=" + FST_USER_ID
				+ ", LST_UPD_DT=" + LST_UPD_DT + ", LST_UPD_ID=" + LST_UPD_ID + "]";
	}
	
	
	
	
}
