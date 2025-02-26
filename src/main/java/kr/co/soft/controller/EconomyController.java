package kr.co.soft.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;

@Controller
@RequestMapping("/economy")
public class EconomyController {
	
	 private String nodeApiUrl = "http://localhost:3000";

	  private final RestTemplate restTemplate;

	  public EconomyController() { // 생성자 주입
	    this.restTemplate = new RestTemplate();
	  }
	  @GetMapping("/economyMain")
	  public String main() {

	    return "/economy/economyMain";
	  }

	  @GetMapping("/searchPro")
	  public String searchPro(@RequestParam String symbol, Model model) {
	    String urlPro = nodeApiUrl + "/economy?symbol=" + symbol;

	      model.addAttribute("symbol", symbol); // 검색한 키워드 추가

	      return "/economy/searchPro"; // 결과를 보여줄 뷰로 이동
	  }

	  @GetMapping("/searchCommodities1")
	  public String searchCommodities1(@RequestParam String symbol, Model model) {

	    // 모델에 추가
	    model.addAttribute("symbol", symbol); // 검색한 키워드 추가

	    return "/economy/searchCommodities1"; // 결과를 보여줄 뷰로 이동
	  }
	  @GetMapping("/searchCommodities2")

	  public String searchCommodities2(@RequestParam String symbol, Model model) {

	    // 모델에 추가
	    model.addAttribute("symbol", symbol); // 검색한 키워드 추가

	    return "/economy/searchCommodities2"; // 결과를 보여줄 뷰로 이동
	  }




}
