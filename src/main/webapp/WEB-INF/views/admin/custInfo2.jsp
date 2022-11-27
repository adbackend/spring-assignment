<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    
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
<%@include file="../includes/header.jsp" %>
<%@include file="../includes/nav.jsp" %>
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<c:set var="genders" value="${codes['SEX_CD']}"/>          <!-- 성별 -->
<c:set var="scalYN" value="${codes['SCAL_YN']}"/>          <!-- 양음력구분 -->
<c:set var="pocCd" value="${codes['POC_CD']}"/>          <!-- 직업상태 -->

<c:set var="psmtGrcCd" value="${codes['PSMT_GRC_CD']}"/>   <!-- 우편물수령 -->
<c:set var="custSsCd" value="${codes['CUST_SS_CD']}"/>   <!-- 고객상태코드 -->
                                             
<c:set var="emailYN" value="${codes['EMAIL_RCV_YN']}"/>    <!-- 이메일수신동의여부 -->
<c:set var="smsYN" value="${codes['SMS_RCV_YN']}"/>       <!-- SMS수신동의여부 -->
<c:set var="dmYN" value="${codes['DM_RCV_YN']}"/>          <!-- DM수신동의여부 -->
<script type="text/javascript">
   
   var phoneCk; //중복체크 했는지 확인 boolean
//    var MBL_NO; //기존번호
   var CUST_NO_A;
   var MBL_NO_A; //기존휴대폰
   var CNCL_DT_A;//기존해지
   var searchFlag = false; // 검색버튼을 확인하는 플래그
   
   
   
   
   var rePhone = false;  //폰중복!
   $(document).ready(function(){
      
      
      //사용자 구분코드 1.회사 2.특약점
      var USER_DT_CD = $("#USER_DT_CD").val(); //사용자 구분코드
      if(USER_DT_CD=='1'){
         $('#btn_update').hide();
      }
      
      custInfoSearch();
         
         
//          historyData = [];
//       count = -1;
         phoneCk=false; //중복체크 했는지 확인 boolean
         var ckmblNo = ''; //중복체크후 수정이 일어났는데 다시 중복체크 안할시 쓸거임
      
         
         CUST_NO_A= document.getElementById('CUST_NO_A').value;
         MBL_NO_A = document.getElementById('MBL_NO_A').value; //기존번호
         
         document.getElementById("BRDY_DT").setAttribute("max", today); //미래 날짜 막음
         
//          var hiddenval = $('#MBL_NO_A').val();
//          alert(hiddenval);
//        alert($("#MBL_NO_A").val()+'기존');

//          alert(MBL_NO_A+'기존번호..');
         
         MBL_NO = document.getElementById('MBL_NO').value; 
         
         
         var EMAIL = document.getElementById('EMAIL').value; 
         sliceMblNo(MBL_NO, "0");
      
         var splitEmail = EMAIL.split('@');
      
      document.getElementById("emailF").value = splitEmail[0];
      document.getElementById("emailL").value = splitEmail[1];
      
      var custNoSearch = document.getElementById("CUST_NO"); //검색칸에.실시간.고객번호
      var custNameSearch = document.getElementById("CUST_NM"); //검색칸에.실시간.고객명
      
      
      var CUST_NM_REAL = document.getElementById('CUST_NM_REAL'); //검색칸 아래정보에 고객명
      
      var originSscd = document.getElementById('originSscd'); //본래의 고객상태코드
      
      var BRDY_DT = document.getElementById('BRDY_DT'); //생년월일

      var POC_CD = document.getElementById('POC_CD'); //직업코드
      
      var mblF = document.getElementById('mblF'); //휴대폰-앞자리.실시간
      var mblS = document.getElementById('mblS'); //휴대폰-중간자리
      var mblT = document.getElementById('mblT'); //휴대폰-뒷자리
      
      var curMbl = mblF.value + mblS.value + mblT.value;
      
      document.getElementById("MBL_NO").value=curMbl;
      
      var CUST_NO2 = document.getElementById("CUST_NO").value;
      
      document.getElementById("CUST_NO2").value =custNoSearch.value;
      
      var emailF = document.getElementById('emailF'); //이메일 앞자리
      var emailL = document.getElementById('emailL'); //이메일 뒷자리
      
      
      var EMAIL2 = emailF.value + '@' + emailL.value;
      document.getElementById("EMAIL").value=EMAIL2;
      
      
      var ADDR = document.getElementById('ADDR'); //주소
      var ADDR_DTL = document.getElementById('ADDR_DTL'); //상세주소
      
      var PRT_CD = document.getElementById('PRT_CD'); //매장코드
      var PRT_NM = document.getElementById('PRT_NM'); //매장명
      
      var CNCL_CNTS = document.getElementById('CNCL_CNTS');//해지사유
      
      var sessionId = document.getElementById('LST_UPD_ID'); //관리자 아이디
      var sessionName = document.getElementById('USER_NM'); //관리자 이름
      
//       var CUST_NM_A = document.getElementById('CUST_NM_A'); //고객이름
//       var BRDY_DT_A = document.getElementById('BRDY_DT_A'); //고객이름
      
      
      
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
      var ssCdValue = originSscd.value; //기존 값
//          console.log(ssCdValue+'...기존 고객상태 10이면 정상');
         
         var today = new Date();

         var year = today.getFullYear();
         var month = ('0' + (today.getMonth() + 1)).slice(-2);
         var day = ('0' + today.getDate()).slice(-2);
         var dateString = year + '-' + month  + '-' + day;
         
//          alert(dateString);
//          var CUST_NM_A = $("#CUST_NM_A").val();


         if(originSscd.value == '10' || originSscd.value == '80'){
             $("#CNCL_CNTS").attr("readonly",true).attr("disabled",false); //입력불가
         }
         
         
         $(".leave").change(function(){
            
//             alert($(this).val());
//             alert(dateString);
            console.log($(this).val()+' 실시간');
            console.log(originSscd.value);
            
            if(originSscd.value == '10' && $(this).val() == '90'){ //원본값이.정상일때 해지불가
               alert("정상에서 해지불가!");
               $(this).prop('checked', false); //체크해제
               $("input:radio[name='CUST_SS_CD']:radio[value='"+ssCdValue+"']").prop('checked', true); //이전 라디오버튼 체크
                $("input:text[name=CNCL_CNTS]").attr("readonly",true);  //해지사유비활성화
            }else if(originSscd.value == '10' && $(this).val() == '80'){ //원본값이. 정상일때 중지로..->중지일자
               $('#STP_DT').val(dateString);
            }else{
               $('#STP_DT').val('');
            }

            
            
            if(ssCdValue=='90' && $(this).val() == '10'){ //원본값이.해지일때 정상으로 가면
//                $(this).prop('checked', false); //체크해제
//                $("input:radio[name='CUST_SS_CD']:radio[value='"+ssCdValue+"']").prop('checked', true); //이전 라디오버튼 체크
/*                document.getElementById("CUST_NM_REAL").value ='';
               
               document.getElementById("mblF").value ='';
               document.getElementById("mblS").value ='';
               document.getElementById("mblT").value =''; */
               
               
//                $('#mblF').val(''); //휴대폰1 ''
//                $('#mblS').val(''); //휴대폰2 ''
//                $('#mblT').val(''); //휴대폰3 ''
               
                $('#CUST_NM_REAL').val(''); //고객명 ''
               $('#mblF').val(' '); //휴대폰1 ''
                $('#mblS').val(' '); //휴대폰2 ''
                $('#mblT').val(' '); //휴대폰3 ''
               $('#JS_DT').val(dateString); //가입일자
            }else if(ssCdValue=='90' && $(this).val() == '80'){ //원본값이.해지 일때 중지로 가면
               alert("해지에서 중지불가");
               $("input:radio[name='CUST_SS_CD']:radio[value='"+ssCdValue+"']").prop('checked', true); //이전 라디오버튼 체크
               $(this).prop('checked', false); //체크해제
               $('#CNCL_DT').val($('#CNCL_DT_A').val()); //기존 해지
            }
            
            
            
            if(ssCdValue=='80' && $(this).val() == '90'){ //중지에서 해지로 가면
               alert("해지사유를 입력하세요.");
                $("#CNCL_CNTS").attr("readonly",false).attr("disabled",false); //입력불가

               $('#CUST_NM_REAL').val('해지고객');
               $('#mblF').val('000');
               $('#mblS').val('0000');
               $('#mblT').val('0000');
               $('#CNCL_DT').val(dateString); //해지일자
               $('#STP_DT').val($('#STP_DT_A').val()); //기존 중지 넣어주기
               ('$CNCL_CNTS').focus();
            }else if(ssCdValue=='80' && $(this).val() == '10'){ //중지에서 정상
               $('#CUST_NM_REAL').val(CUST_NM_A.value);
               $('#mblF').val($('#mblF_A').val()); //원본.번호넣어야됨
               $('#mblS').val($('#mblS_A').val());
               $('#mblT').val($('#mblT_A').val());
               $('#STP_DT').val(''); //원본.중지일자 비우기
               $('#CNCL_DT').val(''); //해지일자
               $('#CNCL_CNTS').val(''); //해지사유 ''
            }else{
               $('#CUST_NM_REAL').val(CUST_NM_A.value);
               $('#mblF').val($('#mblF_A').val()); //원본.번호넣어야됨
               $('#mblS').val($('#mblS_A').val());
               $('#mblT').val($('#mblT_A').val());
               $('#STP_DT').val($('#STP_DT_A').val()); //기존 중지 넣어주기
               $('#CNCL_DT').val(''); //해지일자
            }
            
         });
      
      

      
//           var AssCdValue = originSscd.value; //기존 값
//           console.log(AssCdValue+'... 10 :정상, 80:중지, 90:해지');
//           var liveSscdTarget = event.target.value; //실시간
//           console.log(liveSscdTarget+'...클릭시 타켓.실시간');
         
         
//          if(AssCdValue=='10' ){ //기존값이 정상 10이면 해지불가
//             $("input:radio[id=CUST_SS_CD90]").attr("disabled", true); //비활성화
//             $("input:text[name=CNCL_CNTS]").attr("readonly",true);  //비활성화
//          }else if(AssCdValue=='90'){ //기존값이 해지면 중지불가
//             $("input:radio[id=CUST_SS_CD80]").attr("disabled", true); //비활성화

//          }
      
      
//       var searChageNo = document.getElementById("#CUST_NO_A").value; //고객번호
//       var searChageNm = document.getElementById("#CUST_NM_A").value; //고객명
       
      
      $("#custInfoSearch").on("click", function(){
    	  
         aa();
          mblF = document.getElementById('mblF'); //휴대폰-앞자리.실시간
          mblS = document.getElementById('mblS'); //휴대폰-중간자리
          mblT = document.getElementById('mblT'); //휴대폰-뒷자리
          curMbl = mblF.value + mblS.value + mblT.value;
          $("#MBL_NO").val(curMbl);
//           alert($("#MBL_NO").val());
         
          emailF = document.getElementById('emailF'); //이메일 앞자리
          emailL = document.getElementById('emailL'); //이메일 뒷자리
          EMAIL2 = emailF.value + '@' + emailL.value;
          $("#EMAIL").val(EMAIL2);
         
         searchFlag = true;
         count = history();
         
         if(count != -1){  
            if(confirm("수정이력이 존재합니다. 그래도 조회하시겠습니까?")){
               
               historyData = [];
               count = -1;
               custInfoSearch();
               
            }
            
         }else{
            historyData = [];
            count = -1;
             custInfoSearch();
         }
         
      });
      
      
      //적용눌렀을때 
      $("#btn_update").on("click", function(){
         
         //유효성 체크
         if(validationChk()) {
            return false;
         }
         
         //파라미터 생성 시작
         var bf_data = $().시리얼라이즈어레이();
         var af_data = $().시리얼라이즈어레이();
         
         //UPDATE DATA 생성
         var map = arrayToObj(af_data);
         //INSERT DATA 생성
         var list = histDataCrt(bf_data, af_data);
         
         var data = {
            "map" : map
            ,"list" : list
         };
         var url = '';
         var sucFunc = '';
         
         //ajax 처리
         callAjax(url, data, sucFunc);
         
         
         
         
         mblF = document.getElementById('mblF'); //휴대폰-앞자리.실시간
         mblS = document.getElementById('mblS'); //휴대폰-중간자리
         mblT = document.getElementById('mblT'); //휴대폰-뒷자리
         curMbl = mblF.value + mblS.value + mblT.value;
         $("#MBL_NO").val(curMbl);
//          alert($("#MBL_NO").val());
         
         emailF = document.getElementById('emailF'); //이메일 앞자리
         emailL = document.getElementById('emailL'); //이메일 뒷자리
         EMAIL2 = emailF.value + '@' + emailL.value;
         $("#EMAIL").val(EMAIL2);
//          alert($("#EMAIL").val());
         
         
         custInfoCheck();
         if(count != -1){
            historyData = [];
            count = -1;
         }
      });
    
   }); //(document).ready
   
   
   //고객상태코드
//    function sscdValueGet(event){
      
//       var AssCdValue = originSscd.value; //기존 값
//       console.log(AssCdValue+'... 10 :정상, 80:중지, 90:해지');
//       var liveSscdTarget = event.target.value; //실시간
//       console.log(liveSscdTarget+'...클릭시 타켓.실시간');
      
      
//       if(AssCdValue=='10' ){  //기존값이10 정상일때
//          if(liveSscdTarget=='90'){
//             alert("정상에서 해지불가");
//          $("input:radio[id=CUST_SS_CD90]").attr("disabled", true); //활성화
//          $("input:text[name=CNCL_CNTS]").attr("readonly",true);
//          }
         
         
//       }
//    }
   


   //휴대폰번호 앞자리,중간자리, 뒷자리 자르는 함수
   function sliceMblNo(MBL_NO, TYPE){
      
      // 0101231234
      if(MBL_NO.length==10 && TYPE =="0"){ //휴대폰이 10자리이면
         var mblF = MBL_NO.substring(0,3);//앞자리
         var mblS = MBL_NO.substring(3,6); //중간자리
         var mblT = MBL_NO.substring(6,10); //뒷자리
         
         document.getElementById("mblF").value = mblF;
         document.getElementById("mblS").value = mblS;
         document.getElementById("mblT").value = mblT;
      
      //010 1234 1234
      } else if(MBL_NO.length==11 && TYPE =="0"){ //휴대폰이 11자리이면
         var mblF = MBL_NO.substring(0,3);//앞자리
         var mblS = MBL_NO.substring(3,7); //중간자리
         var mblT = MBL_NO.substring(7,11); //뒷자리

         document.getElementById("mblF").value = mblF;
         document.getElementById("mblS").value = mblS;
         document.getElementById("mblT").value = mblT;
      } else if(MBL_NO.length==10 && TYPE =="1"){ //휴대폰이 10자리이면
         var mblF = MBL_NO.substring(0,3);//앞자리
         var mblS = MBL_NO.substring(3,6); //중간자리
         var mblT = MBL_NO.substring(6,10); //뒷자리
         
         document.getElementById("mblF_A").value = mblF;
         document.getElementById("mblS_A").value = mblS;
         document.getElementById("mblT_A").value = mblT;
      
      //010 1234 1234
      }else if(MBL_NO.length==11 && TYPE =="1"){ //휴대폰이 11자리이면
         var mblF = MBL_NO.substring(0,3);//앞자리
         var mblS = MBL_NO.substring(3,7); //중간자리
         var mblT = MBL_NO.substring(7,11); //뒷자리

         document.getElementById("mblF_A").value = mblF;
         document.getElementById("mblS_A").value = mblS;
         document.getElementById("mblT_A").value = mblT;
      }
   }
   
   
   var custNoSearch ;
   
   //고객정보 검색시
   function custInfoSearch(){
      
//       var chCustAll = history();
//       console.log(chCustAll+'33히스토리 받아오는값');  //변경한 이력이없으면 -1, 있으면 0,1,2 ....
      
//       if(chCustAll > -1){
//          if(confirm("변경한 이력이 있습니다. 그래도 검색한 고객을 조회하시겠습니까?")){
            

            custNoSearch = document.getElementById("CUST_NO").value; //검색칸에.실시간.고객번호
            var custNameSearch = document.getElementById("CUST_NM").value; //검색칸에.실시간.고객명
      
               $.ajax({
                  url : "/admin/searchCustInfo",
                  type: "post",
                  data: {"CUST_NO":custNoSearch},
                  success:function(res){
                     console.log("하하하....");
                     console.log(res);
                     
                     document.getElementById("CUST_NM_REAL").value=res.cust_NM; //고객명ㅇ
                     document.getElementById("BRDY_DT").value=res.brdy_DT; //생년월일ㅇ
                      $("input:radio[name='SEX_CD']:radio[value='"+res.sex_CD+"']").prop('checked', true);   // 성별
                      
                     $("input:radio[name='SCAL_YN']:radio[value='"+res.scal_YN+"']").prop('checked', true);   // 생일
                     document.getElementById("MRRG_DT").value=res.mrrg_DT; //결혼기념일ㅇ
                     $('#POC_CD').val(res.poc_CD).prop("selected",true); //직업코드
         
                     sliceMblNo(res.mbl_NO, "0"); //휴대폰번호
                      // document.getElementsByName("JN_PRT_CD").value=res.jn_PRT_CD; //매장코드
                      $('input[name="JN_PRT_CD"]').val(res.jn_PRT_CD);
                      document.getElementById("PRT_NM").value=res.prt_NM; //매장명
         
                      $("input:radio[name='PSMT_GRC_CD']:radio[value='"+res.psmt_GRC_CD+"']").prop('checked', true);   //우편물수령
                      
                      //너
                      document.getElementById("EMAIL").value=res.email; //이메일
                      
                      var splitEmail = res.email.split('@');
                      
                      document.getElementById("emailF").value = splitEmail[0];
                      document.getElementById("emailL").value = splitEmail[1];
                      
                      
                      
                      document.getElementById("ZIP_CD").value=res.zip_CD; //우편번호
                      document.getElementById("ADDR").value=res.addr; //주소
                      document.getElementById("ADDR_DTL").value=res.addr_DTL; //상세주소
                      
                      $("input:radio[name='CUST_SS_CD']:radio[value='"+res.cust_SS_CD+"']").prop('checked', true);  //고객상태
                      document.getElementById("FST_JS_DT").value=res.fst_JS_DT; //최초가입일자
                      document.getElementById("JS_DT").value=res.js_DT; //가입일자
                      
                      document.getElementById("CNCL_CNTS").value=res.cncl_CNTS; //해지사유
                      document.getElementById("STP_DT").value=res.stp_DT; //중지일자
                      document.getElementById("CNCL_DT").value=res.cncl_DT; //해지일자
                      
                      document.getElementById("TOT_SAL_AMT").value=res.tot_SAL_AMT; //총구매금액
                      document.getElementById("TOT_SAL_MONTH").value=res.tot_SAL_MONTH; //당월구매금액
                      document.getElementById("SAL_DT").value=res.sal_DT; //최종구매일
                      
                      document.getElementById("TOT_PNT").value=res.tot_PNT; //총포인트
                      document.getElementById("RSVG_PNT").value=res.rsvg_PNT; //당월적립포인트
                      document.getElementById("US_PNT").value=res.us_PNT; //당월사용포인트   
                      
                      $("input:radio[name='EMAIL_RCV_YNN']:radio[value='"+res.email_RCV_YN+"']").prop('checked', true);  //이메일수신동의      
                      $("input:radio[name='SMS_RCV_YN']:radio[value='"+res.sms_RCV_YN+"']").prop('checked', true);  //SMS수신동의
                      $("input:radio[name='DM_RCV_YN']:radio[value='"+res.dm_RCV_YN+"']").prop('checked', true);  //DM수신동의
                      
                      // ##############################################################################################
                      document.getElementById("CUST_NO_A").value=res.cust_NO; //고객번호
                      
                     document.getElementById("CUST_NM_A").value=res.cust_NM; //고객명ㅇ
                     document.getElementById("BRDY_DT_A").value=res.brdy_DT; //생년월일ㅇ
                     document.getElementById("SEX_CD_A").value=res.sex_CD; //성별
                     
                     document.getElementById("SCAL_YN_A").value=res.scal_YN; // 양음력
                     document.getElementById("MRRG_DT_A").value=res.mrrg_DT; //결혼기념일ㅇ
                     document.getElementById("POC_CD_A").value=res.poc_CD; //직업코드
                     
                     
                     //너!
                      document.getElementById("MBL_NO_A").value=res.mbl_NO; //휴대폰
                      sliceMblNo(res.mbl_NO, "1"); //휴대폰번호
                      
                      
                      
                      document.getElementById("JN_PRT_CD_A").value=res.jn_PRT_CD; //매장코드
//                       document.getElementById("PRT_NM_A").value=res.prt_NM; //매장명
                      
         
                      document.getElementById("PSMT_GRC_CD_A").value=res.psmt_GRC_CD; //우편물수령
                      
                      document.getElementById("EMAIL_A").value=res.email; //이메일
                      
                      
                      
                      
                      document.getElementById("ZIP_CD_A").value=res.zip_CD; //우편번호
                      document.getElementById("ADDR_A").value=res.addr; //주소
                      document.getElementById("ADDR_DTL_A").value=res.addr_DTL; //상세주소
                      
                      document.getElementById("CUST_SS_CD_A").value=res.cust_SS_CD; //고객상태
                      document.getElementById("CNCL_CNTS_A").value=res.cncl_CNTS; //해지사유
                      
                      
                      document.getElementById("EMAIL_RCV_YN_A").value=res.email_RCV_YN; //이메일수신동의여부
                      document.getElementById("SMS_RCV_YN_A").value=res.sms_RCV_YN; //SMS수신동의여부
                      document.getElementById("DM_RCV_YN_A").value=res.dm_RCV_YN; //DM수신동의여부
                      document.getElementById("CNCL_DT_A").value=res.cncl_DT; //해지일자
                      
                      document.getElementById("STP_DT_A").value=res.stp_DT; //중지일자
                      
                      historyData = [];
                     count = -1;
                  },error:function(res){
                     
                  }
               });// ajax end
      
//          } // confirm if end
//       }else{  // if end
         
//          return chCustAll;
//       } 
               
   
     
   }  //function end
   
   //매장검색
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
   
   //매장검색 팝업창 호출
   function maPartSearchPop(prtNmP){
      
      $("input#prtNmP").val(prtNmP);  // input(hidden)에 넣어준다.
      
      window.name="maPartSearchPop"; //부모창 이름
      openWin = window.open('popUp/maPrtMtSearchPop','ch_child','width=500,height=500,scrollbars=yes,top=100,left=30,resizable=yes');         
      
   }
   
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
   
   
   
   
   var historyData = new Array(); //변경이력 담은 객체
   var count=-1 ;
    //변경이력
   function history(){ //-1이면 변경이력이 없음..  , 변경이력이 있으면 -1이 아니다
         
         var valCk = false; //값이 있는지 체크 
//          var count=-1 ;
         
       var updateForm = $("#custInfoForm").serializeArray();  //수정한 값
      var hiddenForm = $("#custHidden").serializeArray(); //원본 값
      var dateArray = new Date();
      console.log(updateForm);
      console.log(hiddenForm);
      
      
      
      
      
      var sessionId = document.getElementById('LST_UPD_ID'); //관리자 아이디
      var sessionName = document.getElementById('USER_NM'); //관리자 이름
      var custNo = document.getElementById('CUST_NO_A');    //고객번호
      
       for(i=0; i<updateForm.length; i++){
         var update_name = updateForm[i].name;
         var update_value = updateForm[i].value;
         
         for(j=0; j<hiddenForm.length; j++){
            
            var hidden_name = hiddenForm[j].name;
            var hidden_value = hiddenForm[j].value;
            
            if(update_name == hidden_name && update_value != hidden_value){
               valCk=true; //변경된 값이 존재하면 true
//                console.log("변경일자 시스데이트 넣을거..", new Date(););
               
//                for()
               count++;
               console.log("----------------------------");
               console.log(count+'카운트1');
               console.log("변경항목.. "+update_name);
               console.log("변경전값.. "+hidden_value);
               console.log('변경후값.. '+update_value);
               console.log('관리자아이디...'+ sessionId.value);
               console.log('관리자이름...'+ sessionName.value);
               console.log('고객번호..'+custNoSearch);
               console.log("----------------------------");
               
               historyData[count] = {
                     "CUST_NO":custNoSearch  //고객번호
                     ,"CHG_CD":update_name          //변경코드.CHG_CD
                     ,"CHG_BF_CNT": hidden_value      //변경전내용.CHG_BF_CNT
                     ,"CHG_AFT_CNT":update_value      //변경후내용.CHG_AFT_CNT
                     ,"LST_UPD_ID":sessionId.value   //최종수정자.LST_UPD_ID
               };
//                console.log(historyData[0]);
//                console.log(historyData[1]);
            }
         }
       }
      
      console.log(count+'카운트2');
      
      if(count!=-1 && searchFlag === false){ //-1이면 변경이력이 없음..  , 변경이력이 있으면 -1이 아니다
//     	  var historyData = new Array(); //변경이력 담은 객체
         $.ajax({
            url:"/admin/historyInsert",
            type:"post",
            data: JSON.stringify(historyData),
   //          traditional : true,
            contentType: "application/json",
            success:function(res){
               
               console.log('###################')
               console.log('성공 insert')
               console.log('###################')
//                alert("성공insert");
//                return count;
            },
            error: function(request, status, error){
                  alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
             }
            
         });
      }else{
         
         return count;
      }
      
      searchFlag = false;
      return count;
      
       
   }
   
   
   //적용눌렀을때
   function custInfoCheck(){


       //고객명 공백체크
      if(CUST_NM_REAL.value.trim() == '' || CUST_NM_REAL.value == null){
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

      if(currMblNo==MBL_NO){
         phoneCk=true;
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
      }else if(currMblNo.length>11){
         alert("11자리 이하로 입력하세요");
         return false;         
      }
      

      
      var currMblNo = mblF.value + mblS.value + mblT.value; //현재들어있는 값
      
      var hiddenval = $('#MBL_NO_A').val();
      
      console.log(currMblNo + "실시간.휴대폰");
      console.log(hiddenval+'원본.휴대폰1111111');
      
      
      //원본=실시간
      if(currMblNo=hiddenval){
         rePhone = true;
      }else{
         rePhone = false;
      }
      
      if(rePhone==false){
         alert("휴대폰 중복체크 필수");
      }
      
         
      //휴대폰번호 재중복체크 여부 검사
//       if(ckmblNo!=currMblNo){
//          console.log(currMblNo+"현재값");
//          console.log(ckmblNo+"중복체크후 값");
         
//          alert("휴대폰번호 중복체크 필수");
//          phoneCk = false;
//          return false;
//       }
      
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
      if(ADDR.value.trim() !='' && ADDR_DTL.value.trim()==''){
         alert("상세주소를 입력해주세요.");
         return false;
      }else if(ADDR.value.trim()=='' && ADDR_DTL.value.trim() !=''){
         alert("주소를 제대로 입력해주세요.");
         return false;
      }
      
      //매장이 공백일때 
      if(PRT_CD.value.trim()=='' || PRT_NM.value.trim()==''){
         alert("매장을 선택해주세요.");
         return false
      }
      
      // history 에서 뽑아온 데이터들 세팅
      // key:value
//       var data = {
//             "CUST_NM": "소녀시대써니33",
//             "ADDR": "33",
//       }
      
       var historyLast = history();
         console.log(historyLast+ '...과연....변경된 값이 존재하면 true');
      console.log(historyLast+' 적용눌렀을때 히스토리 받아오는값');  //변경한 이력이없으면 -1, 있으면 0,1,2 ....
      
      
      if(historyLast==-1 ){
         alert("변경이력이 없습니다.");
         console.log("ㅇㅇㅇㅇㅇㅇㅇㅇ오냐");
         return false;
      }
      
      
//       if
      var liveSSCD = $('input[name=CUST_SS_CD]:checked').val(); //고객상태 
      
      
      if(liveSSCD=='90' && (CNCL_CNTS.value.trim()=='' || CNCL_CNTS.value==null)){
         alert("해지사유를 입력하세요");
         return false;
      }
            
         
      // 수정
      $.ajax({
         url : "/admin/custInfoUpdate",
         type: "post",
         data : $("#custInfoForm").serialize(),
         success:function(res){
            alert("수정완료");
//             backList();
            
         },
         error:function(res){
            console.log("실패");
         }
      });
      
      backList();
      
      
      
/*        var historyLast = history();
         console.log(historyLast+ '...과연....변경된 값이 존재하면 true');
      
      console.log(historyLast+' 적용눌렀을때 히스토리 받아오는값');  //변경한 이력이없으면 -1, 있으면 0,1,2 ....
      
      
      if(historyLast==-1){
         alert("변경이력이 없습니다.");
         return false;
      } */   
      
      
      // 수정
//       $.ajax({
//          url : "/admin/custInfoUpdate",
//          type: "post",
//          data : JSON.stringify(data),
//          headers: {'Content-Type': 'application/json'},
//          success:function(res){
//             alert("성공");
//          },
//          error:function(res){
//             console.log("실패");
//          }
//       });
   }
   
   
   function backList(){
      
      location.href="/admin/customerList";
   }
   
    //휴대폰번호 중복 클릭시
   function phoneAvail(){
       
       mblNo = mblF.value + mblS.value + mblT.value; //휴대폰 앞자리+중간자리+뒷자리.실시간
       
        console.log("기존번호"+MBL_NO);
       
       console.log("변경한번호"+mblNo);
      
      //isNaN = 숫자일경우 false, 아닐경우 true
      if(isNaN(mblNo)){
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
      
      var liveSSCD = $('input[name=CUST_SS_CD]:checked').val(); //고객상태 
      
      
      if(liveSSCD=!'90' && mblNo=='0000000000'){
         alert('000-000-0000 은 사용할수 없는 핸드폰 번호입니다.');
         $('#mblF').val('');
         $('#mblS').val('');
         $('#mblT').val('');
         $('#mblF').focus();
         return false;
      }else if(liveSSCD=!'90' && mblNo=='00000000000'){
         alert('000-0000-0000 은 사용할수 없는 핸드폰 번호입니다.');
         $('#mblF').val('');
         $('#mblS').val('');
         $('#mblT').val('');
         $('#mblF').focus();
         return false;
      }else if(MBL_NO==mblNo){
         alert("기존번호 입니다");
         rePhone = true;
         return true;
      }else{
         var url = "/admin/phoneOverlap";
         
            $.ajax({
               url: url,
               type : 'post',
               data : {
                        mblNo : mblNo
                     },
               success:function(res){
                  
                  if(res.length==0){  //폰번호 사용가능
//                      phoneCk = true; //휴대폰 중복체크 검사
                     
//                      ckmblNo = mblNo; //중복체크후 수정이 일어났는데 다시 중복체크 안할시 쓸거임
                     document.getElementById("MBL_NO").value = mblNo;
                      rePhone = true; 
                     alert("사용가능한 번호 입니다.");
                     
                  }else{
                     rePhone = false;
                     alert("사용중인 핸드폰번호입니다.");
                     $('#mblF').focus();
                     
                  }
               },
               error:function(res){
                  consolo.log("오류");
               }
            });
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
      <form id="custNoSearchForm" action="admin/custInfo" method="get" onSubmit="return false;">
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
                     <label>고객번호</label>
                       <input type="text" id="CUST_NO" name="CUST_NO" value="${custInfo.CUST_NO}" />
                  <input type="button" id="" value="팝업검색" onclick="SearchPopUp();" />
                  <input type="text" class="blank_key" id="CUST_NM" name="CUST_NM" value="${custInfo.CUST_NM}" onkeyup="csCustEenterkey()" placeholder=""/>
                  </td>

                  <td rowspan="2">

<!--                      <input id="custInfoSearch" class="maBtn" type="button" value="검색" onclick="custInfoSearch()" /> -->
                     <input id="custInfoSearch" class="maBtn" type="button" value="검색"  />
                  </td>
               </tr>
            </thead>
         </table>
      </form>
      
   </div>
   <div>
   
   <form id="custHidden">
        <input type="hidden" id="CUST_NO_A"         name="CUST_NOA"    value=""/><!--  고객번호-->
        <input type="hidden" id="CUST_NM_A"         name="CUST_NM"    value=""/><!-- 고객명 -->
        <input type="hidden" id="BRDY_DT_A"         name="BRDY_DT"    value=""/><!-- 생년월일 -->
        <input type="hidden" id="SEX_CD_A"        name="SEX_CD"       value=""/><!-- 성별 -->
        <input type="hidden" id="SCAL_YN_A"         name="SCAL_YN"    value=""/><!-- 양음력구분 -->
        
        <input type="hidden" id="MRRG_DT_A"         name="MRRG_DT"    value=""/><!-- 결혼기념일 -->
        <input type="hidden" id="POC_CD_A"        name="POC_CD"       value=""/><!-- 직업코드 -->
        
        <input type="hidden" id="MBL_NO_A"         name="MBL_NO"       value=""/><!-- 휴대폰 -->
        
        
        <input type="hidden" id="mblF_A"         name="mblF_A"       value=""/><!-- 휴대폰 -->
        <input type="hidden" id="mblS_A"         name="mblS_A"       value=""/><!-- 휴대폰 -->
        <input type="hidden" id="mblT_A"         name="mblT_A"       value=""/><!-- 휴대폰 -->
        
        
        
        <input type="hidden" id="PSMT_GRC_CD_A"    name="PSMT_GRC_CD" value=""/><!-- 우편물수령코드 -->
        <input type="hidden" id="EMAIL_A"        name="EMAIL"       value=""/><!-- 이메일주소 -->
        <input type="hidden" id="ZIP_CD_A"        name="ZIP_CD"       value=""/><!-- 우편번호코드 -->
        <input type="hidden" id="ADDR_A"            name="ADDR"       value=""/><!-- 주소 -->
        <input type="hidden" id="ADDR_DTL_A"         name="ADDR_DTL"    value=""/><!-- 상세주소 -->
        <input type="hidden" id="CUST_SS_CD_A"     name="CUST_SS_CD"    value=""/><!-- 고객상태코드 -->
        <input type="hidden" id="CNCL_CNTS_A"     name="CNCL_CNTS"    value=""/><!-- 해지사유내용 -->
        <input type="hidden" id="JN_PRT_CD_A"     name="JN_PRT_CD"    value=""/><!-- 가입매장코드 -->
        <input type="hidden" id="EMAIL_RCV_YN_A"     name="EMAIL_RCV_YN" value=""/><!-- 이메일수신동의여부 -->
        <input type="hidden" id="SMS_RCV_YN_A"     name="SMS_RCV_YN"  value=""/><!-- SMS수신동의여부 -->
        <input type="hidden" id="DM_RCV_YN_A"      name=DM_RCV_YN    value=""/><!-- DM수신동의여부 -->
<!--         <input type="hidden" id="PRT_NM_A"         name="PRT_NM"       value=""/>가입매장 --><!-- 필요없음 -->
        <input type="hidden" id="CNCL_DT_A"         name="CNCL_DT"    value=""/><!-- 해지일자 -->

        <input type="hidden" id="STP_DT_A"         name="STP_DT"    value=""/><!-- 중지일자 -->
        
        
        
        
        
   </form>
   
      <form id="custInfoForm"> 
        
         <!-- 매장코드or매장명 입력값 넣어줌- 팝업창으로 던질거 -->
      <input type="hidden" id="prtNmP" name="prtNmP"/>

      <input type="hidden" id="USER_DT_CD" id="USER_DT_CD" value="${cn.USER_DT_CD}"/> <!-- 사용자 -->
      <!-- <input type="hidden" id="MBL_NO2" name="MBL_NO" value=""/>
      <input type="hidden" id="EMAIL2" name="EMAIL" value=""/> -->
         <input type="hidden" id="MBL_NO" name="MBL_NO" value="${custInfo.MBL_NO}"/> <!-- 기존.전체번호 -->
          <input type="hidden" id="EMAIL" name="EMAIL" value="${custInfo.EMAIL}"/>  <!-- 기존.전체이메일 -->
      <input type="hidden" id="CUST_NO2" name="CUST_NO" value=""/>
      <input type="hidden" id="LST_UPD_ID" name="LST_UPD_ID" value="${cn.USER_ID}"/><!-- 최종수정자 -->
      <input type="hidden" id="USER_NM" name="USER_NM" value="${cn.USER_NM}"/><!-- 관리자 이름 -->
      
         <table class="tableON">
<!--             <tbody class="custTbody"> -->
            <tr>
               <td class="tableTitle" colspan="6">회원 기본 정보 </td>
            </tr>
               <tr>
                  <td class="custT"><i>*</i>고객명</td>
                  <td class="custD">
                     <input type="text" class="textVal" id="CUST_NM_REAL" name="CUST_NM" value="${custInfo.CUST_NM}"/>
                  </td>
   
                  <td class="custT"><i>*</i>생년월일</td>
                  <td class="custD">
                     <input type="date" class="textVal" id="BRDY_DT" name="BRDY_DT" value="${custInfo.BRDY_DT}"/>
                  </td>
   
                  <td class="custT"><i>*</i>성별</td>
                  <td class="custD">
                     <c:forEach var="code" items="${genders}">
                         <input type="radio" id="${code.CODE_CD}${code.DTL_CD}" name="${code.CODE_CD}" value="${code.DTL_CD}" <c:if test='${code.DTL_CD==custInfo.SEX_CD}'>checked="checked"</c:if> /><c:out value="${code.DTL_CD_NM}"/>
                     </c:forEach>                     

                  </td>
               </tr>
               <tr>
                  <td class="custT"><i>*</i>생일</td>
                  <td class="custD">
                   <c:forEach var="code" items="${scalYN}">
                        <input type="radio" id="${code.CODE_CD}${code.DTL_CD}" name="${code.CODE_CD}" value="${code.DTL_CD}" <c:if test='${code.DTL_CD==custInfo.SCAL_YN}'>checked="checked"</c:if> /><c:out value="${code.DTL_CD_NM}"/>
                      </c:forEach>
                  </td>
                  
                  <td class="custT">결혼기념일</td>
                  <td class="custD"><input type="date" class="textVal" id="MRRG_DT" name="MRRG_DT" value="${custInfo.MRRG_DT}"/></td>
                  
                  <td class="custT"><i>*</i>직업코드</td>
                  <td class="custD">
                     <select id="POC_CD" name="POC_CD" class="textVal">
                         <option class="textVal" id="" value="" >직업선택</option>
                        <c:forEach var="code" items="${pocCd}">
<%--                            <option class="textVal" value="${code.DTL_CD}" <c:if test='${code.DTL_CD==custInfo.POC_CD}'>selected="selected"</c:if>>${code.DTL_CD_NM}</option> --%>
                           <option class="textVal" value="${code.DTL_CD}" >${code.DTL_CD_NM}</option>
                        </c:forEach>
                     </select>
                  </td>
               </tr>
               <tr>
                  <td class="custT"><i>*</i>휴대폰번호</td>
                  <td class="custD" colspan="3">
                     <input type="text" class="textPhone" id="mblF" name="mblF" />
                     <input type="text" class="textPhone" id="mblS" name="mblS" />
                     <input type="text" class="textPhone" id="mblT" name="mblT" />
                     <input type="button" class="PhoneBtn" id="" name="" value="변경" onclick="phoneAvail()"/>
                  </td>
              <td class="custT"><i>*</i>가입매장</td>
              <td>
                 <input type="text" class="mrtText" id="PRT_CD" name="JN_PRT_CD"  value="${custInfo.JN_PRT_CD}" />
                 <input type="button" class="mrtF"  value="팝업검색" onclick="maPrtMtSearchPopUp();"/>
                 <input type="text" class="blank_key" id="PRT_NM" name="PRT_NM"  value="${custInfo.PRT_NM}" onkeyup="maPrtMtEnterkey()"/>
              </td>                  
                  
                  
               </tr>
               <tr>
                     <td class="custT"><i>*</i>우편물수령</td>
                     <td class="custD">
                        <c:forEach var="code" items="${psmtGrcCd}">
                           <input type="radio" id="${code.CODE_CD}${code.DTL_CD}" name="${code.CODE_CD}" value="${code.DTL_CD}" <c:if test='${code.DTL_CD==custInfo.PSMT_GRC_CD}'>checked="checked"</c:if> /><c:out value="${code.DTL_CD_NM}"/>
                        </c:forEach>
                     </td>
                     <td class="custT"><i>*</i>이메일</td>
                     <td colspan="4" class="custD">
                        <input type="text" class="textEmail" id="emailF" name="emailF"/>@
                        <input type="text" class="textEmail" id="emailL" name="emailL"/>
                     </td>
               </tr>
               <tr>
                     <td class="custT" >주소</td>
                     <td class="custD" colspan="5">
                        <input type="text" id="ZIP_CD" name="ZIP_CD" class="addrAA" value="${custInfo.ZIP_CD}" readonly="readonly"/>
                        <input type="text" id="ADDR" name="ADDR" class="addrBB" value="${custInfo.ADDR}" placeholder="주소"/>
                        <input type="text" id="ADDR_DTL" name="ADDR_DTL" class="addrCC" value="${custInfo.ADDR_DTL}" placeholder="상세주소"/>
                     </td>
               </tr>
               
               <tr>
                     <td class="custT"><i>*</i>고객상태</td>
                     <td class="custD">
                     <input type="hidden" id="originSscd" name="originSscd" value="${custInfo.CUST_SS_CD}"/>
                        <c:forEach var="code" items="${custSsCd}">
<%--                            <input type="radio" id="${code.CODE_CD}${code.DTL_CD}" name="${code.CODE_CD}" value="${code.DTL_CD}" onclick="sscdValueGet(event)" <c:if test='${code.DTL_CD==custInfo.CUST_SS_CD}'>checked="checked"</c:if> /><c:out value="${code.DTL_CD_NM}"/> --%>
                           <input type="radio" class="leave" id="${code.CODE_CD}${code.DTL_CD}" name="${code.CODE_CD}" value="${code.DTL_CD}"  <c:if test='${code.DTL_CD==custInfo.CUST_SS_CD}'>checked="checked"</c:if> /><c:out value="${code.DTL_CD_NM}"/>
                        </c:forEach>
                     </td>
                     
                     <td class="custT">최초가입일자</td>
                     <td class="custD" class="textVal">
                        <input class="textVal" type="date" id="FST_JS_DT" name="FST_JS_DT" value="${custInfo.FST_JS_DT}" readonly="readonly"/>
                     </td>

                     <td class="custT">가입일자</td>
                     <td class="custD" class="textVal">
                        <input type="date" class="textVal" id="JS_DT" name="JS_DT" value="${custInfo.JS_DT}" readonly="readonly"/>
                     </td>
    
               </tr>
               <tr>
                     <td class="custT">해지사유</td>
                     <td class="custD">
                        <input type="text" class="textVal" id="CNCL_CNTS" name="CNCL_CNTS" value="${custInfo.CNCL_CNTS}"/>
                     </td>
                     
                     <td class="custT">중지일자</td>
                     <td class="custD" class="textVal">
                        <input type="date" class="textVal" id="STP_DT" name="STP_DT" value="${custInfo.STP_DT}" readonly="readonly"/>
                     </td>

                     <td class="custT">해지일자</td>
                     <td class="custD" class="textVal">
                        <input type="date" class="textVal" id="CNCL_DT" name="CNCL_DT" value="${custInfo.CNCL_DT}" readonly="readonly"/>
                     </td>
               </tr>
       </table>
       <table class="tableTW">
               <tr>
                  <td class="tableTitle" colspan="6">구매</td>
               </tr>
               <tr>
                  <td class="custT">총구매금액</td>
                  <td class="custD"><input type="text" class="textVal" id="TOT_SAL_AMT" name="TOT_SAL_AMT" value="${custInfo.TOT_SAL_AMT}" readonly="readonly"/></td>
                  
                  <td class="custT">당월구매금액</td>
                  <td class="custD"><input type="text" class="textVal" id="TOT_SAL_MONTH" name="TOT_SAL_MONTH" value="${custInfo.TOT_SAL_MONTH}" readonly="readonly"/></td>
                  
                  <td class="custT">최종구매일</td>
                  <td class="custD"><input type="text" class="textVal" id="SAL_DT" name="SAL_DT" value="${custInfo.SAL_DT}" readonly="readonly"/></td>
               </tr>
               
               </table>  
      <table class="tableTT">
               <tr>
                  <td class="tableTitle" colspan="6">포인트</td>
               </tr>
               <tr>
                  <td class="custT">총포인트</td>
                  <td class="custD"><input type="text" class="textVal" id="TOT_PNT"  value="${custInfo.TOT_PNT}" readonly="readonly"/></td>
                  
                  <td class="custT">당월적립포인트</td>
                  <td class="custD"><input type="text" class="textVal" id="RSVG_PNT" value="${custInfo.RSVG_PNT}" readonly="readonly"/></td>
                  
                  <td class="custT">당월사용포인트</td>
                  <td class="custD"><input type="text" class="textVal" id="US_PNT" readonly="readonly"/></td>
               </tr>   
      </table>
      
        <table class="tableF">
               <tr>
                  <td class="tableTitle" colspan="6">수신동의</td>
               </tr>
               <tr>
                  <td class="custT"><i>*</i>이메일수신동의</td>
                  <td class="custD">
                        <c:forEach var="code" items="${emailYN}">
                           <input type="radio" id="${code.CODE_CD}${code.DTL_CD}" name="${code.CODE_CD}" value="${code.DTL_CD}" <c:if test='${code.DTL_CD==custInfo.EMAIL_RCV_YN}'>checked="checked"</c:if>/><c:out value="${code.DTL_CD_NM}"/>
                        </c:forEach>
                  </td>
                  
                  <td class="custT"><i>*</i>SMS수신동의</td>
                  <td class="custD">
                        <c:forEach var="code" items="${smsYN}">
                           <input type="radio" id="${code.CODE_CD}${code.DTL_CD}" name="${code.CODE_CD}" value="${code.DTL_CD}" <c:if test='${code.DTL_CD==custInfo.SMS_RCV_YN}'>checked="checked"</c:if>/><c:out value="${code.DTL_CD_NM}"/>
                        </c:forEach>
                  </td>
                  
                  <td class="custT"><i>*</i>DM수신동의</td>
                  <td class="custD">
                        <c:forEach var="code" items="${dmYN}">
                           <input type="radio" id="${code.CODE_CD}${code.DTL_CD}" name="${code.CODE_CD}" value="${code.DTL_CD}" <c:if test='${code.DTL_CD==custInfo.DM_RCV_YN}'>checked="checked"</c:if> /><c:out value="${code.DTL_CD_NM}"/>
                        </c:forEach>
                  </td>
               </tr>
           </table>
<!--             </tbody> -->
      <table>
         <tr class="laBtn">
            <td><input class="cloBtn" type="button" id="" value="닫기" onclick="backList()"/></td>            
            <td><button class="cloBtn" type="button" id="btn_update" >적용</button></td>      
<!--             <td><button class="cloBtn" type="button" id="" onclick="custInfoCheck()">적용</button></td>       -->
         </tr>
      </table>
         
      
      </form>
   </div>
   
   
   </div> <!-- .center end -->
</div>      
      
<%@include file="../includes/footer.jsp" %>
</body>
</html>