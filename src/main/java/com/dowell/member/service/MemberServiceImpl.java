//package com.dowell.member.service;
//
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Service;
//
//import com.dowell.member.dao.MemberDAO;
//import com.dowell.member.vo.CsCust01MtVO;
//import com.dowell.member.vo.MemberVO;
//
//@Service
//public class MemberServiceImpl implements MemberService{
//
//	@Autowired
//	private MemberDAO memberDAO;
//	
//	//로그인
//	@Override
//	public MemberVO login(MemberVO memberVO) throws Exception {
//		
//		MemberVO vo = memberDAO.login(memberVO);
//		
//		return vo;
//	}
//
//	@Override
//	public CsCust01MtVO search(CsCust01MtVO mem) throws Exception {
//		// TODO Auto-generated method stub
//		return memberDAO.search(mem);
//	}
//}
