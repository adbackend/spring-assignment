package com.dowell.admin.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.dowell.admin.service.AdminService;
import com.dowell.admin.service.MemberService;
import com.dowell.admin.vo.CodeMtDt;
import com.dowell.admin.vo.CodeNameVO;
import com.dowell.admin.vo.CsCust01MtVO;
import com.dowell.admin.vo.CsSal01MtVO;
import com.dowell.admin.vo.MaPrtMt;
import com.dowell.admin.vo.MemberVO;
import com.dowell.admin.vo.MonthlyVO;
import com.dowell.admin.vo.SdCust01HtVO;
import com.dowell.admin.vo.SearchDTO;

import lombok.extern.slf4j.Slf4j;

/**
 * @FileName : AdminController.java
 * @Date : 2022. 8. 26.
 * @작성자 : 최유정
 * @변경이력 :
 * @프로그램 설명 : 사용자(관리자) 컨트롤러
 */

@Slf4j
@RequestMapping("/admin/*")
@Controller
public class AdminController {

	@Autowired
	private MemberService memberService; // 로그인

	@Autowired
	private AdminService adminService;

	/**
	 * 고객관리 뷰
	 */
	@RequestMapping(value = "/customerList", method = RequestMethod.GET)
	public String login(Model model, HttpServletRequest request) throws Exception {

		HttpSession session = request.getSession(); // 로그인 정보 세션 가져오기

		MemberVO mem = (MemberVO) session.getAttribute("member");
		CodeNameVO cn = new CodeNameVO();

//		List<Map<String, String>> custSsList = adminService.getCustSSList();

		if (mem.getUSER_ID() == null) {
			return "redirect:/";
		} else {

			cn = memberService.codeName(mem.getUSER_ID());

			model.addAttribute("cn", cn);

			return "admin/customerList";
		}

	}

	/**
	 * 고객관리 - default 매장명, 고객상태:전체, 가입일자 d-7 ~ d
	 * 
	 * 고객조회 검색처리
	 */
	@ResponseBody
	@RequestMapping(value = "/customerList/search", method = RequestMethod.GET)
	public List<CsCust01MtVO> search2(Model model, SearchDTO searchDTO) throws Exception {

		log.info("####1##고객관리 메서드- 디폴트 처리단##########  ");
		log.info("------매장명-----!!prt_nm-->" + searchDTO.getPRT_NM());
		log.info("-------!!!!cust_nm---->" + searchDTO.getCUST_NM());
		log.info("------고객상태--!!!cust_ss_cd---->" + searchDTO.getCUST_SS_CD());
		log.info("------가입일자(시작)------>" + searchDTO.getStartDate());
		log.info("------가입일자(종료)------>" + searchDTO.getEndDate());

		List<CsCust01MtVO> customer = adminService.customerList1(searchDTO); // 고객관리 폼 디폴트

		return customer;
	}

	/**
	 * 매장코드+매장명 팝업창 호출
	 * 
	 * PRT_DT_CD 거래처구분코드 “2” 조회
	 * 
	 */
	@ResponseBody
	@RequestMapping(value = "/shopSearch", method = RequestMethod.GET)
	public List<MaPrtMt> shopSearch(String PRT_NM) throws Exception {

		// DB에서 조회한 결과값 조건 = 0, 1, 2이상
		// 1이면 정확히 일치- 팝업창x
		// 0 또는 2이상이면 팝업창 열기
		List<MaPrtMt> shopSearch = adminService.shopSearch(PRT_NM);

		return shopSearch;
	}

	// #######최종
	/**
	 * 고객번호 팝업창 뷰
	 * 
	 */
	@RequestMapping(value = "/popUp/csCustSearchPopUp", method = RequestMethod.GET)
	public String csCustSearchPopUp() throws Exception {

		return "admin/popUp/csCustSearchPopUp";
	}

//	@ResponseBody
//	@RequestMapping(value = "/custNoSearch", produces="text/plain;charset=UTF-8")
//	public String custNoSearch(@RequestParam Map<String, Object> map) {
//		
//		Map<String, Object> totalCount = new HashMap<>();
//		
//		totalCount = adminService.custNoCount(map);
//		
//		
//		Map<String, String> result = new HashMap<String, String>();
//		JSONObject jsonObj = new JSONObject();
//
//		if("1".equals(totalCount.get("CUST_CNT"))){
//			result = adminService.custNoResult(map);
//			jsonObj.put("CUST_NO", result.get("CUST_NO"));
//			jsonObj.put("CUST_NM", result.get("CUST_NM"));
//		}
//		
//		return jsonObj.toString();
//	}

	// 휴대폰 하이픈처리
	// 최종때 건드림##### 쓰는거임
	@ResponseBody
	@RequestMapping(value = "/custNoSearchPop", method = RequestMethod.GET)
	public List<CsCust01MtVO> custNoSearchPop(String CUST_NM) throws Exception {

		log.info("################고객번호 팝업#######");
		log.info(CUST_NM + " -----");

		List<CsCust01MtVO> list = adminService.custNoSearchPop(CUST_NM);

		log.info(list.size() + "#####고객팝업 갯수");

		return list;
	}

	// 휴대폰 하이픈처리
	/**
	 * 고객검색팝업창 고객이름or핸드폰 검색부분
	 */
	@ResponseBody
	@RequestMapping(value = "/popCdSearch", method = RequestMethod.POST)
	public List<CsCust01MtVO> popCdSearch(CsCust01MtVO csVO) throws Exception {

		log.info("이이이이이" + csVO.getCUST_NM());
		log.info("하하하" + csVO.getMBL_NO());

		List<CsCust01MtVO> list = adminService.popCdSearch(csVO);

		return list;
	}

	/**
	 * 변경이력 팝업창 뷰
	 * 
	 */
	@RequestMapping(value = "/popUp/chHistoryPopUp", method = RequestMethod.GET)
	public String chHistoryPopUp() throws Exception {
		return "admin/popUp/chHistoryPopUp";
	}

	/**
	 * 변경이력 팝업창 CUST_NM를 통해 CUST_NM을 들고옴
	 */
	@ResponseBody
	@RequestMapping(value = "/popUp/chCustNo", method = RequestMethod.GET)
	public List<CsCust01MtVO> chCustNo(String CUST_NO) throws Exception {
		log.info("#####################변경이력 팝업창###################");
		List<CsCust01MtVO> list = adminService.chCustNo(CUST_NO);
		log.debug("list 사이즈..." + list.size());

		return list;
	}

	/**
	 * 변경이력 팝업창 처리부분
	 * 
	 */
	@ResponseBody
	@RequestMapping(value = "/popUp/chHistoryPro", method = RequestMethod.GET)
	public List<SdCust01HtVO> chHistoryPro(String CUST_NO) throws Exception {

		List<SdCust01HtVO> list = adminService.chHistoryPro(CUST_NO);

		return list;
	}

	/**
	 * 월별실적 처리부분
	 * 
	 */
	@ResponseBody
	@RequestMapping(value = "/monthPerf/Search", method = RequestMethod.GET)
	public MonthlyVO monthPerfSearch(CsSal01MtVO csSalVO) throws Exception {

		log.info("######월별실적##########");
		log.info(".... " + csSalVO.getPRT_CD() + "........으으");
		log.info("..... " + csSalVO.getSAL_DT() + "........으으");

		MonthlyVO list = adminService.monthPerfSearch(csSalVO);

		return list;
	}

// 최종수정--------------------------	
	/**
	 * 매장검색 팝업창 뷰
	 * 
	 */
	@RequestMapping(value = "popUp/maPrtMtSearchPop", method = RequestMethod.GET)
	public String maPrtMtSearchPop() throws Exception {

		return "admin/popUp/maPrtMtSearchPop";
	}

	/**
	 * 월별실적 뷰 20220905 최종
	 * 
	 */
	@RequestMapping(value = "/monthPerf", method = RequestMethod.GET)
	public String montyPerf(HttpSession session, Model model) throws Exception {

		MemberVO mem = (MemberVO) session.getAttribute("member");
		CodeNameVO cn = new CodeNameVO();

		if (mem.getUSER_ID() == null) {
			return "redirect:/";
		} else {

			cn = memberService.codeName(mem.getUSER_ID());
//   			세션이 들고 있는 값			
//				PRT_CD/*  거래처 코드  */
//				PRT_NM /*  거래처명  */
//				USER_ID  /*  사용자ID  */
//				USER_DT_CD	/* 사용자구분코드  1:회사, 2:특약점*/ 

			model.addAttribute("cn", cn); // 세션

			return "admin/monthPerf1";
		}
	}

	/**
	 * 월별실적 처리부분 최종부분 20220905
	 * 
	 * @throws Exception
	 * 
	 */
	@ResponseBody
	@RequestMapping(value = "/monthPerf/Search1", produces = "text/plain;charset=UTF-8")
	public String getTotal(ModelAndView mav, @RequestParam Map<String, Object> map) throws Exception {
		log.info("$$$$$$$$$$$$$$$$$$$$$$월별실적 최종처리 부분###############");

		System.out.println("maaaaP" + map);

		List<Map<String, String>> totalList = adminService.getTotal(map);

		JSONArray jsonArr = new JSONArray();

		if (totalList != null && totalList.size() > 0) {

			for (Map<String, String> totalMap : totalList) {
				System.out.println("tatallll" + totalMap.get("PRT_CD"));
				JSONObject jsonObj = new JSONObject();
				try {
					jsonObj.put("PRT_CD", totalMap.get("PRT_CD"));
					jsonObj.put("PRT_NM", totalMap.get("PRT_NM"));
					jsonObj.put("SAL_1_QTY", totalMap.get("SAL_1_QTY"));
					jsonObj.put("SAL_2_QTY", totalMap.get("SAL_2_QTY"));
					jsonObj.put("SAL_3_QTY", totalMap.get("SAL_3_QTY"));
					jsonObj.put("SAL_4_QTY", totalMap.get("SAL_4_QTY"));
					jsonObj.put("SAL_5_QTY", totalMap.get("SAL_5_QTY"));
					jsonObj.put("SAL_6_QTY", totalMap.get("SAL_6_QTY"));
					jsonObj.put("SAL_7_QTY", totalMap.get("SAL_7_QTY"));
					jsonObj.put("SAL_8_QTY", totalMap.get("SAL_8_QTY"));
					jsonObj.put("SAL_9_QTY", totalMap.get("SAL_9_QTY"));
					jsonObj.put("SAL_10_QTY", totalMap.get("SAL_10_QTY"));
					jsonObj.put("SAL_11_QTY", totalMap.get("SAL_11_QTY"));
					jsonObj.put("SAL_12_QTY", totalMap.get("SAL_12_QTY"));
					jsonObj.put("SAL_13_QTY", totalMap.get("SAL_13_QTY"));
					jsonObj.put("SAL_14_QTY", totalMap.get("SAL_14_QTY"));
					jsonObj.put("SAL_15_QTY", totalMap.get("SAL_15_QTY"));
					jsonObj.put("SAL_16_QTY", totalMap.get("SAL_16_QTY"));
					jsonObj.put("SAL_17_QTY", totalMap.get("SAL_17_QTY"));
					jsonObj.put("SAL_18_QTY", totalMap.get("SAL_18_QTY"));
					jsonObj.put("SAL_19_QTY", totalMap.get("SAL_19_QTY"));
					jsonObj.put("SAL_20_QTY", totalMap.get("SAL_20_QTY"));
					jsonObj.put("SAL_21_QTY", totalMap.get("SAL_21_QTY"));
					jsonObj.put("SAL_22_QTY", totalMap.get("SAL_22_QTY"));
					jsonObj.put("SAL_23_QTY", totalMap.get("SAL_23_QTY"));
					jsonObj.put("SAL_24_QTY", totalMap.get("SAL_24_QTY"));
					jsonObj.put("SAL_25_QTY", totalMap.get("SAL_25_QTY"));
					jsonObj.put("SAL_26_QTY", totalMap.get("SAL_26_QTY"));
					jsonObj.put("SAL_27_QTY", totalMap.get("SAL_27_QTY"));
					jsonObj.put("SAL_28_QTY", totalMap.get("SAL_28_QTY"));
					jsonObj.put("SAL_29_QTY", totalMap.get("SAL_29_QTY"));
					jsonObj.put("SAL_30_QTY", totalMap.get("SAL_30_QTY"));
					jsonObj.put("SAL_31_QTY", totalMap.get("SAL_31_QTY"));
					jsonObj.put("TOT_SAL_QTY", totalMap.get("TOT_SAL_QTY"));

				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

				jsonArr.put(jsonObj);

			}

		}

		return jsonArr.toString();
	}

	/// ######2차과제##############2차과제#################2차과제#####################

	/**
	 * 고객상세 뷰
	 * 
	 */
	@RequestMapping(value = "/custInfo", method = RequestMethod.POST)
	public String custInfo(HttpSession session, Model model, String CUST_NO) throws Exception {

		MemberVO mem = (MemberVO) session.getAttribute("member");
		CodeNameVO cn = new CodeNameVO();

//		if(mem.getUSER_ID() == null) {
//			return "redirect:/";
//		}

		if (CUST_NO != null) {

			System.out.println("고객상세뷰...고객번호....->" + CUST_NO);

			CsCust01MtVO custInfo = adminService.custInfo(CUST_NO);

			System.out.println(custInfo.toString());
			model.addAttribute("custInfo", custInfo);

			cn = memberService.codeName(mem.getUSER_ID());
//		세션이 들고 있는 값			
//		PRT_CD		/*  거래처 코드  */
//		PRT_NM 		/*  거래처명  */
//		USER_ID  	/*  사용자ID  */
//		USER_NM		/*  사용자명*/
//		USER_DT_CD	/* 사용자구분코드  1:회사, 2:특약점*/ 

			model.addAttribute("cn", cn); // 세션

			// 코드테이블 디폴트값
			Map<String, List<CodeMtDt>> codes = adminService.findCodes();
			model.addAttribute("codes", codes);
			return "admin/custInfo";

		} else {

			return "admin/custInfo";
		}
	}

	/**
	 * 고객상세 뷰 33
	 * 
	 */
	@RequestMapping(value = "/custInfo3", method = { RequestMethod.POST, RequestMethod.GET })
	public String custInfo3(HttpSession session, Model model, String CUST_NO) throws Exception {

		MemberVO mem = (MemberVO) session.getAttribute("member");
		CodeNameVO cn = new CodeNameVO();

//		if(mem.getUSER_ID() == null) {
//			return "redirect:/";
//		}

		if (CUST_NO != null) {

			System.out.println("고객상세뷰...고객번호....->" + CUST_NO);

			CsCust01MtVO custInfo = adminService.custInfo(CUST_NO);

			System.out.println("#############ggggggggggggggggggggggggg#################");
			System.out.println(custInfo.toString());
			model.addAttribute("custInfo", custInfo);

			cn = memberService.codeName(mem.getUSER_ID());
//		세션이 들고 있는 값			
//		PRT_CD		/*  거래처 코드  */
//		PRT_NM 		/*  거래처명  */
//		USER_ID  	/*  사용자ID  */
//		USER_NM		/*  사용자명*/
//		USER_DT_CD	/* 사용자구분코드  1:회사, 2:특약점*/ 

			model.addAttribute("cn", cn); // 세션

			// 코드테이블 디폴트값
			Map<String, List<CodeMtDt>> codes = adminService.findCodes();
			model.addAttribute("codes", codes);
			return "admin/custInfo3";

		} else {
			Map<String, List<CodeMtDt>> codes = adminService.findCodes();
			model.addAttribute("codes", codes);
			return "admin/custInfo3";
		}
	}

	/**
	 * 고객정보 update 및 변경이력 insert update/insert 모두 실패하거나, 모두 성공하거나
	 * 
	 * 
	 * Map<String, List<Map<String, Object>>> map
	 */
	@ResponseBody
	@RequestMapping(value = "/custUpdateInsert", method = RequestMethod.POST)
	public String custUpdateInsert(@RequestBody Map<String, Object> map) throws Exception {

		System.out.println("######custUpdateInsert####");
		System.out.println(map.size() + "맵사이즈..");

		System.out.println(map.get("custUpdate"));

		// String, int, Boolean, ... > Object 담을 수 있음
		// Object > String, int, Boolean, ... Object 담을 수 없음 (형변환)
		Map<String, Object> custUpdate = (Map<String, Object>) map.get("custUpdate");

		int result = adminService.custInfoUpdate(custUpdate);

		if (result == 1) {

			System.out.println(map.get("custInsert"));
//			List<Map<String, Object>> custInsert = (List<Map<String, Object>>) map.get("custInsert");

			List<Map<String, Object>> custInsert = (List<Map<String, Object>>) map.get("custInsert");

			result = adminService.historyInsert(custInsert);
		}

		JSONObject jo = new JSONObject();
		jo.put("rest", result);

		return jo.toString();
	}

	/**
	 * 고객정보조회 검색
	 */
	@ResponseBody
	@RequestMapping(value = "searchCustInfo", method = RequestMethod.POST)
	public CsCust01MtVO searchCustInfo(Model model, String CUST_NO) throws Exception {
		System.out.println("22222222##############################3검색 에이작스########");
		System.out.println(CUST_NO + " 너 오냐?");
		CsCust01MtVO custInfo = adminService.custInfo(CUST_NO);
		model.addAttribute("custInfo", custInfo);

//		넌안쓰지..
//		Map<String, List<CodeMtDt>> codes = adminService.findCodes(); 
//		model.addAttribute("codes", codes);

		return custInfo;
	}

	/**
	 * client(사용자) -> server(controller) json 형식으로 데이터를 보냄 json 형식의 데이터를 서버에서 객체로 값을
	 * 저장하기 위해서는 Converting 변환 -> json -> object 변환하는 과정이 필요 Spring Boot 에서는
	 * ObjectMapper 가 내장되
	 */

	/*
	 * 고객수정쿼리
	 */
//	@ResponseBody
//	@RequestMapping(value="/custInfoUpdate", method = RequestMethod.POST)
//	public int custInfoUpdate(CsCust01MtVO vo) throws Exception{
//		
////		System.out.println(new );
//		
////		System.out.println(vo.toString());
//		
//		System.out.println("##############업데이트##################");
//		
////		int result = adminService.custInfoUpdate(vo);
//		
//		
//		return result ; 
//	}

	/**
	 * 변경이력 인서트
	 * 
	 */
	@ResponseBody
	@RequestMapping(value = "/historyInsert", method = RequestMethod.POST, produces = "text/html; charset=utf-8")
	public String historyInsert(@RequestBody List<Map<String, Object>> map, HttpSession session) {

		System.out.println("^^^");
		System.out.println(map);
		System.out.println(map.size() + "맵사이즈..");
		System.out.println("^^^");

		SdCust01HtVO SdCustVO = new SdCust01HtVO();

		try {
			int resultValue = adminService.historyInsert(map);
		} catch (Exception e) {
			e.printStackTrace();
		}

//		String[] arr = map;

//		for(Map<String, Object> strMap : map) {
//			System.out.println(strMap.get("CHG_CD"));
//			System.out.println(strMap.get("CHG_BF_CNT"));
//			System.out.println(strMap.get("CHG_AFT_CNT"));
//			System.out.println(strMap.get("LST_UPD_ID")); //최종수정자
//			
////			SdCustVO.setCUST_NO(CUST_NO);
//		}

		JSONObject jo = new JSONObject();
		jo.put("rest", "1");

		return jo.toString();
	}

	/*
	 * 고객수정쿼리
	 */
//	@ResponseBody
//	@RequestMapping(value="/custInfoUpdate", method = RequestMethod.POST)
//	public int custInfoUpdate(@RequestBody HashMap<String, Object> reqeust) throws Exception{
//		
////		System.out.println(new );
//		
////		System.out.println(vo.toString());
//		
//		System.out.println("##############업데이트##################");
//		
////		int result = adminService.custInfoUpdate(vo);
//		
//		
//		return 1 ; 
//	}
//	

	/**
	 * 신규등록 팝업창 뷰
	 * 
	 */
	@RequestMapping(value = "/popUp/userRegistPopUp", method = RequestMethod.GET)
	public String userRegistPopUp(HttpSession session, Model model) throws Exception {

		MemberVO mem = (MemberVO) session.getAttribute("member");
		CodeNameVO cn = new CodeNameVO();

		if (mem.getUSER_ID() == null) {
			return "redirect:/";
		} else {

			cn = memberService.codeName(mem.getUSER_ID());
//   			세션이 들고 있는 값			
//				PRT_CD/*  거래처 코드  */
//				PRT_NM /*  거래처명  */
//				USER_ID  /*  사용자ID  */
//				USER_DT_CD	/* 사용자구분코드  1:회사, 2:특약점*/ 

			model.addAttribute("cn", cn); // 세션
		}

		Map<String, List<CodeMtDt>> codes = adminService.findCodes();
		model.addAttribute("codes", codes);

		return "admin/popUp/userRegistPopUp";

	}

	/**
	 * 신규등록 처리 부분
	 * 
	 */
	@ResponseBody
	@RequestMapping(value = "/userRegister", method = RequestMethod.POST)
	public int userRegister(CsCust01MtVO custMtVO) throws Exception {

		System.out.println("오냐??????????????1");
		System.out.println(custMtVO.toString());

		int result = adminService.userRegist(custMtVO);
		System.out.println("result 1이와야 정상....." + result);
		System.out.println(custMtVO.getCUST_NO() + "ㅋㅋㅋㅋㅋㅋ");

		return result;
	}

	/**
	 * 휴대폰번호 중복 체크 변경클릭시
	 * 
	 */
	@ResponseBody
	@RequestMapping(value = "/phoneOverlap", method = RequestMethod.POST)
	public List<CsCust01MtVO> phoneOverlap(@RequestParam("mblNo") String MBL_NO) throws Exception {

		log.info(MBL_NO + " 클라이언트로 부터 받아오는 번호");
		List<CsCust01MtVO> list = adminService.phoneOverlap(MBL_NO);

		return list;
	}

}
