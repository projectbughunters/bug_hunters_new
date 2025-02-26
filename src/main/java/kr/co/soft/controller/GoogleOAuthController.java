package kr.co.soft.controller;

import java.io.IOException;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.google.api.client.http.GenericUrl;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.services.oauth2.model.Userinfo;
import com.google.api.services.people.v1.model.Person;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import kr.co.soft.beans.ProfileBean;
import kr.co.soft.beans.UserBean;
import kr.co.soft.service.GoogleOAuthService;
import kr.co.soft.service.UserService;

@Controller
public class GoogleOAuthController {

    @Autowired
    private GoogleOAuthService googleOAuthService;
    
    @Autowired
    private UserService userService;
    
    @Resource(name = "loginUserBean")
    private UserBean loginUserBean;
    
    @Resource(name = "profileBean")
	private ProfileBean profileBean;

    @GetMapping("/google/login")
    public String googleLogin() {
        String authorizationUrl = googleOAuthService.getAuthorizationUrl();
        return "redirect:" + authorizationUrl;
    }

    @GetMapping("/google/callback")
    public String googleCallback(@RequestParam("code") String code, Model model, HttpServletRequest request) {
        try {
            // Access Token을 세션에 저장
            Userinfo userInfo = googleOAuthService.getUserInfo(code, request);
            int checkGoogle=userService.checkUseEmail(userInfo.getEmail());
            String accessToken = (String) request.getSession().getAttribute("accessToken");
            String birthday="00000000";
         // 생년월일 가져오기
            Person userProfile = googleOAuthService.getUserBirthday(accessToken);
            if (userProfile.getBirthdays() != null && !userProfile.getBirthdays().isEmpty()) {
                String birth = userProfile.getBirthdays().get(0).getDate().toString();
                JsonObject birthObject = JsonParser.parseString(birth).getAsJsonObject();
                int day = birthObject.get("day").getAsInt();
                int month = birthObject.get("month").getAsInt();
                int year = birthObject.get("year").getAsInt();

                // 날짜를 "YYYY-MM-DD" 형식의 문자열로 반환
                birthday=String.format("%04d%02d%02d", year, month, day);
            }
            
            if(checkGoogle==0) {
            	userService.addGoogleInfo(userInfo, birthday);
            	UserBean googleInfo=userService.getLoginGoogleInfo(userInfo);
            	userService.addUserProfile(googleInfo);
            }
            
            UserBean googleInfo=userService.getLoginGoogleInfo(userInfo);
            loginUserBean.setMember_idx(googleInfo.getMember_idx());
            loginUserBean.setMember_id(googleInfo.getMember_id());
            loginUserBean.setMember_name(googleInfo.getMember_name());
            loginUserBean.setBirth(googleInfo.getBirth());
            loginUserBean.setEmail(googleInfo.getEmail());
            loginUserBean.setType(googleInfo.getType());
            loginUserBean.setUserLogin(true);
            ProfileBean profileUserBean = userService.getUserProfile(googleInfo.getMember_idx());
            profileBean.setMember_idx(profileUserBean.getMember_idx());
            profileBean.setMember_name(profileUserBean.getMember_name());
            profileBean.setRole(profileUserBean.getRole());
            profileBean.setPersonal_tendency_code(profileUserBean.getPersonal_tendency_code());
        } catch (IOException e) {
            e.printStackTrace();
            return "error";
        }

        return "redirect:/";
    }
    
    @GetMapping("/google/logout")
    public String logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            // 세션에서 Access Token 가져오기
            String accessToken = (String) session.getAttribute("accessToken");
            session.invalidate();
            
            if (accessToken != null) {
                // Google Access Token 무효화
                try {
                    String revokeUrl = "https://accounts.google.com/o/oauth2/revoke?token=" + accessToken;
                    new NetHttpTransport().createRequestFactory()
                            .buildGetRequest(new GenericUrl(revokeUrl))
                            .execute();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

        // 로그아웃 후 홈 페이지로 리다이렉트
        return "redirect:/user/logout";
    }


}
