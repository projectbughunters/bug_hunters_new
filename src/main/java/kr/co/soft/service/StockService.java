package kr.co.soft.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import kr.co.soft.DAO.StockDataDAO;
import kr.co.soft.beans.PageBean;
import kr.co.soft.beans.StockDataBean;

@Service
public class StockService {
	
	@Autowired
	 private StockDataDAO stockDataDAO;
	
	private final RestTemplate restTemplate;
    private final ObjectMapper objectMapper;

    public StockService() {
        this.restTemplate = new RestTemplate();
        this.objectMapper = new ObjectMapper();
    }

    /**
     * Node.js 서버에서 상위 주식 목록을 가져옴
     */
    public List<Map<String, Object>> getTopStocks() throws Exception {
        String nodeResponse = restTemplate.postForObject(
                "http://localhost:3000/top-stocks", new HashMap<>(), String.class);

        return objectMapper.readValue(nodeResponse, new TypeReference<List<Map<String, Object>>>() {});
    }
    
    public PageBean<Map<String, Object>> getPageTopStocks(int page, int pageSize, HttpSession session) throws Exception {
    	
    	List<Map<String, Object>> allStocks = (List<Map<String, Object>>) session.getAttribute("allStocks");
        if (allStocks == null) {
            String nodeResponse = restTemplate.postForObject(
                    "http://localhost:3000/top-stocks", new HashMap<>(), String.class);
            allStocks = objectMapper.readValue(
                    nodeResponse, new TypeReference<List<Map<String, Object>>>() {});
            session.setAttribute("allStocks", allStocks);
        }

        // 전체 데이터 개수 및 전체 페이지 수 계산
        int totalCount = allStocks.size();
        int totalPage = (int) Math.ceil((double) totalCount / pageSize);

        // 페이지 범위에 맞게 데이터 슬라이싱
        int fromIndex = (page - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, totalCount);
        List<Map<String, Object>> pageStocks = allStocks.subList(fromIndex, toIndex);

        // PageBean 객체에 데이터 세팅
        PageBean<Map<String, Object>> pageBean = new PageBean<>();
        pageBean.setList(pageStocks);
        pageBean.setCurrentPage(page);
        pageBean.setPageSize(pageSize);
        pageBean.setTotalCount(totalCount);
        pageBean.setTotalPage(totalPage);

        return pageBean;
    }


    /**
     * 특정 종목의 개요 데이터를 가져옴
     */
    public Map<String, Object> getStockOverview(String symbol) throws Exception {
        Map<String, Object> requestPayload = new HashMap<>();
        requestPayload.put("symbol", symbol);

        String viewResponse = restTemplate.postForObject(
                "http://localhost:3000/stock-overview", requestPayload, String.class);

        return objectMapper.readValue(viewResponse, new TypeReference<Map<String, Object>>() {});
    }

    /**
     * 
     */
    public Map<String, Object> getStockData(String symbol) throws Exception {
        Map<String, Object> requestPayload = new HashMap<>();
        requestPayload.put("symbol", symbol);

        String dataResponse = restTemplate.postForObject(
                "http://localhost:3000/stock-data", requestPayload, String.class);

        return objectMapper.readValue(dataResponse, new TypeReference<Map<String, Object>>() {});
    }
    
    public List<Map<String, Object>> getStockInfo(String symbol) throws Exception {
        String timeframe = "DAILY";
        String dataResponse = restTemplate.getForObject(
                "http://localhost:3000/stock-info?symbol=" + symbol + "&timeframe=" + timeframe, 
                String.class);
        
        // JSON 배열을 List<Map<String, Object>>로 역직렬화
        return objectMapper.readValue(dataResponse, new TypeReference<List<Map<String, Object>>>() {});
    }
    
    public void saveStockData(StockDataBean stockDataBean) {
        // 데이터 저장 로직
        stockDataDAO.insertStockData(stockDataBean);
      }

      public void updateStockData(StockDataBean stockDataBean) {
        stockDataDAO.updateStockData(stockDataBean);
      }


}
