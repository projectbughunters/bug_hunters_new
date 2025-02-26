package kr.co.soft.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.co.soft.beans.BoardInfoBean;
import kr.co.soft.beans.CommentBean;
import kr.co.soft.service.BoardService;
import kr.co.soft.service.CommentService;
import kr.co.soft.service.UserService;

@RestController
@RequestMapping("/react")
public class BoardReactController {

	
	private final BoardService boardService;

	private final CommentService commentService;

	private UserService userService;

	@Autowired
	public BoardReactController(BoardService boardService, CommentService commentService, UserService userService) {
		this.boardService = boardService;
		this.commentService = commentService;
		this.userService = userService;
	}

	@GetMapping("/boardInfo")
	public List<BoardInfoBean> getAllBoardInfo() {
		// 모든 게시글 정보를 가져옵니다.
		List<BoardInfoBean> boardInfoList = boardService.getAllBoardInfo();

		// 각 게시글에 대해 사용자 ID를 설정합니다.
		for (BoardInfoBean boardInfo : boardInfoList) {
			String member_id = userService.getUserId(boardInfo.getMember_idx()); // 아이디 가져오기
			boardInfo.setMember_id(member_id); // 게시글 정보에 사용자 ID 설정
		}

		return boardInfoList; // 사용자 ID가 포함된 모든 게시글 정보를 반환
	}

	@GetMapping("/boardDetail")
	public BoardInfoBean getBoardInfoByBoardIdx(@RequestParam("board_idx") int board_idx) {
		try {
			BoardInfoBean boardInfo = boardService.getOneBoardInfo(board_idx); // 게시글 정보 가져오기

			// 게시글 정보가 null인지 확인
			if (boardInfo == null) {
				throw new RuntimeException("게시글 정보를 찾을 수 없습니다."); // 예외 발생
			}

			String member_id = userService.getUserId(boardInfo.getMember_idx()); // 아이디 가져오기

			// 게시글 정보에 사용자 ID 설정
			boardInfo.setMember_id(member_id);

			return boardInfo; // 게시글 정보와 사용자 ID가 포함된 객체 반환
		} catch (Exception e) {
			e.printStackTrace(); // 오류 로그 출력
			throw new RuntimeException("게시글을 가져오는 중 오류가 발생했습니다: " + e.getMessage());
		}
	}

	@DeleteMapping("/boardDelete")
	public void deleteBoardInfo(@RequestParam("board_idx")int board_idx) {

		boardService.deleteBoardInfo(board_idx);
	}

	@PostMapping("/noticeInfo")
	public BoardInfoBean getNoticeInfo(@RequestBody Map<String, Integer> request) {
		int board_idx = request.get("board_idx"); // 요청 바디에서 board_idx 가져오기
		try {
			BoardInfoBean noticeInfo = boardService.getOneBoardInfo(board_idx); // 게시글 정보 가져오기

			// 게시글 정보가 null인지 확인
			if (noticeInfo == null) {
				throw new RuntimeException("게시글 정보를 찾을 수 없습니다."); // 예외 발생
			}

			String member_id = userService.getUserId(noticeInfo.getMember_idx()); // 아이디 가져오기

			// 게시글 정보에 사용자 ID 설정
			noticeInfo.setMember_id(member_id);

			return noticeInfo; // 게시글 정보와 사용자 ID가 포함된 객체 반환
		} catch (Exception e) {
			e.printStackTrace(); // 오류 로그 출력
			throw new RuntimeException("게시글을 가져오는 중 오류가 발생했습니다: " + e.getMessage());
		}
	}

	@PostMapping("/noticeInput")
	public ResponseEntity<String> insertNotice(@RequestBody BoardInfoBean noticeBean) {
		try {
			boardService.insertNotice(noticeBean);
			return ResponseEntity.ok("공지사항이 등록되었습니다."); // 성공 시 응답
		} catch (Exception e) {
			e.printStackTrace(); // 스택 트레이스 출력 (개발 시 유용)
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
					.body("공지사항 등록 중 오류가 발생했습니다: " + e.getMessage()); // 오류 메시지와 함께 500 상태 코드 반환
		}
	}

	@PutMapping("/noticeUpdate")
	public ResponseEntity<String> updateNotice(@RequestBody BoardInfoBean noticeBean) {
		try {
			boardService.updateNotice(noticeBean);
			return ResponseEntity.ok("공지사항이 수정되었습니다."); // 성공 시 응답
		} catch (Exception e) {
			e.printStackTrace(); // 스택 트레이스 출력 (개발 시 유용)
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
					.body("공지사항 수정 중 오류가 발생했습니다: " + e.getMessage()); // 오류 메시지와 함께 500 상태 코드 반환
		}
	}

	@PutMapping("/updateNoticeCode")
	public ResponseEntity<String> updateNoticeCode(@RequestBody BoardInfoBean noticeBean) {

		try {
			String noticeCode = noticeBean.getNotice_code();
			int board_idx = noticeBean.getBoard_idx();
			boardService.updateNoticeCode(noticeCode, board_idx);
			return ResponseEntity.ok("공지띄우기 성공!");
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
					.body("공지띄우기 중 오류가 발생했습니다: " + e.getMessage()); 
		}

	}

	@GetMapping("/getComments")
	public List<CommentBean> getCommentsByBoardIdx(@RequestParam("board_idx") int board_idx) {
		// 모든 댓글 정보를 가져옵니다.
		List<CommentBean> commentList = commentService.getCommentsByBoardIdx(board_idx);

		// 각 게시글에 대해 사용자 ID를 설정합니다.
		for (CommentBean commentInfo : commentList) {
			String member_id = userService.getUserId(commentInfo.getMember_idx()); // 아이디 가져오기
			commentInfo.setMember_id(member_id); // 게시글 정보에 사용자 ID 설정
			System.out.println(member_id);
		}
		return commentList;
	}

	@DeleteMapping("/commentDelete")
	public void deleteComment(@RequestParam("comment_idx") int comment_idx) {
		commentService.deleteComment(comment_idx);
	}

}
