package kr.co.soft.controller;

import javax.annotation.Resource;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.ObjectMapper;

import kr.co.soft.beans.ProfileBean;
import kr.co.soft.beans.UserBean;
import kr.co.soft.service.UserService;
import kr.co.soft.validator.UserValidator;

@Controller
@RequestMapping("/user")
public class UserController {
	
	@Autowired
	private UserService userService;
	
	
	@Resource(name = "loginUserBean")
	private UserBean loginUserBean;
	
	@Resource(name = "profileBean")
	private ProfileBean profileBean;
	
	private final RestTemplate restTemplate;
    private final ObjectMapper objectMapper; // JSON 변환을 위한 ObjectMapper

    public UserController() {
    	this.restTemplate = new RestTemplate();
        this.objectMapper = new ObjectMapper();
	}
    
	@GetMapping("/login")
	public String login(@ModelAttribute("tempLoginUserBean") UserBean tempLoginUserBean, 
			@RequestParam(value = "fail", defaultValue = "false") boolean fail, Model model) {
		model.addAttribute("fail", fail);
		
			return "user/login";	
	}
	
	@PostMapping("/login_pro")
	   public String login_pro(@Valid @ModelAttribute("tempLoginUserBean") UserBean tempLoginUserBean, 
	                           BindingResult result, 
	                           Model model) {
	       // 유효성 검사 실패 시 로그인 페이지로 돌아감
	       if (result.hasErrors()) {
	           return "user/login";
	       }

	       try {
	           // 로그인 시도
	           userService.getLoginUserInfo(tempLoginUserBean);

	           // 로그인 성공
	           if (loginUserBean.isUserLogin()) {
	               return "user/login_success";
	           } else {
	               // 로그인 실패
	               int failCount = userService.getFailCount(tempLoginUserBean.getMember_id());
	               model.addAttribute("fail", true);
	               model.addAttribute("failCount", failCount); // 실패 횟수 전달
	               return "user/login";
	           }
	       } catch (RuntimeException e) {
	           // 브루트포스 공격 방지: 로그인 시도가 너무 많을 경우 처리
	           model.addAttribute("fail", true);
	           model.addAttribute("errorMessage", e.getMessage());
	           return "user/login";
	       }
	   }
	
	@GetMapping("/logout")
	public String logout() {
		
		// UserBean 초기화
	    loginUserBean.setMember_idx(0);
	    loginUserBean.setMember_name(null);
	    loginUserBean.setMember_id(null);
	    loginUserBean.setPassword(null);
	    loginUserBean.setPassword2(null);
	    loginUserBean.setBirth(null);
	    loginUserBean.setEmail(null);
	    loginUserBean.setType(null);
	    loginUserBean.setUserIdExist(false);
	    loginUserBean.setUserLogin(false);

	    // ProfileBean 초기화
	    profileBean.setMember_info_idx(0);
	    profileBean.setMember_idx(0);
	    profileBean.setMember_name(null);
	    profileBean.setRole(null);
	    profileBean.setCreated_at(null);
	    profileBean.setIs_active('\0'); // char는 기본값이 '\0'
	    profileBean.setBirth(0);
	    profileBean.setPersonal_tendency_code(null);
		
		return "user/logout";
	}
	
	@GetMapping("/not_login")
	public String not_login() {
		return "user/not_login";
	}
	
	@GetMapping("/createMember")
	public String createMember(@ModelAttribute("joinUserBean") UserBean joinUserBean) {
	
		return "user/createMember";
	}
	
	@PostMapping("/createMember_pro")
	public String join_pro(@Valid @ModelAttribute("joinUserBean") UserBean joinUserBean, BindingResult result) {

		// 이메일 중복 체크
	    if (userService.checkUseEmail(joinUserBean.getEmail()) > 0) {
	        result.rejectValue("email", "error.joinUserBean", "이미 사용 중인 이메일입니다.");
	    }
		
		if (result.hasErrors()) {
			return "user/createMember";
		}
		
		/*
		 * for(int i=1;i<150;i++) { joinUserBean.setMember_id("user"+i);
		 * joinUserBean.setMember_name("user"+i);
		 * joinUserBean.setEmail("user"+i+"@example.com");
		 * joinUserBean.setPassword("12345");
		 * 
		 * userService.addUserInfo(joinUserBean); UserBean
		 * proUserBean=userService.getUserInfo(joinUserBean);
		 * userService.addUserProfile(proUserBean); }
		 */
		
		userService.addUserInfo(joinUserBean);
		UserBean proUserBean=userService.getUserInfo(joinUserBean);
		userService.addUserProfile(proUserBean);
		
		
		
		return "user/createMember_success";
	}
	
	
	@GetMapping("/findId")
	public String findId(@ModelAttribute("tempLoginUserBean")UserBean tempUserBean) {
		
		return "user/findId";
	}
	
	@PostMapping("/findId_pro")
	public String findId_pro(@ModelAttribute("tempLoginUserBean")UserBean tempUserBean, Model model) {
		
		String member_name = tempUserBean.getMember_name();
		String email =tempUserBean.getEmail();
		
		try {
	        // 오라클에서 아이디 가져오기
	        String member_id = userService.getMemberId(member_name, email);
	        
	        if (member_id == null) {
	            model.addAttribute("fail", true); // 실패 플래그
	        } else {
	            model.addAttribute("fail", false); // 성공 플래그
	            model.addAttribute("member_name", member_name);
	            model.addAttribute("member_id", member_id);
	        }
	    } catch (Exception e) {
	        // 에러 발생 시 처리
	        model.addAttribute("fail", true);
	        model.addAttribute("errorMessage", "서버 오류가 발생했습니다. 다시 시도해주세요.");
	    }
	    
	   model.addAttribute("submitted", true); // 버튼 클릭 이후 상태 표시
	    return "user/findId";
	}
	
	
	@GetMapping("/findPassword")
	public String findPassword() {
		
		return "user/findPassword";
	}
	
	@GetMapping("/findPasswordResult")
	public String findPassword_con(@RequestParam("member_id") String member_id, 
	                               @RequestParam("email") String email, 
	                               Model model) {

		try {
	        String message = userService.findPassword(member_id, email);
	        model.addAttribute("message", message);
	    } catch (Exception e) {
	        model.addAttribute("message", "Error: " + e.getMessage());
	    }

	    return "user/findPasswordResult";
	}   
	
	
	
	@GetMapping("/checkUserIdExist/{member_id}")
	@ResponseBody
	public String checkUserIdExist(@PathVariable String member_id) {
		boolean chk=userService.checkUserIdExist(member_id);
		return chk+"";
		
	}
	
	@InitBinder
	   public void initBinder(WebDataBinder binder) {
	      UserValidator validator1 = new UserValidator();
	      binder.addValidators(validator1);
	   }
	
	
}
