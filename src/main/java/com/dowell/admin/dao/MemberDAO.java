package com.dowell.admin.dao;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.dowell.admin.vo.CodeNameVO;
import com.dowell.admin.vo.CsCust01MtVO;
import com.dowell.admin.vo.MemberVO;

@Repository
public class MemberDAO{

	@Autowired
	private SqlSession sqlSession;
	
	//로그인
	
	public MemberVO login(MemberVO memberVO) throws Exception {
		
		MemberVO vo = sqlSession.selectOne("memberMapper.login", memberVO);
		
		return vo;
	}

	
	public CsCust01MtVO search(CsCust01MtVO mem) throws Exception {
		
		CsCust01MtVO vo = sqlSession.selectOne("memberMapper.search", mem);
		return vo;
	}

	
	public CodeNameVO codeName(String USER_ID) throws Exception {
		CodeNameVO vo = sqlSession.selectOne("memberMapper.codeName", USER_ID);
		return vo;
	}
	
}
