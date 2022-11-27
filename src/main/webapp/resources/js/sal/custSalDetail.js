$(document).ready(function(){
		var cust_no = opener.$("input#salDetail_1000000359_2022-06-09_2").val(); //부모창에서 #EcustNo인 값을 들고온다(고객번호)
		
		var getParentCustSalDetail = opener.$("input#custDetail").val();
		
		var jsonPasingDetailValue = JSON.parse(getParentCustSalDetail); // object
		
		var prtCd = jsonPasingDetailValue.prt_CD; //매장코드
		var prtNm = jsonPasingDetailValue.prt_NM; //매장명
		
		var custNo = jsonPasingDetailValue.cust_NO; //고객번호
		var custNm = jsonPasingDetailValue.cust_NM; //고객명
		
		var sumSalQty = jsonPasingDetailValue.sum_SAL_QTY; //판매수량
		var totSalAmt = jsonPasingDetailValue.tot_SAL_AMT//판매금액
		var cshStlmAmt = jsonPasingDetailValue.csh_STLM_AMT//현금
		var crdStlmAmt = jsonPasingDetailValue.crd_STLM_AMT//카드
		var pntStlmAmt = jsonPasingDetailValue.pnt_STLM_AMT//포인트
		
		document.getElementById('PRT_CD').innerText = prtCd; // innerText하여 text변경
		document.getElementById('PRT_NM').innerText = prtNm; // innerText하여 text변경
		
		document.getElementById('CUST_NO').innerText = custNo; // innerText하여 text변경
		document.getElementById('CUST_NM').innerText = custNm; // innerText하여 text변경
		
		
		document.getElementById('sumSalQty').innerText = sumSalQty; // innerText하여 text변경
		document.getElementById('totSalAmt').innerText = totSalAmt; // innerText하여 text변경
		document.getElementById('cshStlmAmt').innerText = cshStlmAmt; // innerText하여 text변경
		document.getElementById('crdStlmAmt').innerText = crdStlmAmt; // innerText하여 text변경
		document.getElementById('pntStlmAmt').innerText = pntStlmAmt; // innerText하여 text변경

		console.log(jsonPasingDetailValue);
		console.log(jsonPasingDetailValue.cust_NO);
		console.log(jsonPasingDetailValue.cust_NM);
		
	});


	//상세조회 목록
//	function(){
//		
//	}
