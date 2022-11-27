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
<link rel="stylesheet" href="/resources/css/content/admin/popUp/ivcoSearchPop.css" />
<title>매장재고조회</title>
</head>
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<style>
#PRT_CD{
	background-color: #edebeb;
}
</style>
<script type="text/javascript">

	$(document).ready(function(){
		
		var hidden_PRT_CD = opener.$("#hidden_PRT_CD").val(); //부모창 매장코드
		var hidden_PRD_CD = opener.$("#hidden_PRD_CD").val(); //부모창에서 #hidden_PRD_CD인 실시간 상품코드
		var hidden_ivco_addRowCount = opener.$("#hidden_ivco_addRowCount").val(); //부모창 검색 위치 count
		
		
		$("#PRT_CD").val(hidden_PRT_CD);
		$("#PRD_CD").val(hidden_PRD_CD);
		
		defaultivcoSearch(hidden_PRT_CD, hidden_PRD_CD); //$(document).ready 
		
		
		//적용버튼 누르면
		$("#add").click(function(){  // 1개만 체크했는지 확인하고! 고객번호,고객이름 들고온다

			var checkIdValue = $("input[name='prdCK']:checked").attr('id');
			var prdCdValue = $("input[name='prdCK']:checked").parent().parent().children().eq(1).text();	// 체크한 위치를 기반으로 상품코드
			var prdNmValue = $("input[name='prdCK']:checked").parent().parent().children().eq(2).text();	// 체크한 위치를 기반으로 상품명
			var ivcoQtyValue = $("input[name='prdCK']:checked").parent().parent().children().eq(3).text();	// 체크한 위치를 기반으로 재고수량
			var prdCsMrUprValue = $("input[name='prdCK']:checked").parent().parent().children().eq(4).text();	// 체크한 위치를 기반으로 소비자가
						
			var cntCk = $("input:checkbox[name='prdCK']:checked").length ; //선택된 체크박스 갯수
			
			
			console.log(checkIdValue + "상품코드" + prdCdValue + "상품명." + prdNmValue + "재고수량." + ivcoQtyValue + "소비자가" + prdCsMrUprValue+ " 체크박스 갯수"+cntCk)
			
			if(cntCk == 0){
				alert("값을 선택하세요.");
				return false;
			}else{
				
				  var resProductData = [];
				  var resProductDataObject = {};
				  
				  resProductDataObject.prd_CD = prdCdValue; //상품코드
				  resProductDataObject.prd_NM = prdNmValue; //상품명
				  
				  resProductData.push(resProductDataObject);
				  
				  opener.prdCdDuplicateCheck(resProductData); //부모창의. 상품 중복체크 함수
				  var parentPrdCdDuplicateCheck = opener.prdCdDuplicateCheck(resProductData);
				  
				  console.log("리턴값 받냐.........."+ parentPrdCdDuplicateCheck);
				

				   if(parentPrdCdDuplicateCheck > 0){
					   alert("이미 동록된 상품입니다.");
					   opener.$('#PRD_CD'+hidden_ivco_addRowCount).val('');
					   return ;
				   }
				
				opener.$("#PRD_CD"+hidden_ivco_addRowCount).val(prdCdValue); //자식창에 체크박스해서 선택한. 상품코드 넣기
				opener.document.getElementById('PRD_NM'+hidden_ivco_addRowCount).innerText = prdNmValue; //자식창에 선택한 상품명 넣기. innerText하여 text변경
				
				opener.document.getElementById('IVCO_QTY'+hidden_ivco_addRowCount).innerText = ivcoQtyValue; //자식창에 선택한. 재고수량 넣기
				opener.document.getElementById('PRD_CSMR_UPR'+hidden_ivco_addRowCount).innerText = prdCsMrUprValue; //자식창에 선택한. 소비자가 넣기
				
				opener.$("#PRD_CD"+hidden_ivco_addRowCount).parent().find('.shield_sw').addClass('shield');
				opener.resetSheildClickEvent();
				self.close();
			}
			
			
		}); // function end
		
		$(".prdSearch").on("click", function(){
			var live = $("#PRD_CD").val();
			defaultivcoSearch(hidden_PRT_CD, live);
		});
	}); //(document).ready end
	
	//체크박스 하나만 선택  
	// 수량 0, 금액 0, 해지(C)  이면 체크박스 선택불가
	function prdCkOne(chk, qty, prd_CSMR_UPR, index, ssCD){
		
		var obj = document.getElementsByName("prdCK");
		
		if(qty == 0 ){
			alert("수량이 0 은 선택불가");
			obj[index].checked = false;
		}else if(prd_CSMR_UPR == 0){
			alert("금액 0 선택불가");
			obj[index].checked = false;
		}else if(ssCD == '0'){
			alert("해지 상품 선택불가");
			obj[index].checked = false;
		}else{
			for(var i=0; i<obj.length; i++){
				if(obj[i] != chk){
					obj[i].checked = false;
				}
			}
		}
	} //function end
	
	
	function defaultivcoSearch(PRT_CD, PRD_CD){
		
		$.ajax({
			url : "/admin/management/ivcoSearch"
		  , type : "post"
		  , data : {
			  		  PRT_CD
					 ,PRD_CD
				 }
			,success:function(res){   // 0개, 2개 이상
				data = "";
				console.log(res);
				if(res.length == 0){
				   	data += "<tr id='h1'>";
					data += "<td colspan='5'>조회된 검색결과가 없습니다</td>";
					data += "</tr>";
				}else{
					$.each(res, function(i, item){
						var ssCD ;
						if(item.prd_SS_CD == 'R'){
							ssCD = 1;
						}else{
							ssCD = 0;
						}
						if(res[i].prd_TP_CD != '20'){ // 10: 본품, 20: 견본품
						   	data += "<tr class='"+item.prd_SS_CD+"'>";
							data += "<td><input type='checkbox' name='prdCK' id='"+i+"' onclick='prdCkOne(this ,"+item.ivco_QTY+","+item.prd_CSMR_UPR+","+i+","+ssCD+");'></td>"; //선택
							data += "<td>"+item.prd_CD+"</td>"; //상품코드
							data += "<td>"+item.prd_NM+"</td>"; //상품명
							data += "<td>"+Number(item.ivco_QTY).toLocaleString()+"</td>"; //재고수량
							data += "<td>"+Number(item.prd_CSMR_UPR).toLocaleString()+"</td>"; //소비자가
							data += "</tr>";
						}
					});
				}
				$("#ivcoSearch_tbody").html(data);
			},
			error:function(res){
				
			}
		});  //ajax end
	} //defaultCust()함수 end
	
	
	
</script>

<body>
	<div class="container">
	<input type="hidden" id="custNm" name="custNm" value=""/>
	
	<!-- 고객검색 부모창에서 입력한 값 -->
	<input type="hidden" id="custNmP" name="custNmP" value=""/>
		<h1>매장재고조회</h1>
		<form id="cd">
			<table class="cdNmSearch">
				<tr>
					<td>
						<label>매장</label>
						<input type="text" class="textVal" id="PRT_CD" name="PRT_CD" value="" readonly="readonly"/>
					</td>
					<td>
						<label>상품(코드+명)</label>
						<input type="text"  class="textVal" id="PRD_CD" name="PRD_CD" value="" />
						<input type="button" class="prdSearch" id="cdSearch" value="검색" onClick="defaultivcoSearch()"/>
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
					<th>상품코드</th>
					<th>상품명</th>
					<th>재고수량</th>
					<th>소비자가</th>
				</tr>
			</thead>
			<tbody id="ivcoSearch_tbody" class="list">
				
			</tbody>
		</table>
	</div>
	<div>
		<input type="button" id="close" value="닫기" onclick="window.close()"/>
		<input type="button" id="add" value="적용" />
	</div>
</body>
</html>