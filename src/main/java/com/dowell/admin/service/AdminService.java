package com.dowell.admin.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.dowell.admin.dao.AdminDAO;
import com.dowell.admin.vo.CodeMtDt;
import com.dowell.admin.vo.CsCust01MtVO;
import com.dowell.admin.vo.CsSal01MtVO;
import com.dowell.admin.vo.MaPrtMt;
import com.dowell.admin.vo.MonthlyVO;
import com.dowell.admin.vo.SdCust01HtVO;
import com.dowell.admin.vo.SearchDTO;

@Service
@Transactional(rollbackFor = Exception.class)
public class AdminService {

	@Autowired
	private AdminDAO adminDAO;

	/**
	 * 고객리스트
	 * 
	 */

	public List<CsCust01MtVO> customerList(SearchDTO searchDTO) throws Exception {

		List<CsCust01MtVO> customerList = adminDAO.customerList(searchDTO);

		return customerList;
	}

	/**
	 * 고객리스트
	 * 
	 */

	public List<CsCust01MtVO> customerList1(SearchDTO searchDTO) throws Exception {
		List<CsCust01MtVO> customerList1 = adminDAO.customerList1(searchDTO);

		return customerList1;
	}

	public List<MaPrtMt> shopSearch(String PRT_NM) throws Exception {
		List<MaPrtMt> shopSearch = adminDAO.shopSearch(PRT_NM);
		return shopSearch;
	}

//	
//	public Map<String, Object> custNoCount(Map<String, Object> map) {
//		
//		return adminDAO.custNoCount(map);
//	}
//	
//	
//	public Map<String, String> custNoResult(Map<String, Object> map) {
//		
//		return adminDAO.custNoResult(map);
//	}

	public List<CsCust01MtVO> custNoSearchPop(String CUST_NM) throws Exception {

		List<CsCust01MtVO> list = adminDAO.custNoSearchPop(CUST_NM);// 고객조건 결과

		return list;
	}

	public List<CsCust01MtVO> popCdSearch(CsCust01MtVO csVO) throws Exception {

		List<CsCust01MtVO> list = adminDAO.popCdSearch(csVO);

		return list;
	}

	public List<SdCust01HtVO> chHistoryPro(String CUST_NO) throws Exception {

		List<SdCust01HtVO> list = adminDAO.chHistoryPro(CUST_NO);

		return list;
	}

	/**
	 * 변경이력 팝업창 CUST_NM를 통해 CUST_NM을 들고옴
	 */

	public List<CsCust01MtVO> chCustNo(String CUST_NO) throws Exception {
		List<CsCust01MtVO> list = adminDAO.chCustNo(CUST_NO);

		return list;
	}

	/**
	 * 
	 * 월별실적 처리부분
	 * 
	 */

	public MonthlyVO monthPerfSearch(CsSal01MtVO csSalVO) throws Exception {

		MonthlyVO result = adminDAO.monthPerfSearch(csSalVO);

		return result;
	}

	/**
	 * 월별실적 최종
	 * 
	 * 
	 */

	public List<Map<String, String>> getTotal(Map<String, Object> map) throws Exception {

		List<Map<String, String>> totalList = adminDAO.getTotal(map);

		return totalList;
	}

//################################2차

	public List<CsCust01MtVO> userRegistPopUp() throws Exception {

		return adminDAO.userRegistPopUp();
	}

	public Map<String, List<CodeMtDt>> findCodes() throws Exception {

		return adminDAO.findCodes();
	}

	/**
	 * 고객정보 불러오는 메서드
	 */

	public CsCust01MtVO custInfo(String CUST_NO) throws Exception {

		CsCust01MtVO custInfo = adminDAO.custInfo(CUST_NO);

		return custInfo;
	}

	/*
	 * 고객정보 업데이트 메서드
	 * 
	 */

	public int custInfoUpdate(Map<String, Object> map) throws Exception {

		int result = adminDAO.custInfoUpdate(map);

		return result;
	}

	public int historyInsert(List<Map<String, Object>> map) throws Exception {

		int result = adminDAO.historyInsert(map);

		return result;
	}

	/**
	 * 신규고객등록
	 */

	public int userRegist(CsCust01MtVO custMtVO) throws Exception {
		int result = adminDAO.userRegist(custMtVO);
		return result;
	}

	public Map<String, String> custInfo2(String CUST_NO) throws Exception {

		Map<String, String> custInfo = adminDAO.custInfo2(CUST_NO);

		return custInfo;
	}

	/**
	 * 휴대폰번호 중복체크
	 */

	public List<CsCust01MtVO> phoneOverlap(String MBL_NO) throws Exception {

		List<CsCust01MtVO> list = adminDAO.phoneOverlap(MBL_NO);

		return list;
	}

}
