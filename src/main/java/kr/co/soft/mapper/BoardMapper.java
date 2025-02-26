package kr.co.soft.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.SelectKey;
import org.apache.ibatis.annotations.Update;

import kr.co.soft.beans.BoardInfoBean;

public interface BoardMapper {

	// 게시글 생성하기
	@SelectKey(statement = "select board_seq.nextval from dual", keyProperty = "board_idx", before = true, resultType = int.class)
	// jdbcType=VARCHAR : MyBatis 에서 null값을 문자로 인지하도록 함
	@Insert("INSERT INTO board (board_idx, title, content, write_date, content_file, member_idx, type, complain_category, notice_code, view_count, like_count) "
	        + "VALUES (#{board_idx}, #{title}, #{content}, TO_DATE(#{write_date}, 'YYYY-MM-DD HH24:MI:SS'), #{content_file, jdbcType=VARCHAR}, #{member_idx}, #{type}, #{complain_category, jdbcType=VARCHAR}, #{notice_code, jdbcType=VARCHAR}, 0, 0)")
	void addContentInfo(BoardInfoBean boardInfoBean);

	// 게시글 목록 가져오기
	@Select("SELECT * FROM board ORDER BY board_idx DESC")
	List<BoardInfoBean> getAllBoardInfo();
	
	// 게시글 공지 가져오기
	@Select("SELECT * FROM board WHERE TRIM(notice_code) = 'notice' and TRIM(type) = '공지게시판' ORDER BY board_idx DESC")
	List<BoardInfoBean> getNoticeBoardInfo();
	
	// 전체 게시글 개수 조회
	@Select("SELECT COUNT(*) FROM board")
    int getBoardCount();

    // 타입별 게시글 개수 조회
    @Select("SELECT COUNT(*) FROM board WHERE type = #{type}")
    int getBoardCountByType(String type);

    // 검색 조건에 따른 게시글 개수 조회 (type이 'all'이면 조건 없이, 그 외에는 type 조건 적용)
    @Select("SELECT COUNT(*) FROM board " +
            "WHERE title LIKE '%' || #{keyword} || '%' " +
            "AND (#{type} = 'all' OR type = #{type})")
    int getSearchBoardCount(@Param("keyword") String keyword, @Param("type") String type);

	// 게시글 읽기
	@Select("SELECT * FROM board WHERE board_idx = #{board_idx}")
	BoardInfoBean getOneBoardInfo(int board_idx);

	// 카테고리별 게시글 목록 가져오기
	@Select("SELECT * FROM board WHERE type = #{type} ORDER BY board_idx DESC")
	List<BoardInfoBean> getBoardInfoByType(String type);

	// 게시글 삭제
	@Delete("DELETE FROM board WHERE board_idx = #{board_idx}")
	void deleteBoardInfo(int board_idx);

	// 게시글 수정하기
	@Update("UPDATE board SET "
	        + "title = #{title}, "
	        + "content = #{content}, "
	        + "write_date = TO_DATE(#{write_date, jdbcType=DATE}, 'YYYY-MM-DD HH24:MI:SS'), "
	        + "content_file = #{content_file, jdbcType=VARCHAR}, "
	        + "type = #{type}, "
	        + "complain_category = #{complain_category, jdbcType=VARCHAR} "
	        + "WHERE board_idx = #{board_idx}")
	void updateBoardInfo(BoardInfoBean boardInfoBean);

	//게시글 조회수 증가
	@Update("UPDATE board SET view_count = view_count + 1 WHERE board_idx = #{board_idx}")
    void incrementViewCount(int board_idx);

	//게시글 추천수 증가
    @Update("UPDATE board SET like_count = like_count + 1 WHERE board_idx = #{board_idx}")
    void incrementLikeCount(int board_idx);
    
 // 전체 게시글 페이징 조회
    @Select("SELECT * FROM ( " +
            "   SELECT a.*, ROWNUM rn FROM ( " +
            "       SELECT * FROM board ORDER BY board_idx DESC " +
            "   ) a WHERE ROWNUM <= #{endRow} " +
            ") WHERE rn >= #{startRow}")
    List<BoardInfoBean> getBoardInfoByPage(@Param("startRow") int startRow, @Param("endRow") int endRow);

    // 타입별 게시글 페이징 조회
    @Select("SELECT * FROM ( " +
            "   SELECT a.*, ROWNUM rn FROM ( " +
            "       SELECT * FROM board WHERE type = #{type} ORDER BY board_idx DESC " +
            "   ) a WHERE ROWNUM <= #{endRow} " +
            ") WHERE rn >= #{startRow}")
    List<BoardInfoBean> getBoardInfoByTypePage(@Param("type") String type,
                                               @Param("startRow") int startRow,
                                               @Param("endRow") int endRow);

    // 검색 조건에 따른 게시글 페이징 조회 (dynamic SQL 없이 고정 구문)
    @Select("SELECT * FROM ( " +
            "   SELECT a.*, ROWNUM rn FROM ( " +
            "       SELECT * FROM board " +
            "       WHERE title LIKE '%' || #{keyword} || '%' " +
            "       AND (#{type} = 'all' OR type = #{type}) " +
            "       ORDER BY board_idx DESC " +
            "   ) a WHERE ROWNUM <= #{endRow} " +
            ") WHERE rn >= #{startRow}")
    List<BoardInfoBean> searchBoardByPage(@Param("keyword") String keyword,
                                          @Param("type") String type,
                                          @Param("startRow") int startRow,
                                          @Param("endRow") int endRow);
    
  //공지사항 코드 업데이트
    @Update("UPDATE board SET notice_code = #{notice_code} WHERE board_idx = #{board_idx}")
    void updateNoticeCode(@Param("notice_code")String notice_code, @Param("board_idx")int board_idx);


	
	
}
