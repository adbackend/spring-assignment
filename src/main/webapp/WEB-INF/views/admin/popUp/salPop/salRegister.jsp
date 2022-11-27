<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="/resources/css/content/admin/popUp/salRegister.css" />
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<c:set var="crdCO" value="${codes['CRD_CO_CD']}"/>

<style>
   .shield{
/* 	   background-color: #00000040;   */
       position: absolute;
       top: 0;
       left: 0;
       width: 100%;
       height: 100%;
       z-index: 999;
       cursor: pointer;
       }
       
.custSheild{
/* 	   background-color: #00000040; */
       position: absolute;
       top: 0;
       left: 0;
       width: 331px;
       height: 100%;
       z-index: 999;
       cursor: pointer;
}
</style>
<script type="text/javascript">

   var PRT_CD ; //매장코드
   var USER_ID; //로그인한 관리자 아이디
   $(document).ready(function(){

      var today = new Date();
      
      var year = today.getFullYear();
      var month = ('0' + (today.getMonth() + 1)).slice(-2);
      var day = ('0' + today.getDate()).slice(-2);
      
      var dateString = year + '-' + month  + '-' + day;   
      console.log(dateString);
      $("#SAL_DT").val(dateString);
      
      
      var cust_no = opener.$("input#EcustNo").val(); //부모창에서 #EcustNo인 값을 들고온다(고객번호)
      PRT_CD = opener.$("#ivocoPrtCd").val(); //부모창에서 매장코드를 들고온다
      
      USER_ID = opener.$("#USER_ID").val(); //부모창에서 로그인id값을 들고온다
      
      var par = opener.$('#EcustNo').attr('id');
      document.getElementById('CUST_NO').innerText = cust_no; // 부모창에서 가져온 고객번호를 innerText하여 text변경
      
      $("input.blank_key").keyup(function(event){                  // 고객번호
         if(event.keyCode == 8 || event.keyCode == 46) {          // 백스페이스(8) 또는 Delete(46)키를 입력했을 경우
               if($("input#CUST_NM").val() == "") {               // 고객검색란의 내용이 아무것도 없다면
                  $("input#CUST_NO").val("");                     // 고객번호를 지운다
                  $("input#AVB_PNT").val("");
                  deleteCustInfo();
               }
            }
         }); // function end 
       
       //카드금액 지울시
      $("input.backCRD").keyup(function(event){                  
         if(event.keyCode == 8 || event.keyCode == 46) {     // 백스페이스(8) 또는 Delete(46)키를 입력했을 경우
               if($("input#CRD_STLM_AMT").val() == "") {       // 카드금액이 지워졌다면
                  
                  $("input#VLD_YM").val("");                   // 유효일자
                  $("input#CRD_CO_CD").val("");               // 카드회사
                  $("input#cardNum1").val("");               // 카드번호1
                  $("input#cardNum2").val("");               // 카드번호2
                  $("input#cardNum3").val("");               // 카드번호3
                  $("input#cardNum4").val("");               // 카드번호4
               }
            }
         }); // function end 
         
       add_row(); //행추가 1행은 default로 있어야 되니 페이지가 실행될때 
      
         
         
         //최유정
         //적용버튼 눌렀을때
         $("#salRegistBtn").off().on("click", function(e){
            e.stopPropagation();
            e.preventDefault();         
            
            if(!salAndCardValidationCk()) {
               return;
            }
            console.log("저장버튼 누를시...");
            if(!confirm("판매수금 등록 하시겠습니까?")){
               //취소시
            }else{
               allDataProcess(); //저장버튼시 데이터 처리 ajax
            }
         });
         
         
         
         $("#CRD_STLM_AMT").on("change keyup paste", function(){
            console.log('실시간감지 동작');
            // 값이 있는지 확인하여
            // 유효일자/카드회사/카드번호 disable 해제처리
            var CRD_STLM_AMT = $("#CRD_STLM_AMT").val().trim();
            
            if(CRD_STLM_AMT.length >0){  //disable false
               console.log("카드 금액 입력 길이 0보다 큼..");
               $("#VLD_YM").attr("disabled", false); //해제
               $("#CRD_CO_CD").attr("disabled", false); //해제
               $("#cardNum1").attr("disabled", false); //해제
               $("#cardNum2").attr("disabled", false); //해제
               $("#cardNum3").attr("disabled", false); //해제
               $("#cardNum4").attr("disabled", false); //해제
            }else{
               console.log("작음");
               $("#VLD_YM").attr("disabled", true); //설정
               $("#CRD_CO_CD").attr("disabled", true); //설정
               $("#cardNum1").attr("disabled", true); //설정
               $("#cardNum2").attr("disabled", true); //설정
               $("#cardNum3").attr("disabled", true); //설정
               $("#cardNum4").attr("disabled", true); //설정
            }
            
            console.log(CRD_STLM_AMT.length);
            
         });
         
            //카드번호 4자리 이후 포커스 이동
            $('#cardNum1').on('keyup', function() {     
               if(this.value.length == 4) {        
                  $('#cardNum2').focus();      
               }
            });
            $('#cardNum2').on('keyup', function() {     
               if(this.value.length == 4) {        
                  $('#cardNum3').focus();      
               }
            });  
            $('#cardNum3').on('keyup', function() {     
               if(this.value.length == 4) {        
                  $('#cardNum4').focus();      
               }
            });         
         
         
   }); //document.ready end #####################################################################################################
   
   // 문자열에서 숫자만 return (type String)
   function returnNum(obj) {
      var regex = /[^0-9]/g;
      var result = obj.toString().replace(regex, "");
      return result;
   }
   
   // 저장눌렀을때 유효성체크함수
   // 1.판매일자, 고객번호 공백체크
   // 2.현금 or 카드금액 공백일때  현금또는 카드금액 입력하라고 처리
   //  현금 카드금액은 빈값이라도 저장시 0 으로 처리 
   // 3.카드금액 입력시 유효일자,카드회사,카드번호 공백인지 체크
   // 4.총판매금액 = 현금+카드금액+포인트 사용액   이 아니면 alert창
   // 5.상품코드,수량 빈값있을 시  alert
   // 6.고객번호 제외한 모든 입력칸은 숫자만 입력하게 
   // 7.포인트사용액이 100보다 커야됨. && 포인트사용액이 가능액보다 크면 안됨
   function salAndCardValidationCk(){
      
      var regExp = /[ \{\}\[\]\/?.,;:|\)*~`!^\-_+┼<>@\#$%&\'\"\\\(\=]/gi; 
      
      var SAL_DT = $("#SAL_DT").val().trim(); //1판매일자
      var SAL_TP_CD = $("#SAL_TP_CD").val().trim(); //2판매구분코드
      var CUST_NO = $("#CUST_NO").val().trim(); //3고객번호
      
      var CSH_STLM_AMT = $("#CSH_STLM_AMT").val().trim(); //1현금
      var CRD_STLM_AMT = $("#CRD_STLM_AMT").val().trim(); //2카드금액
      var PNT_STLM_AMT = $("#PNT_STLM_AMT").val().trim(); //3포인트 사용액
      var AVB_PNT = $("#AVB_PNT").val().trim(); //4포인트가능액
      var VLD_YM = $("#VLD_YM").val().trim(); //5유효일자
      var CRD_CO_CD = $("select[name='CRD_CO_CD']").val(); //7카드회사

      var cardNum1 = $("#cardNum1").val().trim();
      var cardNum2 = $("#cardNum2").val().trim();
      var cardNum3 = $("#cardNum3").val().trim();
      var cardNum4 = $("#cardNum4").val().trim();
      var CRD_NO = cardNum1 + cardNum2 + cardNum3 + cardNum4; //8카드번호
      
      

      if(SAL_DT == '' || SAL_DT == null){
         alert("판매일자 입력필수");
         return false;
      }
      
      if(SAL_TP_CD == '' || SAL_TP_CD == null){
         alert("판매구분코드 필수");
         return false;
      }
      
      if(CUST_NO == '' || CUST_NO == null){
         alert("고객번호 필수");
         return false;
      }
      
      //상품리스트
      var products = [];
      $('#list > tr').each(function(i, row) {
          var proudct = {};
          var prdCd = $(this).children().eq(2).find('.prdCd_blank').val();
          var qty = $(this).children().eq(5).children().eq(0).val(); //수량
          
          console.log("@"+prdCd+"::#"+qty);
          if(!isBlank(prdCd) && !isBlank(qty)){
             proudct.prdCd = prdCd;
             proudct.qty = Number(qty);
             products.push(proudct);
          }
       });
      
      if(products.length == 0){
         alert("등록할 상품이 없습니다.");
         return false;
      }

      
      
       
      
      //현금 or 카드금액 입력값이 최소 하나는 무조건 들어가야됨
      if( (CSH_STLM_AMT == '' || CSH_STLM_AMT == null) && (CRD_STLM_AMT == '' || CRD_STLM_AMT == null) && (PNT_STLM_AMT == '' || PNT_STLM_AMT == null) ){
         alert("현금금액/카드금액/포인트사용액등 결제금액을 입력해주세요");
         return false;
      }
      
      if(isNaN(Number(CSH_STLM_AMT)) || regExp.test(CSH_STLM_AMT)){
         alert("현금에 문자 또는 특수문자 입력불가");
         return false;
      }
      
      
      
      var monthCK = VLD_YM.substr(0, 2);  //월추출
      var yearCK = VLD_YM.substr(2,6);  //월추출  022022
      console.log("yearCK.... "+yearCK);
      
      if(CRD_STLM_AMT != ''){ //카드금액이 빈값이 아닐때
         if(VLD_YM == '' || VLD_YM == null){
            alert("카드사용시 유효일자 필수");
            return false;
         }else if(VLD_YM.length != 6){
            alert("카드유효일자 MMYYYY(달년도) 형식으로 맞춰주세요");
            return false;
         }else if(CRD_CO_CD == '' || CRD_CO_CD == null){
            alert("카드사용시 카드회사 필수");
            return false;
         }else if(cardNum1 == '' || cardNum1 == null){
            alert("카드사용시 번호 필수");
            return false;
         }else if(cardNum2 == '' || cardNum2 == null){
            alert("카드사용시 번호 필수");
            return false;
         }else if(cardNum3 == '' || cardNum3 == null){
            alert("카드사용시 번호 필수");
            return false;
         }else if(cardNum4 == '' || cardNum4 == null){
            alert("카드사용시 번호 필수");
            return false;
         }else if(CRD_NO.length != 16){
            alert("카드번호 16자리 필수");
            return false;
         }
      
         if(VLD_YM.length == 6){
            if(monthCK > 12 || monthCK == '00'){
               alert("카드유효일자 MMYYYY(달년도) 형식으로 맞춰주세요. \n * MM(달) 입력값 오류 *");
               return false;
            }else if(yearCK == '0000'){
               alert("카드유효일자 MMYYYY(달년도) 년도에 0000을 넣을수 없습니다.");
               return false;
            }
         }
      
         if(isNaN(Number(CRD_STLM_AMT)) || regExp.test(CRD_STLM_AMT)){
            alert("카드금액에 문자 또는 특수문자 입력불가");
            return false;
         }
         
         if(isNaN(Number(VLD_YM)) || regExp.test(VLD_YM)){
            alert("유효일자에 문자 또는 특수문자 입력불가");
            return false;
         }
         
         if(isNaN(Number(CRD_NO)) || regExp.test(CRD_NO)){
            alert("카드번호에 문자 또는 특수문자 입력불가");
            return false;
         }
         
         if(CRD_NO == '0000000000000000'){
            alert("카드번호는 0000-0000-0000-0000이 될수 없습니다.");
            return false;
         }
      
      } //카드 if end
      
      
      //최유정
      if(PNT_STLM_AMT != '' && AVB_PNT != ''){
         if(Number(PNT_STLM_AMT) < 100){
            alert("포인트는 100점 이상 사용가능합니다.");
            return false;
         }
         if(Number(AVB_PNT) < Number(PNT_STLM_AMT)){
            alert("포인트사용액은 포인트 가능액보다 작아야됩니다.");
            return false;
         }
         if(isNaN(Number(PNT_STLM_AMT)) || regExp.test(PNT_STLM_AMT)){
            alert("포인트사용액에 문자 또는 특수문자 입력불가");
            return false;
         }
      }
//       최유정
      var totSalAmt = $('#TOT_SAL_AMT').text().replace(/,/g,'');
      if((Number(CSH_STLM_AMT)+Number(CRD_STLM_AMT)+Number(PNT_STLM_AMT)) != Number(totSalAmt)) {
         alert("결제금액이 올바르지 않습니다. \n결제할 총금액: "+Number(totSalAmt).toLocaleString()+"\n입력한 총금액: "+(Number(CSH_STLM_AMT)+Number(CRD_STLM_AMT)+Number(PNT_STLM_AMT)).toLocaleString());
//          alert("결제금액이 올바르지 않습니다");
         return false;
      }
      
      return true;
      
      
   }
   
   //undefined false
   function isBlank(value){
      return !value || value.trim().length === 0;
   };
   
   //저장버튼 눌렀을때 수금 등록할 데이터들 ajax처리
   function allDataProcess(){
      
      var requestData = {};
      
      requestData.salDt = $('#SAL_DT').val().replaceAll("-","");  //판매일자
      requestData.salTpCd = $('#SAL_TP_CD').val();             //판매구분
      requestData.custNo = $('#CUST_NO').val();                //고객번호
      
      requestData.cshStlmAmt = ($('#CSH_STLM_AMT').val() == "" ? "0" : $("#CSH_STLM_AMT").val().trim());    //현금
      requestData.crdStlmAmt = ($('#CRD_STLM_AMT').val() == "" ? "0" : $('#CRD_STLM_AMT').val().trim());    //카드금액
      requestData.pntStlmAmt = ($('#PNT_STLM_AMT').val() == "" ? "0" : $('#PNT_STLM_AMT').val().trim());    //포인트사용액
      requestData.vldYm = $('#VLD_YM').val().trim();             //유효일자
      requestData.crdCoCd  = $('#CRD_CO_CD').val().trim();       //카드회사
      requestData.crdNo = $('#cardNum1').val()+$('#cardNum2').val()+$('#cardNum3').val()+$('#cardNum4').val() //카드번호
      
      requestData.totSalAmt = $("#TOT_SAL_AMT").text().trim().replaceAll(",", ""); //총금액
      console.log(requestData.totSalAmt + "히힝히힝");

      
      //상품리스트
      var products = [];
      $('#list > tr').each(function(i, row) {
          var proudct = {};
          var prdCd = $(this).children().eq(2).find('.prdCd_blank').val();	// 상품코드
          var qty = $(this).children().eq(5).children().eq(0).val(); 		// 수량
          
          console.log("@"+prdCd+"::#"+qty);
          if(!isBlank(prdCd) && !isBlank(qty)){
             proudct.prdCd = prdCd;
             proudct.qty = Number(qty);
             products.push(proudct);
          }
       });
       
       if(products.length == 0){
          alert("등록할 상품이 없습니다.");
          return;
       }
       
       requestData.products = products;
       
       console.log(JSON.stringify(requestData)); // 최종. 보낼데이터
       
       $.ajax({
          url:"/admin/management/salInsert",
          type:"post",
          contentType: 'application/json; charset=utf-8',
          data: JSON.stringify(requestData),
            success:function(res){
                alert("수금등록성공");
                window.close();
             },error:function(err){
                var data = JSON.parse(err.responseText);
                alert(data.error.message);
                 console.log("실패");
             }
       }); //ajax end
       
   } //function end
   
   
   //실시간 수량 입력값 계산function
   //상품코드가 없으면 입력 막기 PRD_CD
   //매장재고보다 크면 막기
   function InputLivesalQty(addRowCount){
      console.log("**************************************************************");
      var regExp = /[ \{\}\[\]\/?.,;:|\)*~`!^\-_+┼<>@\#$%&\'\"\\\(\=]/gi; 
      
      var PRD_CD = document.getElementById("PRD_CD"+addRowCount).value; //실시간 상품코드
      var IVCO_QTY = document.getElementById("IVCO_QTY"+addRowCount).innerText; //실시간 매장재고
      
      var qty = document.getElementById("inpSaleQty"+addRowCount).value; //실시간 수량 입력값
      var totalSale = document.getElementById("totalSale"+addRowCount).innerText;//판매금액
      
      var PRD_CSMR_UPR = document.getElementById("PRD_CSMR_UPR"+addRowCount).innerText.replace(/,/g,''); //실시간 소비자가
      //수량*소비자가
      
      var PRD_NM = document.getElementById("PRD_NM"+addRowCount).innerHTML; //상품명
      
      console.log(PRD_NM + '..상품명..');
      console.log(IVCO_QTY + '   <  ' + qty); //재고
      console.log(qty + '..실시간 수량'); //실시간 수량
      
      if(qty == '0'){
         alert("수량 0 입력불가");
         $("#inpSaleQty"+addRowCount).val('');
         document.getElementById("totalSale"+addRowCount).innerHTML = "";
         calQtyAndTotalPrice();
         return false;
      }else if(regExp.test(qty) || isNaN(Number(qty))){
         alert("수량에 문자 입력불가");
         $("#inpSaleQty"+addRowCount).val('');
         document.getElementById("totalSale"+addRowCount).innerHTML = "";
         calQtyAndTotalPrice();
         return false;
      }
      
      if( (PRD_CD == '' || PRD_CD == null) || (PRD_NM == '' || PRD_NM == null)){
         alert("상품을 선택해주세요.");
         deletePrdCdRow(addRowCount);
         
         return false;
      }else if(Number(IVCO_QTY) < Number(qty)){
         console.log("재고이하의 수량을 입력하세요");
         alert("재고이하의 수량을 입력하세요");
         $("#inpSaleQty"+addRowCount).val('');
         $("#totalSale"+addRowCount).text('');
         calQtyAndTotalPrice();
         return false
      }else{
         //판매금액에 수량*소비자가 넣기
         document.getElementById("totalSale"+addRowCount).innerHTML = (qty * PRD_CSMR_UPR).toLocaleString();
         calQtyAndTotalPrice();
      }

   }
   
   //판매수량 판매금액 계산
   function calQtyAndTotalPrice(){
      var TOT_SAL_QTY = 0; // 판매수랑 합계
      var TOT_SAL_AMT = 0; // 판매금액 합계
      var my_tbody = document.getElementById('list');
      var lastRow = my_tbody.rows.length;
      
      // 합계 행의 전체 판매수량/판매금액을 구한다
      // for문은 불가 : 증가하는 인덱스 값으로 고유한 아이디와 동일하게 만들 수 없음
      // 반복문 사용 O, for X (i 값을 사용해서 기준 행수 만큼 반복), each O (i 값은 있으나 기준 행수가 불필요)
      // each : 배열 > [].each(function() {});
      // each : 배열 > $(document).each([], function() {});
      // each : 배열 > $.each([], function() {});
      // 전체 행의 수량/금액 구한다
      $("input:checkbox[name='checkSal']").each(function(i, k){ //
         
         var tr = k.parentElement.parentElement;  //tr
            var td = tr.children;    //td
            
            TOT_SAL_QTY += Number(td[5].children[0].value); //수량합계
            TOT_SAL_AMT += Number(td[7].innerText.replace(/,/g,'')); // 판매금액합계
      });
      
      document.getElementById("TOT_SAL_QTY").innerHTML = TOT_SAL_QTY; 
      document.getElementById("TOT_SAL_AMT").innerHTML = TOT_SAL_AMT.toLocaleString();
   }
   
   
   //고객번호 팝업창 눌렀을때
   function SearchPopUp(){
      var CUST_NM = $("#CUST_NM").val(); // 고객번호 or 고객명 들어올거임
      

      
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
               $("#AVB_PNT").val(res[0].avb_PNT); // 가용포인트
               $('.custSheild_sw').addClass('custSheild');
               custResetSheildClickEvent(); //고객번호 쉴드
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
   
   ///admin/popUp/csCustSearchPopUp
   //고객번호 팝업창 호출
   function csCustSearchPopUp(CUST_NM){
      
      $("input#custNmP").val(CUST_NM);  // input(hidden)에 넣어준다.
      
      window.name="csCustSearchPopUp"; //부모창 이름
      openWin = window.open('/admin/popUp/csCustSearchPopUp','ch_child','width=640,height=500,scrollbars=yes,top=100,left=40,resizable=yes');         
      
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
   
   //고객번호 쉴드
   function custResetSheildClickEvent(){
	   $(".custSheild").off().on('click',function(){
		   if(confirm('입력하신 고객 정보가 삭제될수 있습니다. \n그래도 다른고객을 조회하시겠습니까?')){
			   $(this).removeClass('shield');
			 deleteCustInfo();
		   }
	   });
   }
   
   //고객번호 변경시. 쉴드처리 해제처리
   // 1.결제금액 값 모두 비우기처리
   // 2.상품입력값 다 지우기
   // 3.상품코드의 쉴드처리 다 지우기
   function deleteCustInfo(){
		   
	  $("#CUST_NO").val(''); //고객번호
	  $("#CUST_NM").val(''); //고객명
	  $("#resetForm")[0].reset();

	  $(".custSheild").removeClass("custSheild"); //고객번호 쉴드처리 삭제
	  
	  $("#list > tr").each(function(){
		  $("[id^='PRD_NM']").text('');  	   	//상품명
		  $("[id^='IVCO_QTY']").text(''); 	   	//매장재고
		  $("[id^='PRD_CSMR_UPR']").text('');  	//소비자가
		  $("[id^='totalSale']").text('');  	//판매금액
		  $("[id='TOT_SAL_QTY']").text('');  	//총판매수량
		  $("[id='TOT_SAL_AMT']").text('');  	//총판매금액
		  
		  //카드값 disabled처리
          $("#VLD_YM").attr("disabled", true); //설정
    	  $("#CRD_CO_CD").val(''); //고객명

          $("#CRD_CO_CD").attr("disabled", true); //설정
          $("#cardNum1").attr("disabled", true); //설정
          $("#cardNum2").attr("disabled", true); //설정
          $("#cardNum3").attr("disabled", true); //설정
          $("#cardNum4").attr("disabled", true); //설정
		  
		  $(this).find(".shield_sw").removeClass('shield'); //상품코드에 쉴드처리 삭제
	  }); //each end
	   
   } //function end
   
   //상품코드 쉴드
   function resetSheildClickEvent(){
	   
      $('.shield').off().on('click',function(){
         if(confirm('다른 상품을 검색 하시겠습니까?')){
        	 
            var addRowCount =$(this).attr('data-addrowcount');
            $(this).parent().find('.prdCd_blank').val('');
            $(this).removeClass('shield');
            deletePrdCdRow(addRowCount);
            
         } //if end
      }); 
      
   }//function end
   
   //해당 행의 값을 모두 삭제하고 쉴드쳐져 있으면 지우기
   function deletePrdCdRow(addRowCount){
      
        $('#PRD_CD'+addRowCount).val('');        //상품코드
        $('#PRD_NM'+addRowCount).text('');         //상품명
        $('#IVCO_QTY'+addRowCount).text('');     //매장재고
        $('#inpSaleQty'+addRowCount).val('');    //수량
        $('#PRD_CSMR_UPR'+addRowCount).text(''); //소비자가
        $('#totalSale'+addRowCount).text('');     //판매금액
        
        $("#sheildRowCount"+addRowCount).removeClass('shield');
//         $(this).removeClass('shield');
//         $('#PRD_CD'+addRowCount).find(".shield_sw").removeClass('shield'); //쉴드해제.최유정
//         $("#list").find(".shield_sw").removeClass('shield'); //첫번째 쉴드해제
        calQtyAndTotalPrice(); // 수량,합계 계산
   }
   
   //상품코드 중복체크
   function prdCdDuplicateCheck(res){
	   console.log(res);
       var prtCount = 0;
       var resData = res[0]; // 하나의. 상품정보가 담겨있음
       
		  //상품 중복 등록 확인
       $('#list > tr').each(function(idx, item) {
     	  console.log("뭐하냐..1");
     	   var trPrdCd = $(this).find('.prdCd_blank').val(); //input에 상품코드
     	   var trPrcNm = $(this).find("td:eq(3)").text();   //상품명
     	   console.log(trPrdCd+"........"+trPrcNm);
     	   
     	   if( trPrdCd != '' && trPrcNm != '' ){
     	     if(trPrdCd == resData.prd_CD || trPrcNm == resData.prd_NM){
     	  		console.log("뭐하냐..2");
				    
				prtCount++;
     	    	
				return false; // each문 종료 (breack)
     	     }
		   } // if end
       }); //each end
       
      console.log(prtCount+'중복체크 함수.......');
       
       return prtCount;
       
   }//function end
   
   
   var PRD_CD ;
   //매장재고조회 팝업창 눌렀을때
   function ivcoSearch(paramPrdCd, addRowCount, target){
      
      PRD_CD = paramPrdCd.value.trim(); //실시간 상품코드
      
         $.ajax({
              url : "/admin/management/ivcoSearch"
            , type : "post"
            , data : {
                 PRD_CD
                ,PRT_CD
             }
            ,success:function(res){
               console.log(res);
               
               var PRD_CD = "PRD_CD"+addRowCount;           //상품코드
               var PRD_NM = "PRD_NM"+addRowCount;           //상품명
               var IVCO_QTY = "IVCO_QTY"+addRowCount;         //매장재고
               var PRD_CSMR_UPR = "PRD_CSMR_UPR"+addRowCount;  //소비자가
               
               if(res.length == 1){
            	  //상품이 이미 등록되어 있는지 확인
                  var prtCount = 0;
                  var resData = res[0];
//                   	debugger;
				  var trLength = $("#list > tr").length;
				  
				  //상품코드 중복체크 함수
				  prdCdDuplicateCheck(res);
				  var prdCount =  prdCdDuplicateCheck(res);
				  
				  
				  console.log("ㅋㅋㅋ" + prdCount);
// 				  return ;
				  console.log("ㅋㅋㅋ");
				  
				  // 중복이 있는경우 해당 행의 값들을 초기화 처리
				  if(prdCount > 0) {
					  alert("이미 동록된 상품입니다.");
// 					  $('#PRD_CD'+addRowCount).val('');

					  deletePrdCdRow(addRowCount);
					  return;
				  }
                  
				  //견본품 등록 불가 검증
                  if(resData.prd_TP_CD == '20'){
                      alert("견본품은 선택불가");
                      $('#PRD_CD'+addRowCount).val('');
                      return;
                   }
				  
                  //해지 상품 등록 불가 검증
                  if(resData.prd_SS_CD != 'R'){
                      alert("해지상품 선택불가");
                      $('#PRD_CD'+addRowCount).val('');
                      return;
                   }
                  
                  //소비자가 0원 이하인 상품 등록 불가 검증
                  if(resData.prd_CSMR_UPR < 1){
                      alert("소비자가 0 이하인 상품 선택불가");
                      $('#PRD_CD'+addRowCount).val('');
                      return;
                   }
                  
                  //제고수량이 0 이하인 상품등록 불가 검증
                  if(resData.ivco_QTY < 1){
                      alert("재고수량이 0 이하인 상품 선택불가");
                      $('#PRD_CD'+addRowCount).val('');
                      return;
                   }
                  

                  
                  $('#PRD_CD'+addRowCount).val(resData.prd_CD); // 상품코드 innerText하여 text변경
                  $('#PRD_NM'+addRowCount).text(resData.prd_NM);// 상품명 
                  $('#IVCO_QTY'+addRowCount).text(resData.ivco_QTY); // 매장재고
                  $('#PRD_CSMR_UPR'+addRowCount).text(resData.prd_CSMR_UPR.toLocaleString()); // 소비자가
                   $(target).parent().find('.shield_sw').addClass('shield');
                   resetSheildClickEvent();
                  return true;
               
               }else if(res.length == 0){
                  alert("검색결과가 존재하지 않습니다.");
                  ivcoSearchPop(paramPrdCd.value, PRT_CD, addRowCount); //실시간입력값, 매장코드
               }else if(res.length > 1){
                  ivcoSearchPop(paramPrdCd.value, PRT_CD, addRowCount); //실시간입력값, 매장코드
               }
            },error:function(res){
               alert("상품검색 실패");
            }
            
            
         });
   }
   
   //재고 팝업창 실행..
   function ivcoSearchPop(PRD_CD, PRT_CD, addRowCount){
         
         $("#hidden_PRD_CD").val(PRD_CD);  // input(hidden)에 넣어준다.
         $("#hidden_PRT_CD").val(PRT_CD);  // input(hidden)에 넣어준다.
         $("#hidden_ivco_addRowCount").val(addRowCount);  // input(hidden)에 넣어준다.
         
         window.name="ivcoSearchPopUp"; //부모창 이름
         openWin = window.open('/admin/management/popUp/ivcoSearchForm','ch_child','width=700,height=500,scrollbars=yes,top=100,left=40,resizable=yes');
   }
   

   
   //상품코드 입력후 엔터
   function prdEenterkey(paramPrdCd, addRowCount, target){
         if (window.event.keyCode == 13) {
            if(paramPrdCd==""){
               alert("검색값을 입력하세요.")
            }else if(paramPrdCd.length<2){
               alert("두자리이상 입력 필수")
            }else{
               ivcoSearch(paramPrdCd, addRowCount, target);
            }
         }
         
         if(window.event.keyCode == 8 || window.event.keyCode == 46) {          // 백스페이스(8) 또는 Delete(46)키를 입력했을 경우
             var prd_cd = $(paramPrdCd).val();
             if(prd_cd == '') {
                  deletePrdCdRow(addRowCount);
//                   $('#PRD_CD'+addRowCount).find(".shield_sw").removeClass('shield'); //쉴드해제.최유정
	
                  $("#sheildRowCount"+addRowCount).removeClass('shield'); //쉴드해제.최유정
				}
          }
   }
   
   var addRowCount = 1 ;  //id 유니크하게
   
   // +버튼 누를시 행추가 function()
   function add_row(){
      var minusCount ; //현재마지막행+1 해준값
      
      var rows = document.getElementById("list").getElementsByTagName("tr"); //tr갯수
       
       minusCount = rows.length + 1;
      
      
      var my_tbody = document.getElementById('list');
       // var row = my_tbody.insertRow(0); // 상단에 추가
       var row = my_tbody.insertRow( my_tbody.rows.length ); // 하단에 추가
       var cell0 = row.insertCell(0); //선택
       var cell1 = row.insertCell(1); //번호
       var cell2 = row.insertCell(2); //상품코드
       
       var cell3 = row.insertCell(3); //상품명
       var cell4 = row.insertCell(4); //매장재고
       var cell5 = row.insertCell(5); //판매수량
       var cell6 = row.insertCell(6); //소비자가
       var cell7 = row.insertCell(7); //판매금액
       
       var paramPrdCd = "PRD_CD"+addRowCount;
       
       cell0.innerHTML = '<input type="checkbox" name="checkSal" id="cellCh'+addRowCount+'"/>'; //선택(체크박스)
       cell1.innerHTML = '<td>'+minusCount+'</td>';              //번호rowNum
       cell2.innerHTML = '<td><div style="position: relative"><input class="prdCd_blank" id="PRD_CD'+addRowCount+'" type="text"  onkeyup="prdEenterkey('+paramPrdCd+','+addRowCount+', this)"/>'      //상품코드
                   + '<button type="button" onclick="ivcoSearch('+paramPrdCd+','+addRowCount+');">'     //상품코드 팝업창
                   + '<img class="searchBtn" src="https://s3.ap-northeast-2.amazonaws.com/cdn.wecode.co.kr/icon/search.png">'
                   + '</button> <div data-addRowCount='+addRowCount+' class="shield_sw" id="sheildRowCount'+addRowCount+'"></div></div></td>';
                   
       cell3.innerHTML = '<span id="PRD_NM'+addRowCount+'"></span>'; //상품명(사용자입력)
       cell4.innerHTML = '<span id="IVCO_QTY'+addRowCount+'"></span>'; //매장재고
       cell5.innerHTML = '<input id="inpSaleQty'+addRowCount+'" name="lo_right" type="text" onkeyup="InputLivesalQty('+addRowCount+')"/>'; //판매수량 (사용자입력)
       cell6.innerHTML = '<span id="PRD_CSMR_UPR'+addRowCount+'" name="lo_right" ></span>'; //소비자가
       cell7.innerHTML = '<span id="totalSale'+addRowCount+'" name="lo_right" ></span>'; //판매금액  (판매수량*소비자가 합산금액).동적
       
       addRowCount++;
   }
   
   
   //행삭제
   function delete_row(){
      var my_tbody = document.getElementById('list');
      var lastRow = my_tbody.rows.length;
      var ReSalSum = 0; //행삭제후 판매금액 재계산
      if($("input:checkbox[name='checkSal']:checked").length === 0){
         alert("삭제할 행을 선택해주세요.");
         return false;
      }else{
         
         // 삭제할 행들에 대해서 삭제 처리
         $("input:checkbox[name='checkSal']:checked").each(function(event, k){ //체크가 된 것들

            var clickedRowTr = $(this).parent().parent(); //tr
                
               //테이블전체에서 번호 찾기
                var first_row_number = $("#list").find("td:eq(1)").text(); //번호 1찍힘
                //체크된행의 번호 찾기
                var clickedRow_number = clickedRowTr.children().eq(1).text(); //체크된 번호들
                
                
                if(first_row_number == clickedRow_number){ //체크된 번호가 1번이면 
	               $("#PRD_CD1").val("");
	               $("#PRD_NM1").text(""); // 상품명 
	               $("#IVCO_QTY1").text("");//매장재고
	               $("#inpSaleQty1").val("")//판매수량
	               $("#PRD_CSMR_UPR1").text("");//소비자가
	               $("#totalSale1").text("");//판매금액
	               
	               $("input:checkbox[id='cellCh1']").prop("checked", false); //첫번째 체크해제
	               $("#list").find(".shield_sw").removeClass('shield'); //쉴드해제.최유정
                }else{
                    var tr = k.parentElement.parentElement;
                    $(tr).remove();
                    
                }  
         });
         
         calQtyAndTotalPrice(); // 수량,합계 계산
         
         // -버튼으로 삭제후 틀어지는 순번 
         // 전체 행의 번호를 다시 매기는 function()
         $("input:checkbox[name='checkSal']").each(function(i, k){
            
               var tr = k.parentElement.parentElement;  //tr
               var td = tr.children;    //td
                
               console.log('i : ' + i);
               console.log(td);
               console.log('td[1].innerText : ' + td[1].innerText);
               console.log('(i+1) : ' + (i+1));
               td[1].innerText = (i+1);
         });
      }
      
   } //function end
   
   
</script>
<title>고객판매수금등록</title>
</head>
<body>
<h1>고객판매수금등록</h1>
   <div>
      <form id="allDataProcess">
         <input type="hidden" id="HH_PRT_CD" name="PRT_CD"/>
      </form>
   
      <form >
      <!-- 고객번호or고객명 입력값 넣어줌- 팝업창으로 던질거 -->
      <input type="hidden" id="custNmP" name="custNmP" value="" onsubmit="return false;"/>
      
      <!-- 매장재고 조회 -->
      <input type="hidden" id="hidden_PRD_CD" name="hidden_PRD_CD"/>
      <input type="hidden" id="hidden_PRT_CD" name="hidden_PRT_CD"/>
      <input type="hidden" id="hidden_ivco_addRowCount" name="hidden_ivco_addRowCount"/>
         <table class="tableOne">
            <thead>
            <tr>
                  <td>
                     <label><i>*</i>판매일자</label>
                  </td>
                  <td>
                     <input class="blank_key" type="date" id="SAL_DT" name="SAL_DT" value="" readonly="readonly" />
                  </td>
                  <td>
                     <label><i>*</i>판매구분</label>
                  </td>
                  <td>
                     <select class="blank_key" id="SAL_TP_CD" name="SAL_TP_CD" readonly="readonly">
                        <option value="SAL" >판매</option>
                     </select>
                  </td>
            </tr>
            
            <tr>
                  <td>
                     <label><i>*</i>고객번호</label>
                  </td>
                  <td>
                     <div style="position: relative">
                     <input class="blank_key" type="text" id="CUST_NO" name="CUST_NO" value="" disabled/>
                     	<button type="button" onclick="SearchPopUp();"><img class="searchBtn" src="https://s3.ap-northeast-2.amazonaws.com/cdn.wecode.co.kr/icon/search.png"> </button>               
                     	<input type="text" class="blank_key" id="CUST_NM" name="CUST_NM" value="" onkeyup="csCustEenterkey()" placeholder=""/>
                     	<div class="custSheild_sw"></div>
                     </div>
                  </td>
                  <td>
               </tr>
            </thead>
         </table>
		 </form>
         <h3>결제금액</h3>
         <form id="resetForm">
         <table class="tableT">
            <tr>
               <td class="tableT_title">현금</td>
               <td><input type="text" id="CSH_STLM_AMT" name="CSH_STLM_AMT" /></td>
               
               <td class="tableT_title">카드금액</td>
               <td><input type="text" class="backCRD" id="CRD_STLM_AMT" name="CRD_STLM_AMT" /></td>
               
               <td class="tableT_title">포인트사용액</td>
<!--                <td><input type="text" id="PNT_STLM_AMT" name="PNT_STLM_AMT" onkeyup="pointUseR()"/></td> -->
               <td><input type="text" id="PNT_STLM_AMT" name="PNT_STLM_AMT"/></td>
            </tr>   
                        
            <tr>
               <td class="tableT_title">유효일자</td>
               <td><input type="text" id="VLD_YM" name="VLD_YM" maxlength="6" disabled="disabled" placeholder="MMYYYY"/></td>
               
               <td class="tableT_title">카드회사</td>
               <td>
                  <select id="CRD_CO_CD" name="CRD_CO_CD" class="crdCOS" disabled="disabled">
                     <option value="">--선택--</option>
                     <c:forEach var="code" items="${crdCO}">
                        <option value="${code.DTL_CD}">${code.DTL_CD_NM}</option>
                     </c:forEach>
                  </select>
               </td>
               
               <td class="tableT_title">포인트가능액</td>
               <td><input class="pntReadOnly" type="text" id="AVB_PNT" name="AVB_PNT" readonly="readonly"/></td>
            </tr>
            <tr>
               <td class="tableT_title">카드번호</td>
               <td><input class="cardB" id="cardNum1" name="CRD_NO" type="text" maxlength="4" disabled="disabled"/></td>
               <td><input class="cardB" id="cardNum2" name="CRD_NO" type="text" maxlength="4" disabled="disabled"/></td>
               <td><input class="cardB" id="cardNum3" name="CRD_NO" type="text" maxlength="4" disabled="disabled"/></td>
               <td><input class="cardB" id="cardNum4" name="CRD_NO" type="text" maxlength="4" disabled="disabled"/></td>
            </tr>               
         </table>
         <div>
            <input type="button" onclick="add_row()" id="saBtn" name="" value="+">
            <input type="button" onclick="delete_row()" id="saBtn" name="" value="-">
         </div>
         <div class="memberList_list">
            <table class="memberList_listTable">
               <thead class="memberList_thead">
                  <tr>
                     <th class="tfirst">선택</th>
                     <th>번호</th>
                     <th>상품코드</th>
                     <th>상품명</th>
                     <th>매장재고</th>
                     <th>판매수량</th>
                     <th>소비자가</th>
                     <th>판매금액</th>
                  </tr>
               </thead>
               <tbody class="tbodySal" id="list">
<!--                   <tr> -->
<!--                      <td><input type="checkbox"/></td> -->
<!--                      <td>test</td> -->
<!--                      <td> -->
<!--                         <input type="text" id="" name=""/> -->
<!--                         <button type="button"><img class="searchBtn" src="https://s3.ap-northeast-2.amazonaws.com/cdn.wecode.co.kr/icon/search.png"></button> -->
<!--                      </td> -->
<!--                      <td>test</td> -->
<!--                      <td>test</td> -->
<!--                      <td><input type="text"/></td> -->
<!--                      <td>소비자가</td> -->
<!--                      <td>판매금액</td> -->
<!--                   </tr> -->
               </tbody>
               <tr>
                  <td colspan="5">합계</td>
<!--                   <td colspan="3" id="sumSal"> -->
<!--                      <label class="tCent">판매수량 : <span id="TOT_SAL_QTY"></span> /</label> -->
<!--                      판매금액 : <span id="TOT_SAL_AMT"></span> -->
<!--                   </td> -->
                  <td id="sumSal"><span id="TOT_SAL_QTY"></span>
                  </td>
                  <td></td>
                  <td>
                     판매금액 : <span id="TOT_SAL_AMT"></span>
                  </td>
               </tr>
            </table>
            
         </div>
      </form>
   </div>
   
   <div class="footerBtn">
      <input type="button" id="close" value="닫기" onclick="window.close()"/>
      <input type="button" id="salRegistBtn" value="저장" />
   </div>

</body>
</html>