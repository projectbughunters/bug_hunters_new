package kr.co.soft.beans;


public class CommentBean {
    private int comment_idx;       // 댓글 인덱스
    private String comment_content; // 댓글 내용
    private int board_idx;         // 게시물 인덱스
    private int member_idx;        // 회원 인덱스
    private String member_id;      // 회원 아이디
    private int step;              // 댓글 단계
    private String comment_time;     // 댓글 작성 시간 
    
    public int getComment_idx() {
        return comment_idx;
    }

    public void setComment_idx(int comment_idx) {
        this.comment_idx = comment_idx;
    }

    public String getComment_content() {
        return comment_content;
    }

    public void setComment_content(String comment_content) {
        this.comment_content = comment_content;
    }

    public int getBoard_idx() {
        return board_idx;
    }

    public void setBoard_idx(int board_idx) {
        this.board_idx = board_idx;
    }

    public int getMember_idx() {
        return member_idx;
    }

    public void setMember_idx(int member_idx) {
        this.member_idx = member_idx;
    }

    public int getStep() {
        return step;
    }

    public void setStep(int step) {
        this.step = step;
    }

    public String getComment_time() {
        return comment_time;
    }

    public void setComment_time(String comment_time) {
        this.comment_time = comment_time;
    }

	public String getMember_id() {
		return member_id;
	}

	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}
    
}
