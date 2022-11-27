<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="/resources/css/content/admin/popUp/custSalDetail.css" />
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>

<!-- <script src="/resources/js/sal/custSalDetail.js"></script> -->
<script type="text/javascript">

$(document).ready(function(){
		
		var getParentCustSalDetail = opener.$("input#custDetail").val();
		
		var userDtCd = opener.$("#USER_DT_CD").val(); //사용자구분코드  1:회사, 2:특약점
// 		alert("사용자구분코드.."+userDtCd);
		
		var jsonPasingDetailValue = JSON.parse(getParentCustSalDetail); // object
		
		console.log("ㅎㅎㅎ");
		console.log(jsonPasingDetailValue);
		
		var PRT_CD = jsonPasingDetailValue.prt_CD; //매장코드
		var prtNm = jsonPasingDetailValue.prt_NM; //매장명
		
		var custNo = jsonPasingDetailValue.cust_NO; //고객번호
		var custNm = jsonPasingDetailValue.cust_NM; //고객명
		
		var sumSalQty = jsonPasingDetailValue.sal_QTY; //판매수량
		var totSalAmt = jsonPasingDetailValue.sal_AMT;//판매금액
		var cshStlmAmt = jsonPasingDetailValue.csh_STLM_AMT;//현금
		var crdStlmAmt = jsonPasingDetailValue.crd_STLM_AMT;//카드
		var pntStlmAmt = jsonPasingDetailValue.pnt_STLM_AMT;//포인트
		
		var salTpCd = jsonPasingDetailValue.sal_TP_CD; //판매구분코드 sal rtn
		var SAL_DT = jsonPasingDetailValue.sal_DT; //판매일자
		var SAL_NO = jsonPasingDetailValue.sal_NO; //판매번호
		
		document.getElementById('PRT_CD').innerText = PRT_CD; // innerText하여 text변경
		document.getElementById('PRT_NM').innerText = prtNm; // innerText하여 text변경
		
		document.getElementById('CUST_NO').innerText = custNo; // innerText하여 text변경
		document.getElementById('CUST_NM').innerText = custNm; // innerText하여 text변경
		
		
		document.getElementById('sumSalQty').innerText = sumSalQty; // innerText하여 text변경
		document.getElementById('totSalAmt').innerText = totSalAmt.toLocaleString(); // innerText하여 text변경
		document.getElementById('cshStlmAmt').innerText = cshStlmAmt.toLocaleString(); // innerText하여 text변경
		document.getElementById('crdStlmAmt').innerText = crdStlmAmt.toLocaleString(); // innerText하여 text변경
		document.getElementById('pntStlmAmt').innerText = pntStlmAmt.toLocaleString(); // innerText하여 text변경
// 		document.getElementById('salTpCd').innerText = salTpCd; //판매구분코드 sal rtn
		
		//hidden에 뿌리기
		document.getElementById('hidden_PRT_CD').value = PRT_CD; // 매장코드
		document.getElementById('hidden_SAL_DT').value = SAL_DT; // 판매일자
		document.getElementById('hidden_SAL_NO').value = SAL_NO; // 판매번호
		
		
		var detailListData = { "PRT_CD" : PRT_CD,
						       "SAL_DT" : SAL_DT,
					           "SAL_NO" : SAL_NO};
		
		//반품처리시 데이터
		var salReturnData = {
								"prtCd" : PRT_CD,
								"salDt" : SAL_DT,
								"salNo" : SAL_NO
							};
		
		custSalDetail(detailListData); //판매상세 목록 뿌리는 함수

		//반품버튼숨기기
		// 1. 회사 로그인시
		// 2. rtn일때
		// 3. 이미 반품처리된 것은 반품버튼 숨기기
		if(userDtCd == '1' || salTpCd =='RTN' || (salTpCd == 'SAL' && salReCheck(detailListData)) ){
				document.getElementById("rtnBtn").style.display="none";
		}
		
		//반품클릭시
		$("#rtnBtn").on("click", function(){
			
			if(!confirm("반품처리 하시겠습니까?")){
				//취소시
			}else{  //반품처리 ajax
				salReturnProcess(salReturnData);
			}
			
		}); //function end
		
	}); //document ready end 
	
	//반품처리 함수
	//"PRT_CD" : PRT_CD,
	//"SAL_DT" : SAL_DT,
	//"SAL_NO" : SAL_NO
	function salReturnProcess(salReturnData){
		
		console.log(JSON.stringify(salReturnData));
		$.ajax({
			
			 url : "/admin/management/salReturnProcess"
			,type : "post"
			,contentType: 'application/json; charset=utf-8'
			,data : JSON.stringify(salReturnData)
			,success:function(res){
				alert("반품성공");
				window.close();
			},error:function(err){
				var data = JSON.parse(err.responseText);
				alert(data.error.message);
// 				alert("조회할 데이터가 올바르지 않아 조회할 수 없습니다.");
			}
			
		}); //ajax end
	}//function end
	
	
	//SAL인데 반품 목록인지 판별하는 함수
	// res.length == 0이면 반품된상품x, 1이면 반품된 상품
	// 1이면 반품버튼 없애기
	// 1이면 return true;
	function salReCheck(detailListData){
		
		var result ;
// 		debugger;
		$.ajax({
			 url : "/admin/management/salReCheck"
			,data : JSON.stringify(detailListData)
			,type : "post"
			,contentType : "application/json"
			,async : false
			,success:function(res){
				if(res.length==1){ //반품된 상품->반품버튼 없애기
					result = true;
				}else if(res.length != 1){ //반품이 안된 상품
					result = false;
				}
				
			},error:function(res){
				alert("반품 목록인지 재체크 실패");
				console.log("실패");
			}
		}); //ajax end
		
		return result; // result값이 true면 반품된 상품
	} //function end
	
	//합계
	function totalSum(count){
		
		var cnt = 0;
		var total_sal_QTY = 0;		//수량 합계
		var total_sal_VOS_AMT = 0;	//공급가 합계
		var total_sal_VAT_AMT = 0;	//부가세 합계
		var total_sal_AMT = 0;		//판매금액 합계
		
		//수량합계
		$("[id^=sal_QTY]").each(function(){
			total_sal_QTY += Number($("#sal_QTY"+cnt).text());
			
			document.getElementById("total_sal_QTY").innerText = total_sal_QTY;
			cnt++;
		});
		cnt = 0 ;
		
		//공급가 합계
		$("[id^=sal_VOS_AMT]").each(function(){
			total_sal_VOS_AMT += Number($("#sal_VOS_AMT"+cnt).text().replace(/,/g,'')); 
			
			document.getElementById("total_sal_VOS_AMT").innerText = total_sal_VOS_AMT.toLocaleString();
			cnt++;
		});
		cnt = 0 ;
		
		//부가세 합계
		$("[id^=sal_VAT_AMT]").each(function(){
			total_sal_VAT_AMT += Number($("#sal_VAT_AMT"+cnt).text().replace(/,/g,''));
			
			document.getElementById("total_sal_VAT_AMT").innerText = total_sal_VAT_AMT.toLocaleString();
			cnt++;
		});
		cnt = 0 ;
		
		//판매금액 합계
		$("[id^=sal_AMT]").each(function(){
			total_sal_AMT += Number($("#sal_AMT"+cnt).text().replace(/,/g,''));
			
			document.getElementById("total_sal_AMT").innerText = total_sal_AMT.toLocaleString();
			cnt++;
		});
		cnt = 0 ;
		
		
		
	}
	//상세조회 목록 ajax
	//prt_cd, sal_dt, sal_no;
	//AJAX는 데이터를 문자열화 해주지 않기 때문에 보낼데이터를 JSON.stringify()로 감싸주었다.
    //그렇지 않으면 json데이터의 "key","value" 형태의 패턴을 인식하지 못한다.
    //  - [{}] : 배열 형태의 데이터
    //   -  {}  :  1개의 데이터 값
	function custSalDetail(detailListData){
		
		console.log("목록 에이작스...");
		console.log(detailListData);
		
		$.ajax({

			url : "/admin/management/salPop/custSalDetailList",
			data : JSON.stringify(detailListData),
			type : "post",
			contentType : "application/json",
			success:function(res){
				console.log(res);
				var count = 0 ;
				var data = "";
				
				if(res.length > 0){
					$.each(res, function(i, item){
						data += "<tr>";
						data += "<td class='custSalRn'>"+item.rn+"</td>"; //번호
						data += "<td class='lo_mid'>"+item.prd_CD+"</td>"; //상품코드
						data += "<td class='lo_mid'>"+item.prd_NM+"</td>"; //상품명
						
						data += "<td class='lo_right' id='sal_QTY"+i+"'>"+item.sal_QTY+"</td>"; //판매수량
						data += "<td class='lo_right' id='sal_VOS_AMT"+i+"'>"+item.sal_VOS_AMT.toLocaleString()+"</td>"; //공급가
						data += "<td class='lo_right' id='sal_VAT_AMT"+i+"'>"+item.sal_VAT_AMT.toLocaleString()+"</td>"; //부가세
						data += "<td class='lo_right' id='sal_AMT"+i+"'>"+item.sal_AMT.toLocaleString()+"</td>"; //판매금액
						data += "</tr>"; 
						
					});
					
					data += "<tr>";
					data += "<td colspan='2' class='lo_right'><span>합계</span><td>"
					data += "<td class='lo_right'> <span class='lo_right' id='total_sal_QTY'></span></td>"; //판매수량
					data += "<td class='lo_right'> <span class='lo_right' id='total_sal_VOS_AMT'></span></td>"; //공급가
					data += "<td class='lo_right'> <span class='lo_right' id='total_sal_VAT_AMT'></span></td>"; //부가세
					data += "<td class='lo_right'> <span class='lo_right' id='total_sal_AMT'></span></td>"; //판매금액
					data += "</tr>";
					
				}else{
					data += "<tr>";
					data += "<td colspan='7'>조회된 검색결과가 없습니다.</td>";
					data += "</tr>";
				}
				$("#list").html(data);
				totalSum(count);
			},error:function(err){
				var data = JSON.parse(err.responseText);
				alert(data.error.message);
// 				alert("조회할 데이터가 올바르지 않아 조회할 수 없습니다.");
				window.close();
			}
		}); //ajax end
	} // function end
	
</script>
<title>상세조회</title>
</head>
<body>
<form id="hiddenSalDetail">
	<input type="hidden" id="hidden_PRT_CD" name="PRT_CD" value=""/> <!-- 매장코드 -->
	<input type="hidden" id="hidden_SAL_DT" name="SAL_DT" value=""/> <!-- 판매일자 -->
	<input type="hidden" id="hidden_SAL_NO" name="SAL_NO" value=""/> <!-- 판매번호 -->
	<input type="hidden" id="hidden_PRT_CD" name="PRT_CD" value=""/> <!-- 판매구분코드 -->
	
		
<!-- 		//총판매수량 -->
<!-- 		//총판매금액 -->
<!-- 		//총공급가액 -->
<!-- 		//총부가세액 -->
<!-- 		//현금결제금액 -->
<!-- 		//카드결제금액 -->
<!-- 		//포인트사용금액 -->
<!-- 		//고객번호 -->
<!-- 		//카드번호 -->
<!-- 		//유효년월 -->
<!-- 		//카드회사 -->
<!-- 		//최초등록일자 -->
<!-- 		//최초등록자 -->
<!-- 		//최종수정일자 -->
<!-- 		//최종수정자 -->
</form>
	<h1>판매상세조회</h1>
	<div class="container">
	<input type="hidden" id="cdHtmlData" name="cdHtmlData" value=""/>
		<form class="chForm">
			<table class="ch_table" id="tableList">
<!-- 				<tr> -->
<!-- 					<td type="hidden" id="salTpCd"></td> -->
<!-- 				</tr> -->
				<tr>
					<td id="titleA">매장</td>
					<td class="subA" colspan="1" id="PRT_CD"></td>
					<td colspan="2" id="PRT_NM"></td>
					<td></td>
					
					<td id="titleA">고객번호</td>
					<td id="CUST_NO"></td>
					<td id="CUST_NM"></td>
				</tr>
				<tr>
					<td id="titleA">판매수량 :</td>
					<td class="subF" id="sumSalQty"></td>

					<td id="titleA">판매금액 : </td>
					<td class="subF" id="totSalAmt"></td>
					
					<td></td>
					<td id="titleA">현금 :</td>
					<td class="subF" id="cshStlmAmt"></td>
					
					<td id="titleA">카드 : </td>
					<td class="subF" id="crdStlmAmt"></td>

					<td id="titleA">포인트 :</td>
					<td class="subF" id="pntStlmAmt"></td>
				</tr>
			</table>
		</form>
	</div>
	<div class="memberList_list">
		<table class="memberList_listTable">
			<thead class="memberList_thead">
				<tr>
					<th>번호</th>
					<th>상품코드</th>
					<th>상품명</th>
					<th>판매수량</th>
					<th>공급가</th>
					<th>부가세</th>
					<th>판매금액</th>
				</tr>
			</thead>
			<tbody id="list">
<!-- 				<tr> -->
<!-- 					<td>test</td> -->
<!-- 					<td>test</td> -->
<!-- 					<td>test</td> -->
<!-- 					<td>test</td> -->
<!-- 					<td>test</td> -->
<!-- 				</tr> -->
			</tbody>
		</table>
	</div>
	<div class="custSalBtn">
		<input type="button" id="close" value="닫기" onclick="window.close()"/>
		<input type="button" id="rtnBtn" value="반품" />
	</div>

</body>
</html>