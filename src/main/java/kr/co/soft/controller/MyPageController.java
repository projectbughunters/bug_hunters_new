package kr.co.soft.controller;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.co.soft.beans.ProfileBean;
import kr.co.soft.beans.UserBean;
import kr.co.soft.service.MyPageService;
import kr.co.soft.service.UserService;

@Controller
@RequestMapping("/user")
public class MyPageController {
	
	@Autowired
	private UserService userService;
	
	@Resource(name = "loginUserBean")
	private UserBean loginUserBean;
	
	@Resource(name = "profileBean")
	private ProfileBean profileBean;
	
	@Autowired
	private MyPageService myPageService;

	
	@GetMapping("/myPage")
	public String myPage(@ModelAttribute("tempLoginUserBean") UserBean tempLoginUserBean,Model model) {
		
		int member_idx=loginUserBean.getMember_idx();
		ProfileBean profileBean=userService.getUserProfile(member_idx);
		
		model.addAttribute("profileBean", profileBean);
		
		return "user/myPage";
	}
	
	@PostMapping("/changePassword")
    public String changePassword(@ModelAttribute("tempLoginUserBean") UserBean tempLoginUserBean, Model model) {
        String message = myPageService.changePassword(tempLoginUserBean, loginUserBean);
        model.addAttribute("message", message);
        return "user/changePassword";
    }


}
