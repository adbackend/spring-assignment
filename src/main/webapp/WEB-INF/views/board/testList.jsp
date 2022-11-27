<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>


<%@include file="../includes/header.jsp"%>
<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">Tables</h1>
	</div>
	<!-- /.col-lg-12 -->
</div>
<!-- /.row -->

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">
				Board List Page
				<button id='regBtn' type="button" class="btn btn-xs pull-right">게시물 등록</button>
			</div>

			<!-- /.panel-heading -->
			<div class="panel-body">
				<table class="table table-striped table-bordered table-hover">
					<thead>
						<tr>
							<th>#번호</th>
							<th>제목</th>
							<th>작성자</th>
						</tr>
					</thead>
					
					<c:forEach items="${list}" var="board">
						<tr>
							<td><c:out value="${board.custNo}"/></td>
							<td><a class="move" href='<c:out value="${board.chgDt}"/>'><c:out value="${board.chgDt}"/></a></td>
							<td><c:out value="${board.chgSeq}"/></td>
<%-- 							<td><c:out value="${board.chgCd}"/></td> --%>
<%-- 							<td><fmt:formatDate pattern="yyyy-MM-dd" value="${board.fstRegDt}"/></td> --%>
<%-- 							<td><fmt:formatDate pattern="yyyy-MM-dd" value="${board.lstUpdDt}"/></td> --%>
						</tr>
					</c:forEach>

				</table>
				
			</div>
			
			
			
			

		</div>
		<!--  end panel-body -->
	</div>
	<!-- end panel -->
</div>
<!-- /.row -->




<%@include file="../includes/footer.jsp"%>
