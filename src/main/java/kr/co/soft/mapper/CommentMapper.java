package kr.co.soft.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.SelectKey;
import org.apache.ibatis.annotations.Update;

import kr.co.soft.beans.CommentBean;

public interface CommentMapper {

	// 댓글 삽입 메서드
	@SelectKey(statement = "SELECT board_comment_seq.NEXTVAL FROM dual", keyProperty = "comment_idx", before = true,resultType = int.class)
	@Insert("INSERT INTO board_comment (comment_idx, comment_content, board_idx, member_idx, step, comment_time) " +
            "VALUES (board_comment_seq.NEXTVAL, #{comment_content}, #{board_idx}, #{member_idx}, null, TO_DATE(#{comment_time}, 'YYYY-MM-DD HH24:MI:SS'))")
   void insertComment(CommentBean comment);

	//댓글 가져오기
    @Select("SELECT comment_idx, comment_content, board_idx, member_idx, step, comment_time " +
            "FROM board_comment " +
            "WHERE board_idx = #{board_idx} " +
            "ORDER BY comment_time DESC")
    List<CommentBean> getCommentsByBoardIdx(int board_idx);
	
    //댓글 업데이트
    @Update("UPDATE board_comment " +
            "SET comment_content = #{comment_content}, comment_time = TO_DATE(#{comment_time}, 'YYYY-MM-DD HH24:MI:SS') " +
            "WHERE comment_idx = #{comment_idx}")
    void updateComment(CommentBean commentBean);
    
    //댓글 지우기
    @Delete("DELETE board_comment WHERE comment_idx=#{comment_idx}")
    void deleteComment(int comment_idx);
    
    
}
