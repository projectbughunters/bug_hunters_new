package kr.co.soft.beans;

import org.springframework.web.multipart.MultipartFile;


public class BoardInfoBean {
    
    private int board_idx; // 게시물 인덱스
    private String title; // 제목
    private String write_date; // 작성 날짜
    private String content; // 내용
    private int view_count; // 조회 수
    private int like_count; // 좋아요 수
    private String content_file; // 첨부 파일 이름
    private MultipartFile upload_file;//첨부 파일
    private String notice_code; // 공지 코드
    private String type; // 게시물 유형
    private int member_idx; // 작성자 인덱스
    private String complain_category; // 민원 사항
    private String member_id;//작성자 아이디
   

    public int getBoard_idx() {
        return board_idx;
    }

    public void setBoard_idx(int board_idx) {
        this.board_idx = board_idx;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getWrite_date() {
        return write_date;
    }

    public void setWrite_date(String write_date) {
        this.write_date = write_date;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public int getView_count() {
        return view_count;
    }

    public void setView_count(int view_count) {
        this.view_count = view_count;
    }

    public int getLike_count() {
        return like_count;
    }

    public void setLike_count(int like_count) {
        this.like_count = like_count;
    }

    public String getContent_file() {
        return content_file;
    }

    public void setContent_file(String content_file) {
        this.content_file = content_file;
    }

    public String getNotice_code() {
        return notice_code;
    }

    public void setNotice_code(String notice_code) {
        this.notice_code = notice_code;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public int getMember_idx() {
        return member_idx;
    }

    public void setMember_idx(int member_idx) {
        this.member_idx = member_idx;
    }

    public String getComplain_category() {
        return complain_category;
    }

    public void setComplain_category(String complain_category) {
        this.complain_category = complain_category;
    }

	public String getMember_id() {
		return member_id;
	}

	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}

	public MultipartFile getUpload_file() {
		return upload_file;
	}

	public void setUpload_file(MultipartFile upload_file) {
		this.upload_file = upload_file;
	}

    

}
