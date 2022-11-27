//package com.dowell.member.dao;
//
//import java.util.List;
//
//import org.apache.ibatis.session.SqlSession;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Repository;
//
//import com.dowell.member.vo.CsCust01MtVO;
//import com.dowell.member.vo.MemberVO;
//
//@Repository
//public class MemberDAOImpl implements MemberDAO{
//
//	@Autowired
//	private SqlSession sqlSession;
//	
//	//로그인
//	@Override
//	public MemberVO login(MemberVO memberVO) throws Exception {
//		
//		MemberVO vo = sqlSession.selectOne("memberMapper.login", memberVO);
//		
//		return vo;
//	}
//
//	@Override
//	public CsCust01MtVO search(CsCust01MtVO mem) throws Exception {
//		// TODO Auto-generated method stub
//		
//		CsCust01MtVO vo = sqlSession.selectOne("memberMapper.search", mem);
//		return vo;
//	}
//	
//}
