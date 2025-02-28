package kr.co.soft.service;

import java.math.BigDecimal;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import kr.co.soft.beans.PageBean;

@Service
public class CoinService {

    private final RestTemplate restTemplate;
    private final ObjectMapper objectMapper;

    public CoinService() {
        this.restTemplate = new RestTemplate();
        this.objectMapper = new ObjectMapper();
    }
    
    /**
     * Node.js 서버에서 코인 데이터를 가져옴
     */
    public List<Map<String, Object>> getAllCoins() throws Exception {
        String nodeResponse = restTemplate.getForObject(
                "http://localhost:3000/content", String.class);
        return objectMapper.readValue(nodeResponse, new TypeReference<List<Map<String, Object>>>() {});
    }
    
    
    public PageBean<Map<String, Object>> getPageCoins(int page, int pageSize) throws Exception {
        // Node.js 서버에서 전체 코인 데이터를 가져옴
        String nodeResponse = restTemplate.getForObject(
                "http://localhost:3000/content", String.class);

        List<Map<String, Object>> allCoins = objectMapper.readValue(
                nodeResponse, new TypeReference<List<Map<String, Object>>>() {});

        // 전체 데이터 개수 및 전체 페이지 수 계산
        int totalCount = allCoins.size();
        int totalPage = (int) Math.ceil((double) totalCount / pageSize);

        // 페이지 범위에 맞게 데이터 슬라이싱
        int fromIndex = (page - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, totalCount);
        List<Map<String, Object>> pageCoins = allCoins.subList(fromIndex, toIndex);

        // PageBean 객체에 데이터 세팅
        PageBean<Map<String, Object>> pageBean = new PageBean<>();
        pageBean.setList(pageCoins);
        pageBean.setCurrentPage(page);
        pageBean.setPageSize(pageSize);
        pageBean.setTotalCount(totalCount);
        pageBean.setTotalPage(totalPage);

        return pageBean;
    }
    
    public Map<String, Object> getCryptoDominance() throws Exception {
        String nodeResponse = restTemplate.getForObject("http://localhost:3000/dominance", String.class);
        Map<String, Object> rawData = objectMapper.readValue(nodeResponse, new TypeReference<Map<String, Object>>() {});

        Map<String, BigDecimal> formattedData = new HashMap<>();
        
        // 데이터를 변환하여 소수점 두 자리 반올림
        for (Map.Entry<String, Object> entry : rawData.entrySet()) {
            try {
                double value = Double.parseDouble(entry.getValue().toString());
                BigDecimal roundedValue = new BigDecimal(value).setScale(2, BigDecimal.ROUND_HALF_UP); // 소수점 둘째 자리 반올림
                formattedData.put(entry.getKey(), roundedValue);
            } catch (NumberFormatException e) {
                // 숫자가 아닌 값은 무시
            }
        }

        // 내림차순(점유율 높은 순) 정렬
        Map<String, Object> sortedData = formattedData.entrySet()
            .stream()
            .sorted(Map.Entry.<String, BigDecimal>comparingByValue(Comparator.reverseOrder())) // 내림차순 정렬
            .collect(Collectors.toMap(
                Map.Entry::getKey, 
                Map.Entry::getValue, 
                (e1, e2) -> e1, 
                LinkedHashMap::new // 순서를 유지하는 LinkedHashMap 사용
            ));

        return sortedData;
    }

}
