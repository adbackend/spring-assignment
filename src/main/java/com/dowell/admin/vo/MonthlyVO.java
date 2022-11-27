package com.dowell.admin.vo;

import java.util.List;
import java.util.Map;

import lombok.Data;

@Data
public class MonthlyVO {
	
	private List<CsSal01MtVO> csSal01MtVO;
	
	private Map<String, Integer> monthlySum;

	
	public MonthlyVO(List<CsSal01MtVO> csSal01MtVO, Map<String, Integer> monthlySum) {
		this.csSal01MtVO=csSal01MtVO;
		this.monthlySum=monthlySum;
	}
}
