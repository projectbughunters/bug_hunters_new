package kr.co.soft.beans;

import java.util.List;

public class PageBean<T> {

	private List<T> list; // 현재 페이지 데이터
	private int currentPage; // 현재 페이지 번호
	private int totalPage; // 전체 페이지 수
	private int pageSize; // 한 페이지당 항목 수
	private int totalCount; // 전체 데이터 개수

	public List<T> getList() {
		return list;
	}

	public void setList(List<T> list) {
		this.list = list;
	}

	public int getCurrentPage() {
		return currentPage;
	}

	public void setCurrentPage(int currentPage) {
		this.currentPage = currentPage;
	}

	public int getTotalPage() {
		return totalPage;
	}

	public void setTotalPage(int totalPage) {
		this.totalPage = totalPage;
	}

	public int getPageSize() {
		return pageSize;
	}

	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}

	public int getTotalCount() {
		return totalCount;
	}

	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}

}
