package com.dowell.commons.exception;

public class DowellException extends RuntimeException {

	private String code;
	private String message;

	public DowellException(String message) {
		this.code = "notdefined";
		this.message = message;
	}

	public DowellException(String code, String message) {
		this.code = code;
		this.message = message;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}
}
