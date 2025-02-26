package kr.co.soft.service;

import java.io.IOException;
import java.util.Arrays;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;

import com.google.api.client.auth.oauth2.AuthorizationCodeRequestUrl;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow;
import com.google.api.client.googleapis.auth.oauth2.GoogleCredential;
import com.google.api.client.googleapis.auth.oauth2.GoogleTokenResponse;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory; // GsonFactory 사용
import com.google.api.services.oauth2.model.Userinfo;
import com.google.api.services.people.v1.PeopleService;
import com.google.api.services.people.v1.model.Person;

@Service
public class GoogleOAuthService {

    private static final String CLIENT_ID = "105693236297-v6nfjnvcbtu5sap6ogfcvefame13hmu0.apps.googleusercontent.com";
    private static final String CLIENT_SECRET = "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";
    private static final String REDIRECT_URI = "http://localhost:9023/bugHunters_TMI/google/callback";
    private static final String APPLICATION_NAME = "Spring MVC Google Login";

    private GoogleAuthorizationCodeFlow flow;

    @PostConstruct
    public void init() {
    	flow = new GoogleAuthorizationCodeFlow.Builder(
    	        new NetHttpTransport(),
    	        GsonFactory.getDefaultInstance(),
    	        CLIENT_ID,
    	        CLIENT_SECRET,
    	        Arrays.asList(
    	            "https://www.googleapis.com/auth/userinfo.profile",
    	            "https://www.googleapis.com/auth/userinfo.email",
    	            "https://www.googleapis.com/auth/user.birthday.read"
    	        )
    	    ).setAccessType("offline").build();
    }

    public String getAuthorizationUrl() {
        AuthorizationCodeRequestUrl authorizationUrl = flow.newAuthorizationUrl();
        authorizationUrl.setRedirectUri(REDIRECT_URI);
        return authorizationUrl.build();
    }

    public Userinfo getUserInfo(String code, HttpServletRequest request) throws IOException {
        GoogleTokenResponse tokenResponse = flow.newTokenRequest(code).setRedirectUri(REDIRECT_URI).execute();
        GoogleCredential credential = new GoogleCredential().setAccessToken(tokenResponse.getAccessToken());

        // 세션에 Access Token 저장
        request.getSession().setAttribute("accessToken", tokenResponse.getAccessToken());

        var oauth2 = new com.google.api.services.oauth2.Oauth2.Builder(
                new NetHttpTransport(), GsonFactory.getDefaultInstance(), credential
        ).setApplicationName(APPLICATION_NAME).build();

        return oauth2.userinfo().get().execute();
    }
    
    public Person getUserBirthday(String accessToken) throws IOException {
        GoogleCredential credential = new GoogleCredential().setAccessToken(accessToken);

        PeopleService peopleService = new PeopleService.Builder(
                new NetHttpTransport(), 
                GsonFactory.getDefaultInstance(), 
                credential
        ).setApplicationName(APPLICATION_NAME).build();

        Person profile = peopleService.people().get("people/me")
                .setPersonFields("birthdays")
                .execute();

        return profile;
    }

}
