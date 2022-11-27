package com.dowell.admin.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.dowell.admin.dao.MemberDAO;
import com.dowell.admin.vo.CodeNameVO;
import com.dowell.admin.vo.CsCust01MtVO;
import com.dowell.admin.vo.MemberVO;

@Service
@Transactional(rollbackFor = Exception.class)
public class MemberService {

	@Autowired
	private MemberDAO memberDAO;

	// 로그인

	public MemberVO login(MemberVO memberVO) throws Exception {

		MemberVO vo = memberDAO.login(memberVO);

		return vo;
	}

	public CsCust01MtVO search(CsCust01MtVO mem) throws Exception {
		// TODO Auto-generated method stub
		return memberDAO.search(mem);
	}

	public CodeNameVO codeName(String USER_ID) throws Exception {
		return memberDAO.codeName(USER_ID);
	}
}
