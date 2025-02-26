package kr.co.soft.controller;

import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import kr.co.soft.beans.DefensiveStockData;
import kr.co.soft.beans.DividendStockData;
import kr.co.soft.beans.ESGStockData;
import kr.co.soft.beans.GrowthStockData;
import kr.co.soft.beans.StockDataBean;
import kr.co.soft.beans.TechStockData;
import kr.co.soft.beans.ValueStockData;
import kr.co.soft.service.AiService;

@Controller
@RequestMapping("/ai")
public class AiController {
	
	@Autowired
	private AiService aiService;
	
	private final RestTemplate restTemplate;
    private final ObjectMapper objectMapper; // JSON 변환을 위한 ObjectMapper

    public AiController() {
        this.restTemplate = new RestTemplate();
        this.objectMapper = new ObjectMapper();
    }   


	@GetMapping("/aiMain")
	public String chatbotMain() {

		
		
		return "ai/aiMain";
	}

	  @GetMapping("/aiRecommend")
	  public String aiRecommend(Model model) {
	    try {
	      // 1. 테마별 데이터 가져오기
	      List<ESGStockData> esgStocks = aiService.getAllESGStocks();
	      List<DefensiveStockData> defensiveStocks = aiService.getAllDefensiveStocks();
	      List<TechStockData> techStocks = aiService.getAllTechStocks();
	      List<ValueStockData> valueStocks = aiService.getAllValueStocks();
	      List<GrowthStockData> growthStocks = aiService.getAllGrowthStocks();
	      List<DividendStockData> dividendStocks = aiService.getAllDividendStocks();

	      // 2. 데이터를 JSON 문자열로 변환
	      String esgJson = objectMapper.writeValueAsString(esgStocks);
	      String defensiveJson = objectMapper.writeValueAsString(defensiveStocks);
	      String techJson = objectMapper.writeValueAsString(techStocks);
	      String valueJson = objectMapper.writeValueAsString(valueStocks);
	      String growthJson = objectMapper.writeValueAsString(growthStocks);
	      String dividendJson = objectMapper.writeValueAsString(dividendStocks);

	      // 3. Model에 JSON 데이터 추가
	      model.addAttribute("esgStocks", esgJson);
	      model.addAttribute("defensiveStocks", defensiveJson);
	      model.addAttribute("techStocks", techJson);
	      model.addAttribute("valueStocks", valueJson);
	      model.addAttribute("growthStocks", growthJson);
	      model.addAttribute("dividendStocks", dividendJson);

	    } catch (Exception e) {
	      e.printStackTrace();
	      model.addAttribute("error", "데이터를 처리하는 중 오류가 발생했습니다.");
	    }

	    return "ai/aiRecommend"; // JSP 또는 HTML 페이지로 이동
	  }

}
