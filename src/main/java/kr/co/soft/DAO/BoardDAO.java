package kr.co.soft.DAO;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.soft.beans.BoardInfoBean;
import kr.co.soft.beans.PageBean;
import kr.co.soft.mapper.BoardMapper;

@Repository
public class BoardDAO {

	@Autowired
	BoardMapper boardMapper;

	public List<BoardInfoBean> getAllBoardInfo() {

		return boardMapper.getAllBoardInfo();
	}
	
	public List<BoardInfoBean> getNoticeBoardInfo() {

		return boardMapper.getNoticeBoardInfo();
	}
	
	public List<BoardInfoBean> getBoardInfoByType(String type) {
		
		return boardMapper.getBoardInfoByType(type);
	}
	
	public BoardInfoBean getOneBoardInfo(int board_idx) {
		return boardMapper.getOneBoardInfo(board_idx);
	}

	public void addContentInfo(BoardInfoBean boardInfoBean) {
		boardMapper.addContentInfo(boardInfoBean);
	}

	public void deleteBoardInfo(int board_idx) {
		boardMapper.deleteBoardInfo(board_idx);
	}

	public void updateBoardInfo(BoardInfoBean boardInfoBean) {
		boardMapper.updateBoardInfo(boardInfoBean);
	}

	public void incrementViewCount(int boardIdx) {
		boardMapper.incrementViewCount(boardIdx);
	}
	
	public void incrementLikeCount(int boardIdx) {
		boardMapper.incrementLikeCount(boardIdx);
	}
	
	public PageBean<BoardInfoBean> getBoardPage(int currentPage, int pageSize) {
        int totalCount = boardMapper.getBoardCount();
        int totalPage = (int) Math.ceil((double) totalCount / pageSize);
        int startRow = (currentPage - 1) * pageSize + 1;
        int endRow = currentPage * pageSize;
        
        List<BoardInfoBean> list = boardMapper.getBoardInfoByPage(startRow, endRow);
        
        PageBean<BoardInfoBean> pageBean = new PageBean<>();
        pageBean.setList(list);
        pageBean.setCurrentPage(currentPage);
        pageBean.setPageSize(pageSize);
        pageBean.setTotalCount(totalCount);
        pageBean.setTotalPage(totalPage);
        
        return pageBean;
    }
    
    /**
     * 게시판 타입별 페이징 처리
     */
    public PageBean<BoardInfoBean> getBoardPageByType(String type, int currentPage, int pageSize) {
        int totalCount = boardMapper.getBoardCountByType(type); // 해당 타입의 게시글 총 개수 조회
        int totalPage = (int) Math.ceil((double) totalCount / pageSize);
        int startRow = (currentPage - 1) * pageSize + 1;
        int endRow = currentPage * pageSize;
        
        List<BoardInfoBean> list = boardMapper.getBoardInfoByTypePage(type, startRow, endRow);
        
        PageBean<BoardInfoBean> pageBean = new PageBean<>();
        pageBean.setList(list);
        pageBean.setCurrentPage(currentPage);
        pageBean.setPageSize(pageSize);
        pageBean.setTotalCount(totalCount);
        pageBean.setTotalPage(totalPage);
        
        return pageBean;
    }
    
    /**
     * 검색어와 타입에 따른 페이징 처리
     */
    public PageBean<BoardInfoBean> searchBoard(String keyword, String type, int currentPage, int pageSize) {
        int totalCount = boardMapper.getSearchBoardCount(keyword, type); // 검색 조건에 맞는 게시글 총 개수 조회
        int totalPage = (int) Math.ceil((double) totalCount / pageSize);
        int startRow = (currentPage - 1) * pageSize + 1;
        int endRow = currentPage * pageSize;
        
        List<BoardInfoBean> list = boardMapper.searchBoardByPage(keyword, type, startRow, endRow);
        
        PageBean<BoardInfoBean> pageBean = new PageBean<>();
        pageBean.setList(list);
        pageBean.setCurrentPage(currentPage);
        pageBean.setPageSize(pageSize);
        pageBean.setTotalCount(totalCount);
        pageBean.setTotalPage(totalPage);
        
        return pageBean;
    }
    
    public void updateNoticeCode(String noticeCode, int boardIdx) {
		boardMapper.updateNoticeCode(noticeCode, boardIdx);
	}


}
