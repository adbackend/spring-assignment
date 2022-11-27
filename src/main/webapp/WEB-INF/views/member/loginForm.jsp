<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="/resources/css/content/loginForm.css" />
<meta charset="UTF-8">
<title>로그인</title>
</head>
<body>
		<%@include file="../includes/header.jsp" %>
		<%@include file="../includes/nav.jsp" %>
		
<div class="loginForm_content">
	<div class="center">
		<h1>로그인</h1>
		19970325<br>
		20220824<br>
		20201002<br>
		<form name='homeForm' action="/member/login" method="post">
			<div class="text_field">
				<input type="text" id="USER_ID" name="USER_ID" required/>
				<label>아이디</label>
			</div>
			<div class="text_field">
				<input type="password" id="USE_PWD" name="USE_PWD" required/>
				<label>비밀번호</label>
			</div>
			
			<div class="pass">비밀번호 찾기</div>
			<input class="login_btn" type="submit" value="로그인">
			<div class="signup_link">
			 회원이 아니신가요? <a href="#"></a>
			</div>
		</form>
	</div>
</div>		
		
		<%@include file="../includes/footer.jsp" %>
</body>
</html>