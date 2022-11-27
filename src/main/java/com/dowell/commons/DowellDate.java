package com.dowell.commons;

import java.text.SimpleDateFormat;

/**
  * @package_name : com.dowell.commons	
  * @FileName : DowellDate.java
  * @Date : 2022. 10. 12. 
  * @작성자 : 최유정
  * @변경이력 :
  * @프로그램 설명 : 시간 공통모듈
  */

public class DowellDate {

	public static String format(final long timeMillis, final String dateFormat) {
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat(dateFormat);
		return simpleDateFormat.format(timeMillis);
	}

	public static String nowString(final String dateFormat) {
		return format(System.currentTimeMillis(), dateFormat);
	}
}
