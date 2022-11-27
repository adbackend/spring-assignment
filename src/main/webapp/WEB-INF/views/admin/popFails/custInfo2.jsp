<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- /dowellPro/src/main/webapp/resources/images/search.png -->
<!DOCTYPE html>
<!-- ################################################################
###################고객정보조회#######################################
#####################################################################
##################################################################### -->
<html>
<head>
<link rel="stylesheet" href="/resources/css/content/admin/custInfo.css" />

</head>
<body>
<%@include file="../../includes/header.jsp" %>
<%@include file="../../includes/nav.jsp" %>
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script type="text/javascript">
   $(document).ready(function(){

      
      
   }); //(document).ready
   

   
   
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
               alert("'"+prtNmP+"' 단어를 포함한 매장이 한곳 존재");
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
   
   
</script>
<div class="admin_memberList">
   <div class="center">
   <div class="memberList_logo">
      <h4>고객정보조회
         <button onclick='window.location.reload()'><img src="/resources/images/reset.png" alt="logo" align="middle"/></button>
      </h4>
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
                     <input type="text" id="PRT_CD" name="매장" value="${cn.PRT_CD}" disabled/>
                     <i class="fa-solid fa-acorn"></i>
                     <input type="button" id="" value="팝업검색" onclick="maPrtMtSearchPopUp();"/>
                     <input type="text" class="blank_key" id="PRT_NM" name="PRT_NM" value="${cn.PRT_NM}" onkeyup="maPrtMtEnterkey()"/>
                  </td>

                  <td rowspan="2">

                     <input type="button" value="검색" onclick= "search();" />
                  </td>
               </tr>
            </thead>
         </table>
      </form>
      
   </div>
   
   <div>
      <p>고객기본정보</p>
        <form action="" method="post" >
        <fieldset>
            <legend>고객기본정보</legend>
            <div>
	            <label for="user_id"><em>*</em>고객명</label>
    	        <input type="text" id="" name="" size="" autofocus>

        	    <label for="user_pw"> 생년월일 </label>
            	<input type="date" id="user_pw" name="user_pw">
            	
        	    <label for="">성별</label>
            	<input type="radio" id="" name="" checked="checked">여성
            	<input type="radio" id="" name="">남성
            </div>
            
            <div>
            	 <label for="">생일</label>
            	<input type="radio" id="" name="" checked="checked">양력
            	<input type="radio" id="" name="">음력
            
            </div>
        </fieldset>

        <fieldset>
            <legend> 회원가입 </legend>
                <!-- em : 진하게, 강조 -->
                <!-- id : lable의 for랑 연결된 부분 / name은 다른 파일로 넘겨줄 파라미터 명 -->
                <label class="reg" for="new_id"> 아이디 <em> * </em></label>
                <input type="text" id="new_id" name="new_id" size="20" autocomplete="on" required>
                    
                <label class="reg" for="new_pw1"> 비밀번호 <em> * </em> </label>
                    <input type="password" id="new_pw1" name="new_pw1" size="20" required>
               
               <div>
               <label class="reg" for="new_pw2"> 비밀번호 확인 <em> * </em> </label>
               <input type="password" id="new_pw2" name="new_pw2" size="20" required>
               </div> 
              
                <label class="reg" for="user_name"> 이름 <em> * </em> </label>
                <input type="text" id="user_name" name="user_name" size="20" required>
                
               <label class="reg" for="user_mail"> 메일주소 <em> * </em> </label>
               <input type="email" id="user_mail" name="user_mail" size="20" required>
                
                <label class="reg" for="user_tel"> 전화 번호 </label>
                <input type="tel" id="user_tel" name="user_tel" size="20">
              
        </fieldset>

        <fieldset class="easys">
               <legend>수신동의(통합)</legend>
	            <label for="user_id"><em>*</em>이메일수신동의</label>
            	<input type="radio" id="a" name="a">예
            	<input type="radio" id="a" name="a">아니오
            	
	            <label for="user_id"><em>*</em>SMS수신동의</label>
            	<input type="radio" id="b" name="b">예
            	<input type="radio" id="b" name="b">아니오
            	
	            <label for="user_id"><em>*</em>DM수신동의</label>
            	<input type="radio" id="c" name="c">예
            	<input type="radio" id="c" name="c">아니오
        </fieldset>

        <fieldset class="sendform">
            <input type="submit" value="닫기">
            <input type="reset" value="저장">
        </fieldset>
        </form>
</div>      
</div>
</div>

      
<%@include file="../../includes/footer.jsp" %>
</body>
</html>