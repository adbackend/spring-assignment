package com.dowell.admin.service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.dowell.admin.dao.CustomerSalDAO;
import com.dowell.admin.dto.SalInsertDTO;
import com.dowell.admin.dto.SalReturnDTO;
import com.dowell.admin.vo.CodeMtDt;
import com.dowell.admin.vo.CsCust01MtVO;
import com.dowell.admin.vo.CsSal01DtVO;
import com.dowell.admin.vo.CsSal01MtVO;
import com.dowell.admin.vo.CustPntD;
import com.dowell.admin.vo.CustPntM;
import com.dowell.admin.vo.CustSalSearchDTO;
import com.dowell.admin.vo.MaPrdMt;
import com.dowell.admin.vo.MemberVO;
import com.dowell.admin.vo.SdIvco01MtVO;
import com.dowell.commons.DowellDate;
import com.dowell.commons.exception.DowellException;

@Service
@Transactional(rollbackFor = Exception.class)
public class CustomerSalService{

   @Autowired
   private CustomerSalDAO customerSalDAO;

   // 고객판매관리 전체 검색

   
   public List<CsSal01MtVO> custSearchList(CustSalSearchDTO custSalSearhDTO) throws Exception {

      List<CsSal01MtVO> custSearchList = customerSalDAO.custSearchList(custSalSearhDTO);

      return custSearchList;
   }

   /**
    * 판매상세조회 팝업창 상세목록
    * 
    * {PRT_CD, SAL_DT, SAL_NO} 가져와서 조회
    */
   
   public List<CsSal01DtVO> custSalDetailList(Map<String, Object> map) throws Exception {

      List<CsSal01DtVO> list = customerSalDAO.custSalDetailList(map);

      return list;
   }

   /**
    * SAL인데 반품목록인지 판별하는 메소드 0이면 반품된상품x, 1이면 반품된 상품
    * 
    */
   
   public List<CsSal01MtVO> salReCheck(Map<String, Object> map) throws Exception {

      List<CsSal01MtVO> list = customerSalDAO.salReCheck(map);

      return list;
   }

   /**
    * 매장 재고조회 상품코드+매장코드를 파라미터로 받아옴
    * 
    */
   
   public List<SdIvco01MtVO> ivcoSearch(SdIvco01MtVO sdIvocoVO) throws Exception {

      List<SdIvco01MtVO> list = customerSalDAO.ivcoSearch(sdIvocoVO);

      return list;
   }

   /**
    * 판매상세수금등록 메소드
    * 
    * ## 트랜잭션  하나라도 실패시 모두 rollback처리
    * 
    * 처리내용
    * 1.고객판매 MT테이블 INSERT
    * 2.고객상세 DT테이블 INSERT
    * 3.매장현재고 업데이트(해당 제품의 구매수량만큼 재고 차감)
    * 4.포인트 추가
    * 5.포인트이력 추가
    * 
    *  
    *  $$공급가액 = 소비자판매가 – (소비자판매가 * 10%)
    *  $$부가세액 = 소비자판매가 * 10% 
    */
   public void salInsert(final SalInsertDTO.Request request, final HttpSession session, Map<String, List<CodeMtDt>> codes) {

      MemberVO memberVO = (MemberVO) session.getAttribute("member");
      String userId = memberVO.getUSER_ID();  // 로그인사용자
      String prtCd = memberVO.getPRT_CD();    // 로그인사용자 매장코드
      
      final int pntStlmAmt = request.getPntStlmAmt(); //회원이 사용한 포인트
      
      System.out.println(pntStlmAmt);
      CsCust01MtVO csCust01MtVO = customerSalDAO.getCsCust01Mt(request.getCustNo()); //회원포인트 조회
      
      //포인트사용 가능 유무 유효성 검사
      if(pntStlmAmt > 0) {
         if(csCust01MtVO.getAVB_PNT() < pntStlmAmt || pntStlmAmt < 100) { //회원이 사용한포인트가 DB예 사용가능한 포인트보다 작고, 사용포인트가 100이상인 경우 포인트 결제 가능.
            throw new DowellException("포인트사용액이 포인트가능액보다 클수 없습니다.");
         }
      }
      
      // List<Product> list에 담긴 Product객체 getQty(수량)을 가져와서 sum
      Integer totSalQty = request.getProducts().stream().mapToInt(p -> p.getQty()).sum(); // 총수량합계

      List<String> prdCdList = request.getProducts().stream().map(p -> p.getPrdCd()).collect(Collectors.toList()); // 상품코드만 가져와 새로운 list에담기
      List<MaPrdMt> products = customerSalDAO.getProducts(prdCdList); // 입력한 상품코드로 판매가 조회
      
      // JSP에서 담은 상품코드 갯수와
      // JAVA에서 그 상품코드를 조회했을때 조회되는 갯수가 다르면.Exception처리
      // 상품코드가 존재하는지 조사
      if(prdCdList.size() != products.size()) {
         throw new DowellException("상품코드가 올바르지 않습니다.");
      }
      
      int totSalAmt = 0; // 총판매금액

      //총판매금액 계산
      for (MaPrdMt product : products) {                                // db에서 가져온 상품코드
         for (SalInsertDTO.Product p : request.getProducts()) {         // jsp에서 가져온 상품코드
            if (product.getPRD_CD().equals(p.getPrdCd())) {             // 코드가 일치하면
               totSalAmt += (product.getPRD_CSMR_UPR() * p.getQty());   // db상품소비자단가*수량(화면에서 가져온)
            }
         }
      } //for end
      
      // DB에서 가져와. 계산한 정확한 총금액과 JSP에서 가져온 총금액이 다르면 Exception.처리
      // F12 개발자도구로 임의로 결제금액을 수정했을때 막으려고 처리한것
      if( Integer.parseInt(request.getTotSalAmt()) != totSalAmt) {
         throw new DowellException("결제금액이 올바르지 않습니다.(F12)");
      }
      
      // 소수점나올수 있는.
      // 부가세액 계산을 위한. 공급가액 계산 변수
      // ##공급가액 = 소비자판매가 – (소비자판매가 * 10%)##
      Integer reCalcTotVosAmt = (int) (totSalAmt - (totSalAmt * 0.1)); //총공급가액
      
      // 고객판매테이블 MT INSERT
      CsSal01MtVO csSal01MtVO = CsSal01MtVO.builder()
            .PRT_CD(prtCd)                                 // 매장코드
            .SAL_DT(request.getSalDt())                    // 판매일자
            .SAL_TP_CD(request.getSalTpCd())               // 판매구분코드  SAL: 판매, RTN : 반품
            .TOT_SAL_QTY(totSalQty)                        // 총판매수량
            .TOT_SAL_AMT(totSalAmt)                        // 총판매금액
            .TOT_VOS_AMT(reCalcTotVosAmt)                  // 총공급가액
            .TOT_VAT_AMT(totSalAmt - reCalcTotVosAmt)      // 총부가세액      //총부가세액 = 총판매금액-총공급가액
            .CSH_STLM_AMT(request.getCshStlmAmt())         // 현금결제금액
            .CRD_STLM_AMT(request.getCrdStlmAmt())         // 카드결제금액
            .PNT_STLM_AMT(request.getPntStlmAmt())         // 포인트사용금액
            .CUST_NO(request.getCustNo())                  // 고객번호
            .CRD_NO(request.getCrdNo())                    // 카드번호
            .VLD_YM(request.getVldYm())                    // 카드 유효일자
            .CRD_CO_CD(request.getCrdCoCd())               // 카드회사
            .FST_USER_ID(userId)                           // 최초등록자
            .LST_UPD_ID(userId)                            // 최종수정자
            .build();
      
      customerSalDAO.createCsSalMt(csSal01MtVO); // MT판매 INSERT

      for (MaPrdMt product : products) {                         	// db에서 가져온 상품코드
         for (SalInsertDTO.Product p : request.getProducts()) {     // jsp에서 가져온 상품코드
            if (product.getPRD_CD().equals(p.getPrdCd())) {       	// 코드가 일치하면

               int salAmt = product.getPRD_CSMR_UPR() * p.getQty(); // 판매금액 = 소비자단가 * 수량
               
               Integer reCalcSalVosAmt = (int) (salAmt - (salAmt * 0.1)); //공급가액
               
               // 부가세액 = 판매금액-공급가액
               CsSal01DtVO csSal01DtVO = CsSal01DtVO.builder()
                     .PRT_CD(prtCd)                               // 매장코드
                     .SAL_DT(request.getSalDt())                  // 판매일자
                     .SAL_NO(csSal01MtVO.getSAL_NO())             // 판매번호
                     .PRD_CD(product.getPRD_CD())                 // 상품코드
                     .PRD_CSMR_UPR(product.getPRD_CSMR_UPR())     // 소비자단가
                     .SAL_QTY(p.getQty())                         // 판매수량  JSP에서 가져옴
                     
                     .SAL_AMT(salAmt)                             // 판매금액
                     .SAL_VOS_AMT(reCalcSalVosAmt)                // 판매공급가액   
                     .SAL_VAT_AMT(salAmt - reCalcSalVosAmt)       // 판매부가세액   //부가세액 = 판매금액-판매공급가액
                     .FST_USER_ID(userId)                         // 최초등록자
                     .LST_UPD_ID(userId)                          // 최종수정자
                     .build();
               customerSalDAO.createCsSal01Dt(csSal01DtVO); // 고객판매상세테이블 DT INSERT
               
               int aa = p.getQty()*(-1);
               System.out.println("Aaaaaaaaaaaaa");
               System.out.println(p.getQty()*(-1));
               System.out.println(aa);
               System.out.println("Aaaaaaaaaaaaa");
               //재고 update
               SdIvco01MtVO sdIvco01MtVO = SdIvco01MtVO.builder()
                     .PRT_CD(prtCd)
                     .PRD_CD(product.getPRD_CD())
                     .QTY(p.getQty()*(-1))
                     .LST_UPD_ID(userId)
                     .build();
               customerSalDAO.ivcoUpdateAdd(sdIvco01MtVO); // 매장현재고 업데이트(해당 제품의 구매수량만큼 재고 차감)
               
            } // if end
         } //for end
      } //for end
      
      //포인트를 사용하였다면 포인트 사용 이력 추가
      if(pntStlmAmt != 0) {
         //포인트 사용 처리 이력 추가
         CustPntD custPntD = CustPntD.builder()
               .CUST_NO(request.getCustNo())
               .ST_DT(request.getSalDt())
               .PNT_DS_CD(200)            //사용
               .PNT_DS_DT_CD(201)          //구매사용
               .PNT(pntStlmAmt)
               .FST_USER_ID(userId)
               .LST_UPD_ID(userId)
               .build();
         customerSalDAO.createCustPntD(custPntD);
      } //if end
      
//      BigDecimal rePercent = new BigDecimal("0.1");
//      int typeConversionTenPercent = rePercent.intValue(); // BigDecimal(String 타입) - > int 변환
      
      
      //포인트제외한 금액의 10% 포인트 지급
      int rewordPoint = (int)((totSalAmt - pntStlmAmt) * 0.1);
      
      //포인트적립 이력 추가
      CustPntD custPntD = CustPntD.builder()
            .CUST_NO(request.getCustNo())
            .ST_DT(request.getSalDt())
            .PNT_DS_CD(100)     //적립
            .PNT_DS_DT_CD(101)  // 구매적립
            .PNT(rewordPoint)
            .FST_USER_ID(userId)
            .LST_UPD_ID(userId)
            .build();
      customerSalDAO.createCustPntD(custPntD);
      
      

      //회원포인트 테이블 업데이트 (적립)
      CustPntM custPntM = CustPntM.builder()
            .plusPoint(rewordPoint)
            .minusPoint(pntStlmAmt) //회원이 사용한 포인트
            .LST_UPD_ID(userId)
            .CUST_NO(request.getCustNo())
            .build();
      customerSalDAO.updateCustPntMPurchase(custPntM);
      
      // 테스트를 위해. 아래로 내림. 위에 있어도됨
//      // DB에서 계산한 정확한 총금액과 JSP에서 가져온 총금액이 다르면 Exception.처리
//      // F12 개발자도구로 임의로 결제금액을 수정했을때 막으려고 처리한것
//      if( Integer.parseInt(request.getTotSalAmt()) != totSalAmt) {
//         throw new DowellException("결제금액이 올바르지 않습니다.(F12)");
//      }
      
      //트랜잭션 테스트를 위해. 아래로 내림. 원래는 위에 있어야.
//      if(csCust01MtVO.getAVB_PNT() < pntStlmAmt || pntStlmAmt < 100) { //회원이 사용한포인트가 DB예 사용가능한 포인트보다 작고, 사용포인트가 100이상인 경우 포인트 결제 가능.
//         throw new DowellException("포인트사용액이 포인트가능액보다 클수 없습니다.");
//      }
      
   } //method end
   
   /**
    * 
    * 반품처리
    * 
    *    "PRT_CD" : PRT_CD,
    *   "SAL_DT" : SAL_DT,
    *   "SAL_NO" : SAL_NO
    *
    *   반품 재고+
    *   반품 포인트+
    *
    * */
   public void salReturnProcess(final SalReturnDTO.Request request, final HttpSession session) throws Exception {
      
      System.out.println("##############반품처리#################2");
      System.out.println(request.getPrtCd());
      System.out.println(request.getSalDt());
      System.out.println(request.getSalNo());
      
      MemberVO memberVO = (MemberVO) session.getAttribute("member");
      String userId = memberVO.getUSER_ID();  // 로그인사용자
      String prtCd = memberVO.getPRT_CD();    // 로그인사용자 매장코드
      
      //반품처리할 MT테이블 판매내역 조회
      CsSal01MtVO salMtVO = CsSal01MtVO.builder()
            .PRT_CD(request.getPrtCd())                              		// 매장코드
            .SAL_DT(request.getSalDt().replaceAll(Pattern.quote("-"), ""))  //판매일자 - 하이픈제거
            .SAL_NO(Integer.parseInt(request.getSalNo()))                 	//판매번호
            .build();
      CsSal01MtVO salMtHistoryVO = customerSalDAO.salHistory(salMtVO);  	//반품처리할 판매내역 조회
      
      if(Objects.isNull(salMtHistoryVO)) {
         throw new DowellException("판매이력이 존재하지 않습니다.");
      }
      
      
      
      System.out.println("Gg");
      System.out.println(salMtHistoryVO.toString());
      System.out.println("Gg");
      
      //오늘날짜
      String strToday = DowellDate.nowString("yyyyMMdd");
        
      //반품처리 insert할 영수증 MT
      CsSal01MtVO salMtRtnInsertVO = CsSal01MtVO.builder()
      
            .PRT_CD(salMtHistoryVO.getPRT_CD())               //1매장코드
            .SAL_DT(strToday)                            	  //2판매일자  SYSDATE
//            .SAL_NO()                                       //3판매번호  selectKey return 값  max처리해야됨..
            .SAL_TP_CD("RTN")                                 //4판매구분코드 SAL: 판매, RTN : 반품
            .TOT_SAL_QTY(salMtHistoryVO.getTOT_SAL_QTY())     //5총판매수량
            .TOT_SAL_AMT(salMtHistoryVO.getTOT_SAL_AMT())     //6총판매금액
            .TOT_VOS_AMT(salMtHistoryVO.getTOT_VOS_AMT())     //7총공급가액
            .TOT_VAT_AMT(salMtHistoryVO.getTOT_VAT_AMT())     //8총부가세액
            .CSH_STLM_AMT(salMtHistoryVO.getCSH_STLM_AMT())   //9현금결제금액
            .CRD_STLM_AMT(salMtHistoryVO.getCRD_STLM_AMT())   //10카드결제금액
            
            .PNT_STLM_AMT(salMtHistoryVO.getPNT_STLM_AMT())   //11포인트사용금액
            .CUST_NO(salMtHistoryVO.getCUST_NO())             //12고객번호
            
            .CRD_NO(salMtHistoryVO.getCRD_NO() == null ? "" : salMtHistoryVO.getCRD_NO())               //13카드번호
            .VLD_YM(salMtHistoryVO.getVLD_YM() == null ? "" : salMtHistoryVO.getVLD_YM())               //14유효년월
            .CRD_CO_CD(salMtHistoryVO.getCRD_CO_CD() == null ? "" : salMtHistoryVO.getCRD_CO_CD())      //15카드회사
            
//            .FST_REG_DT()                              //16최초등록일자  DB서 SYSDATE
            .FST_USER_ID(userId)                         //17최초등록자
//            .LST_UPD_DT                                //18최종수정일자   DB서 SYSDATE
            .LST_UPD_ID(userId)                          //19최종수정자
            .ORG_SHOP_CD(request.getPrtCd())             //원매장코드
            .ORG_SAL_DT(request.getSalDt().replaceAll(Pattern.quote("-"), ""))   //원판매일자
            .ORG_SAL_NO(request.getSalNo())                  //원판매번호
            .build();
      
      System.out.println("$$$$포인트 사용금액$$$$");
      System.out.println(salMtHistoryVO.getPNT_STLM_AMT());
      System.out.println("$$$$포인트 사용금액$$$$");
      
      customerSalDAO.createCsSalMt(salMtRtnInsertVO);// MT테이블 반품처리 INSERT. 기존SQL 재사용할것임
      
      //반품처리할 DT테이블 판매내역 조회
      //    PRT_CD, SAL_DT, SAL_NO 을 가지고 조회
      CsSal01DtVO salDtVO = CsSal01DtVO.builder()
            .PRT_CD(request.getPrtCd()) //매장코드
            .SAL_DT(request.getSalDt().replaceAll(Pattern.quote("-"), "")) //판매일자
            .SAL_NO(Integer.parseInt(request.getSalNo())) //판매번호
            .build();
      
      //구매한 상품들 가져오기 위해  DT테이블 조회
      List<CsSal01DtVO> salDtList = customerSalDAO.salDtList(salDtVO);
      
      for(CsSal01DtVO salDt : salDtList) {
         System.out.println("$$$반품처리$$$$$");
         
         System.out.println(salDt.getPRD_CD());
         System.out.println(salDt.getSAL_QTY());
         
         System.out.println("$$$반품처리$$$$$");
         CsSal01DtVO salDtInsert = CsSal01DtVO.builder()
               .PRT_CD(salDt.getPRT_CD())            	//1매장코드
               .SAL_DT(strToday)                  		//2판매일자 오늘날짜
               .SAL_NO(salMtRtnInsertVO.getSAL_NO())   	//3판매번호  mt테이블 return받은거 넣어야됨 
//               .SAL_SEQ                        		//4판매일련번호 max처리
               .PRD_CD(salDt.getPRD_CD())            	//5상품코드
               .PRD_CSMR_UPR(salDt.getPRD_CSMR_UPR())   //6소비자단가
               .SAL_QTY(salDt.getSAL_QTY())         	//7판매수량
               .SAL_AMT(salDt.getSAL_AMT())         	//8판매금액
               .SAL_VOS_AMT(salDt.getSAL_VOS_AMT())   	//9판매공급가액
               .SAL_VAT_AMT(salDt.getSAL_VAT_AMT())   	//10판매부가세액
//               .FST_REG_DT                        	//11최초등록일자 DB sysdate처리
               .FST_USER_ID(userId)               		//12최초등록자 
//               .LST_UPD_DT                        	//13최종수정일자 DB sysdate처리
               .LST_UPD_ID(userId)                  	//14최종수정자
               .build();
         
         customerSalDAO.createCsSal01Dt(salDtInsert); //DT테이블 반품처리 INSERT. 기존SQL 재사용할것임
         
         System.out.println("오징어11111111111");
         
         
         // 매장현재고 업데이트 (해당 제품의 반품 수량만큼 재고 더해주기 )
         SdIvco01MtVO ivocoMtAdd = SdIvco01MtVO.builder()
               .PRT_CD(salDt.getPRT_CD())     //매장코드
               .PRD_CD(salDt.getPRD_CD())     //상품코드
               .QTY(salDt.getSAL_QTY())  //재고수량
//               .LST_UPD_DT                  // DB서 SYSDATE처리
               .LST_UPD_ID(userId)            //최종수정자
               .build();
         customerSalDAO.ivcoUpdateAdd(ivocoMtAdd);
         System.out.println("오징어222222222222222222");
         
      } //for end
      
      /**
      	반품시 포인트 처리
      	1.사용포인트=0이면
      	판매적립포인트 (현금+카드) *0.1   포인트에 - 처리
      
      	2.사용포인트가 있다면 
      	판매적립포인트 (현금+카드- 포인트)*0.1   -처리   
       */
   
      int deductionPoint = (int)((salMtHistoryVO.getCSH_STLM_AMT() + salMtHistoryVO.getCRD_STLM_AMT()) * 0.1); // (현금+카드)*0.1
      int earnPoint = salMtHistoryVO.getPNT_STLM_AMT(); //포인트 사용시 사용포인트 반환
      
      //구매금액의 10% 적립 되었던 포인트 회수
      CustPntD custPntD = CustPntD.builder()
            .CUST_NO(salMtHistoryVO.getCUST_NO())
            .ST_DT(request.getSalDt().replaceAll(Pattern.quote("-"), ""))
            .PNT_DS_CD(100)     // 100:적립  200:사용
            .PNT_DS_DT_CD(104)  // 104:구매적립취소
            .PNT(deductionPoint)
            .FST_USER_ID(userId)
            .LST_UPD_ID(userId)
            .build();
      customerSalDAO.createCustPntD(custPntD);
      
      System.out.println("오징어333333333333333333");
      //포인트를 사용했다면 사용한 포인트만큼 반환
      if(earnPoint!=0) {
         CustPntD custPntDPoint = CustPntD.builder()
               .CUST_NO(salMtHistoryVO.getCUST_NO())
               .ST_DT(request.getSalDt().replaceAll(Pattern.quote("-"), "")) //기준일자
               .PNT_DS_CD(200)		// 100:적립  200:사용
               .PNT_DS_DT_CD(202)   // 202:구매사용 취소
               .PNT(earnPoint)	    // 포인트
               .FST_USER_ID(userId)
               .LST_UPD_ID(userId)
               .build();
         customerSalDAO.createCustPntD(custPntDPoint);
      }
      
      System.out.println("오징어44444444444444444");
      
      //회원포인트 테이블 업데이트
      CustPntM custPntM = CustPntM.builder()
            .minusPoint(deductionPoint)  // 10% 적립된
            .plusPoint(earnPoint)	     // 고객이 사용한
            .LST_UPD_ID(userId)
            .CUST_NO(salMtHistoryVO.getCUST_NO())
            .build();
      customerSalDAO.updateCustPntMReturn(custPntM);      
      
      System.out.println("오징어55555555555555555");
         
         
      } //method end
   
   
      //트랜잭션 테스트코드
      public void txTest(Boolean sw, Integer cqy) {
         SdIvco01MtVO ivocoMtAdd = SdIvco01MtVO.builder()
               .PRT_CD("B0000004")     //매장코드
               .PRD_CD("100000012")     //상품코드
               .IVCO_QTY(cqy)   //재고수량
               .build();
         customerSalDAO.txTest(ivocoMtAdd);
         
         if(sw) {
            throw new DowellException("예외발생");
         }
      }
      
      
   

} //class end