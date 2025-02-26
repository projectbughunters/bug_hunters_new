package kr.co.soft.beans;

public class ProfileBean {

	private int member_info_idx; // member_info_idx
	private int member_idx; // member_idx
	private String member_name; // member_name
	private String role; // role
	private String created_at; // created_at
	private char is_active; // is_active
	private int birth; // birth
	private String personal_tendency_code; // personal_tendency_code

	public int getMember_info_idx() {
		return member_info_idx;
	}

	public void setMember_info_idx(int member_info_idx) {
		this.member_info_idx = member_info_idx;
	}

	public int getMember_idx() {
		return member_idx;
	}

	public void setMember_idx(int member_idx) {
		this.member_idx = member_idx;
	}

	public String getMember_name() {
		return member_name;
	}

	public void setMember_name(String member_name) {
		this.member_name = member_name;
	}

	public String getRole() {
		return role;
	}

	public void setRole(String role) {
		this.role = role;
	}

	public String getCreated_at() {
		return created_at;
	}

	public void setCreated_at(String created_at) {
		this.created_at = created_at;
	}

	public char getIs_active() {
		return is_active;
	}

	public void setIs_active(char is_active) {
		this.is_active = is_active;
	}

	public int getBirth() {
		return birth;
	}

	public void setBirth(int birth) {
		this.birth = birth;
	}

	public String getPersonal_tendency_code() {
		return personal_tendency_code;
	}

	public void setPersonal_tendency_code(String personal_tendency_code) {
		this.personal_tendency_code = personal_tendency_code;
	}

}
