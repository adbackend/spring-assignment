package com.dowell.board.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.dowell.board.service.BoardService;
import com.dowell.board.vo.BoardVO;
import com.dowell.board.vo.Criteria;
import com.dowell.board.vo.PageDTO;
import com.dowell.board.vo.TestVO;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;


/**
  * @FileName : BoardController.java
  * @Date : 2022. 8. 22. 
  * @작성자 : 최유정
  * @변경이력 :
  * @프로그램 설명 :
  */
@Controller
@Log4j
@RequestMapping("/board/*")
@AllArgsConstructor
public class BoardController {
	
	

	@Autowired
	private BoardService boardService;

	@RequestMapping(value="/testList", method=RequestMethod.GET)
	public void list(Model model) {
		
		List<TestVO> a = boardService.getTestList();
		
		System.out.println(a.size()+"a 사이즈.......");
		
		model.addAttribute("list",boardService.getTestList());
		
	}
	
	

	
}







