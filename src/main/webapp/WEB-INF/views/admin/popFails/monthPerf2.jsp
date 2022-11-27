<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="/resources/css/content/admin/monthPerf.css" />
<meta charset="UTF-8">
<title>월별실적</title>
</head>

 <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<%-- <%@include file="../includes/header.jsp" %> --%>
<%-- <%@include file="../includes/nav.jsp" %> --%>
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
<script src="//code.jquery.com/jquery.min.js"></script>
<script src="//code.jquery.com/ui/1.11.4/jquery-ui.min.js"></script>
<style>
	.ui-datepicker-calendar {
    	display: none;
    }
    
    
   .table.test1 {
   		overflow-x: auto;
		width: 1600px;
	} 
	.table.test1 thead {
		background-color: lightgrey;
	}
	
	.table.test1 th {
		width: 3%;
	}
	.table.test1 td {
		width: 3%;
	}
    ​
</style>   
 <script type="text/javascript">
        $(function() {
            $('.date-picker-year').datepicker({
                changeYear: true,
                showButtonPanel: true,
                dateFormat: 'yy-mm',
                onClose: function(dateText, inst) { 
                    var year = $("#ui-datepicker-div .ui-datepicker-year :selected").val();
                    $(this).datepicker('setDate', new Date(year, 1));
                }
            });
        $(".date-picker-year").focus(function () {
                $(".ui-datepicker-month").hide();
            });
        });

</script>
<body>
<div class="admin_memberList">

<div class="searchForm">
   <p>매장실적조회</p>

<div>

<label for="startYear"> Start Year: </label>
  <input name="startYear" id="startYear" class="date-picker-year" />  
   <form class="searchM">
      <table class="sTable">
         <thead>
            <tr>
               <td>매출월 <input type="month" id="datepicker1">
               </td>
               <td>
                  <label>매장</label>
                  <input type="text" id="" name="" value="" disabled/>
                  <input type="button" id="" value="팝업검색" onclick="csCustSearchPopUp();" />
                  <input type="text" id="CUST_NO" name="CUST_NO" value="" onkeyup=""/>
               </td>
            </tr>
            <tr>
               <td rowspan="2">
                  <input type="button" value="검색"/>
               </td>
            </tr>
            
         </thead>
      </table>
   </form>
</div>
</div>

      <div class="view">
        <div class="wrapper">
          <table class="table test1">
            <thead>
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
                   <th >19일</th>
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
                    <tr>
                     <td colspan="2">합계</td>
                     <td>1일</td>
                   <td>2일</td>
                   <td>3일</td>
                   <td>4일</td>
                   <td>5일</td>
                   <td>6일</td>
                   <td>7일</td>
                   <td>8일</td>
                   <td>9일</td>
                   <td>10일</td>
                   <td>11일</td>
                   <td>12일</td>
                   <td>13일</td>
                   <td>14일</td>
                   <td>15일</td>
                   <td>16일</td>
                   <td>17일</td>
                   <td>18일</td>
                   <td>19일</td>
                   <td>20일</td>
                   <td>21일</td>
                   <td>22일</td>
                   <td>23일</td>
                   <td>24일</td>
                   <td>25일</td>
                   <td>26일</td>
                   <td>27일</td>
                   <td>28일</td>
                   <td>29일</td>
                   <td>30일</td>
                   <td>31일</td>
                   <td>합계</td>
                   </tr>
            </tbody>
          </table>
        </div>
      </div>
</div>

<%-- <%@include file="../includes/footer.jsp" %> --%>
</body>
</html>