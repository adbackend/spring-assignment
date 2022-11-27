package com.dowell.admin.vo;

import java.util.Date;

import lombok.Data;


/**
  * @package_name : com.dowell.admin.vo	
  * @FileName : SearchDTO.java
  * @Date : 2022. 8. 27. 
  * @작성자 : 최유정
  * @변경이력 :
  * @프로그램 설명 :
  */

@Data
public class SearchDTO extends CsCust01MtVO{
	
	private String PRT_CD; //매장코드
	private String PRT_NM; //매장명
	private String startDate; // 가입일자(시작)
	private String endDate; //가입일자(종료)
	
}
