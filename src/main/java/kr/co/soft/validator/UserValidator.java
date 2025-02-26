package kr.co.soft.validator;

import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import kr.co.soft.beans.UserBean;

public class UserValidator implements Validator{

	@Override
	public boolean supports(Class<?> clazz) {
		
		return UserBean.class.isAssignableFrom(clazz);
	}

	@Override
	public void validate(Object target, Errors errors) {
		
		UserBean userBean=(UserBean)target;
		
		String beanName=errors.getObjectName();
		
		System.out.println(beanName);
		
		if(beanName.equals("joinUserBean")) {
		
			if(userBean.getPassword().equals(userBean.getPassword2())==false) {
				errors.rejectValue("password", "NotEquals");
				errors.rejectValue("password2", "NotEquals");
			}
			
			if(userBean.isUserIdExist()==false) {
				errors.rejectValue("member_id", "DontCheckUserIdExist");
			}
			
		}
		
	}

}
