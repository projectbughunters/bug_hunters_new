package kr.co.soft.service;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import kr.co.soft.DAO.BoardDAO;
import kr.co.soft.beans.BoardInfoBean;
import kr.co.soft.beans.PageBean;
import kr.co.soft.beans.UserBean;

@Service
public class BoardService {

	@Resource(name = "loginUserBean")
	private UserBean loginUserBean;

	@Autowired
	UserService userService;
	
	@Autowired
	private BoardDAO boardDAO;

	public List<BoardInfoBean> getAllBoardInfo() {

		return boardDAO.getAllBoardInfo();
	}
	
	public List<BoardInfoBean> getNoticeBoardInfo() {

		return boardDAO.getNoticeBoardInfo();
	}

	public PageBean<BoardInfoBean> getBoardPageByType(String type, int currentPage, int pageSize) {
        PageBean<BoardInfoBean> pageBean;
        // 특정 타입(공지게시판, 자유게시판, 고객센터)인 경우 해당 타입으로 조회하고,
        // "all" 등 잘못된 타입이면 전체 게시글 페이징 조회
        if ("공지게시판".equals(type) || "자유게시판".equals(type) || "고객센터".equals(type)) {
            pageBean = boardDAO.getBoardPageByType(type, currentPage, pageSize);
        } else {
            pageBean = boardDAO.getBoardPage(currentPage, pageSize);
        }
        return pageBean;
    }


	public BoardInfoBean getOneBoardInfo(int board_idx) {

		return boardDAO.getBoardInfo(board_idx);
	}

	public void addContentInfo(BoardInfoBean boardInfoBean) {

		MultipartFile upload_file = boardInfoBean.getUpload_file();

		if (upload_file.getSize() > 0) {
			String file_name = saveUploadFile(upload_file);
			// 첨부파일 이름 저장
			boardInfoBean.setContent_file(file_name);
		}
		// 로그인 정보에서 Member_idx를 가져와 Content_writer_idx에 사용
		boardInfoBean.setMember_idx(loginUserBean.getMember_idx());
		// Date
		boardInfoBean.setWrite_date(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
		// 글쓰기
		boardDAO.addContentInfo(boardInfoBean);
	};

	
	public void deleteBoardInfo(int board_idx) {

		boardDAO.deleteBoardInfo(board_idx);
	}

	public void updateBoardInfo(BoardInfoBean boardInfoBean) {
		// 현재 날짜를 write_date에 설정
		boardInfoBean.setWrite_date(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));

		// 파일이 있다면 업로드
		MultipartFile upload_file = boardInfoBean.getUpload_file();

		if (upload_file.getSize() > 0) {// upload가 있다면
			String file_name = saveUploadFile(upload_file);
			boardInfoBean.setContent_file(file_name);
		}

		boardDAO.updateBoardInfo(boardInfoBean);
	}

	private String saveUploadFile(MultipartFile upload_file) {
		// 파일 이름 생성
		String file_name = System.currentTimeMillis() + "_tmi_uploadFile" + "."
				+ FilenameUtils.getExtension(upload_file.getOriginalFilename());
		String path_upload = "/Users/ej/Desktop/cording/soldesk/Spring_WS/bugHunters_TMI/src/main/webapp/resources/upload";
		System.out.println("파일 저장 경로: " + path_upload);

		try {
			upload_file.transferTo(new File(path_upload + "/" + file_name));
		} catch (IOException e) {
			System.out.println("파일 저장 오류 발생 : " + e.getMessage());
			// 예외 처리
			throw new RuntimeException("파일 저장 중 오류가 발생했습니다.", e);
		}

		return file_name;
	}

	@Transactional
	public void incrementViewCount(int boardIdx) {
		boardDAO.incrementViewCount(boardIdx);
	}

	@Transactional
	public void incrementLikeCount(int boardIdx) {
		boardDAO.incrementLikeCount(boardIdx);
	}
	
	 /**
     * 검색어와 타입에 따른 페이징 처리된 게시글 목록 반환
     */
    public PageBean<BoardInfoBean> searchBoard(String keyword, String type, int currentPage, int pageSize) {
        return boardDAO.searchBoard(keyword, type, currentPage, pageSize);
    }
	
	
	public void validateBoardAccess(BoardInfoBean boardBean) {
        int member_idx = boardBean.getMember_idx();
        if (boardBean.getType().equals("고객센터") && (loginUserBean == null || member_idx != loginUserBean.getMember_idx())) {
            throw new RuntimeException("접근 권한이 없습니다.");
        }
    }
	
	
	public void insertNotice(BoardInfoBean noticeBean) {
		// Date
		noticeBean.setWrite_date(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
		// 글쓰기
		boardDAO.addContentInfo(noticeBean);
	}
	
	public void updateNotice(BoardInfoBean noticeBean) {
		// 현재 날짜를 write_date에 설정
		noticeBean.setWrite_date(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
		boardDAO.updateBoardInfo(noticeBean);
	}

	
	public void updateNoticeCode(String noticeCode, int boardIdx) {
			boardDAO.updateNoticeCode(noticeCode, boardIdx);
		}
	
		

}