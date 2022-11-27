package com.dowell.admin.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.dowell.admin.vo.CodeMtDt;
import com.dowell.admin.vo.CsCust01MtVO;
import com.dowell.admin.vo.CsSal01MtVO;
import com.dowell.admin.vo.MaPrtMt;
import com.dowell.admin.vo.MonthlyVO;
import com.dowell.admin.vo.SdCust01HtVO;
import com.dowell.admin.vo.SearchDTO;
import com.dowell.commons.Masking;

import lombok.extern.log4j.Log4j;

@Log4j
@Repository
public class AdminDAO {

	private static Logger logger = LoggerFactory.getLogger(AdminDAO.class);

	@Autowired
	private SqlSession sqlSession;

	/**
	 * 고객조회 검색처리
	 * 
	 * @param
	 */
//	
//	public List<CsCust01MtVO> customerList1(SearchDTO searchDTO) {
//		
//		logger.info(searchDTO.getPRT_CD()+"매장코드 왼쪽");
//		logger.info(searchDTO.getCUST_NO() + "고객번호 왼쪽");
//		
//		
//		logger.info(searchDTO.getPRT_NM() + "가입매장");
//		logger.info(searchDTO.getCUST_SS_CD() + "고객상태");
//		logger.info(searchDTO.getStartDate() + "시작");
//		logger.info(searchDTO.getEndDate() + "종료");
//
//		List<CsCust01MtVO> customerList = null;
//		
//		try {
//			List<String> conditions = new ArrayList<String>();
//			
//			if(searchDTO.getPRT_NM() != null ) { //가입매장OR매장코드
//				conditions.add("AND (shop.PRT_NM LIKE "+"'%"+searchDTO.getPRT_NM()+"%' OR shop.PRT_CD LIKE "+"'%"+searchDTO.getPRT_NM()+"%')");
//			}
//			
//			if(searchDTO.getCUST_NM() != null) { //고객번호OR고객이름
//				conditions.add("AND (customer.CUST_NM LIKE" + "'%" + searchDTO.getCUST_NM() +"%' OR customer.CUST_NO LIKE "+"'%"+searchDTO.getCUST_NM()+"%')");
//			}
//			
//			if(searchDTO.getCUST_SS_CD()!=null && searchDTO.getCUST_SS_CD() != "0" && searchDTO.getCUST_SS_CD()!="") { //고객상태
//				conditions.add("AND customer.CUST_SS_CD='"+ searchDTO.getCUST_SS_CD()+ "'");
//			}
//			
//			if((searchDTO.getStartDate() !=null && searchDTO.getStartDate()!="") && (searchDTO.getEndDate() !=null && searchDTO.getEndDate() != "")){
//				conditions.add("AND customer.JS_DT between TO_DATE('"+searchDTO.getStartDate()+ "','YY-MM-DD') AND TO_DATE('" + searchDTO.getEndDate() +  "','YY-MM-DD')");
//				
//			}
//					
//				
//			searchDTO.setCondition(String.join(" ", conditions));
//			
//			customerList = sqlSession.selectList("memberMapper.customerList1", searchDTO );
//			
//			//이름+휴대폰번호 마킹처리
//			for(CsCust01MtVO data : customerList) {
//				data.setCUST_NM(nameMasking(data.getCUST_NM())); //이름 마킹처리
//				data.setMBL_NO(maskingPhoneNumber(convertTelNo(data.getMBL_NO()))); //휴대폰 마킹처리
//				
//			}
//			
//			log.info("********************전체검색 처리 찍히냐?.....->" +customerList.size() );
//			
//		}catch(Exception e) {
//			
//		}
//		
//		return customerList;
//	}

	/**
	 * 고객조회 검색처리 last
	 * 
	 * @param
	 */

	public List<CsCust01MtVO> customerList1(SearchDTO searchDTO) {

		logger.info("--" + searchDTO.getPRT_CD() + "--매장코드 왼쪽");
		logger.info("--" + searchDTO.getCUST_NO() + "--고객번호 왼쪽");

		logger.info(searchDTO.getPRT_NM() + "가입매장");
		logger.info(searchDTO.getCUST_SS_CD() + "고객상태");
		logger.info(searchDTO.getStartDate() + "시작");
		logger.info(searchDTO.getEndDate() + "종료");

		List<CsCust01MtVO> customerList = null;

		try {
			List<String> conditions = new ArrayList<String>();

			if (searchDTO.getPRT_CD() != null && searchDTO.getPRT_CD() != "") { // 정확한 매장코드
				conditions.add("AND shop.PRT_CD ='" + searchDTO.getPRT_CD() + "'");
			}

			if (searchDTO.getCUST_NO() != null && searchDTO.getCUST_NO() != "") { // 정확한 고객이름
				conditions.add("AND customer.CUST_NO ='" + searchDTO.getCUST_NO() + "'");
			}

			if (searchDTO.getCUST_SS_CD() != null && searchDTO.getCUST_SS_CD() != "0"
					&& searchDTO.getCUST_SS_CD() != "") { // 고객상태
				conditions.add("AND customer.CUST_SS_CD='" + searchDTO.getCUST_SS_CD() + "'");
			}

			if ((searchDTO.getStartDate() != null && searchDTO.getStartDate() != "")
					&& (searchDTO.getEndDate() != null && searchDTO.getEndDate() != "")) {
				conditions.add("AND customer.JS_DT between TO_DATE('" + searchDTO.getStartDate()
						+ "','YY-MM-DD') AND TO_DATE('" + searchDTO.getEndDate() + "','YY-MM-DD')");

			}

			searchDTO.setCondition(String.join(" ", conditions));

			customerList = sqlSession.selectList("memberMapper.customerList1", searchDTO);

			// 이름+휴대폰번호 마킹처리
			for (CsCust01MtVO data : customerList) {
				data.setCUST_NM(Masking.nameMasking(data.getCUST_NM())); // 이름 마킹처리
				data.setMBL_NO(Masking.maskingPhoneNumber(Masking.convertTelNo(data.getMBL_NO()))); // 휴대폰 마킹처리

			}

			log.info("********************전체검색 처리 찍히냐?.....->" + customerList.size());

		} catch (Exception e) {

		}

		return customerList;
	}

	// 쓰는거

	public List<CsCust01MtVO> customerList(SearchDTO searchDTO) throws Exception {

		List<CsCust01MtVO> customerList = sqlSession.selectList("memberMapper.customerList", searchDTO);

		return customerList;
	}

	public List<MaPrtMt> shopSearch(String PRT_NM) throws Exception {
		List<MaPrtMt> shopSearch = sqlSession.selectList("memberMapper.shopSearch", PRT_NM);

		System.out.println("리스트 ............" + shopSearch.size());
		return shopSearch;
	}

//	
//	public Map<String, Object> custNoCount(Map<String, Object> map) {
//		
//		Map<String, Object> totalCount = sqlSession.selectOne("memberMapper.custNoCount", map);
//		
//		
//		System.out.println("검색 결과 갯수......"+totalCount);
//		
//		return totalCount;
//	}
//	
//	
//	
//	public Map<String, String> custNoResult(Map<String, Object> map) {
//		
//		Map<String, String> custNoResult = sqlSession.selectOne("memberMapper.custNoResult");
//		
//		return custNoResult;
//	}

	public List<CsCust01MtVO> custNoSearchPop(String CUST_NM) throws Exception {

		List<CsCust01MtVO> list = sqlSession.selectList("memberMapper.custNoSearchPop", CUST_NM);

		// 휴대폰번호 하이픈처리
		for (CsCust01MtVO data : list) {
			data.setMBL_NO(Masking.convertTelNo(data.getMBL_NO()));
		}

		return list;
	}

	public List<CsCust01MtVO> popCdSearch(CsCust01MtVO csVO) throws Exception {
		System.out.println(csVO.getCUST_NM() + "너가?");
		System.out.println(csVO.getMBL_NO() + "너가?");

		List<CsCust01MtVO> list = sqlSession.selectList("memberMapper.popCdSearch", csVO);

		// 휴대폰번호 하이픈처리
		for (CsCust01MtVO data : list) {
			data.setMBL_NO(Masking.convertTelNo(data.getMBL_NO()));
		}

		return list;
	}

	public List<SdCust01HtVO> chHistoryPro(String CUST_NO) throws Exception {

		logger.info("######변경이력창 조회할 고객번호######....->" + CUST_NO);

		List<SdCust01HtVO> list = sqlSession.selectList("memberMapper.chHistoryPopUp", CUST_NO);

		return list;
	}

	public List<CsCust01MtVO> chCustNo(String CUST_NO) throws Exception {

		List<CsCust01MtVO> list = sqlSession.selectList("memberMapper.chCustNo", CUST_NO);
		return list;
	}

	/**
	 * 월별실적 처리부분
	 */

	public MonthlyVO monthPerfSearch(CsSal01MtVO csSalVO) throws Exception {

		String salesDateWasRemovedHypen = csSalVO.getSAL_DT().replaceAll(Pattern.quote("-"), "");

		csSalVO.setSAL_DT(salesDateWasRemovedHypen);
//		String lastDay = getLastDateOfMonth(csSalVO.getSAL_DT());

//		int a =30;
//		
//		
//		CsSal01MtVO b = new CsSal01MtVO();
//		b.setPRT_CD("B0000004");
//		b.setSAL_DT("9");
//		b.setTOT_SAL_QTY(3);
//		
//		List<CsSal01MtVO> list1 = new ArrayList<CsSal01MtVO>();
//		list1.add(b);
//		
//		for(CsSal01MtVO i : list1) {
//			for(int c=1; c<=a; c++) {
//				if(!i.getSAL_DT().equals((String.valueOf(c)))) {
//					String temp = "0";
//					System.out.print(temp);
//				}else {
//					System.out.print(i.getTOT_SAL_QTY());
//				}
//				System.out.print(" ");
//			}
//			System.out.println("  ");
//		}

		// CsSal01MtVO 는 데이터베이스 쿼리와 1:1 매핑되는 객체
		// 화면에서 필요한 데이터를 담고 있는 객체를 만들어서 리턴해야 함
		// Monthly

		List<CsSal01MtVO> list = sqlSession.selectList("memberMapper.monthPerfSearch", csSalVO);
		Map<String, Integer> monthlySum = list.stream().collect(
				Collectors.groupingBy(CsSal01MtVO::getPRT_CD, Collectors.summingInt(CsSal01MtVO::getTOT_SAL_QTY)));
		System.out.println("monthlysum is : " + monthlySum.get("B0000019"));

		MonthlyVO monthly = new MonthlyVO(list, monthlySum);

		System.out.println(list.size() + "  월별실적 사이즈.................");
		// 마지막날짜

		return monthly;
	}

	/**
	 * 월별실적 최종처리부분
	 * 
	 */

	public List<Map<String, String>> getTotal(Map<String, Object> map) throws Exception {

		return sqlSession.selectList("memberMapper.totalTable", map);
	}

	// ##########################2차과제####################

	/**
	 * 휴대폰번호 중복 검사
	 * 
	 */

	public List<CsCust01MtVO> phoneOverlap(String MBL_NO) throws Exception {

		List<CsCust01MtVO> list = sqlSession.selectList("memberMapper.phoneOverlap", MBL_NO);

		return list;
	}

	/**
	 * 고객정보 불러오는 메서드
	 */

	public CsCust01MtVO custInfo(String CUST_NO) throws Exception {

		CsCust01MtVO custInfo = sqlSession.selectOne("memberMapper.custInfo2", CUST_NO);
//		CsCust01MtVO custInfo2 = sqlSession.selectOne("memberMapper.custSal", CUST_NO);

		String brdyDtH = Masking.getDate(custInfo.getBRDY_DT()); // 년월일 하이픈 넣기(생일)
		String mrrgDtH = Masking.getDate(custInfo.getMRRG_DT()); // 년월일 하이픈 넣기(결혼기념일)
		String fstJsDtH = Masking.getDate(custInfo.getFST_JS_DT()); // 년월일 하이픈 넣기(최초가입일자)
		String jsDtH = Masking.getDate(custInfo.getJS_DT()); // 년월일 하이픈 넣기(가입일자)
		String stpDtH = Masking.getDate(custInfo.getSTP_DT()); // 년월일 하이픈 넣기(중지일자)
		String cnclDtH = Masking.getDate(custInfo.getCNCL_DT()); // 년월일 하이픈 넣기(해지일자)

		custInfo.setBRDY_DT(brdyDtH); // 생일
		custInfo.setMRRG_DT(mrrgDtH); // 결혼기념일
		custInfo.setFST_JS_DT(fstJsDtH); // 최초가입일자
		custInfo.setJS_DT(jsDtH); // 가입일자
		custInfo.setSTP_DT(stpDtH); // 중지일자
		custInfo.setCNCL_DT(cnclDtH); // 해지일자

		System.out.println("결혼--하이픈 넣었냐??????" + custInfo.getBRDY_DT()); // 년월일 하이픈 넣기(결혼기념일)
		System.out.println("최초--하이픈 넣었냐??????" + custInfo.getFST_JS_DT()); // 년월일 하이픈 넣기(최초가입일자)
		return custInfo;
	}

	public Map<String, String> custInfo2(String CUST_NO) throws Exception {

		Map<String, String> custInfo = sqlSession.selectOne("memberMapper.custInfo3", CUST_NO);

		System.out.println(custInfo);

		return custInfo;
	}

	/**
	 * 고객정보 수정
	 */

	public int custInfoUpdate(Map<String, Object> map) throws Exception {

//		String birthWasRemoveHypen = vo.getBRDY_DT().replaceAll(Pattern.quote("-"), ""); //생일 - 하이픈제거
//		vo.setBRDY_DT(birthWasRemoveHypen);
//		
//		String fstJsDtWasRemoveHypen = vo.getFST_JS_DT().replaceAll(Pattern.quote("-"), ""); //최초가입일자 하이픈제거
//		vo.setFST_JS_DT(fstJsDtWasRemoveHypen);
//		
//		String stpWasRemoveHypen = vo.getSTP_DT().replaceAll(Pattern.quote("-"), ""); //중지일자 하이픈제거
//		vo.setSTP_DT(stpWasRemoveHypen);
//		
//		String cnclDtWasRemoveHypen = vo.getCNCL_DT().replaceAll(Pattern.quote("-"),""); // 해지일자 하이픈제거
//		vo.setCNCL_DT(cnclDtWasRemoveHypen);
//		
//		String mrrgDtWasRemoveHypen = vo.getMRRG_DT().replaceAll(Pattern.quote("-"),""); //결혼기념일 하이픈 제거
//		vo.setMRRG_DT(mrrgDtWasRemoveHypen);

		map.put("BRDY_DT", String.valueOf(map.get("BRDY_DT")).replaceAll(Pattern.quote("-"), ""));
		map.put("MRRG_DT", String.valueOf(map.get("MRRG_DT")).replaceAll(Pattern.quote("-"), ""));
		map.put("FST_JS_DT", String.valueOf(map.get("FST_JS_DT")).replaceAll(Pattern.quote("-"), ""));
		map.put("JS_DT", String.valueOf(map.get("JS_DT")).replaceAll(Pattern.quote("-"), ""));
		map.put("STP_DT", String.valueOf(map.get("STP_DT")).replaceAll(Pattern.quote("-"), "")); // 중지일자
		map.put("CNCL_DT", String.valueOf(map.get("CNCL_DT")).replaceAll(Pattern.quote("-"), "")); // 중지일자

		int result = sqlSession.update("memberMapper.custInfoUpdate", map);

		System.out.println(result + "뭐오징..");
		return result;
	}

	/**
	 * 변경이력
	 * 
	 */

	public int historyInsert(List<Map<String, Object>> map) throws Exception {

		int result = 0;
		for (Map<String, Object> strMap : map) {

			result = sqlSession.insert("memberMapper.historyInsert", strMap);

		}
		System.out.println(result + "  0이면 실패.. 1이면 성공..성공했냐..?");

//		int result = sqlSession.insert(statement)
		return result;
	}

	/**
	 * 신규고객 등록 코드테이블
	 * 
	 */

	public Map<String, List<CodeMtDt>> findCodes() throws Exception {

		List<CodeMtDt> list = sqlSession.selectList("memberMapper.findCodes");

		Map<String, List<CodeMtDt>> result = list.stream().collect(Collectors.groupingBy(code -> code.getCODE_CD()));

		return result;
	}

	/**
	 * 신규고객 등록처리 부분
	 * 
	 */

	public int userRegist(CsCust01MtVO custMtVO) throws Exception {

		String replaceBrith = custMtVO.getBRDY_DT().replaceAll(Pattern.quote("-"), ""); // 생일 하이픈제거
		custMtVO.setBRDY_DT(replaceBrith);

		String mrrgDtWasRemoveHypen = custMtVO.getMRRG_DT().replaceAll(Pattern.quote("-"), ""); // 결혼기념일 하이픈 제거
		System.out.println(mrrgDtWasRemoveHypen + "결혼하이픈ㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴ");
		custMtVO.setMRRG_DT(mrrgDtWasRemoveHypen);

		int result = sqlSession.insert("memberMapper.userRegist", custMtVO);

		System.out.println(custMtVO.getCUST_NO() + "111111ㅎㅎㅎㅎㅎㅎㅎㅎㅎㅎㅎㅎㅎ");

		if (result == 1) {
			sqlSession.insert("memberMapper.pntDinsert", custMtVO);
			sqlSession.insert("memberMapper.pntDinsert2", custMtVO);

		}

		System.out.println(custMtVO.getCUST_NO() + "222222ㅎㅎㅎㅎㅎㅎㅎㅎㅎㅎㅎㅎㅎㅎㅎ");
		System.out.println(custMtVO.getFST_USER_ID() + "최초등록자");

		return result;

	}

	public List<CsCust01MtVO> userRegistPopUp() throws Exception {

		return null;
	}

}
