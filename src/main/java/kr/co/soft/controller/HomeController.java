package kr.co.soft.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.ObjectMapper;

import kr.co.soft.beans.CyptoExchangeBean;
import kr.co.soft.beans.FavoriteBean;
import kr.co.soft.beans.NewsBean;
import kr.co.soft.beans.PageBean;
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
   @RequestMapping(value = "/", method = RequestMethod.GET)
   public String home(Model model, HttpSession session) {
      session.removeAttribute("allStocks");
      try {
         // 상위 5개 주식 목록 가져오기
         List<Map<String, Object>> allStocks = stockService.getTopStocks();
         List<Map<String, Object>> topStocks = allStocks.subList(0, Math.min(5, allStocks.size()));
         List<String> stockSymbols = new ArrayList<>();

         // 페이지 정보를 담을 객체 (PageBean for Stocks)
         PageBean pageBeanForStocks = new PageBean();
         pageBeanForStocks.setList(topStocks);
         model.addAttribute("pageBeanForStocks", pageBeanForStocks);

         for (Map<String, Object> stock : topStocks) {
            String symbol = (String) stock.get("symbol");
            stockSymbols.add(symbol);
         }

         // JSON 문자열로 변환 (ObjectMapper를 사용)
         String stockSymbolsJson = objectMapper.writeValueAsString(stockSymbols);
         model.addAttribute("stockSymbolsJson", stockSymbolsJson);

      } catch (Exception e) {
         e.printStackTrace();
      }

      session.removeAttribute("allCoins");
      try {
         // 상위 5개 코인 목록 가져오기
         List<Map<String, Object>> allCoins = coinService.getAllCoins();
         List<Map<String, Object>> topCoins = allCoins.subList(0, Math.min(5, allCoins.size()));
         List<String> coinSymbols = new ArrayList<>();

         // 페이지 정보를 담을 객체 (PageBean for Coins)
         PageBean pageBeanForCoins = new PageBean();
         pageBeanForCoins.setList(topCoins);
         model.addAttribute("pageBeanForCoins", pageBeanForCoins);

         for (Map<String, Object> coin : topCoins) {
            String symbol = (String) coin.get("symbol");
            coinSymbols.add(symbol);
         }

         // JSON 문자열로 변환 (ObjectMapper를 사용)
         String coinSymbolsJson = objectMapper.writeValueAsString(coinSymbols);
         model.addAttribute("coinSymbolsJson", coinSymbolsJson);

      } catch (Exception e) {
         e.printStackTrace();
      }

      // 뉴스 크롤링: 뉴스 제목 가져오기
      try {
         List<NewsBean> newsList = newsCrawlingService.getNewsArticles();
         model.addAttribute("newsList", newsList);
      } catch (Exception e) {
         e.printStackTrace();
         model.addAttribute("newsList", new ArrayList<NewsBean>());
      }
   // 로그인한 사용자의 member_idx를 사용하여 즐겨찾기 목록을 가져옵니다.
      List<FavoriteBean> favorites = favoriteService.selectFavoritesByMemberIdx(loginUserBean.getMember_idx());

      // 모델에 favorites 리스트를 추가합니다.
      model.addAttribute("favorites", favorites);
      List<CyptoExchangeBean> list = exchangeService.getcyptoExchangeList();
      model.addAttribute("cyptoexchangeList", list);
      
      return "bugMain";
   }

}
