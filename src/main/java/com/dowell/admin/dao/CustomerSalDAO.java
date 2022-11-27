package com.dowell.admin.dao;

import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.dowell.admin.dto.SalReturnDTO;
import com.dowell.admin.vo.CsCust01MtVO;
import com.dowell.admin.vo.CsSal01DtVO;
import com.dowell.admin.vo.CsSal01MtVO;
import com.dowell.admin.vo.CustPntD;
import com.dowell.admin.vo.CustPntM;
import com.dowell.admin.vo.CustSalSearchDTO;
import com.dowell.admin.vo.MaPrdMt;
import com.dowell.admin.vo.SdIvco01MtVO;

@Repository
public class CustomerSalDAO {

	@Autowired
	private SqlSession sqlSession;

	// 고객판매관리 전체 검색
	public List<CsSal01MtVO> custSearchList(CustSalSearchDTO custSalSearhDTO) throws Exception {

		String startDateWasRemoveHypen = custSalSearhDTO.getStartDate().replaceAll(Pattern.quote("-"), ""); // 시작일자 -하이픈제거
		custSalSearhDTO.setStartDate(startDateWasRemoveHypen);

		String endDateWasRemoveHypen = custSalSearhDTO.getEndDate().replaceAll(Pattern.quote("-"), ""); // 종료일자 - 하이픈제거
		custSalSearhDTO.setEndDate(endDateWasRemoveHypen);

		List<CsSal01MtVO> custSearchList = sqlSession.selectList("customerSalMapper.custSearchList", custSalSearhDTO);

		return custSearchList;
	}

	/**
	 * 판매상세조회 팝업창 상세목록
	 * 
	 * {PRT_CD, SAL_DT, SAL_NO} 가져와서 조회
	 */
	public List<CsSal01DtVO> custSalDetailList(Map<String, Object> map) throws Exception {

		map.put("SAL_DT", String.valueOf(map.get("SAL_DT")).replaceAll(Pattern.quote("-"), "")); // 하이픈제거

		List<CsSal01DtVO> list = sqlSession.selectList("customerSalMapper.custSalDetailList", map);

		return list;
	}

	/**
	 * SAL인데 반품목록인지 판별하는 메소드 0이면 반품된상품x, 1이면 반품된 상품
	 * 
	 */

	public List<CsSal01MtVO> salReCheck(Map<String, Object> map) throws Exception {

		map.put("SAL_DT", String.valueOf(map.get("SAL_DT")).replaceAll(Pattern.quote("-"), "")); // 하이픈제거

		List<CsSal01MtVO> list = sqlSession.selectList("customerSalMapper.salReCheck", map);

		return list;
	}

	/**
	 * 매장 재고조회 상품코드+매장코드를 파라미터로 받아옴
	 * 
	 */

	public List<SdIvco01MtVO> ivcoSearch(SdIvco01MtVO sdIvocoVO) throws Exception {

		List<SdIvco01MtVO> list = sqlSession.selectList("customerSalMapper.ivcoSearch", sdIvocoVO);

		return list;
	}

	//List<Product> list에 담긴 Product객체
	public List<MaPrdMt> getProducts(List<String> prdCdList) {
		return sqlSession.selectList("customerSalMapper.getProducts", prdCdList);
	}

	// MT테이블 반품처리 OR 판매 처리 할때  INSERT
	public int createCsSalMt(CsSal01MtVO csSal01MtVO) {
		System.out.println("11 반품처리 OR 판매 처리 할때");
		System.out.println(csSal01MtVO.toString());
		System.out.println("11 반품처리 OR 판매 처리 할때");
		int result = sqlSession.insert("customerSalMapper.createCsSalMt", csSal01MtVO);

		return result;
	}

	// 고객판매상세테이블 INSERT
	public int createCsSal01Dt(CsSal01DtVO csSal01DtVO) {
		int result = sqlSession.insert("customerSalMapper.createCsSal01Dt", csSal01DtVO);
		return result;
	}
	
	// 매장현재고 업데이트(해당 제품의 구매수량만큼 재고 차감)
	public int createSdIvco01Mt(SdIvco01MtVO sdIvco01MtVO) {
		int result = sqlSession.update("customerSalMapper.createSdIvco01Mt", sdIvco01MtVO);
		return result;

	}

	//한명의 고객의 회원포인트 조회
	public CsCust01MtVO getCsCust01Mt(String custNo) {
		CsCust01MtVO csCust01MtVO = sqlSession.selectOne("customerSalMapper.getCsCust01Mt", custNo);
		return csCust01MtVO;
	}

	//포인트를 사용하였다면 포인트 사용 이력 추가
	//포인트 사용 안했다면 포인트 제외한 금액의 10%지금
	public int createCustPntD(CustPntD custPntD) {
		int result = sqlSession.insert("customerSalMapper.createCustPntD", custPntD);
		return result;
		
	}
	
	//회원포인트 테이블 업데이트 (구매)
	public int updateCustPntMPurchase(CustPntM custPntM) {
		int result = sqlSession.update("customerSalMapper.updateCustPntMPurchase", custPntM);
		return result;	
	}
	
	//회원포인트 테이블 업데이트 (반품)
	public int updateCustPntMReturn(CustPntM custPntM) {
		int result = sqlSession.update("customerSalMapper.updateCustPntMReturn", custPntM);
		return result;	
	}
	
	//반품처리할 MT테이블의 판매내역 조회
	public CsSal01MtVO salHistory(CsSal01MtVO salMtVO) {
		
		CsSal01MtVO vo = sqlSession.selectOne("customerSalMapper.salHistory", salMtVO);
		
		System.out.println("fffffffffffffffffff");
		
		System.out.println(vo.toString());
		return vo;
	}
	
	//반품처리하기 위해. 구매한 상품들  DT테이블 조회해서 LIST에 담기
	public List<CsSal01DtVO> salDtList(CsSal01DtVO salDtList){
		
		List<CsSal01DtVO> list = sqlSession.selectList("customerSalMapper.salDtList", salDtList);
		
		System.out.println("반품처리 list 사이즈........"+list.size());
		
		return list;
	}
	
	// 매장현재고 업데이트 (해당 제품의 반품 수량만큼 재고 더해주기 )
	public void ivcoUpdateAdd(SdIvco01MtVO ivocoMtAdd) {
		sqlSession.update("customerSalMapper.ivocoMtAdd", ivocoMtAdd);
	}

	public void txTest(SdIvco01MtVO ivocoMtAdd) {
		sqlSession.update("customerSalMapper.txTest", ivocoMtAdd);
		
	}

}
