package kr.co.soft.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.context.annotation.SessionScope;

import kr.co.soft.beans.ProfileBean;
import kr.co.soft.beans.UserBean;




//프로젝트 작업시 사용할 bean들을 정의하는 클래스
@Configuration
public class RootAppContext {
	
	@Bean("loginUserBean")
	@SessionScope
	public UserBean loginUserBean() {
		return new UserBean();
		
	}
	
	@Bean("profileBean")
	@SessionScope
	public ProfileBean profileBean() {
		return new ProfileBean();
		
	}
	
	@Bean
	public BCryptPasswordEncoder passwordEncoder() {
	    return new BCryptPasswordEncoder();
	}

	
}
