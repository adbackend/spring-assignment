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
		
		
		//월별실적 버튼을 눌렀을때
		function monthSearch(){
			var prtCd = $("#PRT_CD").val(); // 선택한 매장
			var cuMonth = $("#currnetMonth").val(); // 선택한 년월
			
			var prtNm = $("#PRT_NM").val(); // 고객코드or고객명 들어옴

			if(prtNm.length==""){
				alert("매장 입력필수");
				return false;
			}
			
			var url = "/admin/monthPerf/Search"
			$.ajax({
				url : url+"?PRT_CD="+prtCd+"&SAL_DT="+cuMonth,
				type : "get",
				success:function(res){
					console.log(res.csSal01MtVO.length);
					console.log(res.csSal01MtVO);

					console.log(res.csSal01MtVO[0].prt_CD);
					
					console.log(res.monthlySum[res.csSal01MtVO[0].prt_CD])

// 					console.log(res.monthlySum[])
					console.log("으아아아");
					
					
// 					console.log(res.monthlySum(res.csSal01MtVO[0].prt_CD));
					
					var htm ="";
					
					if(res.csSal01MtVO.length==0){
// 						var str = res.csSal01MtVO[0].sal_DT;
						alert("조회된 값이 없습니다.");
						htm += "<tr>";
						htm += "<td colspan='34'>조회된 검색결과가 없습니다.</td>";
						htm += "</tr>";
					}else{
						
						console.log(res.monthlySum.get(res.csSal01MtVO[0].prt_CD));

					//1. csSal01mtvo(list) 안에 SAL_DT 가 몇월인지를 먼저 체크
					//2. 6월인거 확인 후 -> 자바스크림트 2022,06 달이 몇일 까지 있는지 
					//3. 31일까지 있는거 확인 후 -> 반복문 1 ~ 31  (가장 바깥 반복문)
					// 내부에서 반복문 한번더 cssal01mtvo 있는 값 
					// 반복문 돌릴 때, sal_dt(20220609) 뒤에 2자리 확인 -> 값이 같은지 (바깥 반복문 i 값과 같은지 )
					// 같으면 tot_SAL_QTY 출력 , 다르면 0
					// 4. 마지막 합계는 monthlySUm 출력 (키값으로 prt_CD 사용)
					// Ex. monthlySUm[getprt_cd] => 각 매장에 대한 합계
					var str = res.csSal01MtVO[0].sal_DT;
					var yyyyMM = str.substr(0,6);   //202206
					var yyyy = yyyyMM.substr(0, 4);
					var mm = yyyyMM.substr(4, 6);
					
					var date = new Date(yyyy, mm, 0);
					var cnt = date.getDate();
					
					htm += "<tr>"
					htm +="<td>"+res.csSal01MtVO[0].prt_CD+"</td>";
					htm +="<td>"+res.csSal01MtVO[0].prt_NM+"</td>";
					
	                // 매장별 반복문 
	                	// <tr>
// 	                   <td>매장코드</td>
// 	                   <td>강남역</td>
					for(var i=1; i<=cnt; i++){
						
						var cntSum = 0;
						
						$.each(res.csSal01MtVO, function(j, item){
							var dd = parseInt(item.sal_DT.substr(6, 8));
							
							if (i == dd) {
								htm += "<td>" + item.tot_SAL_QTY  + "</td>";
								cntSum++;
							} 
						});
						if (cntSum == 0) {
							htm += "<td>0</td>";
						} 
					} //for문 end
// 					htm += "<td>"++"</td>";
					htm += "</tr>";
					
					}
					$("#PERFORM_DISPLAY").html(htm);
				},error:function(res){
	
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
							<input type="text" id="PRT_NM" name="PRT_NM" value="${cn.PRT_NM}" onkeyup="Eenterkey()" disabled/>
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
			            
			            <tbody id="PERFORM_DISPLAY">
<!-- 			            <tr> -->
<!-- 			                   <td>123</td> -->
<!-- 			                   <td>강남역</td> -->
<!-- 			                   <td id="date1">1일</td> -->
<!-- 			                   <td>2일</td> -->
<!-- 			                   <td>3일</td> -->
<!-- 			                   <td>4일</td> -->
<!-- 			                   <td>5일</td> -->
<!-- 			                   <td>6일</td> -->
<!-- 			                   <td>7일</td> -->
<!-- 			                   <td>8일</td> -->
<!-- 			                   <td>9일</td> -->
<!-- 			                   <td>10일</td> -->
<!-- 			                   <td>11일</td> -->
<!-- 			                   <td>12일</td> -->
<!-- 			                   <td>13일</td> -->
<!-- 			                   <td>14일</td> -->
<!-- 			                   <td>15일</td> -->
<!-- 			                   <td>16일</td> -->
<!-- 			                   <td>17일</td> -->
<!-- 			                   <td>18일</td> -->
<!-- 			                   <td>19일</td> -->
<!-- 			                   <td>20일</td> -->
<!-- 			                   <td>21일</td> -->
<!-- 			                   <td>22일</td> -->
<!-- 			                   <td>23일</td> -->
<!-- 			                   <td>24일</td> -->
<!-- 			                   <td>25일</td> -->
<!-- 			                   <td>26일</td> -->
<!-- 			                   <td>27일</td> -->
<!-- 			                   <td>28일</td> -->
<!-- 			                   <td>29일</td> -->
<!-- 			                   <td>30일</td> -->
<!-- 			                   <td>31일</td> -->
<!-- 			                   <td>합계</td> -->
<!-- 			                   </tr> -->
<!-- 			                   <tr> -->
<!-- 			                     <td colspan="2">합계</td> -->
<!-- 			                   <td>합계</td> -->
<!-- 			                   <td>합계</td> -->
<!-- 			                   <td>합계</td> -->
<!-- 			                   <td>합계</td> -->
<!-- 			                   <td>합계</td> -->
<!-- 			                   <td>합계</td> -->
<!-- 			                   <td>합계</td> -->
<!-- 			                   <td>합계</td> -->
<!-- 			                   <td>합계</td> -->
<!-- 			                   <td>합계</td> -->
<!-- 			                   <td>합계</td> -->
<!-- 			                   <td>합계</td> -->
<!-- 			                   <td>합계</td> -->
<!-- 			                   <td>합계</td> -->
<!-- 			                   <td>합계</td> -->
<!-- 			                   <td>합계</td> -->
<!-- 			                   <td>합계</td> -->
<!-- 			                   <td>합계</td> -->
<!-- 			                   <td>합계</td> -->
<!-- 			                   <td>합계</td> -->
<!-- 			                   <td>합계</td> -->
<!-- 			                   <td>합계</td> -->
<!-- 			                   <td>합계</td> -->
<!-- 			                   <td>합계</td> -->
<!-- 			                   <td>합계</td> -->
<!-- 			                   <td>합계</td> -->
<!-- 			                   <td>합계</td> -->
<!-- 			                   <td>합계</td> -->
<!-- 			                   <td>합계</td> -->
<!-- 			                   <td>합계</td> -->
<!-- 			                   <td>합계</td> -->
<!-- 			                   <td>합계</td> -->
<!-- 			                   </tr> -->
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