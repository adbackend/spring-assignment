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
<c:set var="genders" value="${codes['SEX_CD']}"/> 			<!-- 성별 -->
<c:set var="scalYN" value="${codes['SCAL_YN']}"/> 			<!-- 양음력구분 -->
<c:set var="pocCd" value="${codes['POC_CD']}"/> 			<!-- 직업상태 -->

<c:set var="psmtGrcCd" value="${codes['PSMT_GRC_CD']}"/>	<!-- 우편물수령 -->
<c:set var="custSsCd" value="${codes['CUST_SS_CD']}"/>	<!-- 고객상태코드 -->
															
<c:set var="emailYN" value="${codes['EMAIL_RCV_YN']}"/> 	<!-- 이메일수신동의여부 -->
<c:set var="smsYN" value="${codes['SMS_RCV_YN']}"/> 		<!-- SMS수신동의여부 -->
<c:set var="dmYN" value="${codes['DM_RCV_YN']}"/> 			<!-- DM수신동의여부 -->
<script type="text/javascript">
   
   
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
   	  <input type="hidden" id="CUST_NO_A" 	     name="CUST_NOA" 	value=""/><!--  고객번호-->
   	  <input type="hidden" id="CUST_NM_A" 	     name="CUST_NM" 	value=""/><!-- 고객명 -->
   	  <input type="hidden" id="BRDY_DT_A" 	     name="BRDY_DT" 	value=""/><!-- 생년월일 -->
   	  <input type="hidden" id="SEX_CD_A" 		 name="SEX_CD" 		value=""/><!-- 성별 -->
   	  <input type="hidden" id="SCAL_YN_A" 	     name="SCAL_YN" 	value=""/><!-- 양음력구분 -->
   	  
   	  <input type="hidden" id="MRRG_DT_A" 	 	 name="MRRG_DT" 	value=""/><!-- 결혼기념일 -->
   	  <input type="hidden" id="POC_CD_A" 		 name="POC_CD" 		value=""/><!-- 직업코드 -->
   	  
   	  <input type="hidden" id="MBL_NO_A" 	     name="MBL_NO" 		value=""/><!-- 휴대폰 -->
   	  
   	  
   	  <input type="hidden" id="mblF_A" 	     name="mblF_A" 		value=""/><!-- 휴대폰 -->
   	  <input type="hidden" id="mblS_A" 	     name="mblS_A" 		value=""/><!-- 휴대폰 -->
   	  <input type="hidden" id="mblT_A" 	     name="mblT_A" 		value=""/><!-- 휴대폰 -->
   	  
   	  
   	  
   	  <input type="hidden" id="PSMT_GRC_CD_A"    name="PSMT_GRC_CD" value=""/><!-- 우편물수령코드 -->
   	  <input type="hidden" id="EMAIL_A" 		 name="EMAIL" 		value=""/><!-- 이메일주소 -->
   	  <input type="hidden" id="ZIP_CD_A" 		 name="ZIP_CD" 		value=""/><!-- 우편번호코드 -->
   	  <input type="hidden" id="ADDR_A" 		     name="ADDR" 		value=""/><!-- 주소 -->
   	  <input type="hidden" id="ADDR_DTL_A" 	     name="ADDR_DTL" 	value=""/><!-- 상세주소 -->
   	  <input type="hidden" id="CUST_SS_CD_A" 	 name="CUST_SS_CD" 	value=""/><!-- 고객상태코드 -->
   	  <input type="hidden" id="CNCL_CNTS_A" 	 name="CNCL_CNTS" 	value=""/><!-- 해지사유내용 -->
   	  <input type="hidden" id="JN_PRT_CD_A" 	 name="JN_PRT_CD" 	value=""/><!-- 가입매장코드 -->
   	  <input type="hidden" id="EMAIL_RCV_YN_A" 	 name="EMAIL_RCV_YN" value=""/><!-- 이메일수신동의여부 -->
   	  <input type="hidden" id="SMS_RCV_YN_A" 	 name="SMS_RCV_YN"  value=""/><!-- SMS수신동의여부 -->
   	  <input type="hidden" id="DM_RCV_YN_A"      name=DM_RCV_YN 	value=""/><!-- DM수신동의여부 -->
<!--    	  <input type="hidden" id="PRT_NM_A" 	 	 name="PRT_NM" 		value=""/>가입매장 --><!-- 필요없음 -->
   	  <input type="hidden" id="CNCL_DT_A" 	 	 name="CNCL_DT" 	value=""/><!-- 해지일자 -->

   	  <input type="hidden" id="STP_DT_A" 	 	 name="STP_DT" 	value=""/><!-- 중지일자 -->
   	  
   	  
   	  
   	  
   	  
   </form>
   	  
   	  <!-- ####실시간#### -->
      <form id="custInfoForm"> 
		
         <table class="tableON">
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
<%-- 	                        <option class="textVal" value="${code.DTL_CD}" <c:if test='${code.DTL_CD==custInfo.POC_CD}'>selected="selected"</c:if>>${code.DTL_CD_NM}</option> --%>
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
<%--                				<input type="radio" id="${code.CODE_CD}${code.DTL_CD}" name="${code.CODE_CD}" value="${code.DTL_CD}" onclick="sscdValueGet(event)" <c:if test='${code.DTL_CD==custInfo.CUST_SS_CD}'>checked="checked"</c:if> /><c:out value="${code.DTL_CD_NM}"/> --%>
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
<!-- 				<td><button class="cloBtn" type="button" id="" onclick="custInfoCheck()">적용</button></td>		 -->
			</tr>
		</table>
         
      
      </form>
   </div>
   
   
   </div> <!-- .center end -->
</div>      
      
<%@include file="../includes/footer.jsp" %>
</body>
</html>