package kr.co.soft.service;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

import com.google.api.services.oauth2.model.Userinfo;

import kr.co.soft.DAO.UserDao;
import kr.co.soft.beans.ProfileBean;
import kr.co.soft.beans.UserBean;

@Service
public class UserService {

	 @Autowired
	    private UserDao userDao;

	    @Resource(name = "loginUserBean")
	    private UserBean loginUserBean;
	    
	    @Resource(name = "profileBean")
		private ProfileBean profileBean;

	    @Autowired
	    private BCryptPasswordEncoder passwordEncoder;

	    private Map<String, Integer> loginFailCount = new HashMap<>();
	    private Map<String, Long> lockoutTime = new ConcurrentHashMap<>(); // 계정 잠금 시간 기록

	    private static final Logger logger = LoggerFactory.getLogger(UserService.class);
	    private static final int MAX_LOGIN_ATTEMPTS = 5;
	    private static final long LOCKOUT_DURATION = 15 * 1000; // 15초

	    public boolean checkUserIdExist(String member_id) {
	        String member_name = userDao.checkUserIdExist(member_id);

	        return member_name == null;
	    }

	    public void addUserInfo(UserBean joinUserBean) {
	        String encodedPassword = passwordEncoder.encode(joinUserBean.getPassword());
	        joinUserBean.setPassword(encodedPassword);
	        userDao.addUserInfo(joinUserBean);
	    }
	    
	    public void addGoogleInfo(Userinfo userInfo,String birth) {

	    	userDao.addGoogleInfo(userInfo,birth);
		}
	    
	    public void addUserProfile(UserBean proUserBean) {
	    	
	    	userDao.addUserProfile(proUserBean);
			
		}
	    
	    public String getUserId(int member_idx) {
	    	
			return userDao.getUserId(member_idx);
		}
	    
	    public ProfileBean getUserProfile(int member_idx) {
			
			return userDao.getUserProfile(member_idx);
		}
	    
	    public int checkUseEmail(String email) {
			return userDao.checkUseEmail(email);
		}
	    
	    public UserBean getUserInfo(UserBean proUserBean) {

	    	UserBean proUserBean2=userDao.getUserInfo(proUserBean);
	    	
	    	return proUserBean2;
		}

	    public void getLoginUserInfo(UserBean tempLoginUserBean) {
	        String memberId = tempLoginUserBean.getMember_id();
	        long currentTime = System.currentTimeMillis();

	        // 잠금 상태 확인
	        if (lockoutTime.containsKey(memberId)) {
	            long lockedUntil = lockoutTime.get(memberId);
	            if (currentTime < lockedUntil) {
	                long secondsRemaining = (lockedUntil - currentTime) / 1000;
	                logger.error("로그인 시도가 너무 많습니다. 사용자 ID: {}. {}초 후 다시 시도하십시오.", memberId, secondsRemaining);
	                throw new RuntimeException("로그인 시도가 너무 많습니다. <br>" + secondsRemaining + "초 후 다시 시도해주세요.");
	            } else {
	                // 잠금 해제
	                lockoutTime.remove(memberId);
	                loginFailCount.put(memberId, 0);
	            }
	        }

	        UserBean tempLoginUserBean2 = userDao.getLoginUserInfo(tempLoginUserBean);

	        if (tempLoginUserBean2 != null &&
	                passwordEncoder.matches(tempLoginUserBean.getPassword().trim(), tempLoginUserBean2.getPassword().trim())) {
	            loginUserBean.setMember_idx(tempLoginUserBean2.getMember_idx());
	            loginUserBean.setMember_id(tempLoginUserBean2.getMember_id());
	            loginUserBean.setMember_name(tempLoginUserBean2.getMember_name());
	            loginUserBean.setBirth(tempLoginUserBean2.getBirth());
	            loginUserBean.setEmail(tempLoginUserBean2.getEmail());
	            loginUserBean.setType(tempLoginUserBean2.getType());
	            loginUserBean.setUserLogin(true);
	            loginFailCount.put(memberId, 0); // 로그인 성공 시 실패 카운트 초기화
	            logger.info("로그인 성공: 사용자 ID: {}", memberId);
	            ProfileBean profileUserBean = userDao.getUserProfile(tempLoginUserBean2.getMember_idx());
	            profileBean.setMember_idx(profileUserBean.getMember_idx());
	            profileBean.setMember_name(profileUserBean.getMember_name());
	            profileBean.setRole(profileUserBean.getRole());
	            profileBean.setPersonal_tendency_code(profileUserBean.getPersonal_tendency_code());
	        } else {
	            // 로그인 실패 처리
	            int failCount = loginFailCount.getOrDefault(memberId, 0) + 1;
	            loginFailCount.put(memberId, failCount);

	            if (failCount >= MAX_LOGIN_ATTEMPTS) {
	                lockoutTime.put(memberId, currentTime + LOCKOUT_DURATION); // 잠금 시작 시간 기록
	                logger.warn("로그인 시도 초과: 사용자 ID: {}. 계정이 15초 동안 잠깁니다.", memberId);
	                throw new RuntimeException("로그인 시도가 너무 많습니다. <br> 15초 후 다시 시도해주세요.");
	            }

	            logger.warn("로그인 실패: 사용자 ID: {}", memberId);
	        }
	    }
	    
	    public UserBean getLoginGoogleInfo(Userinfo userInfo) {

			return userDao.getLoginGoogleInfo(userInfo);
		}

	    public int getFailCount(String userId) {
	        return loginFailCount.getOrDefault(userId, 0);
	    }
	    
	    public String getMemberEmail(String member_id) {
			
			return userDao.getMemberEmail(member_id);
		}
	    
	    public String getMemberId(String member_name, String email) {
			
			return userDao.getMemberId(member_name, email);
		}
	    
	    public String findPassword(String memberId, String email) {
	        // DB에서 email 조회
	        String dbEmail = getMemberEmail(memberId); // DB에서 이메일 조회하는 메서드

	        RestTemplate restTemplate = new RestTemplate();
	        if (dbEmail == null) {
	            return "해당 ID가 존재하지 않습니다.";
	        }

	        // 입력한 email과 DB email 비교
	        if (!email.equals(dbEmail)) {
	            return "입력하신 이메일 주소가 올바르지 않습니다.";
	        }

	        try {
	            // Node.js 서버로 get 요청 보내기
	            String nodeJsServerResponse = restTemplate
	                    .getForObject("http://localhost:3000/findPassword?member_id=" + memberId, String.class);

	            // 응답 문자열에 따라 분기 처리
	            if (nodeJsServerResponse.contains("임시 비밀번호가 이메일로 발송되었습니다.")) {
	                return "임시 비밀번호가 이메일로 발송되었습니다.";
	            } else if (nodeJsServerResponse.contains("해당 ID가 존재하지 않습니다.")) {
	                return "해당 ID가 존재하지 않습니다.";
	            } else {
	                return nodeJsServerResponse; // 기타 경우
	            }
	        } catch (RestClientException e) {
	            return "서버와 통신 중 문제가 발생했습니다."; // Node.js 통신 에러
	        }
	    }
	    
	    public void deleteMemberById(int member_idx) {
	    	userDao.deleteMemberById(member_idx);
		};

		
}
