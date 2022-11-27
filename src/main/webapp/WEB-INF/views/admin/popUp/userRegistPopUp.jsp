<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!-- /dowellPro/src/main/webapp/resources/images/search.png -->
<!DOCTYPE html>
<!-- ################################################################
###################고객등록#######################################
#####################################################################
##################################################################### -->
<html>
<head>
<link rel="stylesheet" href="/resources/css/content/admin/popUp/userRegistPopUp.css" />

</head>
<body>
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script type="text/javascript">
	
	var phoneCk; //중복체크 했는지 확인 boolean

	$(document).ready(function() {
		
		phoneCk=false; //중복체크 했는지 확인 boolean
		var ckmblNo = ''; //중복체크후 수정이 일어났는데 다시 중복체크 안할시 쓸거임
		
		var now_utc = Date.now();
		var timeOff = new Date().getTimezoneOffset()*60000;
		var today = new Date(now_utc-timeOff).toISOString().split("T")[0];
		
		document.getElementById("BRDY_DT").setAttribute("max", today); //미래 날짜 막음
		
		$("input.blank_key").keyup(function(event){                  // 매장조건 입력란에서 키보드를 입력할 때
			if(event.keyCode == 8 || event.keyCode == 46) {          // 백스페이스(8) 또는 Delete(46)키를 입력했을 경우
	            if( $("input#PRT_NM").val() == "" ) {            // 매장검색란의 내용이 아무것도 없다면
	               $("input#PRT_CD").val("");                  // 매장코드를 비운다
	            } 
	         }
	      });
		
		
		//휴대폰번호 3자리입력시 input 포커스 이동
		$('#mblF').on('keyup', function() {     
			if(this.value.length == 3) {        
				$('#mblS').focus();      
			}
		});
		$('#mblS').on('keyup', function() {     
			if(this.value.length == 4) {        
				$('#mblT').focus();      
			}
		});
		
		
		
		var CUST_NM = document.getElementById('CUST_NM'); //고객명
		var POC_CD = document.getElementById('POC_CD'); //직업코드
		
		var BRDY_DT = document.getElementById('BRDY_DT'); //생년월일
		var mblF = document.getElementById('mblF'); //휴대폰-앞자리
		var mblS = document.getElementById('mblS'); //휴대폰-중간자리
		var mblT = document.getElementById('mblT'); //휴대폰-뒷자리
		
		var emailF = document.getElementById('emailF'); //이메일 앞자리
		var emailL = document.getElementById('emailL'); //이메일 뒷자리
		
		var ADDR = document.getElementById('ADDR'); //주소
		var ADDR_DTL = document.getElementById('ADDR_DTL'); //상세주소
		
		var PRT_CD = document.getElementById('PRT_CD'); //매장코드
		var PRT_NM = document.getElementById('PRT_NM') //매장명
		

		
		$("input:radio[name='SEX_CD']:radio[value='F']").prop('checked', true); // 성별선택하기
		
		
// 		var innerText = document.getElementById(elementId).innerText;
		
		$("input:radio[name='PSMT_GRC_CD']:radio[value='H']").prop('checked', true); // 자택선택하기
		
		
		const userRegisterInput = document.querySelector("#submitBtn");
		
		
	}); //(document).ready

	//#######################최종 매장검색
	function maPrtMtSearchPopUp() {
		var prtNmP = $("#PRT_NM").val(); // 매장명or매장코드가 들어올거임
		
		var url = "/admin/shopSearch";

		$.ajax({
			url : url + "?PRT_NM=" + prtNmP,
			type : "get",
			success : function(res) { //  결과가 0, 1, 2개
				if (res.length == 1) {
					$("#PRT_NM").val(res[0].prt_NM); //0번째 배열의 매장명 
					$("#PRT_CD").val(res[0].prt_CD);
				} else if (res.length == 0) { // 매장명or매장코드 값모두 불일치 ->팝업창열림
					alert("일치하는 매장이 없습니다.");
					maPartSearchPop(prtNmP); // 매장코드+매장명 팝업창 호출
				} else { // ex) 2개이상일치 ->강남점, 서초강남점 뿌림
					maPartSearchPop(prtNmP); // 매장코드+매장명 팝업창 호출
				}
			}
		});
	}

	//매장검색 팝업창 호출
	function maPartSearchPop(prtNmP) {

		$("input#prtNmP").val(prtNmP); // input(hidden)에 넣어준다.

		window.name = "maPartSearchPop"; //부모창 이름
		openWin = window.open('maPrtMtSearchPop', 'ch_child',
						'width=500,height=500,scrollbars=yes,top=100,left=30,resizable=yes');

	}

	//매장검색에서 엔터키를 눌렀을때
	function maPrtMtEnterkey() {
		
		var prtNmP = $("#PRT_NM").val(); // 매장명or매장코드가 들어올거임
		
		if (window.event.keyCode == 13) {
			if (prtNmP == "" && prtNmP < 1) {
				alert("검색값을 입력하세요");
			} else if (prtNmP.length < 2) {
				alert("두자리 이상 입력 필수");
			} else {
				maPrtMtSearchPopUp();
			}
		}
	}
	

	
	//휴대폰번호 중복 클릭시
	function phoneAvail(){
		
		var regExp = /[ \{\}\[\]\/?.,;:|\)*~`!^\-_+┼<>@\#$%&\'\"\\\(\=]/gi; 
		mblNo = mblF.value + mblS.value + mblT.value; //휴대폰 앞자리+중간자리+뒷자리
		
		//isNaN = 숫자일경우 false, 아닐경우 true
		if(isNaN(mblNo) || regExp.test(mblNo)){
			alert("휴대폰번호에 문자를 넣을수 없습니다");
			return false;
		}
		
		//휴대폰번호 공백체크
		if(mblF.value=='' || mblF.value==null){
			alert("휴대폰 번호를 입력하세요");
			return false;
		}else if(mblS.value=='' || mblS.value==null){
			alert("휴대폰 번호를 입력하세요");
			return false;			
		}else if(mblT.value==''||mblT.value==null){
			alert("휴대폰 번호를 입력하세요");
			return false;			
		}else if(mblNo.length>11){
			alert("11자리 이하로 입력하세요");
			return false;			
		}
		
		
		if(mblNo=='0000000000'){
			alert('000-000-0000 은 사용할수 없는 핸드폰 번호입니다.');
			$('#mblF').val('');
			$('#mblS').val('');
			$('#mblT').val('');
			$('#mblF').focus();
		}else if(mblNo=='00000000000'){
			alert('000-0000-0000 은 사용할수 없는 핸드폰 번호입니다.');
			$('#mblF').val('');
			$('#mblS').val('');
			$('#mblT').val('');
			$('#mblF').focus();
		}else{
			var url = "/admin/phoneOverlap";
			
				$.ajax({
					url: url,
					type : 'post',
					data : {
								mblNo : mblNo
							},
					success:function(res){
						
						if(res.length==0){
							phoneCk = true; //휴대폰 중복체크 검사
							
							ckmblNo = mblNo; //중복체크후 수정이 일어났는데 다시 중복체크 안할시 쓸거임
							document.getElementById("MBL_NO").value = ckmblNo;
							alert("사용가능한 번호 입니다.");
							
						}else{
							alert("사용중인 핸드폰번호입니다.");
							$('#mblF').val('');
							$('#mblS').val('');
							$('#mblT').val('');
							$('#mblF').focus();
						}
					},
					error:function(res){
						consolo.log("오류");
					}
				});
		}
	}
	
	
	function closeBtn(){
		window.close();
	}
	

	
	
	//등록 눌렀을때
	function userRegistCheck(){
		
// 		e.preventDefault();
		
		//고객명 공백체크
		if(CUST_NM.value.trim() == '' || CUST_NM.value == null){
			alert("고객명을 입력하세요");
			return false;
		}
		
		//직업코드 공백체크
		if(!POC_CD.value){
			alert("직업코드를 선택해주세요.");
			return false;
		}
		
		//생년월일 공백체크
		if(BRDY_DT.value =='' || BRDY_DT.value==null){
			alert("생년월일을 선택하세요.");
			return false;
		}
		
		var currMblNo = mblF.value + mblS.value + mblT.value; //현재들어있는 값

		//휴대폰번호 공백체크
		if(mblF.value=='' || mblF.value==null){
			alert("휴대폰 번호를 입력하세요");
			return false;
		}else if(mblS.value=='' || mblS.value==null){
			alert("휴대폰 번호를 입력하세요");
			return false;			
		}else if(mblT.value==''||mblT.value==null){
			alert("휴대폰 번호를 입력하세요");
			return false;			
		}else if(currMblNo.length>11){
			alert("11자리 이하로 입력하세요");
			return false;			
		}else if(!phoneCk){
			alert("중복체크 필수");
			return false;
		}
		
		
		
		//휴대폰번호 재중복체크 여부 검사
		if(ckmblNo!=currMblNo){
			console.log(currMblNo+"현재값");
			console.log(ckmblNo+"중복체크후 값");
			
			alert("휴대폰번호 중복체크 필수");
			phoneCk = false;
			return false;
		}
		
		//이메일 유효성
		var regEmail = /^([0-9a-zA-Z_\.-]+)@([0-9a-zA-Z_-]+)(\.[0-9a-zA-Z_-]+){1,2}$/;
		
		var EMAIL = emailF.value + '@' + emailL.value;
		
		if(emailF.value=='' || emailF.value==null){
			alert("이메일을 입력하세요");
			return false;
		}else if(emailL.value=='' || emailL.value==null){
			alert("이메일을 입력하세요.");
			return false;
		}else if(!regEmail.test(EMAIL)){
			alert("이메일이 유효하지 않습니다.");
			return false;
		}
		
		document.getElementById("EMAIL").value = EMAIL;

		
		
		//주소  ADDR ADDR_DTL
		if(ADDR.value!='' && ADDR_DTL.value==''){
			alert("상세주소를 입력해주세요.");
			return false;
		}else if(ADDR.value.trim()=='' && ADDR_DTL.value!=''){
			alert("주소를 제대로 입력해주세요.");
			return false;
		}
		
		//매장이 공백일때 
		if(PRT_CD.value.trim()=='' || PRT_NM.value.trim()==''){
			alert("매장을 선택해주세요.");
			return false
		}
		
		
        if (confirm("신규고객으로 등록하시겠습니까?")) {
        	$.ajax({
        		url: "/admin/userRegister",
        		type: "post",
        		data: $("#userRegisterForm").serialize(),
        		success:function(res){
        			alert("신규고객이 등록되었습니다.");
        			window.close();
        		},
        		error:function(res){
        			
        		}
        	});

        } else {
        	return false;
        }
		
		
	}
	


</script>
<c:set var="pocCd" value="${codes['POC_CD']}"/> 			<!-- 직업상태 -->
<c:set var="genders" value="${codes['SEX_CD']}"/> 			<!-- 성별 -->
<c:set var="scalYN" value="${codes['SCAL_YN']}"/> 			<!-- 양음력구분 -->
<c:set var="psmtGrcCd" value="${codes['PSMT_GRC_CD']}"/>	<!-- 우편물수령 -->
															
<c:set var="emailYN" value="${codes['EMAIL_RCV_YN']}"/> 	<!-- 이메일수신동의여부 -->
<c:set var="smsYN" value="${codes['SMS_RCV_YN']}"/> 		<!-- SMS수신동의여부 -->
<c:set var="dmYN" value="${codes['DM_RCV_YN']}"/> 			<!-- DM수신동의여부 -->


<div class="admin_memberList">
   <div class="center">
   <div class="memberList_logo">
      <h4>신규고객등록</h4>
   </div>
   
   <div>
<!--       <form id="userRegisterForm" action="/admin/userRegister" method="post" onsubmit="return false;"> -->
<!--       <form id="userRegisterForm" action="/admin/userRegister" method="post" onsubmit="return userRegistCheck();"> -->
      <form id="userRegisterForm" action="/admin/userRegister" method="post" >
		<!-- 매장코드or매장명 입력값 넣어줌- 팝업창으로 던질거 -->
		<input type="hidden" id="prtNmP" name="prtNmP" value=""/>
		
		<!-- 최초등록자 -->
		<input type="hidden" id="FST_USER_ID" name="FST_USER_ID" value="${cn.USER_ID}"/>
		<!-- 최종수정자 -->
		<input type="hidden" id="LST_UPD_ID" name="LST_UPD_ID" value="${cn.USER_ID}"/>
		<!-- 휴대폰 -->
		<input type="hidden" id="MBL_NO" name="MBL_NO"/>
		<!-- 이메일 -->      
		<input type="hidden" id="EMAIL" name="EMAIL"/>
		
         <table class="tableON">
<!--             <tbody class="custTbody"> -->
            <tr>
            	<td class="tableTitle" colspan="6">회원 기본 정보 </td>
            </tr>
               <tr>
                  <td class="custT"><i>*</i>고객명</td>
                  <td class="custD">
                     <input type="text" class="textVal" id="CUST_NM" name="CUST_NM" value=""/>
                  </td>
   				
   				  <td class="custT"><i>*</i>직업코드</td>
                  <td class="custD">
                     <select id="POC_CD" name="POC_CD" class="textVal">
	                      <option class="textVal" id="" value="" >직업선택</option>
                     	<c:forEach var="code" items="${pocCd}">
	                        <option class="textVal" value="${code.DTL_CD}">${code.DTL_CD_NM}</option>
                     	</c:forEach>
                     </select>
                  </td>
               </tr>
               <tr>
               
                  <td class="custT"><i>*</i>생년월일</td>
                  <td class="custD">
                     <input type="date" class="textVal" id="BRDY_DT" name="BRDY_DT" value=""/>
                  </td>
 
                   <td class="custT"><i>*</i>성별</td>
                  
                  <td class="custD">
	                  <c:forEach var="gender" items="${genders}">
	                   	<input type="radio" id="${gender.CODE_CD}" name="${gender.CODE_CD}" value="${gender.DTL_CD}" /><c:out value="${gender.DTL_CD_NM}"/>
	                  </c:forEach>
                  </td>                 
                  
               </tr>
               <tr>
               
                  <td class="custT"><i>*</i>휴대폰번호</td>
                  <td class="custD">
                     <input type="text" class="textPhone" id="mblF" name="mblF" value="" maxlength="3"/>
                     <input type="text" class="textPhone" id="mblS" name="mblS" value="" maxlength="4"/>
                     <input type="text" class="textPhone" id="mblT" name="mblT" value="" maxlength="4"/>
                     <input type="button" class="PhoneBtn" value="중복" onclick="phoneAvail()"/>
                  </td>
                  <td class="custT"><i>*</i>생일</td>
                  <td class="custD">
	            	    <c:forEach var="code" items="${scalYN}">
               				<input type="radio" id="${code.CODE_CD}" name="${code.CODE_CD}" value="${code.DTL_CD}" checked="checked"/><c:out value="${code.DTL_CD_NM}"/>
               			</c:forEach>
                  </td>                  
                  
                  
                  
               </tr>
               
               <tr>
               		<td class="custT"><i>*</i>우편물수령</td>
               		<td class="custD">
               			<c:forEach var="code" items="${psmtGrcCd}">
               				<input type="radio" id="${code.CODE_CD}" name="${code.CODE_CD}" value="${code.DTL_CD}" checked="checked"/><c:out value="${code.DTL_CD_NM}"/>
               			</c:forEach>
                  	</td>
<!--                     	<input type="radio" id="a" name="PSMT_GRC_CD" value="" checked="checked"/>자택 -->
<!--                      	<input type="radio" id="a" name="PSMT_GRC_CD" value=""/>직장 -->
               		<td class="custT"><i>*</i>이메일</td>
                  	<td class="custD">
                  		<input type="text" class="textEmail" id="emailF" name="emailF"/>@
                  		<input type="text" class="textEmail" id="emailL" name="emailL"/>
                  	</td>
               </tr>
               
               
               
               <tr>
               		<td class="custT" >주소</td>
               		<td class="custD" colspan="3">
	               		<input type="text" class="addrAA" id="ZIP_CD" name="ZIP_CD" value="" readonly="readonly"/>
	               		<input type="text" class="addrBB" id="ADDR" name="ADDR" placeholder="주소"/>
	               		<input type="text" class="addrCC" id="ADDR_DTL" name="ADDR_DTL" placeholder="상세주소"/>
               		</td>
               		<td></td>
               		<td></td>
               </tr>
               
               <tr>
               		<td class="custT">결혼기념일</td>
                  	<td class="custD"><input type="date" class="textVal" id="MRRG_DT" name="MRRG_DT" /></td>
                  
					<td class="custT"><i>*</i>매장</td>
					<td class="custD">
						<input type="text" class="mrtText" id="PRT_CD" name="JN_PRT_CD" value="${cn.PRT_CD}" readonly="readonly"/>
						<input type="button" value="팝업검색" onclick="maPrtMtSearchPopUp();"/>
						<input type="text" class="blank_key" id="PRT_NM" name="PRT_NM" value="${cn.PRT_NM}" onkeyup="maPrtMtEnterkey()" readonly="readonly"/>
					</td>
                  
               </tr>
       </table>
	     <table class="tableF">
	            <tr>
	            	<td class="tableTitle">수신동의</td>
	            </tr>
	            <tr>

	            	<td class="custT"><i>*</i>이메일수신동의</td>
	            	<td class="custD">
	            	    <c:forEach var="code" items="${emailYN}">
               				<input type="radio" id="${code.CODE_CD}" name="${code.CODE_CD}" value="${code.DTL_CD}" checked="checked"/><c:out value="${code.DTL_CD_NM}"/>
               			</c:forEach>
	            	</td>
	            	
	            	<td class="custT"><i>*</i>SMS수신동의</td>
	            	<td class="custD">
	            	    <c:forEach var="code" items="${smsYN}">
               				<input type="radio" id="${code.CODE_CD}" name="${code.CODE_CD}" value="${code.DTL_CD}" checked="checked"/><c:out value="${code.DTL_CD_NM}"/>
               			</c:forEach>
	            	</td>
	            	
	            </tr>
	            
	            <tr>
	            	<td></td>
	            	<td></td>
	            	<td class="custT" rowspan="2"><i>*</i>DM수신동의</td>
	            	<td class="custD">
	            	    <c:forEach var="code" items="${dmYN}">
               				<input type="radio" id="${code.CODE_CD}" name="${code.CODE_CD}" value="${code.DTL_CD}" checked="checked"/><c:out value="${code.DTL_CD_NM}"/>
               			</c:forEach>
	            	</td>	            
	            </tr>
	        </table>
<!--             </tbody> -->
		<table>
			<tr class="laBtn">
				<td><input class="cloBtn" type="button"  value="닫기" onclick="closeBtn();"/></td>				
<!-- 				<td><input class="cloBtn" type="submit" value="등록" onclick="userRegistCheck(e);"/></td>				 -->
					<td><button class="cloBtn" type="button" id="register" onclick="userRegistCheck()">등록</button></td>
					
					
			</tr>
		</table>
         
      
      </form>
   </div>
   
   
   </div> <!-- .center end -->
</div>      
      
</body>
</html>