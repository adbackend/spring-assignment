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
 
 
#footList{
 	position: sticky; bottom: 0; 
 	background-color: #e6f2f5;
 	font-weight: bolder;
}

.memberList_thead{
 	position: sticky;  top: 0;

}
 </style>
</head>
<body>
<%@include file="../../includes/header.jsp" %>
<%@include file="../../includes/nav.jsp" %>
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script type="text/javascript">
   $(document).ready(function(){
      
      var start = document.getElementById('startDate'); //시작일
      
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
      
      
      var USER_DT_CD = $("#USER_DT_CD").val(); //사용자 구분코드
      var PRT_CD = $("#PRT_CD").val(); //매장코드
      var PRT_NM = $("#PRT_NM").val(); //매장명
      
      if(USER_DT_CD=='2'){ //특약점이면
         $("#PRT_CD").val(PRT_CD);
         $("#PRT_NM").val(PRT_NM);
         $("#PRT_CD").attr("readonly",true); //설정
         $("#PRT_NM").attr("readonly",true); //설정
      }else{
         $("#memberAddBtn").attr("disabled", true); //판매등록 버튼 disabled
         $("#PRT_CD").val("");
         $("#PRT_NM").val("");
         
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
      

        //고객판매관리 전체검색
         $("#custSalSearchBtn").on("click", function(){
           
            
            if(nullValidation()){ //유효성검사 true시 전체 검색ajax 함수 호출
// 		       getSum();
               custSalSearch();
            }
            
         });
          
          
          
   }); //(document).ready
   
   
   //판매상세조회 팝업창
   function salDetailPopUp(){
	  console.log("###판매상세 팝업창###");   
      
      window.name = "salDetailPopUp"; //부모창 이름
      openWin = window.open('popUp/salPop/custSalDetial','ch_child','width=1550,height=500,scrollbars=yes,top=100,left=60,resizable=yes');      
      
   }
   
   
   function returnValueA(resList){
	   console.log("#######데이터조회.#####");
// 	   console.log(resList.cust_NO);
	   
	   console.log(JSON.stringify(resList));
	   
	   document.getElementById("custDetail").value=JSON.stringify(resList);
	   
	   salDetailPopUp();
   }
   
   //판매수량 판매금액 현금 카드 포인트
   function getSum(count){
	   
	   var cnt = 0;					// flag
	   var total_sal_qty = 0; 		// 수량합계
	   var total_sal_amt = 0; 		// 금액합계
	   var total_csh_stlm_amt = 0;  // 현금합계
	   var total_crd_stlm_amt = 0;  // 카드합계
	   var total_pnt_stlm_amt = 0;  // 포인트합계
	   
		   
	   //수량합계
	   $("[class^='sal_qty']").each(function(){
		   if($("#SAL_TP_CD"+cnt).text() == 'SAL'){
			   total_sal_qty += Number($(".sal_qty"+cnt).text());
		   }else{
			   total_sal_qty -= Number($(".sal_qty"+cnt).text());
		   }
	       document.getElementById("total_sal_qty").innerText = total_sal_qty;
		   cnt++;
	   });
	   cnt = 0; //수량합계때 쓰인 카운트 초기화
	   
	   //금액합계 .sal_amt
	   $("[class^='sal_amt']").each(function(){
		   if($("#SAL_TP_CD"+cnt).text() == 'SAL'){
			   total_sal_amt += Number($(".sal_amt"+cnt).text().replace(/,/g,''));
		   }else{
			   total_sal_amt -= Number($(".sal_amt"+cnt).text().replace(/,/g,''));
		   }
	       document.getElementById("total_sal_amt").innerText = total_sal_amt.toLocaleString();
	       cnt++;
	   });
	   cnt = 0; //카운트 초기화
	   
	   //현금합계 .csh_stlm_amt
	   $("[class^='csh_stlm_amt']").each(function(){
		   if($("#SAL_TP_CD"+cnt).text() == 'SAL'){
			   total_csh_stlm_amt += Number($(".csh_stlm_amt"+cnt).text().replace(/,/g,''));
		   }else{
			   total_csh_stlm_amt -= Number($(".csh_stlm_amt"+cnt).text().replace(/,/g,''));
		   }
	       document.getElementById("total_csh_stlm_amt").innerText = total_csh_stlm_amt.toLocaleString();
	       cnt++;
	   });
	   cnt = 0; //카운트 초기화
	   
	   //카드합계 .crd_stlm_amt
	   $("[class^='crd_stlm_amt']").each(function(){
		   if($("#SAL_TP_CD"+cnt).text() == 'SAL'){
			   total_crd_stlm_amt += Number($(".crd_stlm_amt"+cnt).text().replace(/,/g,''));
		   }else{
			   total_crd_stlm_amt -= Number($(".crd_stlm_amt"+cnt).text().replace(/,/g,''));
		   }
	       document.getElementById("total_crd_stlm_amt").innerText = total_crd_stlm_amt.toLocaleString();
	       cnt++;
	   });
	   cnt = 0; //카운트 초기화	   

	   //포인트합계 .pnt_stlm_amt
	   $("[class^='pnt_stlm_amt']").each(function(){
		   if($("#SAL_TP_CD"+cnt).text() == 'SAL'){
			   total_pnt_stlm_amt += Number($(".pnt_stlm_amt"+cnt).text().replace(/,/g,''));
		   }else{
			   total_pnt_stlm_amt -= Number($(".pnt_stlm_amt"+cnt).text().replace(/,/g,''));
		   }
	       document.getElementById("total_pnt_stlm_amt").innerText = total_pnt_stlm_amt.toLocaleString();
	       cnt++;
	   });
	   cnt = 0; //카운트 초기화	   
	   
   }
   
   //전체 검색 ajax
   function custSalSearch(){
      $.ajax({
          url : "/admin/management/custSalSearch"
         ,type : "get"
         ,data : $("#custSalSearchForm").serialize()
         ,success:function(res){
        	 
            console.log(res);
            var data = ""; //리스트 그리는 html변수
            var dataLast = ""; //합계 그리는 html변수
            
            var trLength = res.length;
            var count = 0;
            
            if(res.length >1){

//             	$.each(res-1,function(i, item){
				for(i=0; i<res.length-1; i++){
                    count = i+1;
              	  //id 고객번호_판매일자_판매번호_매장코드
                    var inputId = 'salDetail_' + res[i].cust_NO + '_' + res[i].sal_DT + '_' + res[i].sal_NO + '_' + res[i].prt_CD;
                    
                    data += "<tr>";
                    data += "<td class='lo_mid'>"+res[i].sal_DT; //판매일자
                    data += "<td class='lo_mid'>"+res[i].cust_NO; //고객번호
                    data += "<td class='lo_mid'>"+res[i].cust_NM; //고객명
                    
                    data += "<td class='lo_mid' id='salNoT' >"+res[i].sal_NO; //판매번호
// //                  data += '<input type="button" id="'+inputId+'" id="'+inputId+'" value="상세" onclick="salDetailPopUp('+JSON.stringify(item)+')" />';
                    data += '<input type="button" id="'+inputId+'" name="'+inputId+'" value="상세"/>';
                    data += "</td>";
                    
                    data += "<td class='sal_qty"+i+"' id='"+res[i].sal_TP_CD+"'>"+res[i].sal_QTY; //수량
                    data += "<td class='sal_amt"+i+"' id='"+res[i].sal_TP_CD+"'>"+(res[i].sal_AMT).toLocaleString(); //금액
                    
                    data += "<td class='csh_stlm_amt"+i+"' id='textR'>"+res[i].csh_STLM_AMT.toLocaleString(); //현금
                    
                    data += "<td class='crd_stlm_amt"+i+"' id='textR'>"+res[i].crd_STLM_AMT.toLocaleString(); //카드
                    data += "<td class='pnt_stlm_amt"+i+"' id='textR'>"+res[i].pnt_STLM_AMT.toLocaleString(); //포인트
                    data += "<td class='lo_mid'>"+res[i].user_NM; //최초등록자
                    
                    data += "<td class='lo_mid'>"+res[i].fst_REG_DT; //등록시간
                    
  				  	data += "<td style='display:none' id='SAL_TP_CD"+i+"'>"+res[i].sal_TP_CD+"</td>";
//   				data += "<td id='SAL_TP_CD"+i+"'>"+item.sal_TP_CD+"</td>";
                    data += "</tr>";

                 };  //each end
                 
 	            dataLast += "<tr>";
	            dataLast += "<td colspan='4' class='lo_mid'>합계</td>";
	            dataLast += "<td class='lo_right'>  <span id='total_sal_qty'>"+res[trLength-1].sal_QTY+"</span></td>";  		 	    				//판매수량
	            dataLast += "<td class='lo_right'>  <span id='total_sal_amt'>"+res[trLength-1].sal_AMT.toLocaleString()+"</span></td>";  	 	 	//판매금액
	            dataLast += "<td class='lo_right'>  <span id='total_csh_stlm_amt'>"+res[trLength-1].csh_STLM_AMT.toLocaleString()+"</span></td>"; 	//현금
	            dataLast += "<td class='lo_right'>  <span id='total_crd_stlm_amt'>"+res[trLength-1].crd_STLM_AMT.toLocaleString()+"</span></td>"; 	//카드
	            dataLast += "<td class='lo_right'>  <span id='total_pnt_stlm_amt'>"+res[trLength-1].pnt_STLM_AMT.toLocaleString()+"</span></td>"; 	//포인트
	            dataLast += "<td colspan='2'></td>"
	            dataLast += "</tr>";
                
            }else{
                alert("검색된 결과가 없습니다.");
                data += "<tr>";
                data += "<td colspan='11'>조회된 검색결과가 없습니다.</td>";
                data += "</tr>";	
            }
                
                $("#list").html(data); //목록
                $("#footList").html(dataLast); //합계 

               //합계 화면에서 구한거
//             getSum(count);
            
            $('[id^="salDetail_"]').click(function(){
            	console.log($(this));
            	var custNo = $(this).attr('id').split('_')[1];
            	var salDt = $(this).attr('id').split('_')[2];
            	var salNo = $(this).attr('id').split('_')[3];
            	var prtCd = $(this).attr('id').split('_')[4];
            	
            	var find = res.find(x => x.cust_NO == custNo 
            						  && x.sal_DT == salDt 
            						  && x.sal_NO == salNo
            						  && x.prt_CD == prtCd);
            	returnValueA(find);
            });
            
         },error:function(res){
            alert("실패");
         }
      });
      
   }
   
   //유효성검사
   function nullValidation(){ //다 체크했으면 true, 하나라도 실패시 false
      
      console.log("#########유효성 시작##########");
      var startDate = document.getElementById("startDate"); //시작일
      var endDate = document.getElementById("endDate"); //종료일
      var PRT_CD = document.getElementById("PRT_CD"); //매장코드
      var PRT_NM = document.getElementById("PRT_NM"); //매장명
      
      console.log(startDate.value == null);
      console.log(startDate.value);
      console.log(startDate.value.length == 0);
      if(startDate.value.length == 0){
         alert("판매일자 시작일을 넣어주세요.");
         return false;         
      }else if(endDate.value.length == 0){
         alert("판매일자 종료일을 넣어주세요.");
         return false;
      }else if( Number(startDate.value.replace(/-/gi,"")) >  Number(endDate.value.replace(/-/gi,""))){
    	  alert("시작일이 종료일보다 클 수 없습니다.");
    	  return false;
      }
//       else if(PRT_CD.value.length == 0 || PRT_NM.value.length == 0){
//          alert("매장을 제대로 입력해주세요");
//          return false;
//       }
      return true;
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
      openWin = window.open('../popUp/maPrtMtSearchPop','ch_child','width=500,height=500,scrollbars=yes,top=100,left=30,resizable=yes');         
      
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
      
//       alert("너는 받아오징?"+CUST_NM);
      
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
//                alert(CUST_NM + ' 문자를 포함한 고객이 여러명 존재합니다.');
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
      openWin = window.open('../popUp/csCustSearchPopUp','ch_child','width=640,height=500,scrollbars=yes,top=100,left=40,resizable=yes');         
      
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
   
   
   
   
   //판매등록 팝업창
   function salRegisterPop(){
      window.name="salRegisterPop"; //부모창 이름
      openWin = window.open('popUp/salPop/salRegister','ch_child','width=1300,height=700,scrollbars=no,top=100,left=20,resizable=yes');         
   }
</script>
<div class="admin_memberList">
   
   <form id="hiddenForm" action="/admin/custInfo" method="get">
      <input type="hidden" id="hiddenCustNo" name="CUST_NO" value=""/>
   </form>
   <div class="center">
   <div class="memberList_logo">
      고객판매관리<a href="/admin/management/custSalSearchForm"><img src="/resources/images/reset.png" alt="logo" align="middle"/></a>
   </div>
   <div class="memberList_search">
      
      <form id="custSalSearchForm">
      
      <!-- 사용자구분코드  1:회사, 2:특약점 -->
      <input type="hidden" id="USER_DT_CD" name="USER_DT_CD" value="${cn.USER_DT_CD}"/>
      <!-- 세션.고객번호 -->
      <input type="hidden" id="USER_ID" name="USER_ID" value="${cn.USER_ID}"/>
      
      <input type="hidden" id="EcustNo" id="EcustNo" value=""/>
      <!-- 매장코드or매장명 입력값 넣어줌- 팝업창으로 던질거 -->
      <input type="hidden" id="prtNmP" name="prtNmP" value=""/>
      <!-- 고객번호or고객명 입력값 넣어줌- 팝업창으로 던질거 -->
      <input type="hidden" id="custNmP" name="custNmP" value=""/>
      
      <!-- 매장코드 -->
      <input type="hidden" id="ivocoPrtCd" name="ivocoPrtCd" value="${cn.PRT_CD}"/>
      
      <input type="hidden" id="custDetail" name="custDetail"/>
      
         <table class="memberList_searchTable">
            <thead class="thead">
               <tr>
                  <td>
                     <label><i>*</i>판매일자</label>
                     <input type="date" id="startDate" name="startDate" value="" />~
                     <input type="date" id="endDate" name="endDate" value=""/>
                  </td>
                  <td>
                     <label><i>*</i>매장</label>
                     <input type="text" id="PRT_CD" name="PRT_CD" value="${cn.PRT_CD}" />
                     <button type="button" onclick="maPrtMtSearchPopUp();"><img class="searchBtn" src="https://s3.ap-northeast-2.amazonaws.com/cdn.wecode.co.kr/icon/search.png"> </button>					
                     <input type="text" class="blank_key" id="PRT_NM" name="PRT_NM" value="${cn.PRT_NM}" onkeyup="maPrtMtEnterkey()" />
                  </td>
               </tr>
               <tr>
                  <td>
                     <label>고객번호</label>
                     <input type="text" id="CUST_NO" name="CUST_NO" value="" readonly="readonly"/>
					 <button type="button" onclick="SearchPopUp();"><img class="searchBtn" src="https://s3.ap-northeast-2.amazonaws.com/cdn.wecode.co.kr/icon/search.png"> </button>					
                     <input type="text" class="blank_key" id="CUST_NM" name="CUST_NM" value="" onkeyup="csCustEenterkey()" placeholder=""/>
                  </td>
                  <td rowspan="2">
<!--                      <input type="button" id="search_list" onclick= "search();"> -->
<!--                           <img class="searchbt" src="/resources/images/search.png" alt="search" /> -->
<!--                      </input> -->
                     <input type="button" id="custSalSearchBtn" value="검색"  />
                  </td>
               </tr>
            </thead>
         </table>
      </form>
      
   </div>
   <div class="listM">
      
   </div>
   
   
   <div class="memberList_list">
      <input type="hidden" id="USER_DT_CD" name="USER_DT_CD" value="${cn.USER_DT_CD}"/> <!-- 사용자구분코드  1:회사, 2:특약점 -->
      <input type="button" id="memberAddBtn" name="" class="memberList_btn" value="판매등록" onclick="salRegisterPop();">
      <table id="st" class="memberList_listTable">
         <thead class="memberList_thead">
            <tr>
               <th class="" id="" rowspan="2">판매일자</th>
               <th class="" id="" rowspan="2">고객번호</th>
               <th class="" id="" rowspan="2">고객명</th>
               <th class="" id="" rowspan="2">판매번호</th>
               <th class="" id="" colspan="2">판매</th>
               <th class="" id="" colspan="3">수금</th>
               <th class="" id="" rowspan="2">등록자</th>
               <th class="" id="" rowspan="2">등록시간</th>
            </tr>
            <tr>   
               <th class="" id="" >수량</th>
               <th class="" id="" >금액</th>
               <th class="" id="" >현금</th>
               <th class="" id="" >카드</th>
               <th class="" id="" >포인트</th>
            </tr>
         </thead>
         
         <tbody id='list'>
            
         </tbody>
         <tfoot id="footList">
         </tfoot>
      </table>
   </div>
   </div> <!-- .center end -->
</div>      
      
<%@include file="../../includes/footer.jsp" %>
</body>
</html>