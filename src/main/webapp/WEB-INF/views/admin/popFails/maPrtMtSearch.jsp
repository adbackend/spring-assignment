<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="/resources/css/content/admin/popUp/maPrtMtPop.css" />
<title>매장코드/매장명 검색</title>
</head>
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		
		$("#cdNmC").focus();
		
// 		setTimeout(function(){
// 		var result = document.getElementById("cdHtmlData").value; //
// 		$("#cdNmSearch_tbody").html(result);
// 		},2000);
		
		setTimeout(function(){
		var result = opener.a ;
		$("#cdNmSearch_tbody").html(result);
		},500);
		
		
		
		$("#add").click(function(){ //체크박스 선택후 적용버튼 누르면
			
			var checkIdValue = $("input[name='prtNm']:checked").attr('id');
			var prtCdValue = $("input[name='prtNm']:checked").parent().parent().children().eq(1).text();	// 체크한 위치를 기반으로 매장코드를 가져온다
			
			var count = $("input:checkbox[name='prtNm']:checked").length ; //선택된 체크박스 갯수
			
			if(count != 1){
				alert("매장은 하나만 체크할수 있습니다.");
				return false;
			}
				
				opener.document.getElementById("PRT_NM").value = checkIdValue; //매장명
				opener.document.getElementById("PRT_CD").value = prtCdValue; //매장코드
				window.close();			
		}); //적용버튼 end
		
		if(opener==undefined){
			opner=window.dialogArguments;
			
		}
		
		var html = opener.a ;
		

		
	});
	
	
	//팝업창>검색버튼 클릭> 매장검색
	function popCdSearch(){
		var cdNmC = $("#cdNmC").val(); // 거래처명(매장)
		var count = $("input:checkbox[name='prtNm']:checked").length ; //선택된 체크박스 갯수
		
		if(cdNmC == ""){
			alert("검색값을 입력하세요");
			$("#cdNmC").focus();
		}
		if(cdNmC.length<2){
			alert("두글자이상 입력하세요.")
		}
		
		
		
		var url = "/admin/shopSearch";
	
		$.ajax({
			url: url +"?PRT_NM="+cdNmC,
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
	} //팝업창의 검색버튼 end
	
	
	
	
</script>

<body>
	<div class="container">
	<input type="hidden" id="cdHtmlData" name="cdHtmlData" value=""/>
		<h1>매장조회</h1>
		<form>
			<table class="cdNmSearch">
				<tr>
					<td>
						<label>매장</label>
						<input type="text"  class="cdNmC" id="cdNmC" name="cdNmC" value="" placeholder="매장코드/매장명 입력"/>
					</td>
					<td>
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