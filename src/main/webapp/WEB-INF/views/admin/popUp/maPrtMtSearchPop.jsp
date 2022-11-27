<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<!-- <h4>진짜 마지막#########매장검색###
#################################################################
#####################################################################
################################################################ -->
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="/resources/css/content/admin/popUp/maPrtMtPop.css" />
<title>매장검색팝업창</title>
</head>
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		 
		var prtNmP = opener.$("input#prtNmP").val(); //부모창에서 #prtNmP인 값을 들고온다(고객번호)
// 		document.getElementById('PRT_NM').innerText = prtNmP; // 왜안되지???... 부모창에서 가져온 고객번호를 innerText하여 text변경 
		$('#PRT_NM').val(prtNmP);
		
		popSearch(prtNmP);
		
		$("#add").click(function(){ //체크박스 선택후 적용버튼 누르면
			
			var checkIdValue = $("input[name='prtNm']:checked").attr('id');
			var prtCdValue = $("input[name='prtNm']:checked").parent().parent().children().eq(1).text();	// 체크한 위치를 기반으로 매장코드를 가져온다
			
			var count = $("input:checkbox[name='prtNm']:checked").length ; //선택된 체크박스 갯수
			
			if(count > 1){
				alert("매장은 하나만 체크할 수 있습니다.");
				return false;
			}if(count == 0 ){
				alert("매장 체크후 적용가능");
				return false;
			}
				
				opener.document.getElementById("PRT_NM").value = checkIdValue; //매장명
				opener.document.getElementById("PRT_CD").value = prtCdValue; //매장코드
				window.close();			
		}); //적용버튼 end
		
		
		aa();
	});
	
	function aa(){
		$("#cdNmSearch_tbody > tr").click(function(){
			alert("더블클릭!");
			
			var str = "";
			var tdArr = new Array(); //배열선언
			
			var tr = $(this); //현재 클릭된 row(<tr>)
			var td = tr.children();
			
			console.log("클릭한 row의 모든 데이터" + tr.text());
		});
	}
	function dob(){
		//더블클릭시
		$("#prtCd").click(function(){
			alert("더블클릭!");
			
			var str = "";
			var tdArr = new Array(); //배열선언
			
			var tr = $(this); //현재 클릭된 row(<tr>)
			var td = tr.children();
			
			console.log("클릭한 row의 모든 데이터" + tr.text());
		});
	}
	
	//매장검색
	function popSearch(val){
		
		var PRT_CD = $("#PRT_NM").val(); //매장코드
		
		var url = "/admin/shopSearch";
		
			$.ajax({
			url: url +"?PRT_NM="+PRT_CD,
			type:"get",
			success:function(res){
				console.log(res.length);
				var data = "";
				
				if(res.length>0){
					$.each(res, function(i, item){
					   	data += "<tr>";
						data += "<td><input type='checkbox' name='prtNm' id='"+item.prt_NM+"'></td>"	; //선택
						data += "<td id='prtCd' value='"+item.prt_CD+"'>"+item.prt_CD+"</td>"	; //매장코드
						data += "<td>"+item.prt_NM+"</td>"; //매장명
						data += "<td>"+item.prt_SS_CD+"</td>"	; //매장상태
						data += "</tr>";
					});
				}else{
				   	data += "<tr id='h1'>";
					data += "<td colspan='4'>조회된 검색결과가 없습니다</td>";
					data += "</tr>";
				}
				$("#cdNmSearch_tbody").html(data);
				
			},
			error:function(res){
				
			}
		}); //ajax end
		
	}
	
	
	//엔터키 눌렀을때
// 	function Eenterkey(){
// 		if (window.event.keyCode == 13) { 
// 			popSearch();
// 		}
// 	}
</script>
<body>
	<div class="container">
	<input type="hidden" id="cdHtmlData" name="cdHtmlData" value=""/>
	
	<input type="hidden" id="prtNmP" name="prtNmP" value=""/>
		<h1>매장조회</h1>
		<form>
			<table class="cdNmSearch">
				<tr>
					<td>
						<label>매장</label>
						<input type="text" id="PRT_NM" name="PRT_NM"  onkeyup="Eenterkey();"/>
					</td>
					<td>
						<input type="button" class="cdSearch" id="cdSearch" value="검색" onClick="popSearch()"/>
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
					<th>매장코드</th>
					<th>매장명</th>
					<th>매장상태</th>
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

