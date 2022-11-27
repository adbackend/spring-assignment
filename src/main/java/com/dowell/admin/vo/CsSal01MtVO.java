package com.dowell.admin.vo;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

/**
  * @package_name : com.dowell.admin.vo	
  * @FileName : CsSal01MtVO.java
  * @Date : 2022. 9. 4. 
  * @작성자 : 최유정
  * @변경이력 : 
  * @프로그램 설명 :  고객판매테이블 CS_SAL01_MT
  */

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CsSal01MtVO {
	private String PRT_CD; //매장코드 ㅇ
	private String SAL_DT; //판매일자ㅇ
	private int SAL_NO; //판매번호
	
	private String SAL_TP_CD; //판매구분코드
	
	private int TOT_SAL_QTY; //총판매수량
	private int TOT_SAL_AMT; //총판매금액
	
	private int TOT_VOS_AMT; //총공급가액
	private int TOT_VAT_AMT; //총부가세액
	
	
	private int CSH_STLM_AMT; //현금결제금액
	private int CRD_STLM_AMT; //카드결제금액
	private int PNT_STLM_AMT; //포인트 사용금액
	private String CUST_NO; //고객번호ㅇ
	
	private String CRD_NO; //카드번호
	private String VLD_YM; //유효년월
	private String CRD_CO_CD;// 카드회사
	private String FST_REG_DT; //최초등록일자
	private String FST_USER_ID; //최초등록자
	private String LST_UPD_DT; //최종수정일자
	private String LST_UPD_ID; //최종수정자
	

	private String ORG_SHOP_CD; //원매장코드
	private String ORG_SAL_DT; //원판매일자
	private String ORG_SAL_NO; //원판매번호
	
	
	private String PRT_NM; //매장코드
	private String cuMonth; //매출월
	
	
	private Integer AVB_PNT; //가용포인트


	@Override
	public String toString() {
		return "CsSal01MtVO [PRT_CD=" + PRT_CD + ", SAL_DT=" + SAL_DT + ", SAL_NO=" + SAL_NO + ", SAL_TP_CD="
				+ SAL_TP_CD + ", TOT_SAL_QTY=" + TOT_SAL_QTY + ", TOT_SAL_AMT=" + TOT_SAL_AMT + ", TOT_VOS_AMT="
				+ TOT_VOS_AMT + ", TOT_VAT_AMT=" + TOT_VAT_AMT + ", CSH_STLM_AMT=" + CSH_STLM_AMT + ", CRD_STLM_AMT="
				+ CRD_STLM_AMT + ", PNT_STLM_AMT=" + PNT_STLM_AMT + ", CUST_NO=" + CUST_NO + ", CRD_NO=" + CRD_NO
				+ ", VLD_YM=" + VLD_YM + ", CRD_CO_CD=" + CRD_CO_CD + ", FST_REG_DT=" + FST_REG_DT + ", FST_USER_ID="
				+ FST_USER_ID + ", LST_UPD_DT=" + LST_UPD_DT + ", LST_UPD_ID=" + LST_UPD_ID + ", ORG_SHOP_CD="
				+ ORG_SHOP_CD + ", ORG_SAL_DT=" + ORG_SAL_DT + ", ORG_SAL_NO=" + ORG_SAL_NO + ", PRT_NM=" + PRT_NM
				+ ", cuMonth=" + cuMonth + ", AVB_PNT=" + AVB_PNT + "]";
	}






	
	
}
