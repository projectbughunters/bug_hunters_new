package kr.co.soft.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;


@RequestMapping("/embedded")
@Controller
public class BIController {
	
	@GetMapping("/sitePortalAudSample")
    public String sitePortalAudSample() {
       
        return "embedded/sitePortalAudSample"; 
    }
	
	@GetMapping("/iaudEmbedded")
    public String iaudEmbedded() {
       
        return "embedded/iaudEmbedded"; 
    }

}
