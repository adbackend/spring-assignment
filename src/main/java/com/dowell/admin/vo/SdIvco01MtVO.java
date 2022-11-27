package com.dowell.admin.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;


/**
  * @package_name : com.dowell.admin.vo	
  * @FileName : SdIvco01MtVO.java
  * @Date : 2022. 10. 9. 
  * @작성자 : 최유정
  * @변경이력 : 
  * @프로그램 설명 : 매장현재고 SD_IVCO01_MT 테이블
  */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SdIvco01MtVO {
	
	private String	PRT_CD; //매장코드
	private String	PRD_CD; //상품코드
	private int	IVCO_QTY; //재고수량
	private String	FST_REG_DT; //최초등록일자
	private String	FST_USER_ID; //최초등록자
	private String LST_UPD_DT; //최종수정일자
	private String	LST_UPD_ID; //최종수정자

	
	
	private String	PRD_NM; //상품명
	private String	PRD_TP_CD; //상품유형코드
	private int	PRD_CSMR_UPR; //상품소비자단가
	private int	PRD_PCH_UPR; //상품매입단가
	private String	TAX_CS_CD; //세금분류코드
	private String PRD_SS_CD; //상품상태코드
	
	private int QTY;

	
}
