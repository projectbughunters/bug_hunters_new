package kr.co.soft.service;

import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class NewsService {

    public Map<String, List<Map<String, Object>>> fetchAllNews() {
        Map<String, List<Map<String, Object>>> newsData = new HashMap<>();

        // RestTemplate 객체 생성
        RestTemplate restTemplate = new RestTemplate();
        String economyUrl = "http://localhost:3000/economynews";
        String coinUrl = "http://localhost:3000/coinnews";
        String stockUrl = "http://localhost:3000/stocknews";

        Map<String, String> requestData = new HashMap<>();

        try {
            // Node.js 서버에서 데이터 가져오기
            Map<String, Object> economyResponse = restTemplate.postForObject(economyUrl, requestData, Map.class);
            Map<String, Object> coinResponse = restTemplate.postForObject(coinUrl, requestData, Map.class);
            Map<String, Object> stockResponse = restTemplate.postForObject(stockUrl, requestData, Map.class);

            // 데이터 가공
            newsData.put("economyItems", (List<Map<String, Object>>) economyResponse.get("items"));
            newsData.put("coinItems", (List<Map<String, Object>>) coinResponse.get("items"));
            newsData.put("stockItems", (List<Map<String, Object>>) stockResponse.get("items"));

        } catch (Exception e) {
            e.printStackTrace();
            newsData.put("economyItems", new ArrayList<>());
            newsData.put("coinItems", new ArrayList<>());
            newsData.put("stockItems", new ArrayList<>());
        }

        return newsData;
    }
    
    public List<Map<String, Object>> stockInfoNews(String symbol) {
    	
    	List<Map<String, Object>> stockInfoNews = new ArrayList<Map<String,Object>>();
        // RestTemplate 객체 생성
        RestTemplate restTemplate = new RestTemplate();
        String stockUrl = "http://localhost:3000/stockinfonews";

        Map<String, String> requestData = new HashMap<>();
        requestData.put("symbol", symbol);

        try {
            // Node.js 서버에서 데이터 가져오기
            Map<String, Object> stockResponse = restTemplate.postForObject(stockUrl, requestData, Map.class);
            

            // 데이터 가공
            stockInfoNews = (List<Map<String, Object>>) stockResponse.get("items");
            

        } catch (Exception e) {
            e.printStackTrace();
        }
        return stockInfoNews;
        
    }
    
public List<Map<String, Object>> coinInfoNews(String symbol) {
    	
    	List<Map<String, Object>> coinInfoNews = new ArrayList<Map<String,Object>>();
        // RestTemplate 객체 생성
        RestTemplate restTemplate = new RestTemplate();
        String stockUrl = "http://localhost:3000/coininfonews";

        Map<String, String> requestData = new HashMap<>();
        requestData.put("symbol", symbol);

        try {
            // Node.js 서버에서 데이터 가져오기
            Map<String, Object> coinResponse = restTemplate.postForObject(stockUrl, requestData, Map.class);
            

            // 데이터 가공
            coinInfoNews = (List<Map<String, Object>>) coinResponse.get("items");
            

        } catch (Exception e) {
            e.printStackTrace();
        }
        return coinInfoNews;
        
    }
}
