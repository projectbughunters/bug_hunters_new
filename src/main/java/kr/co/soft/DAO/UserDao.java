package kr.co.soft.DAO;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.google.api.services.oauth2.model.Userinfo;

import kr.co.soft.beans.ProfileBean;
import kr.co.soft.beans.UserBean;
import kr.co.soft.mapper.UserMapper;

@Repository
public class UserDao {

	@Autowired
	private UserMapper userMapper;

	public String checkUserIdExist(String member_id) {

		return userMapper.checkUserIdExist(member_id);
	}

	public void addUserInfo(UserBean joinUserBean) {

		userMapper.addUserInfo(joinUserBean);
	}
	
	public void addGoogleInfo(Userinfo userInfo,String birth) {

		int birth1=Integer.parseInt(birth);
		userMapper.addGoogleInfo(userInfo,birth1);
	}
	
	public ProfileBean getUserProfile(int member_idx) {
		
		return userMapper.getUserProfile(member_idx);
	}
	
	public String getUserId(int member_idx) {
		return userMapper.getUserID(member_idx);
	}
	
	public void addUserProfile(UserBean proUserBean) {

		userMapper.addUserProfile(proUserBean);
	}
	
	public UserBean getUserInfo(UserBean proUserBean) {

		return userMapper.getUserInfo(proUserBean);
	}
	
	public UserBean getLoginUserInfo(UserBean tempLoginUserBean) {

		return userMapper.getLoginUserInfo(tempLoginUserBean);
	}
	
	public UserBean getLoginGoogleInfo(Userinfo userInfo) {

		return userMapper.getLoginGoogleInfo(userInfo);
	}
	
	public String getMemberEmail(String member_id) {
		return userMapper.getMemberEmail(member_id);
	}
	
	public String getMemberId(String member_name, String email) {
		return userMapper.getMemberId(member_name, email);
	}
	
	public int checkUseEmail(String email) {
		return userMapper.checkUseEmail(email);
	}
	
	public String getPassword(String member_id) {
		return userMapper.getPassword(member_id);
	}
	
	public void updatePassword(String password, String member_id) {
		userMapper.updatePassword(password, member_id);
	};
	
}
