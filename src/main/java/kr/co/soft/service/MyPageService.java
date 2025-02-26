package kr.co.soft.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import kr.co.soft.DAO.ProfileDAO;
import kr.co.soft.DAO.UserDao;
import kr.co.soft.beans.ProfileBean;
import kr.co.soft.beans.UserBean;

@Service
public class MyPageService {

	@Autowired
	private UserDao userDao;
	
	@Autowired
	private ProfileDAO profileDAO;

	public String changePassword(UserBean tempLoginUserBean, UserBean loginUserBean) {
		String member_id = loginUserBean.getMember_id();
		String dbPassword = userDao.getPassword(member_id); // DB에서 가져온 비밀번호
		String confirmPassword = tempLoginUserBean.getPassword(); // 입력한 비밀번호
		String newPassword = tempLoginUserBean.getPassword2(); // 변경할 비밀번호

		// BCryptPasswordEncoder를 사용하여 입력 비밀번호 검증
		BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

		// 입력된 비밀번호가 현재 비밀번호와 일치하지 않는지 먼저 확인후, DB 비밀번호와 일치하면 새 비밀번호를 해싱 후 저장
		if (passwordEncoder.matches(confirmPassword, dbPassword)) {
			if (passwordEncoder.matches(newPassword, dbPassword)) {
				return "현재 비밀번호와 다른 비밀번호로 설정해야 합니다.";
			} else {
				String encodedPassword = passwordEncoder.encode(newPassword);
				userDao.updatePassword(encodedPassword, member_id);
				return "비밀번호가 성공적으로 변경되었습니다.";
			}
		} else {
			return "현재 비밀번호가 일치하지 않습니다.";
		}

	}
	
	
	public void updateTendencyCode(String tendencycode, int member_idx) {

		profileDAO.updateTendencyCode(tendencycode, member_idx);
	}
	
	
	
}
