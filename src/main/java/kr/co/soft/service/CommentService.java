package kr.co.soft.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.soft.DAO.CommentDAO;
import kr.co.soft.beans.CommentBean;

@Service
public class CommentService {

	@Autowired
	CommentDAO commentDAO;
	
	public void insertComment(CommentBean comment) {
		commentDAO.insertComment(comment);
	}
	
	public List<CommentBean> getCommentsByBoardIdx(int board_idx){
		return commentDAO.getCommentsByBoardIdx(board_idx);
	}
	
	public void updateComment(CommentBean commentBean) {
		commentDAO.updateComment(commentBean);
	}
	
	public void deleteComment(int comment_idx) {
		commentDAO.deleteComment(comment_idx);
	};
}
