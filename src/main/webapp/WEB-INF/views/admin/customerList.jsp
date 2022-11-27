<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="/resources/css/content/admin/memberList.css" />

<style>
 #search_list {
 	display: flex;
 	justify-content: center;
 	align-items: center;
 	width: 45px;
 	height: 45px;
 }
 .searchbt { 
 	width: 42px;
    height: 36px;
 }
 </style>
</head>
<body>
<%@include file="../includes/header.jsp" %>
<%@include file="../includes/nav.jsp" %>
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		
		$("#PRT_NM").focus();
		
		var start = document.getElementById('startDate'); //시작일자
		
		//날짜 포맷 변환 함수(YYYY-MM-DD)
		function dateConvert(period){
			var today = new Date();
			today.setDate(today.getDate() - period);
			var year = today.getFullYear();
			var month = ('0' + (today.getMonth() + 1)).slice(-2);
			var day = ('0' + today.getDate()).slice(-2);
			
			var dateStr = year + '-' + month  + '-' + day;
			return dateStr; // 년월일 리턴
		}
		
		start.value = dateConvert(7); // 7일전

		
		var now_utc = Date.now();
		var timeOff = new Date().getTimezoneOffset()*60000;
		var today = new Date(now_utc-timeOff).toISOString().split("T")[0];
		
		document.getElementById("startDate").setAttribute("max", today); //미래 날짜 막음
		document.getElementById("endDate").setAttribute("max", today); //미래날짜 막음		
		
		document.getElementById('endDate').valueAsDate = new Date(); //오늘날짜 넣음
		
		
		
// 		search(); //디폴트 처리하기 위해 넣은거
		
		//사용자 구분코드 1.회사 2.특약점
		var USER_DT_CD = $("#USER_DT_CD").val(); //사용자 구분코드
		if(USER_DT_CD=='1'){
			$("#PRT_CD").val("");
			$("#PRT_NM").val("");
			$("#memberAddBtn").attr("disabled", true); //설정

		}
		
		
		
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
		
		
		
		
		
	}); //(document).ready
	
	//전체 검색버튼 처리
	function search(){
		
		  var stDt = $("#startDate").val();
		  var edDt = $("#endDate").val();
		  
		  
		  if(stDt == ''){
		   alert("시작일을 입력하세요.");
		   stDt.focus();
		   return false;
		  }
		  if(edDt == ''){
		   alert("종료일을 입력하세요.");
		   edDt.focus();
		   return false;
		  }
		  if( Number(stDt.replace(/-/gi,"")) > Number(edDt.replace(/-/gi,"")) ){
		   alert("시작일이 종료일보다 클 수 없습니다.");
		   stDt.focus();
		   return false;
		  } 
		
		
		
		var url = "/admin/customerList/search"; // 고객조회url
		
		var PRT_CD = $("#PRT_CD").val(); //매장코드  --왼쪽
		var CUST_NO = $("#CUST_NO").val(); //고객번호   --왼쪽
		
		var PRT_NM = $("#PRT_NM").val(); //거래처명(매장) --오른쪽
		
		
		var CUST_NM = $("#CUST_NM").val(); //고객이름or번호  --오른쪽
		var CUST_SS_CD = $("input[name='CUST_SS_CD']:checked").val(); //고객상태
		var startDate = $("#startDate").val(); //가입일자
		var endDate = $("#endDate").val(); //가입일자
		
		
		
// 		if(PRT_NM==""){
// 			$("#PRT_CD").val("");
// 		}
// 		if(CUST_NM==""){
// 			$("#CUST_NO").val("");
// 		}
		
// 		if(CUST_NM!="" && CUST_NO==""){
// // 			$("#CUST_NO").val("");
// // 			$("#CUST_NM").val("");
// 			alert("고객번호를 제대로 입력해주세요");
// 			return false;
// 		}
				
		$.ajax({
						
// 			url : url + "?PRT_NM="+PRT_NM //거래처명(매장) -- 오른쪽
// 						+"&CUST_NM="+CUST_NM
// 						+"&CUST_SS_CD="+CUST_SS_CD //고객상태  --오른쪽
// 						+"&startDate="+startDate //가입일자(시작)
// 						+"&endDate="+endDate,  //가입일자(종료)
						
						
			url : url + "?PRT_CD="+PRT_CD //거래처명(매장) -- 왼쪽
						+"&CUST_NO="+CUST_NO  // 고객번호 --왼쪽
						+"&CUST_SS_CD="+CUST_SS_CD //고객상태  
						+"&startDate="+startDate //가입일자(시작)
						+"&endDate="+endDate,  //가입일자(종료)
						
						
			type : "get",
			success:function(res){
				
				var data = ""
				if(res.length>0){
					$.each(res,function(i,item){
						data += "<tr>";
						data += "<td class='lo_left'>"+item.cust_NO; //고객번호
// 						data += "<input type='button' id='historyPop' name='' value='변경이력' onClick='chHistoryPopUp("+item.cust_NO+","+item.cust_NM+")';/>";
						data += "<input type='button' id='historyPop' name='"+item.cust_NO+"' value='변경이력' onclick='chHistoryPopUp("+item.cust_NO+")';/>";
						data += "</td>";
						data += "<td class='lo_left'>"+item.cust_NM; //고객이름
						data += "<input type='submit' id='custInfo' name='custInfo' value='상세' onclick='custInfo("+item.cust_NO+")' />";
						data += "</td>"	; 
						data += "<td class='lo_mid'>"+item.mbl_NO+"</td>"	; //휴대폰번호
						data += "<td class='lo_mid'>"+item.cust_SS_CD+"</td>"	; //고객상태
						data += "<td class='lo_mid'>"+item.js_DT+"</td>"	; //가입일자
						data += "<td class='lo_left'>"+item.prt_NM+"</td>"	; //가입매장
						data += "<td class='lo_left'>"+item.user_NM+"</td>"	; //등록자
						data += "<td class='lo_mid'>"+item.lst_UPD_DT+"</td>"	; //수정일자
						data += "</tr>";
					
					});
				}else{
					alert("조회된 검색결과가 없습니다.");
					data += "<tr>";
					data += "<td colspan='8'>조회된 검색결과가 없습니다.</td>";
					data += "</tr>";
				}
					$("#list").html(data);
			}, //success end
			error:function(res){
				console.log(res);
			} 	//error end 
		});    //ajax end
	}  // search()함수 end
	
	
	//변경이력 팝업창
	function chHistoryPopUp(custNo){
		$("input#EcustNo").val(custNo);  //변경이력시 클릭한 고객번호를 input(hidden)에 넣어준다
		
		window.name="chParentForm"; //부모장치름
			//오픈할 url,   자식창이름
		openWin = window.open('popUp/chHistoryPopUp','ch_child','width=1000,height=500,scrollbars=yes,top=100,left=40,resizable=yes');			
		
	}
	
	//#######################최종 매장검색
	function maPrtMtSearchPopUp(){
		var prtNmP = $("#PRT_NM").val(); // 매장명or매장코드가 들어올거임
		
		var url ="/admin/shopSearch";
		
		$.ajax({
			url:url+"?PRT_NM="+prtNmP,
			type:"get",
			success:function(res){ //  결과가 0, 1, 2개
				if(res.length==1){
					$("#PRT_NM").val(res[0].prt_NM);  //0번째 배열의 매장명 
					$("#PRT_CD").val(res[0].prt_CD);   
				}else if(res.length==0){ // 매장명or매장코드 값모두 불일치 ->팝업창열림
					alert("일치하는 매장이 없습니다.");
					maPartSearchPop(prtNmP); // 매장코드+매장명 팝업창 호출
				}else{ // ex) 2개이상일치 ->강남점, 서초강남점 뿌림
					maPartSearchPop(prtNmP); // 매장코드+매장명 팝업창 호출
				}
			}
		});
	}
	
	//#######################최종 매장검색
	//매장검색 팝업창 호출
	function maPartSearchPop(prtNmP){
		
		$("input#prtNmP").val(prtNmP);  // input(hidden)에 넣어준다.
		
		window.name="maPartSearchPop"; //부모창 이름
		openWin = window.open('popUp/maPrtMtSearchPop','ch_child','width=500,height=500,scrollbars=yes,top=100,left=30,resizable=yes');			
		
	}
	
	//#######################최종 매장검색
	//매장검색에서 엔터키를 눌렀을때
	function maPrtMtEnterkey(){
		var prtNmP = $("#PRT_NM").val(); // 매장명or매장코드가 들어올거임

		if (window.event.keyCode == 13) {
			if(prtNmP=="" && prtNmP<1){
				alert("검색값을 입력하세요");				
			}else if(prtNmP.length <2){
				alert("두자리 이상 입력 필수");
			}else{
				maPrtMtSearchPopUp();
			}
		}
	}
	
	
	//## 오른쪽############ 고객번호 팝업창 최종....
	//고객번호 팝업창 눌렀을때
	function SearchPopUp(){
		var CUST_NM = $("#CUST_NM").val(); // 고객번호 or 고객명 들어올거임
		
// 		alert("너는 받아오징?"+CUST_NM);
		
		var url = "/admin/custNoSearchPop";
		
		$.ajax({
			url: url+"?CUST_NM="+CUST_NM,
			type:"get",
			success:function(res){   // 0개, 1개(일치), 2개이상
				console.log(res.length + ' 갯수');
				console.log(res);
				if(res.length == 1){  // 1개 - 출력
					$("#CUST_NO").val(res[0].cust_NO);							
					$("#CUST_NM").val(res[0].cust_NM);							
				}else if(res.length == 0){  // 0개, 2개이상 
					alert(CUST_NM + '를 찾지 못했습니다.')
					csCustSearchPopUp(CUST_NM);
				}else{
// 					alert(CUST_NM + ' 문자를 포함한 고객이 여러명 존재합니다.');
					csCustSearchPopUp(CUST_NM);
				}
			},
			error:function(json){
				
			}
		});
	}
	
	
	//고객번호 팝업창 호출
	function csCustSearchPopUp(CUST_NM){
		
		$("input#custNmP").val(CUST_NM);  // input(hidden)에 넣어준다.
		
		window.name="scCustSearchPop"; //부모창 이름
		openWin = window.open('popUp/csCustSearchPopUp','ch_child','width=640,height=500,scrollbars=yes,top=100,left=40,resizable=yes');			
		
	}
	
	
	
	//고객번호에서 엔터키 눌렀을때
	function csCustEenterkey(){
		var custNm = $("#CUST_NM").val(); // 고객코드or고객명 들어옴
		if (window.event.keyCode == 13) {
			if(custNm==""){
				alert("검색값을 입력하세요.")
			}else if(custNm.length<2){
				alert("두자리이상 입력 필수")
			}else{
				SearchPopUp();
			}
		}
	}
	
	//상세버튼 클릭시 고객번호(CUST_NO)를 들고옴
	function custInfo(custNo){
		$("#hiddenCustNo").val(custNo);  // input(hidden)에 넣어준다.

		hiddenCustVal(); //form();
	}
	
	//고객 상세조회시
	// id가 hiddenForm인 form 실행
	function hiddenCustVal(){
		var custNo = $("#hiddenCustNo").val(); // 매장명or매장코드가 들어올거임

		var formObj = $("#hiddenForm");
		
// 		formObj.attr("method","get");
		formObj.attr("method","post");
		//최지민
		formObj.attr("action", "/admin/custInfo3");
		formObj.submit();
		
	}
	
	//신규등록 클릭시
	function userRegist(){
		window.name="userRegistPopUp"; //부모창 이름
		openWin = window.open('popUp/userRegistPopUp','ch_child','width=1300,height=700,scrollbars=no,top=100,left=20,resizable=yes');			
	}
</script>
<div class="admin_memberList">
	
	<form id="hiddenForm" action="/admin/custInfo" method="get">
		<input type="hidden" id="hiddenCustNo" name="CUST_NO" value=""/>
	</form>
	<div class="center">
	<div class="memberList_logo">
		고객조회<a href="/admin/customerList"><img src="/resources/images/reset.png" alt="logo" align="middle"/></a>
	</div>
	<div class="memberList_search">
		
		<form>
		
		<input type="hidden" id="USER_DT_CD" id="USER_DT_CD" value="${cn.USER_DT_CD}"/>
		<input type="hidden" id="EcustNo" id="EcustNo" value=""/>
		<!-- 매장코드or매장명 입력값 넣어줌- 팝업창으로 던질거 -->
		<input type="hidden" id="prtNmP" name="prtNmP" value=""/>
		
		<!-- 고객번호or고객명 입력값 넣어줌- 팝업창으로 던질거 -->
		<input type="hidden" id="custNmP" name="custNmP" value=""/>
		
			<table class="memberList_searchTable">
				<thead class="thead">
					<tr>
						<td>
							<label>매장</label>
							<input type="text" id="PRT_CD" name="PRT_CD" value="${cn.PRT_CD}" disabled/>
<!-- 							<input type="button" id="" value="팝업검색" onclick="maPrtMtSearchPopUp();"/> -->
							<button type="button" onclick="maPrtMtSearchPopUp();"><img class="searchBtn" src="https://s3.ap-northeast-2.amazonaws.com/cdn.wecode.co.kr/icon/search.png"> </button>					
							
							<input type="text" class="blank_key" id="PRT_NM" name="PRT_NM" value="${cn.PRT_NM}" onkeyup="maPrtMtEnterkey()"/>
						</td>
						<td>
							<label>고객번호</label>
							<input type="text" id="CUST_NO" name="CUST_NO" value="" disabled/>
							<button type="button" onclick="SearchPopUp();"><img class="searchBtn" src="https://s3.ap-northeast-2.amazonaws.com/cdn.wecode.co.kr/icon/search.png"> </button>					
							<input type="text" class="blank_key" id="CUST_NM" name="CUST_NM" value="" onkeyup="csCustEenterkey()" placeholder=""/>
						</td>
					</tr>
					<tr>
						<td>
							<label><i>*</i>고객상태</label>
							<input type="radio" id="CUST_SS_CD" name="CUST_SS_CD" value="" checked="checked"/>전체
							<input type="radio" id="CUST_SS_CD" name="CUST_SS_CD" value="10"/>정상
							<input type="radio" id="CUST_SS_CD" name="CUST_SS_CD" value="80"/>중지
							<input type="radio" id="CUST_SS_CD" name="CUST_SS_CD" value="90"/>해지
						</td>
						<td>
							<div>
							<label><i>*</i>가입일자</label>
							<input type="date" id="startDate" name="startDate" value="" />
							<input type="date" id="endDate" name="endDate" value=""/>
							</div>
						</td>
						<td rowspan="2">
<!-- 							<input type="button" id="search_list" onclick= "search();"> -->
<!--  					 			<img class="searchbt" src="/resources/images/search.png" alt="search" /> -->
<!-- 							</input> -->
							<input type="button" value="검색" onclick= "search();" />
						</td>
					</tr>
				</thead>
			</table>
		</form>
		
	</div>
	<div class="listM">
		
	</div>
	
	
	<div class="memberList_list">
		<input type="button" id="memberAddBtn" name="" class="memberList_btn" value="신규등록" onclick="userRegist();">
		<table id="st" class="memberList_listTable">
			<thead class="memberList_thead">
				<tr>
					<th class="" id="CUST_NO">고객번호</th>
					<th class="" id="CUST_NM">고객이름</th>
					<th class="" id="MBL_NO">휴대폰번호</th>
					<th class="" id="CUST_SS_CD">고객상태</th>
					<th class="" id="CUST_SS_CD">가입일자</th>
					<th class="" id="JN_PRT_CD">가입매장</th>
					<th class="" id="FST_USER_ID">등록자</th>
					<th class="" id="LST_UPD_DT">수정일자</th>
				</tr>
			</thead>
			<tbody id='list'>
			<div class="scroll">
			
			</div> 
			</tbody>
		</table>
	</div>
	</div> <!-- .center end -->
</div>		
		
<%@include file="../includes/footer.jsp" %>
</body>
</html>