<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<link rel="stylesheet" href="/resources/css/comm/header.css" />
<script type="text/javascript">
	$(document).ready(function(){
		
		//로그아웃
		$("#logoutBtn").on("click", function(){
			
			if (!confirm("로그아웃 하시겠습니까?")) {
				return false;
			} else {
				location.href="/member/logout";
	        }
			
		});
		
	});
</script>
<div class="header">

    <div class="nav_main">
	<div class="navber_logo">
<!--  <img src="/resources/images/samsung.webp" alt="Logo"> -->
<!-- <img src="../images/samsung.webp" alt="Logo"> -->
	</div>

	<nav class="navbar">
		<div class="navbar_logo">
			<i class="fab"> 
				<a href="">Dowell</a>
			</i>

			<div class="navbar_main">
				<c:if test="${member==null}">
					<a href="/member/loginForm">로그인 |</a> 
					<a href="/member/register">회원가입 |</a>
				</c:if>
				<c:if test="${member != null}">
					${member.USER_NM}(${member.USER_ID})님 환영합니다.
<!-- 					<button id="memberUpdateBtn" type="button">회원정보수정</button> -->
<!-- 					<button id="memberDeleteBtn" type="button">회원탈퇴</button> -->
					<button id="logoutBtn" type="button">로그아웃</button>
				</c:if>  
			</div>
		</div>
		
		<ul class="navbar_menu">
			<li><a href="/">메인 </a></li>
		<c:if test="${member != null}">
			<li><a href="/admin/customerList">고객관리</a></li>
			<li><a href="/admin/monthPerf">월별실적조회</a></li>
			<li><a href="/admin/custInfo3">고객정보조회</a></li>
			<li><a href="/admin/management/custSalSearchForm">고객판매조회</a></li>
			<li><a href="#">마이페이지</a></li>
		</c:if>
		</ul>
	</nav>
    </div>
</div>