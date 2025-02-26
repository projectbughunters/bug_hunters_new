package kr.co.soft.beans;

import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;

public class UserBean {

	private int member_idx;
	
	@Size(min = 2, max = 4)
	@Pattern(regexp = "[가-힣]*")
	private String member_name;
	
	@Size(min=4, max=20)
	@Pattern(regexp = "[a-zA-Z0-9]*")
	private String member_id;
	
	@Size(min=4, max=20)
	@Pattern(regexp = "[a-zA-Z0-9]*")
	private String password;
	
	@Size(min=4, max=20)
	@Pattern(regexp = "[a-zA-Z0-9]*")
	private String password2;
	
	@Size(min=8, max=8)
	@Pattern(regexp = "[0-9]*")
	private String birth;
	
	@Size(min=4, max=25)
	@Pattern(regexp = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$")
	private String email;
	
	private String type;
	
	private boolean userIdExist;
	
	private boolean userLogin;

	public UserBean() {
		this.userIdExist=false;
		this.userLogin=false;
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

	public String getMember_id() {
		return member_id;
	}

	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getPassword2() {
		return password2;
	}

	public void setPassword2(String password2) {
		this.password2 = password2;
	}

	public String getBirth() {
		return birth;
	}

	public void setBirth(String birth) {
		this.birth = birth;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public boolean isUserIdExist() {
		return userIdExist;
	}

	public void setUserIdExist(boolean userIdExist) {
		this.userIdExist = userIdExist;
	}

	public boolean isUserLogin() {
		return userLogin;
	}

	public void setUserLogin(boolean userLogin) {
		this.userLogin = userLogin;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}
	
	
	
	
	
}
