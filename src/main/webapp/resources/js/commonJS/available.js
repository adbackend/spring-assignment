console.log("available module 동작 테스트.......");

var availableService = (function(){
	
	function phoneAvail(phoneNumVal, callback, error){
		
		$.ajax({
			type :'post',
			url : '/admin/phoneOverlap',
			data : phoneNumVal,
			success:function(result, status, err){
				
			},
			error:function(xhr, status, er){
				if(error){
					error(er);
				}
			}
		});
	}
})(); //즉시실행함수