package kr.co.soft.DAO;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.soft.beans.CommentBean;
import kr.co.soft.mapper.CommentMapper;

@Repository
public class CommentDAO {
	
	@Autowired
	CommentMapper commentmapper;
	
	
	public void insertComment(CommentBean comment) {
		commentmapper.insertComment(comment);
	}
	
	public List<CommentBean> getCommentsByBoardIdx(int board_idx) {
		return commentmapper.getCommentsByBoardIdx(board_idx);
	} 
	
	public void updateComment(CommentBean commentBean) {
		commentmapper.updateComment(commentBean);
	}
	public void deleteComment(int comment_idx) {
		commentmapper.deleteComment(comment_idx);
	};
	
	
}
