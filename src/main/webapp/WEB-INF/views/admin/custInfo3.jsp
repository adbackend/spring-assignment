<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    
<!-- /dowellPro/src/main/webapp/resources/images/search.png -->
<!DOCTYPE html>
<!-- ###2차ㅋ#############################################################
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

   var originMlbNoFlag = false; //기존번호 여부
   var phoneCheck1 = false; //첫번째 중복체크여부   
   
   var rePhone = ''; //중복체크후 저장된 번호
   
   $(document).ready(function(){
      
      var CUST_NM_REAL = document.getElementById('CUST_NM_REAL'); // 고객명
      var originalMlbNo = $("#MBL_NO_A").val(); //원본.휴대폰
      
      
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
         
         
         //원본 고객데이터
         var originalMblNo = $("#MBL_NO_A").val(); //원본.통휴대폰
         
         sliceMblNo(originalMblNo); //상세에서 들어올시 초기휴대폰번호를 잘라서 넣어준다
         
         var liveF = $("#mblF").val();
         var liveS = $("#mblS").val();
         var liveT = $("#mblT").val();
         
         //실시간 휴대폰번호를 들고와서
         //liveForm에 넣어준다
         var originalEmail = $("#EMAIL_A").val(); //통이메일
         
         var splitEmail = originalEmail.split('@');
         
         
         var today = new Date();

         var year = today.getFullYear();
         var month = ('0' + (today.getMonth() + 1)).slice(-2);
         var day = ('0' + today.getDate()).slice(-2);
         var dateString = year + '-' + month  + '-' + day;
         
         
         document.getElementById("emailF").value = splitEmail[0]; //실시간.이메일 앞자리에 넣어준다
         if(splitEmail.length == 1){
            document.getElementById("emailL").value = ''; //실시간.이메일 뒷자리에 넣어준다
         }else{
            document.getElementById("emailL").value = splitEmail[1]; //실시간.이메일 뒷자리에 넣어준다
         }
        
         var originSscd = document.getElementById("CUST_SS_CD_A"); //원본.고객상태
         
         if(originSscd.value == '10' || originSscd.value == '80'){ //원본.고객상태가 정상or중지 일때 해지사유 readonly처리
             $("#CNCL_CNTS").attr("readonly",true).attr("disabled",false); //입력불가
         }
        
         //고객상태
         //1.정상
         // 정상->중지가능  중지일자 넣기
         // 정상->해지 alert("해지불가")처리하고 라디오버튼 다시 정상으로 옮기기
         // 정상 해지사유 readOnly
         // 
         //2.중지
         //  중지->정상가능.  
         //  중지->해지시  
         //      a.해지일자update, 
         //      b.이름+번호 해지고객, 000 0000 0000처리 
         //     c.해지사유 readonly 풀기
         //  중지->해지, 해지->중지로 왔을때 
         $(".sscdLeave").change(function(){
            
            console.log($("#STP_DT_A").val() +'원본 중지일자..');
            console.log(originSscd.value + '   원본 고객상태');
            console.log(originalMblNo + "원본 휴대폰");
             console.log($(this).val()+'  실시간.고객상태. 10 :정상, 80:중지, 90:해지');
             
             var mblF = originalMblNo.substring(0,3);//앞자리
             var mblS = originalMblNo.substring(3,7); //중간자리
             var mblT = originalMblNo.substring(7,11); //뒷자리
             
               //1.원본이.정상일때
             if(originSscd.value == '10' && $(this).val() == '90'){ //원본이.정상일때 해지불가
               alert("정상에서 해지불가"+ $("#CNCL_DT_A").val());
                $(this).prop('checked', false); //체크해제 
                $("input:radio[name='CUST_SS_CD']:radio[value='"+originSscd.value+"']").prop('checked', true); //이전 라디오버튼 체크
                $("#CNCL_DT").val($("#CNCL_DT_A").val()); //원본.해지일자 넣기
             }else if(originSscd.value == '10' && $(this).val() == '80'){ //원본.정상이고 실시간.중지일때
                $('#STP_DT').val(dateString); //중지일자
             }else{ //정상->중지 갔다가, 다시 중지->정상 왔을때 원본 중지일자 넣어주기
                $("#STP_DT").val($("#STP_DT_A").val()); //원본중지일자
             }
               
               //2.원본이.중지일때
               if(originSscd.value == '80' && $(this).val() == '90'){ //해지선택시
                  alert("해지사유를 입력하세요");
                  $("#CUST_NM_REAL").val('해지고객'); //
                  $("#mblF").val('000');
                  $("#mblS").val('0000');
                  $("#mblT").val('0000');
                  $("#CNCL_DT").val(dateString); //해지일자.오늘날짜로update
                 $("#CNCL_CNTS").attr("readonly",false); //입력가능
               }else if(originSscd.value == '80' && $(this).val() == '10'){ //원본이.중지이고 실시간.정상일때
                  $("#CUST_NM_REAL").val($("#CUST_NM_A").val()); //원본.고객이름 넣기
                  $("#mblF").val(mblF);//원본.휴대폰.앞자리
                   $("#mblS").val(mblS);//원본.휴대폰.중간
                   $("#mblT").val(mblT);//원본.휴대폰.뒷자리
                    $("#CNCL_CNTS").attr("readonly",true); //입력불가능
                    $("#CNCL_CNTS").val("");
                  $("#CNCL_DT").val($("#CNCL_DT_A").val()); //원본.해지일자 넣기
               }else{
                  $("#CUST_NM_REAL").val($("#CUST_NM_A").val()); //원본.고객이름 넣기
                  $("#mblF").val(mblF);//원본.휴대폰.앞자리
                   $("#mblS").val(mblS);//원본.휴대폰.중간
                   $("#mblT").val(mblT);//원본.휴대폰.뒷자리
                   $("#CNCL_CNTS").attr("readonly",true); //입력불가능
                   $("#CNCL_CNTS").val("");
                  $("#CNCL_DT").val($("#CNCL_DT_A").val()); //원본.해지일자 넣기
               }
               
               //3.원본이.해지일때
               if(originSscd.value == '90' && $(this).val() == '80'){ //원본이.해지이고. 실시간.중지로 갈때
                $("#CNCL_CNTS").val($("#CNCL_CNTS_A").val());
                $("input:radio[name='CUST_SS_CD']:radio[value='"+originSscd.value+"']").prop('checked', true); //이전 라디오버튼 체크
                $("#CNCL_CNTS").val($("#CNCL_CNTS_A").val())
                 alert("해지에서 중지불가" + $("#CNCL_CNTS_A").val());
                // 해지-> 정상상태 변경시 이름 및 휴대폰번호 변경필수 (해지일자, 중지일자, 해지사유 지워주세요)
               }else if(originSscd.value == '90' && $(this).val() == '10'){
                 $("#CUST_NM_REAL").val(''); //
                $("#mblF").val('');
                $("#mblS").val('');
                $("#mblT").val('');
                $("#CNCL_DT").val(''); //해지일자
                $("#STP_DT").val(''); //중지일자
                $("#CNCL_CNTS").val(''); //해지사유
               }else{
//                 $("input:radio[name='CUST_SS_CD']:radio[value='"+originSscd.value+"']").prop('checked', true); //이전 라디오버튼 체크
                  
               }
         });
        
           //고객정보 검색시
           $('#custInfoSearch').on("click", function(){
              
              var liveMlbNo = $("#mblF").val() + $("#mblS").val() + $("#mblT").val(); //실시간.이메일
              $("#MBL_NO").val(liveMlbNo);
              
              var liveEmail = $("#emailF").val() + '@' + $("#emailL").val(); //실시간.휴대폰
              $("#EMAIL").val(liveEmail);
              
              custInfoSearch(); //고객검색버튼->한명의.고객정보 불러옴
              
               historyData = [];
               count = -1;
              
           }); //고객정보 검색 함수 end  
         
           //적용클릭했을때update
           $('#btn_update').on("click", function(){
               var liveSSCD = $('input[name=CUST_SS_CD]:checked').val(); //실시간. 고객상태

              var liveMlbNo = $("#mblF").val() + $("#mblS").val() + $("#mblT").val(); //실시간.휴대폰
              $("#MBL_NO").val(liveMlbNo);
              
              var liveEmail = $("#emailF").val() + '@' + $("#emailL").val(); //실시간.이메일
              $("#EMAIL").val(liveEmail);
              
              if(rePhone==''){
                 rePhone = liveMlbNo;
              }
              
//               var custValidationResult = custValidation(); //유효성 테스트
//               var phoneValidationFalg = phoneValidation(); //휴대폰 유효성
              
//               console.log(custValidationResult + "...기본정보 유효성 벨리데이션.. true면 성공");
//               console.log(phoneValidationFalg + "...휴대폰 유효성 벨리데이션.. true면 성공");

              
                    
//               if(custValidationResult===true && phoneValidationFalg === true){ //기본유효성, 전화번호 유효성 성공시 true
//             if(liveSSCD=='90'){
//                phoneCheck1=true;
//             }
//                  if(phoneCheck1==false){ //중복체크 안했을시 phoneCheck1=false
//                     alert("휴대폰 중복체크 필수");
//                  }else{
//                     var historyValue = history(); //수정된 값이 없으면 false, 수정된 값이 하나라도 있으면 true
//                     if(historyValue==false){
//                        alert("수정된 내용이 없습니다.");
//                     }else{ //수정된 내용존재, update 및 변경이력 insert
                       
//                        if(!confirm("수정된 내용을 저장하시겠습니까?")){
//                             //취소시
//                          }else{
//                           custUpdateInsert(); //적용클릭시 insert/update처리할 ajax;
//                          }
//                     }
                    
//                     console.log(historyValue);
//                      historyData = [];
//                      count = -1;
//                   }
//                }//if end   
         
              
              if(!custValidation()){ //유효성 테스트
                 return ;
              }
             phoneValidation(); //휴대폰 유효성 검사
             
             var historyValue = history(); //수정된 값이 없으면 false, 수정된 값이 하나라도 있으면 true 
             
             console.log(historyValue+'수정이력 ggggggggggggg');
             
             //기존휴대폰번호 이면 중복체크 필요 없음.
//              if(!historyValue){
//                 phoneCheck1 = true;
//              }
             
             console.log(phoneCheck1+" 폰 힝");
             if(phoneCheck1==false){
                alert("휴대폰 중복체크 필수");
                return;
             }
             
             
             if(historyValue == false){
                phoneCheck1 = true;
                alert("수정된 내용이 없습니다.");
             }else{ //수정된 내용이 존재, update 및 변경이력 insert
                 if(!confirm("수정된 내용을 저장하시겠습니까?")){
                  //취소시
                 }else{
                    if(rePhone != liveMlbNo){
                       console.log("바꾼.."+rePhone);
                       console.log("실시간.."+liveMlbNo);
                       alert("휴대폰 중복체크 필수");
                       phoneCheck1 = false;
                       return ;
                    }
                    custUpdateInsert(); //적용클릭시 insert/update처리할 ajax;
                }
             }
              console.log(historyValue);
              historyData = [];
              count = -1;
             
              
           }); //적용클릭 함수 end
           
           //휴대폰번호 중복 클릭
           $('#phoneOverlap').on("click", function(){
              
              var phoneValiFalg = phoneValidation(); //휴대폰 유효성체크 - 다 체크했으면 true,
              
              if(phoneValiFalg){ //유효성 실시했으면 중복체크ajax 실행
                 phoneOverlap(); //중복체크 ajax
              }
           });
           
      
   });  //document end
   
   
   
      //휴대폰 유효성
      function phoneValidation(){ //휴대폰 유효성체크 - 다 체크했으면 true, 
         
           var regExp = /[ \{\}\[\]\/?.,;:|\)*~`!^\-_+┼<>@\#$%&\'\"\\\(\=]/gi; 
         
           var liveAllMlbNo = $("#mblF").val() + $("#mblS").val() + $("#mblT").val(); //실시간.휴대폰
           var liveMblF = $("#mblF").val(); //앞자리
           var liveMblS = $("#mblS").val(); //중간자리
           var liveMblT = $("#mblT").val(); //뒷자리
           
           var originalMlbNo = $("#MBL_NO_A").val(); //원본.휴대폰
           var liveSSCD = $('input[name=CUST_SS_CD]:checked').val(); //고객상태

           if(liveAllMlbNo==originalMlbNo){
              phoneCheck1 = true;
           }
           
           
//            alert(liveSSCD); //실시간 고객상태
           console.log("##########휴대폰 유효성 시작##########");
           console.log("##########휴대폰 유효성 끝##########");
           
           if(isNaN(liveAllMlbNo)){ //isNaN = 숫자일경우 false, 아닐경우 true
              alert("휴대폰번호에 문자 입력불가");
              return false;
           }else if(regExp.test(liveAllMlbNo)){
              alert("휴대폰번호에 특수문자 입력불가");
              return false;
           }else if(liveMblF.length<3 || liveMblF.length>3){ // 앞자리 3자리
              alert("휴대폰 앞자리 3자 입력 필수");
              return false;
           }else if(liveMblS.length<3 || liveMblS.length>4){ // 중간자리 3~4자리 
              alert("휴대폰 중간자리 3~4자 입력 필수");
              return false;
           }else if(liveMblT.length < 4 || liveMblT.length > 4 ){ //뒷자리 4자만 입력가능
              alert("휴대폰 뒷자리 4자 입력 필수");
              return false;
           }else if(liveSSCD !='90' && liveAllMlbNo=='0000000000'){
              alert('000-000-0000 은 사용할수 없는 핸드폰 번호입니다.');
              $('#mblF').val('');
              $('#mblS').val('');
              $('#mblT').val('');
            return false;
           }else if(liveSSCD !='90' && liveAllMlbNo=='00000000000'){
            alert('000-0000-0000 은 사용할수 없는 핸드폰 번호입니다.');
            $('#mblF').val('');
            $('#mblS').val('');
            $('#mblT').val('');
            $('#mblF').focus();
            return false;
           }else{
              
              return true;
           }
           return true;
      }//function end
   

   
   //기존휴대폰번호 였는지 확인
   function originPhone(){
      var liveAllMlbNo = $("#mblF").val() + $("#mblS").val() + $("#mblT").val(); //실시간.휴대폰
      var originalMlbNo = $("#MBL_NO_A").val(); //원본.휴대폰
      
      if(liveAllMlbNo==originalMlbNo){
         originMlbNoFlag = true;
         phoneCheck1 = true;
         return true;
      }
      return false;
   }
   
   
   
   //중복체크 클릭시
   function phoneOverlap(){

//       var liveSSCD = $('input[name=CUST_SS_CD]:checked').val(); //고객상태
      
       var liveAllMlbNo = $("#mblF").val() + $("#mblS").val() + $("#mblT").val(); //실시간.휴대폰
        
            
        if(originPhone()){
           alert("기존번호 입니다.");
           phoneCheck1=true;
           return true;
        }else{
           
           $.ajax({
              url : "/admin/phoneOverlap",
              type : "post",
              data : { mblNo : liveAllMlbNo},
              success:function(res){
                 if(res.length == 0){ //사용가능
                    alert("사용가능한 번호 입니다.");
                    phoneCheck1=true;  //첫번째 중복체크여부
                    console.log(phoneCheck1+ '..첫번째 중복체크... 사용가능한걸로 true 나와야됨..');
                    rePhone = liveAllMlbNo;
                    console.log(rePhone);
                 }else{ //사용중인 핸드폰
                    alert("사용중인 핸드폰번호 입니다.");
                    phoneCheck1=false;  //첫번째 중복체크여부
                 }
              }
           });
           
        }
   } //function end
   
   
   //유효성테스트
   function custValidation(){
      
       //휴대폰
       
       //고객명 공백체크
       if(CUST_NM_REAL.value.trim() == '' || CUST_NM_REAL.value == null){
          alert("고객명을 입력하세요");
          return false;
       }

         //생년월일 공백체크
         if(BRDY_DT.value =='' || BRDY_DT.value==null){
            alert("생년월일을 선택하세요.");
            return false;
         }      
      
         //직업코드 공백체크
         if(!POC_CD.value){
            alert("직업코드를 선택해주세요.");
            return false;
         }
         
         var regEmail = /^([0-9a-zA-Z_\.-]+)@([0-9a-zA-Z_-]+)(\.[0-9a-zA-Z_-]+){1,2}$/;
         
         var EMAIL = emailF.value + '@' + emailL.value;
         
         if(emailF.value=='' || emailF.value==null){
            alert("이메일을 입력하세요");
            return ;
         }else if(emailL.value=='' || emailL.value==null){
            alert("이메일을 입력하세요.");
            return false;
         }else if(!regEmail.test(EMAIL)){
            alert("이메일이 유효하지 않습니다.");
            return false;
         }
         
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
         
         var liveSSCD = $('input[name=CUST_SS_CD]:checked').val(); //실시간. 고객상태
      
        if(liveSSCD == '90' && $("#CNCL_CNTS").val()==''){
           alert("해지사유를 입력하세요");
           return false;
        }
      
      return true;
   }
   
   //serializeArray()함수 key,value 파싱
   function keyValueParsing(){
      var o = {};
      var a = $("#custInfoForm").serializeArray();
      
      $.each(a, function(){
         if (o[this.name] !== undefined) {
               if (!o[this.name].push) {
                   o[this.name] = [o[this.name]];
               }      
               o[this.name].push(this.value || '');
           } else {
               o[this.name] = this.value || '';
           }
      });
      
      return o;
   }
   
   //최유정
   //적용눌렀을때. update/insert
   function custUpdateInsert(){
      
      console.log("##########적용눌렀을때 updateInsert#########");
      console.log("ㅎㅎㅎㅎㅎㅎㅎㅎㅎㅎㅎㅎㅎㅎ");
      
      console.log(historyData);
      console.log(keyValueParsing());
      
      console.log("##########적용눌렀을때 updateInsert#########");
      
      var data = { 
            "custInsert" : historyData                 // historyData = new Array(); //변경이력 담은 객체
            ,"custUpdate" : keyValueParsing()           // serializeArray() 데이터
      };
      
      console.log("적용눌렀을때..");
      console.log("data : " + JSON.stringify(data));
      
      
      
      //AJAX는 데이터를 문자열화 해주지 않기 때문에 보낼데이터를 JSON.stringify()로 감싸주었다.
      //그렇지 않으면 json데이터의 "key","value" 형태의 패턴을 인식하지 못한다.
      //  - [{}] : 배열 형태의 데이터
      //   -  {}  :  1개의 데이터 값
      $.ajax({
         url : "/admin/custUpdateInsert",
         contentType: 'application/json; charset=utf-8',
         type : "post",
         dataType : "JSON",
         data : JSON.stringify(data),
         success:function(res){
            alert("성공");
            console.log(JSON.stringify(res));
            console.log(res.rest);
            backList();
         },error:function(res){
            console.log("실패");
         }
      });
      
   }
   
   
   

   
   
   var historyData = new Array(); //변경이력 담을 객체
   var count = -1;
   var historyFalg = false; //값변화가 없으면 false, 값변화가 있으면 true
   
   //변경이력
   function history(){
      
      var settingCustNo = $("#settingCustNo").val(); //상세들어올때 초기 고객번호
      var updateForm = $("#custInfoForm").serializeArray();  //수정한 값
      var hiddenForm = $("#custInfoHidden").serializeArray(); //원본 값
      var sessionId = document.getElementById("LST_UPD_ID").value; //관리자 아이디
      
      console.log(updateForm);
      console.log(hiddenForm);
      
      for(i=0; i<updateForm.length; i++){
        var update_name = updateForm[i].name;
         var update_value = updateForm[i].value;
         
         for(j=0; j<hiddenForm.length; j++){
            var hidden_name = hiddenForm[j].name;
             var hidden_value = hiddenForm[j].value;
             
             if(update_name == hidden_name && update_value != hidden_value){
                historyFalg = true;  //변경된 값이 존재하므로  falg true로 설정
                count++;
                
                 console.log("####히스토리함수 영역#####");
                 
                 console.log(historyFalg+"......변경된 이력이 존재하면 falg = true로 설정...")
                 console.log(count+'........-1부터 시작 카운트');
                 console.log("변경항목.. "+update_name);
                 console.log("변경전값.. "+hidden_value);
                 console.log('변경후값.. '+update_value);
                 console.log('관리자아이디...'+ sessionId);
//                  console.log('관리자이름...'+ sessionName.value);
                 console.log('고객번호..'+settingCustNo);
                 console.log("####히스토리함수 영역#####");
                 
                 historyData[count] = {
                       "CUST_NO":settingCustNo  //고객번호
                       ,"CHG_CD":update_name          //변경코드.CHG_CD
                       ,"CHG_BF_CNT": hidden_value      //변경전내용.CHG_BF_CNT
                       ,"CHG_AFT_CNT":update_value      //변경후내용.CHG_AFT_CNT
                       ,"LST_UPD_ID":sessionId   //최종수정자.LST_UPD_ID
                 };
                 
             } // if end
         } // for end
      } //for end
      
      return historyFalg; //수정된 값이 없으면 false, 값변화가 있으면 true
      
   } //history() end
   
      //휴대폰번호 앞자리,중간자리, 뒷자리 자르는 함수
      function sliceMblNo(MBL_NO){
         
         // 010 1231 234
         if(MBL_NO.length==10){ //휴대폰이 10자리이면
            var mblF = MBL_NO.substring(0,3);//앞자리
            var mblS = MBL_NO.substring(3,6); //중간자리
            var mblT = MBL_NO.substring(6,10); //뒷자리
            
            document.getElementById("mblF").value = mblF;
            document.getElementById("mblS").value = mblS;
            document.getElementById("mblT").value = mblT;
         
         //010 1234 1234
         }else if(MBL_NO.length==11){ //휴대폰이 11자리이면
            var mblF = MBL_NO.substring(0,3);//앞자리
            var mblS = MBL_NO.substring(3,7); //중간자리
            var mblT = MBL_NO.substring(7,11); //뒷자리

            document.getElementById("mblF").value = mblF;
            document.getElementById("mblS").value = mblS;
            document.getElementById("mblT").value = mblT;
         }else{
            var mblF = MBL_NO.substring(0,3);//앞자리
             var mblS = MBL_NO.substring(3,7); //중간자리
             var mblT = MBL_NO.substring(7,MBL_NO.length); //뒷자리
             
             document.getElementById("mblF").value = mblF;
             document.getElementById("mblS").value = mblS;
             document.getElementById("mblT").value = mblT;
         }
      }
   
   
   
   //고객번호 팝업창 눌렀을때
   function SearchPopUp(){
      var CUST_NM = $("#CUST_NM").val(); // 고객번호 or 고객명 들어올거임
      
      
      var url = "/admin/custNoSearchPop";
      
      $.ajax({
         url: url+"?CUST_NM="+CUST_NM,
         type:"get",
         success:function(res){   // 0개, 1개(일치), 2개이상
            console.log(res.length + ' 고객 갯수');
            console.log(res);
            if(res.length == 1){  // 1개 - 출력
               $("#CUST_NO").val(res[0].cust_NO);                     
               $("#CUST_NM").val(res[0].cust_NM);                     
            }else if(res.length == 0){  // 0개, 2개이상 
               alert(CUST_NM + '를 찾지 못했습니다.')
               csCustSearchPopUp(CUST_NM);
            }else{
               csCustSearchPopUp(CUST_NM);
            }
         },
         error:function(json){
            
         }
      });
   } //SearchPopUp() 고객번호 팝업창 end
   
   
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
    
    //닫기
   function backList(){
            
      location.href="/admin/customerList";
   }
    
    
    
    
    //변경이력이 있으면 변경이력이 있는데 검색할거냐 물어보기
    //검색안할거면(취소) 정보그대로 유지, 확인누르면 검색한 정보 불러오기
    //글로벌변수 이용.var historyFalg = false; //값변화가 없으면 false, 값변화가 있으면 true
    //고객정보 검색시
    //한명의 고객을 불러옴.
    function custInfoSearch(){
//        alert("고객조회 함수......");
       history();
       historyFalg; //값변화가 없으면 false, 값변화가 있으면 true
       console.log(historyFalg+'###검색시 히스토리##값변화가 없으면 false, 값변화가 있으면 true##'+ count);
      
       var liveCustNo = $("#CUST_NO").val(); //실시간.검색창의.고객번호
       
       if(historyFalg==true){ //값변화가 없으면 false, 값변화가 있으면 true
         if(confirm("수정이력이 있는데 그래도 다른 고객을 조회하시겠습니까?")){
//             alert("다른고객 조회.. 에이작스처리");
//             alert("실시간 고객번호.."+liveCustNo);
            
            custInfoSearchAjax(liveCustNo);

         }else{
//              alert("조회안할건데");
          }          
       }else{
          custInfoSearchAjax(liveCustNo);
       }
    }
    
    
    //검색시 에이작스처리
    function custInfoSearchAjax(liveCustNo){
//        alert("검색시에이작스 ㅋ"+ liveCustNo);
      $.ajax({
         
         url : "/admin/searchCustInfo",
         type : "post",
         data : {
               "CUST_NO" : liveCustNo
         },
         success:function(res){
            console.log("#########고객조회 함수..성공 시작########");
            console.log(res);
            document.getElementById("CUST_NM_REAL").value=res.cust_NM; //고객명ㅇ
                document.getElementById("BRDY_DT").value=res.brdy_DT; //생년월일ㅇ
                $("input:radio[name='SEX_CD']:radio[value='"+res.sex_CD+"']").prop('checked', true);   // 성별
                
                $("input:radio[name='SCAL_YN']:radio[value='"+res.scal_YN+"']").prop('checked', true);   // 생일
                document.getElementById("MRRG_DT").value=res.mrrg_DT; //결혼기념일ㅇ
                $('#POC_CD').val(res.poc_CD).prop("selected",true); //직업코드
                
                sliceMblNo(res.mbl_NO); //휴대폰번호
                $('input[name="JN_PRT_CD"]').val(res.jn_PRT_CD);
                document.getElementById("PRT_NM").value=res.prt_NM; //매장명
            
                
                $("input:radio[name='PSMT_GRC_CD']:radio[value='"+res.psmt_GRC_CD+"']").prop('checked', true);   //우편물수령
                  
                document.getElementById("EMAIL").value=res.email; //이메일
                  
                var splitEmail = res.email.split('@');
                  
                
                
                
                document.getElementById("emailF").value = splitEmail[0];
                if(splitEmail.length == 1){
                   document.getElementById("emailL").value = '';
                }else{
                   document.getElementById("emailL").value = splitEmail[1];
                }

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
                  
                $("input:radio[name='EMAIL_RCV_YN']:radio[value='"+res.email_RCV_YN+"']").prop('checked', true);  //이메일수신동의      
                $("input:radio[name='SMS_RCV_YN']:radio[value='"+res.sms_RCV_YN+"']").prop('checked', true);  //SMS수신동의
                $("input:radio[name='DM_RCV_YN']:radio[value='"+res.dm_RCV_YN+"']").prop('checked', true);  //DM수신동의
            
                
               console.log("#########고객조회 함수..성공 끝########");
                
                console.log("##########검색한 새로운 값 다시 원본 데이터로 복사. 시작##########");
                
                document.getElementById("CUST_NO_A").value=res.cust_NO; //고객번호
                
                document.getElementById("CUST_NM_A").value=res.cust_NM; //고객명
                document.getElementById("BRDY_DT_A").value=res.brdy_DT; //생년월일
                document.getElementById("SEX_CD_A").value=res.sex_CD; //성별

                document.getElementById("SCAL_YN_A").value=res.scal_YN; //양음력구분ㅇ
                document.getElementById("MRRG_DT_A").value=res.mrrg_DT; //결혼기념일
                document.getElementById("POC_CD_A").value=res.poc_CD; //직업코드
                
                document.getElementById("MBL_NO_A").value=res.mbl_NO; //휴대폰번호
                document.getElementById("JN_PRT_CD_A").value=res.jn_PRT_CD; //가입매장코드
                document.getElementById("PRT_NM_A").value=res.prt_NM; //매장코드명
                
                
                document.getElementById("PSMT_GRC_CD_A").value=res.psmt_GRC_CD; //우편물수령                 
                document.getElementById("EMAIL_A").value=res.email; //이메일
                

                document.getElementById("ZIP_CD_A").value=res.zip_CD; //우편번호
                document.getElementById("ADDR_A").value=res.addr; //주소
                document.getElementById("ADDR_DTL_A").value=res.addr_DTL; //상세주소

                document.getElementById("CUST_SS_CD_A").value=res.cust_SS_CD; //고객상태
                document.getElementById("FST_JS_DT_A").value=res.fst_JS_DT; //최초가입일자
                document.getElementById("JS_DT_A").value=res.js_DT; //가입일자
                
                
                document.getElementById("CNCL_CNTS_A").value=res.cncl_CNTS; //해지사유
                document.getElementById("STP_DT_A").value=res.stp_DT; //중지일자
                document.getElementById("CNCL_DT_A").value=res.cncl_DT; //해지일자
                
                
                document.getElementById("EMAIL_RCV_YN_A").value=res.email_RCV_YN; //이메일수신동의  
                document.getElementById("SMS_RCV_YN_A").value=res.sms_RCV_YN; //SMS수신동의
                document.getElementById("DM_RCV_YN_A").value=res.dm_RCV_YN; //DM수신동의
                
                /**
                        필요없을듯..?
                document.getElementById("TOT_SAL_AMT").value=res.tot_SAL_AMT; //총구매금액
                document.getElementById("TOT_SAL_MONTH").value=res.tot_SAL_MONTH; //당월구매금액
                document.getElementById("SAL_DT").value=res.sal_DT; //최종구매일
                  
                document.getElementById("TOT_PNT").value=res.tot_PNT; //총포인트
                document.getElementById("RSVG_PNT").value=res.rsvg_PNT; //당월적립포인트
                document.getElementById("US_PNT").value=res.us_PNT; //당월사용포인트                       
                
                */
                
                console.log("##########검색한 새로운 값 다시 원본 데이터로 복사. 끝############");
            
         },
         error:function(res){
            console.log("고객검색 실패");
         }
      }); //ajax end
    }
     
    
   
   
</script>
<div class="admin_memberList">
   <div class="center">
   <div class="memberList_logo">
      <h4>고객정보조회
         <button onclick='window.location.reload()'><img src="/resources/images/reset.png" alt="logo" align="middle"/></button>
      </h4>
   </div>
        
        <!-- 원본 데이터 -->
      <form id="custInfoHidden">
           <input type="hidden" id="CUST_NO_A"         name="CUST_NOA"    value="${custInfo.CUST_NO}"/><!--  고객번호-->
           
           <input type="hidden" id="CUST_NM_A"         name="CUST_NM"    value="${custInfo.CUST_NM}"/><!-- 고객명 -->
           <input type="hidden" id="BRDY_DT_A"         name="BRDY_DT"    value="${custInfo.BRDY_DT }"/><!-- 생년월일 -->
           <input type="hidden" id="SEX_CD_A"        name="SEX_CD"       value="${custInfo.SEX_CD}"/><!-- 성별 -->
           
           <input type="hidden" id="SCAL_YN_A"         name="SCAL_YN"    value="${custInfo.SCAL_YN}"/><!-- 양음력구분 -->
           
           <input type="hidden" id="MRRG_DT_A"         name="MRRG_DT"    value="${custInfo.MRRG_DT}"/><!-- 결혼기념일 -->
           <input type="hidden" id="POC_CD_A"        name="POC_CD"       value="${custInfo.POC_CD}"/><!-- 직업코드 -->
           
           <input type="hidden" id="MBL_NO_A"             name="MBL_NO"       value="${custInfo.MBL_NO}"/><!-- 휴대폰 -->
           <input type="hidden" id="JN_PRT_CD_A"     name="JN_PRT_CD"    value="${custInfo.JN_PRT_CD}"/><!-- 가입매장코드 -->
           
   <!--         <input type="text" id="mblF_A"         name="mblF_A"       value=""/>휴대폰 -->
   <!--         <input type="text" id="mblS_A"         name="mblS_A"       value=""/>휴대폰 -->
   <!--         <input type="text" id="mblT_A"         name="mblT_A"       value=""/>휴대폰 -->
           
           
           
           <input type="hidden" id="PSMT_GRC_CD_A"    name="PSMT_GRC_CD" value="${custInfo.PSMT_GRC_CD}"/><!-- 우편물수령코드 -->
           <input type="hidden" id="EMAIL_A"        name="EMAIL"       value="${custInfo.EMAIL}"/><!-- 이메일주소 -->
           
           <input type="hidden" id="ZIP_CD_A"        name="ZIP_CD"       value="${custInfo.ZIP_CD}"/><!-- 우편번호코드 -->
           <input type="hidden" id="ADDR_A"            name="ADDR"       value="${custInfo.ADDR}"/><!-- 주소 -->
           <input type="hidden" id="ADDR_DTL_A"         name="ADDR_DTL"    value="${custInfo.ADDR_DTL}"/><!-- 상세주소 -->
           
           <input type="hidden" id="CUST_SS_CD_A"     name="CUST_SS_CD"    value="${custInfo.CUST_SS_CD}"/><!-- 고객상태코드 -->
           <input type="hidden" id="FST_JS_DT_A"     name="FST_JS_DT"    value="${custInfo.FST_JS_DT}"/><!-- 최초가입일자 -->
           <input type="hidden" id="JS_DT_A"         name="JS_DT"    value="${custInfo.JS_DT}"/><!-- 가입일자 -->
           
           <input type="hidden" id="CNCL_CNTS_A"     name="CNCL_CNTS"    value="${custInfo.CNCL_CNTS}"/><!-- 해지사유내용 -->
           <input type="hidden" id="STP_DT_A"         name="STP_DT"       value="${custInfo.STP_DT}"/><!-- 중지일자 -->
           <input type="hidden" id="CNCL_DT_A"         name="CNCL_DT"    value="${custInfo.CNCL_DT}"/><!-- 해지일자 -->
                
           <input type="hidden" id="EMAIL_RCV_YN_A"     name="EMAIL_RCV_YN" value="${custInfo.EMAIL_RCV_YN}"/><!-- 이메일수신동의여부 -->
           <input type="hidden" id="SMS_RCV_YN_A"     name="SMS_RCV_YN"  value="${custInfo.SMS_RCV_YN}"/><!-- SMS수신동의여부 -->
           <input type="hidden" id="DM_RCV_YN_A"      name=DM_RCV_YN    value="${custInfo.DM_RCV_YN}"/><!-- DM수신동의여부 -->
           
           <input type="hidden" id="PRT_NM_A"         name="PRT_NM"       value="${custInfo.PRT_NM}"/> <!-- 가입매장 -->
           
   </form>
   
   <!-- 검색창 -->
   <div class="memberList_search">
      <form id="custNoSearchForm" action="admin/custInfo" onSubmit="return false;">
           
           <!-- 고객번호or고객명 입력값 넣어줌- 팝업창으로 던질거 -->
      <input type="hidden" id="custNmP" name="custNmP" value=""/>
      <!-- 매장코드or매장명 입력값 넣어줌- 팝업창으로 던질거 -->
      <input type="hidden" id="prtNmP" name="prtNmP" value=""/>
      
      
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
   

   
      <form id="custInfoForm">
      <input type="hidden" id="settingCustNo" name="CUST_NO" value="${custInfo.CUST_NO}"/>
     <input type="hidden" id="EMAIL" name="EMAIL"/> <!-- 실시간.통이메일 -->
     <input type="hidden" id="MBL_NO" name="MBL_NO"/> <!-- 실시간.통번호 -->
     
     <input type="hidden" id="LST_UPD_ID" name="LST_UPD_ID" value="${cn.USER_ID}"/><!-- 최종수정자 -->
         <table class="tableON">
<!--             <tbody class="custTbody"> -->
            <tr>
               <td class="tableTitle" colspan="6">회원 기본 정보 </td>
            </tr>
               <tr>
                  <td class="custT"><i>*</i>고객명</td>
                  <td class="custD">
                     <input type="text" class="textVal" id="CUST_NM_REAL" name="CUST_NM" value="${custInfo.CUST_NM}" />
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
                           <option class="textVal" value="${code.DTL_CD}" <c:if test='${code.DTL_CD==custInfo.POC_CD}'>selected="selected"</c:if>>${code.DTL_CD_NM}</option>
<%--                            <option class="textVal" value="${code.DTL_CD}" >${code.DTL_CD_NM}</option> --%>
                        </c:forEach>
                     </select>
                  </td>
               </tr>
               <tr>
                  <td class="custT"><i>*</i>휴대폰번호</td>
                  <td class="custD" colspan="3">
                     <input type="text" class="textPhone" id="mblF" name="mblF" maxlength="3"/>
                     <input type="text" class="textPhone" id="mblS" name="mblS" maxlength="4"/>
                     <input type="text" class="textPhone" id="mblT" name="mblT" maxlength="4"/>
<!--                      <input type="button" class="PhoneBtn"  value="변경" onclick="phoneOverlap()"/> -->
                     <input type="button" class="PhoneBtn" id="phoneOverlap" name="phoneOverlap" value="변경" />
                  </td>
              <td class="custT"><i>*</i>가입매장</td>
              <td>
                 <input type="text" class="mrtText" id="PRT_CD" name="JN_PRT_CD"  value="${custInfo.JN_PRT_CD}" readonly="readonly"/>
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
                           <input type="radio"  class="sscdLeave" id="${code.CODE_CD}${code.DTL_CD}" name="${code.CODE_CD}" value="${code.DTL_CD}"  <c:if test='${code.DTL_CD==custInfo.CUST_SS_CD}'>checked="checked"</c:if> /><c:out value="${code.DTL_CD_NM}"/>
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
                  <td class="custD"><input type="text" class="textVal" id="US_PNT" value="${custInfo.US_PNT}" readonly="readonly"/></td>
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
