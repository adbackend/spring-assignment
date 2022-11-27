package com.dowell.commons.exception;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.sql.SQLIntegrityConstraintViolationException;

import javax.servlet.http.HttpServletRequest;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import com.dowell.commons.domain.Error;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestControllerAdvice
public class DowellExceptionHandler {

	@ExceptionHandler(DowellException.class)
	public ResponseEntity dowellException(DowellException dowellException, HttpServletRequest httpServletRequest) {
		Error error = Error.builder().error(Error.Value.builder().code(dowellException.getCode()).message(dowellException.getMessage()).build()).build();
		return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(error);
	}
	
//	@ExceptionHandler(Exception.class)
//	public ResponseEntity dowellException(Exception exception, HttpServletRequest httpServletRequest) {
//		log.error(stackTrace(exception));
//		Error error = Error.builder().error(Error.Value.builder().code("WOD4W").message("잠시후 다시 시도해주세요.").build()).build();
//		return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
//	}
	
	@ExceptionHandler(SQLIntegrityConstraintViolationException.class)
	public ResponseEntity dowellException(SQLIntegrityConstraintViolationException exception, HttpServletRequest httpServletRequest) {
		log.error(stackTrace(exception));
		Error error = Error.builder().error(Error.Value.builder().code("WOD4W").message("데이터가 올바르지 않아 반품처리 할수 없습니다.\n(무결성 제약조건 위배)").build()).build();
		return ResponseEntity.status(HttpStatus.CONFLICT).body(error);
	}
	
	@ExceptionHandler(IndexOutOfBoundsException.class)
	public ResponseEntity dowellException(IndexOutOfBoundsException exception, HttpServletRequest httpServletRequest) {
		System.out.println("무결성 실패....");
		log.error(stackTrace(exception));
		
		Error error = Error.builder().error(Error.Value.builder().code("WOD4W").message("조회할 데이터가 올바르지 않습니다.(Index 0 out of bounds for length 0)").build()).build();
		return ResponseEntity.status(HttpStatus.CONFLICT).body(error);
	}
	
	
	public String stackTrace(Throwable t) {
		StringWriter sw = new StringWriter();
		t.printStackTrace(new PrintWriter(sw));
		return sw.toString();
	}
}