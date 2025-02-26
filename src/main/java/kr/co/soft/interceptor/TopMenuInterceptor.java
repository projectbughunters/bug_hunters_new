package kr.co.soft.interceptor;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.HandlerInterceptor;

import kr.co.soft.beans.ProfileBean;
import kr.co.soft.beans.UserBean;
import kr.co.soft.service.UserService;

public class TopMenuInterceptor implements HandlerInterceptor{

	private UserBean loginUserBean;
	private ProfileBean profileBean;
	
	public TopMenuInterceptor(UserBean loginUserBean, ProfileBean profileBean) {
		this.loginUserBean=loginUserBean;
		this.profileBean=profileBean;
	}

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		request.setAttribute("loginUserBean", loginUserBean);
		request.setAttribute("profileBean", profileBean);
		return true;
	}
	
	
}
