package kr.co.soft.controller;

import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.soft.beans.BoardInfoBean;
import kr.co.soft.beans.CommentBean;
import kr.co.soft.beans.PageBean;
import kr.co.soft.beans.UserBean;
import kr.co.soft.service.BoardService;
import kr.co.soft.service.CommentService;
import kr.co.soft.service.UserService;

@RequestMapping("/board")
@Controller
public class BoardController {

	@Autowired
	BoardService boardService;

	@Autowired
	CommentService commentService;
	
	@Autowired
	UserService userService;

	@Resource(name = "loginUserBean")
	private UserBean loginUserBean;

	@GetMapping("/boardMain")
	public String boardMain(Model model) {
		System.out.println("member_idx="+loginUserBean.getMember_idx());
		
		List<BoardInfoBean> boardList = boardService.getAllBoardInfo(); // 게시글 목록 가져오기
		List<BoardInfoBean> noticeList = boardService.getNoticeBoardInfo(); 
		if (boardList != null && !boardList.isEmpty()) {
			for (BoardInfoBean boardBean : boardList) {
				int memberIdx = boardBean.getMember_idx();
				// DB에서 member_idx로 member_id 가져오기
				String memberId = userService.getUserId(memberIdx);
				boardBean.setMember_id(memberId);
			}
			model.addAttribute("boardList", boardList);
			model.addAttribute("noticeList", noticeList);
		} else {
			// boardList가 null이거나 비어있을 때의 처리
			System.out.println("게시글 목록이 없습니다.");
		}

		return "board/boardMain";
	}

	 @GetMapping("/boardWrite")
	    public String boardWrite(@ModelAttribute("boardWriteBean") BoardInfoBean boardInfoBean, Model model) {
	        if (!loginUserBean.isUserLogin()) {
	            return "portfolio/loginError";
	        }
	        model.addAttribute("boardBean", new BoardInfoBean());
	        return "board/boardWrite"; 
	    }

	@PostMapping("/boardWriteSuccess")
	public String writeSuccess(@ModelAttribute("boardWriteBean") BoardInfoBean boardInfoBean, Model model,
			BindingResult result) {
		if (result.hasErrors()) {
			return "board/write";
		}

		// 파일이 boardInfoBean에 자동으로 바인딩되었는지 확인
		if (boardInfoBean.getUpload_file() == null || boardInfoBean.getUpload_file().isEmpty()) {
			System.out.println("파일이 업로드되지 않았습니다.");
		}

		// 서비스 호출
		boardService.addContentInfo(boardInfoBean);

		model.addAttribute("boardInfoBean", boardInfoBean);
		return "board/boardWriteSuccess";
	}

	// 게시글 읽기
	@GetMapping("/boardRead")
	public String boardRead(@RequestParam("board_idx") int board_idx, 
							@ModelAttribute("commentBean") CommentBean commentBean, 
							Model model) throws UnsupportedEncodingException {
		//댓글작성시 필요 
	    commentBean.setBoard_idx(board_idx);
	    //게시글 가져오기
	    BoardInfoBean boardBean = boardService.getOneBoardInfo(board_idx);
	    int member_idx = boardBean.getMember_idx();
	    // 접근 권한 체크
	    if (boardBean.getType().equals("고객센터") && (loginUserBean == null || member_idx != loginUserBean.getMember_idx())) {
	    	// 권한이 없을 경우 처리
	    	model.addAttribute("errorMessage", "접근 권한이 없습니다.");
	    	return "board/accessError"; // 오류 페이지로 이동
	    }
	    
	    // 조회수 증가
        boardService.incrementViewCount(board_idx); // 조회수 증가 메서드 호출
	    //작성자 정보 가져오기
	    String member_id=userService.getUserId(member_idx);
	    boardBean.setMember_id(member_id);
	    
	    // 모델에 게시글 및 댓글 정보 추가
	    model.addAttribute("boardBean", boardBean);
		model.addAttribute("commentBean", commentBean);

	    // 댓글 리스트 가져오기
		List<CommentBean> commentList = commentService.getCommentsByBoardIdx(board_idx);
	    model.addAttribute("commentList", commentList);
	    
	    // 사용자 ID를 저장할 맵 생성
	    Map<Integer, String> userIdMap = new HashMap<>();
	   
	    // 각 댓글의 member_idx를 통해 사용자 ID를 가져와 맵에 저장
	    for (CommentBean comment : commentList) {
	        String userId = userService.getUserId(comment.getMember_idx());
	        userIdMap.put(comment.getMember_idx(), userId);
	    }
	    // 모델에 사용자 ID 맵 추가
	    model.addAttribute("userIdMap", userIdMap);
		
		// 업로드 된 파일 이름 가져오기
		String fileName = boardBean.getContent_file();
		System.out.println("fileName : "+fileName);
		if (fileName != null && !fileName.isEmpty()) {
			// 파일 경로를 완성
			String filePath = "upload/" + fileName;
			model.addAttribute("filePath", filePath); // JSP에서 사용할 수 있도록 모델에 추가
		}

		return "board/boardRead";
	}

	// 게시글 수정 페이지 보여주기
	@GetMapping("/boardModify")
	public String boardEdit(@RequestParam("board_idx") int board_idx, Model model) {
		BoardInfoBean boardBean = boardService.getOneBoardInfo(board_idx); // 게시글 정보 가져오기
		model.addAttribute("boardBean", boardBean);
		return "board/boardModify"; // 수정 페이지 JSP 반환
	}

	// 게시글 수정 처리
	@PostMapping("/boardModifyPro")
	public String boardWritePro(@ModelAttribute("boardBean") BoardInfoBean boardBean) {
		boardService.updateBoardInfo(boardBean); // 수정된 게시글 정보 업데이트

		return "redirect:/board/boardRead"; // 수정 후 게시글 목록으로 리다이렉트
	}

	// 게시글 삭제 처리
	@GetMapping("/boardDelete")
	public String boardDelete(@RequestParam("board_idx") int boardIdx) {
		boardService.deleteBoardInfo(boardIdx); // 게시글 삭제 로직
		return "redirect:/board/boardMain"; // 삭제 후 게시글 목록으로 리다이렉트
	}
	
	// 댓글 넣기
	@PostMapping("/commentAdd")
	public String commentAdd(@ModelAttribute("commentBean") CommentBean commentBean, @RequestParam("member_idx")int member_idx) {
		
		int board_idx = commentBean.getBoard_idx();
		commentBean.setMember_idx(member_idx);
		//현재시간 설정
		SimpleDateFormat comment_time = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		commentBean.setComment_time(comment_time.format(new Date()));
		//댓글추가를 위해 서비스 호출 
		commentService.insertComment(commentBean);
			
		return "redirect:/board/boardRead?board_idx="+board_idx; 
	} 
	
	@PostMapping("/commentUpdate")
	public String commentUpdate(@ModelAttribute("commentBean") CommentBean commentBean) {
		
		int board_idx = commentBean.getBoard_idx();
		
		SimpleDateFormat comment_time = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		commentBean.setComment_time(comment_time.format(new Date()));
		commentService.updateComment(commentBean);
		
		return "redirect:/board/boardRead?board_idx="+board_idx;
	}
	
	@PostMapping("/commentDelete")
	public String commentDelete(@ModelAttribute("commentBean")CommentBean commentBean) {
		int comment_idx = commentBean.getComment_idx();
		commentService.deleteComment(comment_idx);
		int board_idx = commentBean.getBoard_idx();
		
		return "redirect:/board/boardRead?board_idx="+board_idx;
	}
	
	// 추천수 증가
    @PostMapping("/incrementLikeCount")
    public ResponseEntity<Map<String, Integer>> incrementLikeCount(@RequestParam("board_idx") int board_idx) {
        boardService.incrementLikeCount(board_idx);
        
        //게시글 정보를 가져와 새로운 추천수 조회
        BoardInfoBean boardBean = boardService.getOneBoardInfo(board_idx);
        int newLikeCount = boardBean.getLike_count(); // 추천수 가져오기
        
        // 응답 생성
        Map<String, Integer> response = new HashMap<>();
        response.put("newLikeCount", newLikeCount);
        
        return ResponseEntity.ok(response); // JSON 형태로 응답
    }
    
 // 1) 게시판 타입별 페이징 처리
    @GetMapping("/getBoardInfoByType")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getBoardInfoByType(
            @RequestParam("type") String type,
            @RequestParam(value = "currentPage", defaultValue = "1") int currentPage,
            @RequestParam(value = "pageSize", defaultValue = "10") int pageSize) {
        
        // Service 계층에서 타입별 페이징 처리된 결과 반환
        PageBean<BoardInfoBean> pageBean = boardService.getBoardPageByType(type, currentPage, pageSize);
        
        // 각 게시글에 대해 작성자(member_id) 설정
        for (BoardInfoBean board : pageBean.getList()) {
            int memberIdx = board.getMember_idx();
            String memberId = userService.getUserId(memberIdx);
            board.setMember_id(memberId);
        }
        
        Map<String, Object> response = new HashMap<>();
        response.put("list", pageBean.getList());
        response.put("pageBean", pageBean);
        return ResponseEntity.ok(response);
    }
    
    // 2) 검색 기능의 페이징 처리
    @GetMapping("/searchBoard")
    public ResponseEntity<Map<String, Object>> searchBoard(
            @RequestParam("keyword") String keyword,
            @RequestParam("type") String type,
            @RequestParam(value = "currentPage", defaultValue = "1") int currentPage,
            @RequestParam(value = "pageSize", defaultValue = "10") int pageSize) {
        
        // Service 계층에서 검색 및 페이징 처리된 결과 반환
        PageBean<BoardInfoBean> pageBean = boardService.searchBoard(keyword, type, currentPage, pageSize);
        
        // 각 게시글에 대해 작성자(member_id) 설정
        for (BoardInfoBean board : pageBean.getList()) {
            int memberIdx = board.getMember_idx();
            String memberId = userService.getUserId(memberIdx);
            board.setMember_id(memberId);
        }
        
        Map<String, Object> response = new HashMap<>();
        response.put("list", pageBean.getList());
        response.put("pageBean", pageBean);
        return ResponseEntity.ok(response);
    }

    

}
