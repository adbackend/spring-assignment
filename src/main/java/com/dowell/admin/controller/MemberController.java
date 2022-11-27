package com.dowell.admin.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.dowell.admin.service.MemberService;
import com.dowell.admin.vo.MemberVO;

@Controller
@RequestMapping("/member/*")
public class MemberController {

	@Autowired
	private MemberService memberService;

	// 로그인 폼
	@RequestMapping(value = "/loginForm", method = RequestMethod.GET)
	public String loginForm(Model model) throws Exception {

		return "member/loginForm";
	}

	// 로그인 처리
	@RequestMapping(value = "/login", method = RequestMethod.POST)
	public String login(MemberVO memberVO, HttpServletRequest request, Model model, RedirectAttributes rttr)
			throws Exception {

		System.out.println(memberVO.getUSER_ID() + "  1");
		System.out.println(memberVO.getUSE_PWD() + "  2");
		HttpSession session = request.getSession();

		MemberVO member = memberService.login(memberVO);

		// 20220824
		if (member == null) { // 로그인 실패
			session.setAttribute("member", null);
			rttr.addFlashAttribute("msg", false);
		} else { // 로그인 성공

			session.setAttribute("member", member);
		}
		return "redirect:/";
	}

	// 로그아웃
	@RequestMapping(value = "/logout", method = RequestMethod.GET)
	public String logout(HttpSession session) throws Exception {

		session.invalidate();

		return "redirect:/";
	}

}
