package com.dowell.commons;

import java.util.Calendar;
import java.util.regex.Pattern;

import org.springframework.util.StringUtils;

import com.dowell.admin.dao.AdminDAO;

import lombok.extern.log4j.Log4j;

/**
  * @package_name : com.dowell.commons	
  * @FileName : Masking.java
  * @Date : 2022. 9. 12. 
  * @작성자 : 최유정
  * @변경이력 :
  * @프로그램 설명 : 단어중간 마킹처리, 휴대폰 하이픈, 휴대폰 마킹처리
  */

@Log4j
public class Masking {
	
	/**
	 * 월 마지막날 가져오기
	 * @param yyyyMM
	 * @return
	 */
	public static String getLastDateOfMonth(String yyyyMMdd) {	
		String year = yyyyMMdd.substring(0,4);
		String month = yyyyMMdd.substring(6,7);
		
		Calendar cal = Calendar.getInstance();
		cal.set(Integer.parseInt(year),Integer.parseInt(month)-1,1);
		
		String lastDay = Integer.toString(cal.getActualMaximum(Calendar.DAY_OF_MONTH));
		
		return lastDay;
	}
	
	
	public static String midMasking(String userName) {
		
		//사용자 이름 첫글자
		String frsName = userName.substring(0,1);
		
		//사용자이름 중간글자
		String midName = userName.substring(1, userName.length()-1);
		
		//사용자 이름중간글자 마스킹
		String cnvMidName = "";
		for(int i=0; i<midName.length(); i++) {
			cnvMidName +="*";
		}
		
		//사용자 이름 마지막 글자
		String lstName = userName.substring(userName.length()-1, userName.length());
		
		//마스킹 완성된 사용자 이름
		String maskingName = frsName + cnvMidName + lstName;
		
		return maskingName;
	}
	
	
	/**
	 * 이름 마킹처리하는 메서드
	 *  
	 *  ex) 김민       ->  최*
	 *      김민수    ->  김*수
	 *      김아무개 ->  김**개
	 * 
	 * */
	public static String nameMasking(String name) throws Exception {
		// 한글만 (영어, 숫자 포함 이름은 제외)
//		String regex = "(^[가-힣]+)$";
//		
//		Matcher matcher = Pattern.compile(regex).matcher(name);
//		if(matcher.find()) {
			int length = name.length();
			
			String middleMask = "";
			if(length > 2) {
				middleMask = name.substring(1, length - 1);
			} else {	// 이름이 외자
				middleMask = name.substring(1, length);
			}
			
			String dot = "";
			for(int i = 0; i<middleMask.length(); i++) {
				dot += "*";
			}
			
			if(length > 2) {
				return name.substring(0, 1)
						+ middleMask.replace(middleMask, dot)
						+ name.substring(length-1, length);
			} else { // 이름이 외자 마스킹 리턴
				return name.substring(0, 1)
						+ middleMask.replace(middleMask, dot);
			}
//		}
//		return name;
	}
	
	
	
	/**
	 *  휴대폰or전화번호 하이픈 넣는 메서드
	 *  
	 * */
	public static String convertTelNo(String src) {

		String mobTelNo = src;

		if (mobTelNo != null) {
			// 일단 기존 - 전부 제거
			mobTelNo = mobTelNo.replaceAll(Pattern.quote("-"), "");

			if (mobTelNo.length() == 11) {
				// 010-1234-1234
				mobTelNo = mobTelNo.substring(0, 3) + "-" + mobTelNo.substring(3, 7) + "-" + mobTelNo.substring(7);

			} else if (mobTelNo.length() == 8) {
				// 1588-1234
				mobTelNo = mobTelNo.substring(0, 4) + "-" + mobTelNo.substring(4);
			} else {
				if (mobTelNo.startsWith("02")) { // 서울은 02-123-1234
					mobTelNo = mobTelNo.substring(0, 2) + "-" + mobTelNo.substring(2, 5) + "-" + mobTelNo.substring(5);
				} else { // 그외는 012-123-1345
					mobTelNo = mobTelNo.substring(0, 3) + "-" + mobTelNo.substring(3, 6) + "-" + mobTelNo.substring(6);
				}
			}

		}
		return mobTelNo;
	}
	
	
	
	
	
	/**
	 * 휴대폰번호 마스킹 
	 * 
	 * 10자리인 경우. 000-***-0000로 지환
	 * 11자리인 경우. 000-****-0000로 지환
	 * 변환 실패시 입력값 그대로 리턴
	 * */
	public static String maskingPhoneNumber(String phoneNumber){
	    try{
	        if(StringUtils.isEmpty(phoneNumber)){
	            return phoneNumber;
	        }

	        phoneNumber = phoneNumber.replaceAll("[^0-9]",""); // 숫자만 추출

	        if(!(phoneNumber.length() == 10 || phoneNumber.length() == 11)){
	            return phoneNumber;
	        }

	        if(phoneNumber.length() == 10){         // 10자리인 경우. 000-***-0000로 지환
	            return phoneNumber.substring(0, 3) + "-***-" + phoneNumber.substring(6, 10);
	        }else if(phoneNumber.length() == 11){   // 11자리인 경우. 000-****-0000로 지환
	            return phoneNumber.substring(0, 3) + "-****-" + phoneNumber.substring(7, 11);
	        }
	    }catch (Exception e){
	        log.error(e.toString());
	    }

	    return phoneNumber;
	}
	
		
		/**
		 *  날짜형식 하이픈 넣기 
		 *  ex) 20200112 -> 2020-01-12
		 * 
		 * */
	 	public static String getDate(String str) {
	        
	        if(str == null) {
	            return str;
	        }
	        
	        int size = str.length();
	        
	        if(size==4) {
	            return str;
	        }else if(size==6) {
	            str = str.substring(0,4)+"-"+str.substring(4,6);
	        }else if(size==8) {
	            str = str.substring(0,4)+"-"+str.substring(4,6)+"-"+str.substring(6,8);
	        }else {
	            return str;
	        }
	        
	        return str;
	        
	    }
	 


}
