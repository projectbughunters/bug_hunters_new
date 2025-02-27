package kr.co.soft.mapper;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.google.api.services.oauth2.model.Userinfo;

import kr.co.soft.beans.ProfileBean;
import kr.co.soft.beans.UserBean;



public interface UserMapper {
	
	@Select("select member_name from member where member_id=#{member_id}")
	String checkUserIdExist(String member_id);

	@Insert("insert into member(member_idx, member_name, member_id, password, birth, email, type) values(member_seq.nextval, #{member_name}, "
			+ "#{member_id}, #{password}, #{birth},#{email}, 'user')")
	void addUserInfo(UserBean joinUserBean);
	
	@Insert("insert into member(member_idx, member_name, member_id, password, birth, email, type) "
	        + "values(member_seq.nextval, #{userInfo.name}, #{userInfo.email}, null, #{birth}, #{userInfo.email}, 'google')")
	void addGoogleInfo(@Param("userInfo") Userinfo userInfo, @Param("birth") int birth);

	@Select("select member_id from member where member_idx=#{member_idx}")
	String getUserID(int member_idx);
	
	@Insert("INSERT INTO profile (member_info_idx, member_idx, member_name, role, created_at, is_active, birth, personal_tendency_code) " +
	        "VALUES (member_info_seq.nextval, #{member_idx}, #{member_name}, 'user', TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI'), 'N', #{birth}, NULL)")
	void addUserProfile(UserBean proUserBean);
	
	@Select("select member_idx, member_name, role, created_at, is_active, birth, personal_tendency_code " + 
	         "from profile " + 
	         "where member_idx=#{member_idx}")
	ProfileBean getUserProfile(@Param("member_idx")int member_idx);
	
	@Select("select member_idx, member_name, birth " + 
	         "from member " + 
	         "where member_id=#{member_id}")
	UserBean getUserInfo(UserBean proUserBean);
	
	@Select("select member_idx, member_id, member_name, password, birth, email, type " + 
	         "from member " + 
	         "where member_id=#{member_id}")
	UserBean getLoginUserInfo(UserBean tempLoginUserBean);
	
	@Select("select member_idx, member_id, member_name, birth, email, type " + 
	         "from member " + 
	         "where member_id=#{email}")
	UserBean getLoginGoogleInfo(Userinfo userInfo);
	
	@Select("SELECT email FROM member WHERE member_id = #{member_id}")
	String getMemberEmail(String member_id);
	
	@Select("SELECT COUNT(*) FROM member WHERE email = #{email}")
	int checkUseEmail(String email);
	
	@Select("SELECT member_id FROM member WHERE member_name = #{member_name} AND email = #{email}")
	String getMemberId(@Param("member_name")String member_name, @Param("email")String email);
	
	@Select("SELECT password FROM member WHERE member_id=#{member_id}")
	String getPassword(String member_id);
	
	@Update("UPDATE member SET password=#{password} WHERE member_id=#{member_id}")
	void updatePassword(@Param("password")String password ,@Param("member_id") String member_id);
	
	@Delete("DELETE FROM member WHERE member_idx = #{member_idx}")
    void deleteMemberById(@Param("member_idx") int member_idx);

}
