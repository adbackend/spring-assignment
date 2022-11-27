package com.dowell.board.service;

import java.util.List;

import com.dowell.board.vo.BoardVO;
import com.dowell.board.vo.Criteria;
import com.dowell.board.vo.TestVO;

public interface BoardService {

//	public void register(BoardVO board);
//
//	public BoardVO get(Long bno);
//
//	public boolean modify(BoardVO board);
//
//	public boolean remove(Long bno);
//
////	public List<BoardVO> getList();
//	
//	public List<BoardVO> getList(Criteria cri); //페이징 처리된 목록
//	
//	public int getTotal(Criteria cri); //전체 데이터 개수
	
	public List<TestVO> getTestList(); //테스트
}
