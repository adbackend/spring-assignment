package com.dowell.admin.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.dowell.admin.dto.SalInsertDTO;
import com.dowell.admin.dto.SalReturnDTO;
import com.dowell.admin.service.AdminService;
import com.dowell.admin.service.CustomerSalService;
import com.dowell.admin.service.MemberService;
import com.dowell.admin.vo.CodeMtDt;
import com.dowell.admin.vo.CodeNameVO;
import com.dowell.admin.vo.CsSal01DtVO;
import com.dowell.admin.vo.CsSal01MtVO;
import com.dowell.admin.vo.CustSalSearchDTO;
import com.dowell.admin.vo.MemberVO;
import com.dowell.admin.vo.SdIvco01MtVO;

/**		
 * @package_name : com.dowell.admin.controller
 * @FileName : CustomerSalController.java				
 * @Date : 2022. 9. 26.						
 * @작성자 : 최유정
 * @변경이력 :
 * @프로그램 설명 : 고객판매 컨트롤러
 */
@RequestMapping("/admin/management/*")
@Controller
public class CustomerSalController {

	@Autowired
	private MemberService memberService;

	@Autowired
	private AdminService adminService;

	@Autowired
	private CustomerSalService customerSalService;
	
	@GetMapping("/tx-test")
	public ResponseEntity<Void> txTest(Boolean sw, Integer cqy) {
		customerSalService.txTest(sw, cqy);
		return ResponseEntity.status(HttpStatus.OK).build();
	} 

	/**
	 * 고객판매조회 FORM
	 * 
	 */
	@RequestMapping(value = "/custSalSearchForm", method = { RequestMethod.POST, RequestMethod.GET })
	public String custSalSearch(Model model, HttpSession session) throws Exception {

		MemberVO mem = (MemberVO) session.getAttribute("member");
		CodeNameVO cn = new CodeNameVO();

		if (mem.getUSER_ID() == null) {
			System.out.println("세션끊김!!!!!!!!!!!!!!!!!!!!!");
			return "redirect:member/loginForm";
		} else {

			cn = memberService.codeName(mem.getUSER_ID());
//   			세션이 들고 있는 값			
//				PRT_CD/*  거래처 코드  */
//				PRT_NM /*  거래처명  */
//				USER_ID  /*  사용자ID  */
//				USER_DT_CD	/* 사용자구분코드  1:회사, 2:특약점*/ 

			model.addAttribute("cn", cn); // 세션

			return "admin/customerSalManagement/custSalSearchForm";
		}

	}

	/**
	 * 고객판매조회 검색ajax 처리
	 * 
	 */
	@ResponseBody
	@RequestMapping(value = "/custSalSearch", method = RequestMethod.GET)
	public List<CsSal01MtVO> custSalSearch(CustSalSearchDTO custSalSearhDTO) throws Exception {
		System.out.println(custSalSearhDTO.toString());

		List<CsSal01MtVO> custSearchList = customerSalService.custSearchList(custSalSearhDTO);

		return custSearchList;
	}

	/**
	 * 판매상세조회 팝업창 FORM
	 * /dowellPro/src/main/webapp/WEB-INF/views/admin/popUp/salPop/custSalDetail.jsp
	 */
	@RequestMapping(value = "/popUp/salPop/custSalDetial", method = RequestMethod.GET)
	public String custSalDetail() throws Exception {

		System.out.println("#####판매상세조회 팝업창#####");

		return "admin/popUp/salPop/custSalDetail";
	}

	/**
	 * 판매상세조회 팝업창 상세목록
	 * 
	 * {PRT_CD, SAL_DT, SAL_NO} 가져와서 조회
	 */
	@ResponseBody
	@RequestMapping(value = "/salPop/custSalDetailList", method = RequestMethod.POST)
	public List<CsSal01DtVO> custSalDetailList(@RequestBody Map<String, Object> map) throws Exception {

		System.out.println("#####################판매상세조회 리스트11################");
		System.out.println("맵사이즈..........." + map.size());
		System.out.println("매장코드..........." + map.get("PRT_CD"));
		System.out.println("판매일자..........." + map.get("SAL_DT"));
		System.out.println("판매번호..........." + map.get("SAL_NO"));

		List<CsSal01DtVO> list = customerSalService.custSalDetailList(map);
//		System.out.println(list.get(0).getPRD_CD() + "   ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ");
		return list;
	}

	/**
	 * 판매상세조회 - SAL인데 반품목록인지 판별하는 컨트롤러 0이면 반품된상품x, 1이면 반품된 상품
	 */
	@ResponseBody
	@RequestMapping(value = "/salReCheck", method = RequestMethod.POST)
	public List<CsSal01MtVO> salReCheck(@RequestBody Map<String, Object> map) throws Exception {

		List<CsSal01MtVO> list = customerSalService.salReCheck(map);

		return list;
	}

	/**
	 * 고객판매수금등록 팝업창 FORM
	 * 
	 */
	@RequestMapping(value = "/popUp/salPop/salRegister", method = RequestMethod.GET)
	public String salRegister(Model model) throws Exception {
		
		// 코드테이블 디폴트값
		Map<String, List<CodeMtDt>> codes = adminService.findCodes();
		model.addAttribute("codes", codes);

		return "admin/popUp/salPop/salRegister";
	}

	/**
	 * 매장재고 팝업창 FORM
	 * 
	 */
	@RequestMapping(value = "popUp/ivcoSearchForm", method = RequestMethod.GET)
	public String ivcoSearchForm() throws Exception {

		return "/admin/popUp/ivcoSearchPopUp";
	}

	/**
	 * 매장 재고조회
	 * 
	 * 상품코드+매장코드를 파라미터로 받아옴
	 * 
	 */
	@ResponseBody
	@RequestMapping(value = "/ivcoSearch", method = RequestMethod.POST)
	public List<SdIvco01MtVO> ivcoSearch(SdIvco01MtVO sdIvocoVO) throws Exception {
		
		List<SdIvco01MtVO> list = customerSalService.ivcoSearch(sdIvocoVO);

		return list;
	}

	/**
	 * 판매상세수금등록
	 * 
	 * 고객판매mt ,dt insert 포인트 재고관리
	 * 
	 */
	@ResponseBody
	@PostMapping("/salInsert")
	public ResponseEntity<Void> salInsert(@RequestBody SalInsertDTO.Request request, HttpSession session) throws Exception {
		
		Map<String, List<CodeMtDt>> codes = adminService.findCodes(); //코드테이블
		customerSalService.salInsert(request, session, codes);
		
		return ResponseEntity.status(HttpStatus.OK).build();
	}
	
	/**
	 * 반품처리  
	 * 
	 * */
	@ResponseBody
	@PostMapping("/salReturnProcess")
	public ResponseEntity<Void> salReturnProcess(@RequestBody SalReturnDTO.Request request, HttpSession session) throws Exception{
		
		customerSalService.salReturnProcess(request, session);
		
		return ResponseEntity.status(HttpStatus.OK).build();
	}

}
