<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<!-- <h4>진짜 마지막#########고객검색###
#################################################################
#####################################################################
################################################################ -->
<meta charset="UTF-8">
<link rel="stylesheet" href="/resources/css/content/admin/popUp/csCustSearchPop.css" />
<title>고객조회</title>
</head>
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script type="text/javascript">

	$(document).ready(function(){
		
		var custNmP = opener.$("input#custNmP").val(); //부모창에서 #custNmP인 값을 들고온다(고객번호)
// 		var cnSearch = $("#custNm").val();
		$('#custNmP').val(custNmP);
// 		alert(custNmP+"으아앙");
		
		
		defaultCust(); //$(document).ready 바로 ajax실행하면 안탐.. 왜지..?
		
		
		//적용버튼 누르면
		$("#add").click(function(){  // 1개만 체크했는지 확인하고! 고객번호,고객이름 들고온다

			var checkIdValue = $("input[name='custCK']:checked").attr('id');
			var custCdValue = $("input[name='custCK']:checked").parent().parent().children().eq(2).text();	// 체크한 위치를 기반으로 고객명을 가져온다
			
			console.log("############");
			console.log(checkIdValue); //고객번호
			console.log(custCdValue); //고객이름
			console.log("############");
			
			var count = $("input:checkbox[name='custCK']:checked").length ; //선택된 체크박스 갯수
			
			if(count == 0){
				alert("적용하시려면 한개 체크 필수")
			}else if(count >1){
				alert("고객은 하나만 체크할 수 있습니다.");
				return false;
			}else{
				opener.document.getElementById("CUST_NO").value = checkIdValue; //고객번호를 부모창에 전달
				opener.document.getElementById("CUST_NM").value = custCdValue; //고객이름를 부모창에 전달
				
				opener.$('.custSheild_sw').addClass('custSheild'); //부모장 쉴드처리
				
				window.close();
			}
			
		});
	}); //(document).ready end
	
	
	
	
	
	function defaultCust(){
		
		var CUST_NM = $("#custNmP").val(); //매장코드
	
		var url = "/admin/custNoSearchPop";
		
		$.ajax({
			url: url+"?CUST_NM="+CUST_NM,
			type:"get",
			success:function(res){   // 0개, , 2개이상 들어올드
				data = "";
				if(res.length == 0){
				   	data += "<tr id='h1'>";
					data += "<td colspan='4'>조회된 검색결과가 없습니다</td>";
					data += "</tr>";
				}else{
					$.each(res, function(i, item){
					   	data += "<tr>";
						data += "<td><input type='checkbox' name='custCK' id='"+item.cust_NO+"'></td>"; //선택
						data += "<td id='custNO' value='"+item.cust_NM+"'>"+item.cust_NO+"</td>"; //고객번호
						data += "<td>"+item.cust_NM+"</td>"; //고객명
						data += "<td>"+item.mbl_NO+"</td>"; //핸드폰
						data += "<td>"+item.cust_SS_CD+"</td>"; //고객상태
						data += "</tr>";
					});
				}
				$("#cdNmSearch_tbody").html(data);
			},
			error:function(res){
				
			}
		});  //ajax end
	} //defaultCust()함수 end
	
	//검색클릭시
	function popCdSearch(){
		
		var custNmCk = $("#CUST_NM").val(); //고객이름
		var mblNoCk = $("#MBL_NO").val(); //고객 핸드폰
		
		//이름 두자리
		if(custNmCk!='' && custNmCk.length<2){
			alert("고객이름 두자리이상 필수");
			$('#CUST_NM').focus();
			return false;
		}
		
	    // 번호 10자리 이하 불가
        if(mblNoCk.trim() != '' && mblNoCk.trim().length < 10) {
         alert('정확한 번호를 입력하셔야 합니다.');
         $('#MBL_NO').focus();
         return false;
       }  
		
		$.ajax({
			url : "/admin/popCdSearch",
			type : "post",
			data : $("#cd").serialize()
			,
			success:function(res){
				
				var data = "";
				console.log(res.length+"ㅜㅜㅜ");
				if(res.length == 0){ // 검색 결과가 없음
				   	data += "<tr id='h1'>";
					data += "<td colspan='4'>조회된 검색결과가 없습니다</td>";
					data += "</tr>";
				}else{ //검색결과 1개이상 존재
					$.each(res, function(i, item){
					   	data += "<tr>";
						data += "<td><input type='checkbox' name='custCK' id='"+item.cust_NO+"'></td>"; //선택
						data += "<td id='custNO' value='"+item.cust_NM+"'>"+item.cust_NO+"</td>"; //고객번호
						data += "<td>"+item.cust_NM+"</td>"; //고객명
						data += "<td>"+item.mbl_NO+"</td>"; //핸드폰
						data += "<td>"+item.cust_SS_CD+"</td>"; //고객상태
						data += "</tr>";
					});
				} //else end
				$("#cdNmSearch_tbody").html(data);
			}
		}); //ajax end
	} // 함수 종료
	
	
</script>

<body>
	<div class="container">
	<input type="hidden" id="custNm" name="custNm" value=""/>
	
	<!-- 고객검색 부모창에서 입력한 값 -->
	<input type="hidden" id="custNmP" name="custNmP" value=""/>
		<h1>고객조회</h1>
		<form id="cd">
			<table class="cdNmSearch">
				<tr>
					<td>
						<label>고객이름</label>
						<input type="text" class="textVal" id="CUST_NM" name="CUST_NM" value="" placeholder=""/>
					</td>
					<td>
						<label>핸드폰번호</label>
						<input type="text"  class="textVal" id="MBL_NO" name="MBL_NO" value="" placeholder=""/>
						<input type="button" class="cdSearch" id="cdSearch" value="검색" onClick="popCdSearch()"/>
					</td>
				</tr>
			</table>
		</form>
	</div>
	<div class="memberList_list">
		<table class="memberList_listTable">
			<thead class="memberList_thead">
				<tr>
					<th>선택</th>
					<th>고객번호</th>
					<th>고객명</th>
					<th>핸드폰</th>
					<th>고객상태</th>
				</tr>
			</thead>
			<tbody id="cdNmSearch_tbody" class="list">
				
			</tbody>
		</table>
	</div>
	<div>
		<input type="button" id="close" value="닫기" onclick="window.close()"/>
		<input type="button" id="add" value="적용" />
	</div>
</body>
</html>