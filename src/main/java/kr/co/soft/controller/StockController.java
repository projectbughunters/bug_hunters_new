package kr.co.soft.controller;

import java.time.Duration;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import io.github.bonigarcia.wdm.WebDriverManager;
import kr.co.soft.beans.FavoriteBean;
import kr.co.soft.beans.PageBean;
import kr.co.soft.beans.UserBean;
import kr.co.soft.service.FavoriteService;
import kr.co.soft.service.NewsService;
import kr.co.soft.service.StockService;

@Controller
@RequestMapping("/stock")
public class StockController {
	
	@Autowired
	private StockService stockService;
	
	@Autowired
	private FavoriteService favoriteService;
	
	@Autowired
	private NewsService newsService;
	
	@Resource(name = "loginUserBean")
	  private UserBean loginUserBean;

    private final RestTemplate restTemplate;
    private final ObjectMapper objectMapper; // JSON 변환을 위한 ObjectMapper

    public StockController() {
        this.restTemplate = new RestTemplate();
        this.objectMapper = new ObjectMapper();
    }    
    
    @GetMapping("/stockMain")
    public String getStocksData(@RequestParam(defaultValue = "1") int page,HttpSession session, Model model) {
    	
    	try {
    		int member_idx=loginUserBean.getMember_idx();
            int pageSize = 15; // 한 페이지당 10개 항목 (필요에 따라 조정)
            PageBean<Map<String, Object>> pageBean = stockService.getPageTopStocks(page, pageSize, session);
            List<FavoriteBean> favorites = favoriteService.selectFavoritesByMemberIdx(member_idx);
            model.addAttribute("pageBean", pageBean);
            model.addAttribute("favorites", favorites);
             
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "데이터를 불러오지 못했습니다.");
        }
        return "stock/stockMain";
    }

    @GetMapping("/info/{symbol}")
    public String getStockInfo(@PathVariable("symbol") String symbol, Model model) {
        try {
            Map<String, Object> processedData = stockService.getStockOverview(symbol);
            Map<String, Object> overData = stockService.getStockData(symbol);
            List<Map<String, Object>> stockInfoNews= newsService.stockInfoNews(symbol);

            model.addAttribute("processedData", processedData);
            model.addAttribute("overData", overData);
            model.addAttribute("symbol", symbol);
            model.addAttribute("stockInfoNews", stockInfoNews);
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "데이터를 불러오지 못했습니다.");
        }
        return "stock/stockInfo";
    }

    @GetMapping("/search")
    public String getNodeData(@RequestParam("keyword") String keyword, Model model) {
        try {
            // Node.js 서버에서 데이터 가져오기
            String nodeResponse = restTemplate.getForObject(
                    "http://localhost:3000/search?keyword=" + keyword, String.class);

            // JSON 문자열을 Java 객체로 변환
            List<Map<String, Object>> stocks = objectMapper.readValue(nodeResponse, new TypeReference<List<Map<String, Object>>>() {});

            // 데이터를 JSP에 전달
            model.addAttribute("stocks", stocks);
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "데이터를 불러오지 못했습니다.");
        }
        return "stock/search"; // view는 JSP 파일의 이름입니다.
    }
    
    @GetMapping("/aiBot")
    public String aiBotMain(Model model) {
    	
    	return "stock/aiBot";
    }
    
}