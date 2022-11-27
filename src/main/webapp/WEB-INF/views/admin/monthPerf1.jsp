<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="/resources/css/content/admin/monthPerf.css" />
<!-- <link rel="stylesheet" href="/resources/css/content/admin/memberList.css" /> -->

<meta charset="UTF-8">
<title>월별실적</title>
</head>

<%@include file="../includes/header.jsp" %>
<%@include file="../includes/nav.jsp" %>
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>

<script type="text/javascript">
	$(document).ready(function(){
		
		//현재년월 default로 셋팅
		document.getElementById('currnetMonth').value= new Date().toISOString().slice(0, 7);
		
		//사용자 구분코드 1.회사 2.특약점
		var USER_DT_CD = $("#USER_DT_CD").val(); //사용자 구분코드
		var PRT_CD = $("#PRT_CD").val(); //매장코드
		var PRT_NM = $("#PRT_NM").val(); //매장명
		
		if(USER_DT_CD=='2'){ //특약점이면
			$("#PRT_CD").val(PRT_CD);
			$("#PRT_NM").val(PRT_NM);
		}else{
			$("#PRT_CD").val("");
			$("#PRT_NM").val("");
			$("#PRT_NM").attr("disabled", false); //해제
			$("#cdBtn").attr("disabled", false); //해제
			
			
		      $("input.blank_key").keyup(function(event){                  // 매장조건 입력란에서 키보드를 입력할 때
		          if(event.keyCode == 8 || event.keyCode == 46) {          // 백스페이스(8) 또는 Delete(46)키를 입력했을 경우
		                if( $("input#PRT_NM").val() == "" ) {            // 매장검색란의 내용이 아무것도 없다면
		                   $("input#PRT_CD").val("");                  // 매장코드를 비운다
		                } 
		             
		                if($("input#CUST_NM").val() == "") {               // 고객검색란의 내용이 아무것도 없다면
		                   $("input#CUST_NO").val("");                     // 고객번호를 지운다
		                }
		             }
		          }); // end of $("input.blank_key").keyup(function(event){})------------- 
			
		}
	});
		
			//결과가 0, 1, 2개 판별 해서
			//1이면 디폴트로 매장명,매장코드 뿌리고
			//아니면 팝업창 열기
			
			//엔터를 눌렀을때도
			//결과가 0, 1, 2개 판별해서
			//1이면 디폴트로 매장명, 매장코드 뿌리고
			//아니면 팝업창열기
		

		//팝업검색
		function SearchPopUp(){

			var prtNmP = $("#PRT_NM").val(); // 매장명or매장코드가 들어올거임
			
			var url ="/admin/shopSearch";
			
			$.ajax({
				url:url+"?PRT_NM="+prtNmP,
				type:"get",
				success:function(res){ //  결과가 0, 1, 2개
					if(res.length==1){
						alert("'"+prtNmP+"' 단어를 포함한 매장이 한곳 존재");
						$("#PRT_NM").val(res[0].prt_NM);  //0번째 배열의 매장명 
						$("#PRT_CD").val(res[0].prt_CD);   
					}else if(res.length==0){ // 매장명or매장코드 값모두 불일치 ->팝업창열림
						alert("일치하는 매장이 없습니다.");
						maPartSearchPop(prtNmP); // 매장코드+매장명 팝업창 호출
					}else{ // ex) 2개이상일치 ->강남점, 서초강남점 뿌림
						maPartSearchPop(prtNmP); // 매장코드+매장명 팝업창 호출
					}
				},
				error:function(res){
					
				}
			});//ajax end
		} //SearchPopUp() end
		
		//매장검색 팝업창 호출
		function maPartSearchPop(prtNmP){
			
			$("input#prtNmP").val(prtNmP);  // input(hidden)에 넣어준다.
			
			window.name="maPartSearchPop"; //부모창 이름
			openWin = window.open('popUp/maPrtMtSearchPop','ch_child','width=500,height=500,scrollbars=yes,top=100,left=40,resizable=yes');			
			
		}
		
		//매장검색에서 엔터눌렀을떄
		function Eenterkey(){
			
			var prtNm = $("#PRT_NM").val(); // 고객코드or고객명 들어옴

			if (window.event.keyCode == 13) {
				if(prtNm==""){
					alert("검색값을 입력하세요.")
				}else if(prtNm.length<2){
					alert("두자리이상 입력 필수")
				}else{
					SearchPopUp();
				}
			}
		}
		
		
// 		//월별실적 버튼을 눌렀을때
// 		function monthSearch(){
// 			var prtCd = $("#PRT_CD").val(); // 선택한 매장코드
// 			var prtNm = $("#PRT_NM").val(); //  입력한 매장
// 			var cuMonth = $("#currnetMonth").val(); // 선택한 년월
			
// 		     var ym = cuMonth.replace("-", "");

			
			
// // 			if(prtNm.length==""){
// // 				alert("매장 입력필수");
// // 				return false;
// // 			}
			
// 			var url = "/admin/monthPerf/Search1"
// 			$.ajax({
// 				url : url,
// 				data : {"in_prt": prtCd,
// 		            	"ym": cuMonth} ,
// 				type: "post",
// 				dataType:"JSON",
// 				 async: false,
// 				 success:function(json){
					 
// 					 console.log(json[0].PRT_CD=='총합');
// 					 console.log(json[0]);
					 
// 					 let html = "";
// 			           if(json.length > 1){
// 			               $.each(json,function(index, item){
			                  	
// 			                  html += "<tr style='width: 100%;'>";
// 			                  html += "<td id='PRT_CD'>"+item.PRT_CD+"</td>";
// 			                  html += "<td id='PRT_NM'>"+item.PRT_NM+"</td>";
// 			                  html += "<td id='SAL_1_QTY'>"+item.SAL_1_QTY+"</td>";
// 			                  html += "<td id='SAL_2_QTY'>"+item.SAL_2_QTY+"</td>";
// 			                  html += "<td id='SAL_3_QTY'>"+item.SAL_3_QTY+"</td>";
// 			                  html += "<td id='SAL_4_QTY'>"+item.SAL_4_QTY+"</td>";
// 			                  html += "<td id='SAL_5_QTY'>"+item.SAL_5_QTY+"</td>";
// 			                  html += "<td id='SAL_6_QTY'>"+item.SAL_6_QTY+"</td>";
// 			                  html += "<td id='SAL_7_QTY'>"+item.SAL_7_QTY+"</td>";
// 			                  html += "<td id='SAL_8_QTY'>"+item.SAL_8_QTY+"</td>";
// 			                  html += "<td id='SAL_9_QTY'>"+item.SAL_9_QTY+"</td>";
// 			                  html += "<td id='SAL_10_QTY'>"+item.SAL_10_QTY+"</td>";
// 			                  html += "<td id='SAL_11_QTY'>"+item.SAL_11_QTY+"</td>";
// 			                  html += "<td id='SAL_12_QTY'>"+item.SAL_12_QTY+"</td>";
// 			                  html += "<td id='SAL_13_QTY'>"+item.SAL_13_QTY+"</td>";
// 			                  html += "<td id='SAL_14_QTY'>"+item.SAL_14_QTY+"</td>";
// 			                  html += "<td id='SAL_15_QTY'>"+item.SAL_15_QTY+"</td>";
// 			                  html += "<td id='SAL_16_QTY'>"+item.SAL_16_QTY+"</td>";
// 			                  html += "<td id='SAL_17_QTY'>"+item.SAL_17_QTY+"</td>";
// 			                  html += "<td id='SAL_18_QTY'>"+item.SAL_18_QTY+"</td>";
// 			                  html += "<td id='SAL_19_QTY'>"+item.SAL_19_QTY+"</td>";
// 			                  html += "<td id='SAL_20_QTY'>"+item.SAL_20_QTY+"</td>";
// 			                  html += "<td id='SAL_21_QTY'>"+item.SAL_21_QTY+"</td>";
// 			                  html += "<td id='SAL_22_QTY'>"+item.SAL_22_QTY+"</td>";
// 			                  html += "<td id='SAL_23_QTY'>"+item.SAL_23_QTY+"</td>";
// 			                  html += "<td id='SAL_24_QTY'>"+item.SAL_24_QTY+"</td>";
// 			                  html += "<td id='SAL_25_QTY'>"+item.SAL_25_QTY+"</td>";
// 			                  html += "<td id='SAL_26_QTY'>"+item.SAL_26_QTY+"</td>";
// 			                  html += "<td id='SAL_27_QTY'>"+item.SAL_27_QTY+"</td>";
// 			                  html += "<td id='SAL_28_QTY'>"+item.SAL_28_QTY+"</td>";
// 			                  html += "<td id='SAL_29_QTY'>"+item.SAL_29_QTY+"</td>";
// 			                  html += "<td id='SAL_30_QTY'>"+item.SAL_30_QTY+"</td>";
// 			                  html += "<td id='SAL_31_QTY'>"+item.SAL_31_QTY+"</td>";
// 			                  html += "<td id='TOT_SAL_QTY'>"+item.TOT_SAL_QTY+"</td>";
// 			                  html += "</tr>";
// 			                  html += "<tr style='width: 100%;'>";
			                  
			                  
// 			                  html += "</tr>";
// 			               });
// 			            }// if end
// 			            else {
// 			            	alert("검색된 결과가 없습니다.");
// 			                html += "<tr>";
// 			                html += "<td colspan='34'>검색된 결과가 없습니다.</td>";
// 			                html += "</tr>";
// 			             }
// 			           $("tbody#mae_body").html(html);              
// 				 }//success end
// 				,error:function(res){
// 					alert("매출월 실패");
// 				}
// 			}); //ajax end
			
// 		}


		//월별실적 버튼을 눌렀을때
		function monthSearch(){
			var prtCd = $("#PRT_CD").val(); // 선택한 매장코드
			
			var prtNm = $("#PRT_NM").val(); //  입력한 매장
			var cuMonth = $("#currnetMonth").val(); // 선택한 년월
			
		     var ym = cuMonth.replace("-", "");

			
			
// 			if(prtNm.length==""){
// 				alert("매장 입력필수");
// 				return false;
// 			}
			
			var url = "/admin/monthPerf/Search1"
			$.ajax({
				url : url,
				data : {"in_prt": prtCd,
		            	"ym": ym} ,
				type: "post",
				dataType:"JSON",
				 async: false,
				 success: function(json){
			            
			            let html = "";
			            //console.log(json.length);
			            if(json.length > 0 && json[0].PRT_CD != '총합'){
			               $.each(json,function(index, item){
			                  
			                  
			                  html += "<tr style='width: 100%;'>";
			                  
			                     if(item.PRT_NM != '합계'){
			                              html += "<td class='left'>"+item.PRT_CD+"</td>";//매장코드
			                              html += "<td class='left'>"+item.PRT_NM+"</td>";//매장명
			                           }
			                           if(item.PRT_NM == '합계'){

			                              html += "<td colspan='2' >"+item.PRT_NM+"</td>";//매장명
			                           }
			                           
			   

			                  
			/*                   html += "<td id='PRT_CD'>"+item.PRT_CD+"</td>";
			                  html += "<td id='PRT_NM'>"+item.PRT_NM+"</td>"; */
			                  html += "<td class='right' id='SAL_1_QTY'>"+item.SAL_1_QTY+"</td>";
			                  html += "<td class='right' id='SAL_2_QTY'>"+item.SAL_2_QTY+"</td>";
			                  html += "<td class='right' id='SAL_3_QTY'>"+item.SAL_3_QTY+"</td>";
			                  html += "<td class='right' id='SAL_4_QTY'>"+item.SAL_4_QTY+"</td>";
			                  html += "<td class='right' id='SAL_5_QTY'>"+item.SAL_5_QTY+"</td>";
			                  html += "<td class='right' id='SAL_6_QTY'>"+item.SAL_6_QTY+"</td>";
			                  html += "<td class='right' id='SAL_7_QTY'>"+item.SAL_7_QTY+"</td>";
			                  html += "<td class='right' id='SAL_8_QTY'>"+item.SAL_8_QTY+"</td>";
			                  html += "<td class='right' id='SAL_9_QTY'>"+item.SAL_9_QTY+"</td>";
			                  html += "<td class='right' id='SAL_10_QTY'>"+item.SAL_10_QTY+"</td>";
			                  html += "<td class='right' id='SAL_11_QTY'>"+item.SAL_11_QTY+"</td>";
			                  html += "<td class='right' id='SAL_12_QTY'>"+item.SAL_12_QTY+"</td>";
			                  html += "<td class='right' id='SAL_13_QTY'>"+item.SAL_13_QTY+"</td>";
			                  html += "<td class='right' id='SAL_14_QTY'>"+item.SAL_14_QTY+"</td>";
			                  html += "<td class='right' id='SAL_15_QTY'>"+item.SAL_15_QTY+"</td>";
			                  html += "<td class='right' id='SAL_16_QTY'>"+item.SAL_16_QTY+"</td>";
			                  html += "<td class='right' id='SAL_17_QTY'>"+item.SAL_17_QTY+"</td>";
			                  html += "<td class='right' id='SAL_18_QTY'>"+item.SAL_18_QTY+"</td>";
			                  html += "<td class='right' id='SAL_19_QTY'>"+item.SAL_19_QTY+"</td>";
			                  html += "<td class='right' id='SAL_20_QTY'>"+item.SAL_20_QTY+"</td>";
			                  html += "<td class='right' id='SAL_21_QTY'>"+item.SAL_21_QTY+"</td>";
			                  html += "<td class='right' id='SAL_22_QTY'>"+item.SAL_22_QTY+"</td>";
			                  html += "<td class='right' id='SAL_23_QTY'>"+item.SAL_23_QTY+"</td>";
			                  html += "<td class='right' id='SAL_24_QTY'>"+item.SAL_24_QTY+"</td>";
			                  html += "<td class='right' id='SAL_25_QTY'>"+item.SAL_25_QTY+"</td>";
			                  html += "<td class='right' id='SAL_26_QTY'>"+item.SAL_26_QTY+"</td>";
			                  html += "<td class='right' id='SAL_27_QTY'>"+item.SAL_27_QTY+"</td>";
			                  html += "<td class='right' id='SAL_28_QTY'>"+item.SAL_28_QTY+"</td>";
			                  html += "<td class='right' id='SAL_29_QTY'>"+item.SAL_29_QTY+"</td>";
			                  html += "<td class='right' id='SAL_30_QTY'>"+item.SAL_30_QTY+"</td>";
			                  html += "<td class='right' id='SAL_31_QTY'>"+item.SAL_31_QTY+"</td>";
			                  html += "<td class='right' id='TOT_SAL_QTY'>"+item.TOT_SAL_QTY+"</td>";
			                  html += "</tr>"; 
			               });
			            }
			            else {
			            	alert("검색결과가 없습니다.");
			               html += "<tr>";
			               html += "<td colspan='34'>검색결과가 존재하지 않습니다.</td>";
			               html += "</tr>";
			            }

			           $("tbody#mae_body").html(html);              
				 }//success end
				,error:function(res){
					alert("매출월 실패");
				}
			}); //ajax end
			
		}

</script>  
<body>
<div class="admin_memberList">


 	<div class="center">
	<div class="memberList_logo">
	</div>
	<div class="memberList_search">
	<H4>월별실적조회</H4>
		<form>
		<!-- 사용자구분코드  1:회사, 2:특약점  -->
		<input type="hidden" id="USER_DT_CD" name="USER_DT_CD" value="${cn.USER_DT_CD}"/>
		
		<!-- 매장코드or매장명 입력값 넣어줌- 팝업창으로 던질거 -->
		<input type="hidden" id="prtNmP" name="prtNmP" value=""/>
			<table class="memberList_searchTable">
				<thead class="thead">
					<tr>
						<td>
							<label>매출월</label>
							<input type="month" id="currnetMonth" name="currnetMonth"/>
						</td>
						<td>
							<label>매장</label>
							<input type="text" id="PRT_CD" name="PRT_CD" value="${cn.PRT_CD}" disabled/>
							<input type="button" id="cdBtn" value="팝업검색" onclick="SearchPopUp();" disabled/>
							<input type="text" id="PRT_NM" name="PRT_NM" class="blank_key" value="${cn.PRT_NM}" onkeyup="Eenterkey()" disabled/>
							<input type="button" value="검색" onclick= "monthSearch();" />
						</td>
					</tr>
				</thead>
			</table>
		</form>
		
	</div>
	
	
	<div class="memberList_list">
		<table class="memberList_listTable">
			<thead class="memberList_thead">
			              <tr> 
			                   <th>매장코드</th>
			                   <th>매장명</th>
			                   <th>1일</th>
			                   <th>2일</th>
			                   <th>3일</th>
			                   <th>4일</th>
			                   <th>5일</th>
			                   <th>6일</th>
			                   <th>7일</th>
			                   <th>8일</th>
			                   <th>9일</th>
			                   <th>10일</th>
			                   <th>11일</th>
			                   <th>12일</th>
			                   <th>13일</th>
			                   <th>14일</th>
			                   <th>15일</th>
			                   <th>16일</th>
			                   <th>17일</th>
			                   <th>18일</th>
			                   <th>19일</th>
			                   <th>20일</th>
			                   <th>21일</th>
			                   <th>22일</th>
			                   <th>23일</th>
			                   <th>24일</th>
			                   <th>25일</th>
			                   <th>26일</th>
			                   <th>27일</th>
			                   <th>28일</th>
			                   <th>29일</th>
			                   <th>30일</th>
			                   <th>31일</th>
			                   <th>합계</th>
			              </tr>
			            </thead>
			            
							<tbody id="mae_body"/>			            
							</tbody>
			          </table>
			        </div>
			      </div>




	</div>
	</div> <!-- .center end -->
</div>

<%@include file="../includes/footer.jsp" %>
</body>
</html>