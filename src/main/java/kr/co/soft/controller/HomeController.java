package kr.co.soft.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.ObjectMapper;

import kr.co.soft.beans.CyptoExchangeBean;
import kr.co.soft.beans.NewsBean;
import kr.co.soft.beans.UserBean;
import kr.co.soft.service.CoinService;
import kr.co.soft.service.CyptoExchangeService;
import kr.co.soft.service.FavoriteService;
import kr.co.soft.service.NewsCrawlingService;
import kr.co.soft.service.StockService;

@Controller
public class HomeController {

   @Resource(name = "loginUserBean")
   private UserBean loginUserBean;

   private final RestTemplate restTemplate;
   private final ObjectMapper objectMapper;

   public HomeController() {
      this.restTemplate = new RestTemplate();
      this.objectMapper = new ObjectMapper();
   }

   @Autowired
   private StockService stockService;

   @Autowired
   private CoinService coinService;

   @Autowired
   private NewsCrawlingService newsCrawlingService;
   
   @Autowired
   private FavoriteService favoriteService;
   
   @Autowired
   private CyptoExchangeService exchangeService;

   // 홈 페이지 (bugMain.jsp) 관련 메소드
   @GetMapping("/")
   public String home(Model model, HttpSession session) {
	    session.removeAttribute("allStocks");
	    session.removeAttribute("allCoins");
	    // 뉴스 크롤링: 뉴스 제목 가져오기
	      try {
	         List<NewsBean> newsList = newsCrawlingService.getNewsArticles();
	         model.addAttribute("newsList", newsList);
	         List<CyptoExchangeBean> list = exchangeService.getcyptoExchangeList();
	         model.addAttribute("cyptoexchangeList", list);
	      } catch (Exception e) {
	         e.printStackTrace();
	         model.addAttribute("newsList", new ArrayList<NewsBean>());
	      }
	    return "bugMain";
	  }

	  // 주식 데이터를 AJAX로 반환
	  @RequestMapping(value = "/loadStocks", method = RequestMethod.GET, produces = "application/json")
	  @ResponseBody
	  public List<Map<String, Object>> loadStocks() {
	    try {
	      List<Map<String, Object>> allStocks = stockService.getTopStocks();
	      return allStocks.subList(0, Math.min(5, allStocks.size()));
	    } catch (Exception e) {
	      e.printStackTrace();
	      return new ArrayList<>();
	    }
	  }

	  // 코인 데이터를 AJAX로 반환
	  @RequestMapping(value = "/loadCoins", method = RequestMethod.GET, produces = "application/json")
	  @ResponseBody
	  public List<Map<String, Object>> loadCoins() {
	    try {
	      List<Map<String, Object>> allCoins = coinService.getAllCoins();
	      return allCoins.subList(0, Math.min(5, allCoins.size()));
	    } catch (Exception e) {
	      e.printStackTrace();
	      return new ArrayList<>();
	    }
	  }
	}


