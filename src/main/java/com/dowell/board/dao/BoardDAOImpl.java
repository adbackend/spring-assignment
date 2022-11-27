package com.dowell.board.dao;

import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.dowell.board.vo.TestVO;

@Repository
public class BoardDAOImpl implements BoardDAO{
	
	@Autowired
	private SqlSession sqlSession;
	
	@Override
	public List<TestVO> getTestList() {
		
		List<TestVO> list = sqlSession.selectList("boardMapper.getTestList");
		
		System.out.println(list.size()+"  리스트 사이즈");
		
		return list;
	}

}
