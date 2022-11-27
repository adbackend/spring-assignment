<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="/resources/css/content/admin/popUp/chHistoryPopUp.css" />
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>

<script type="text/javascript">
	$(document).ready(function(){
		var cust_no = opener.$("input#EcustNo").val(); //부모창에서 #EcustNo인 값을 들고온다(고객번호)
		
		var par = opener.$('#EcustNo').attr('id');
		document.getElementById('CUST_NO').innerText = cust_no; // 부모창에서 가져온 고객번호를 innerText하여 text변경
		
		
		
		var urlC ="/admin/popUp/chCustNo";
		
		var htm = "";
		$.ajax({
			url : urlC+"?CUST_NO="+cust_no,
			type:"get",
			success:function(res){
				$.each(res,function(i, res){
					htm += "<tr>";
					htm += "<th>고객</td>"	; 
					htm += "<th>"+res.cust_NO+"</th>"	; //고객아이디
					htm += "<th>"+res.cust_NM+"</th>"	; //고객명
					htm += "</tr>";
				});
				
				$("#tableList").html(htm);
			}
		});
		
		
		var url = "/admin/popUp/chHistoryPro";
		$.ajax({
			url : url+"?CUST_NO="+cust_no,
			type : "get",
			success:function(res){
				
				var data = "";
				var custNm = "";
				if(res.length==0){
				   	data += "<tr id='h1'>";
					data += "<td colspan='6'>조회된 검색결과가 없습니다</td>";
					data += "</tr>";
				}else{
					$.each(res, function(i, item){
						console.log(res);
					   	data += "<tr>";
						data += "<td class='ch_mid'>"+item.chg_DT+"</td>"; //변경일자
						data += "<td class='ch_mid'>"+item.chg_CD+"</td>"	; //변경전
						data += "<td class='ch_mid'>"+item.chg_BF_CNT+"</td>"	; //변경후
						data += "<td class='ch_mid'>"+item.chg_AFT_CNT+"</td>"	; //변경후
						data += "<td class='ch_mid'>"+item.lst_UPD_ID+"</td>"	; //수정자
						data += "<td>"+item.lst_UPD_DT+"</td>"	; //수정일시
						data += "</tr>";
					});
				}
				$("#list").html(data);

			},
			error:function(res){

			}
		});
	});
	
</script>

<title>변경이력</title>
</head>
<body>
	<div class="container">
	<input type="hidden" id="cdHtmlData" name="cdHtmlData" value=""/>
		<form class="chForm">
			<table class="ch_table" id="tableList">
				<tr>
					<th>고객</th>
					<th id="CUST_NO">100</th>
					<th id="CUST_NM"></th>
				</tr>
			</table>
		</form>
	</div>
	<div class="memberList_list">
		<table class="memberList_listTable">
			<thead class="memberList_thead">
				<tr>
					<th>변경일자</th>
					<th>변경항목</th>
					<th>변경전</th>
					<th>변경후</th>
					<th>수정자</th>
					<th>수정일시</th>
				</tr>
			</thead>
			<tbody id="list">
<!-- 				<tr> -->
<!-- 					<td>test</td> -->
<!-- 					<td>test</td> -->
<!-- 					<td>test</td> -->
<!-- 					<td>test</td> -->
<!-- 					<td>test</td> -->
<!-- 					<td>test</td> -->
<!-- 				</tr> -->
			</tbody>
		</table>
	</div>
	<div>
		<input type="button" id="close" value="닫기" onclick="window.close()"/>
	</div>

</body>
</html>