package kr.co.soft.service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import kr.co.soft.DAO.PortfolioDAO;
import kr.co.soft.DAO.ProfileDAO;
import kr.co.soft.beans.PortfolioBean;
import kr.co.soft.beans.PortfolioInfoBean;
import kr.co.soft.beans.StockInfoBean;

@Service
public class PortfolioService {

	@Autowired
	private ProfileDAO profileDAO;
	
	@Autowired
	private PortfolioDAO portfolioDAO;
	
	private final RestTemplate restTemplate;
    private final ObjectMapper objectMapper; // JSON 변환을 위한 ObjectMapper

    public PortfolioService() {
        this.restTemplate = new RestTemplate();
        this.objectMapper = new ObjectMapper();
    }
	
	public String getTendencyCode(int member_idx) {
		String tendencyCode=profileDAO.getTendencyCode(member_idx);
		
		return tendencyCode;
	}
	
	public void addPortfolio(PortfolioBean joinPortfolioBean) {
		portfolioDAO.addPortfolio(joinPortfolioBean);
	}
	
	public List<PortfolioBean> getPortfolio(int member_idx) {
		
		return portfolioDAO.getPortfolio(member_idx);
	}
	
	public PortfolioBean getPortfolioInfo(int portfolio_idx) {
		
		return portfolioDAO.getPortfolioInfo(portfolio_idx);
	}
	
	public void insertStockInfo(StockInfoBean StockInfoBean) {
		portfolioDAO.insertStockInfo(StockInfoBean);
	}
	
	public List<StockInfoBean> searchStocksByCompanyName(String company_name) {
		
		   return portfolioDAO.searchStocksByCompanyName(company_name);
	}
	
	public void addPortfolioInfo(PortfolioInfoBean newPortfolioInfoBean) {
		portfolioDAO.addPortfolioInfo(newPortfolioInfoBean);
	}
	
	public List<PortfolioInfoBean> getPortfolioInfoBean(int portfolio_idx) {
		
		return portfolioDAO.getPortfolioInfoBean(portfolio_idx);
	}
	
	public void deletePortfolioInfoById(int portfolio_info_idx) {
		portfolioDAO.deletePortfolioInfoById(portfolio_info_idx);
	}
	
	public void updatePortfolioDeposit(int portfolio_idx) {
		portfolioDAO.updatePortfolioDeposit(portfolio_idx);
	}
	
	public void updatePortfolioProfitRate(int portfolio_idx, double totalProfitRate) {
		portfolioDAO.updatePortfolioProfitRate(portfolio_idx, totalProfitRate);
	}
	
	public void deletePortfolio(int portfolio_idx) {
		portfolioDAO.deletePortfolio(portfolio_idx);
	}
	
	//여기부터 portfolioMain 메서드
	public List<PortfolioBean> getUpdatedPortfolios(int member_idx) {
        List<PortfolioBean> portfolios = portfolioDAO.getPortfolio(member_idx);

        for (PortfolioBean portfolio : portfolios) {
            updatePortfolioProfitRate(portfolio);
        }

        return portfolioDAO.getPortfolio(member_idx); // 최신화된 포트폴리오 리스트 반환
    }

    private void updatePortfolioProfitRate(PortfolioBean portfolio) {
        int portfolio_idx = portfolio.getPortfolio_idx();
        List<PortfolioInfoBean> portfolioInfoBeans = portfolioDAO.getPortfolioInfoBean(portfolio_idx);

        BigDecimal totalEvaluation = BigDecimal.ZERO;
        BigDecimal totalPurchase = BigDecimal.ZERO;

        for (PortfolioInfoBean infoBean : portfolioInfoBeans) {
        	if(infoBean.getAsset_type().equals("stock")) {
        		BigDecimal evaluation = getStockEvaluation(infoBean);
                totalEvaluation = totalEvaluation.add(evaluation);
        	}
            if(infoBean.getAsset_type().equals("crypto")) {
            	BigDecimal evaluation = getCoinEvaluation(infoBean);
                totalEvaluation = totalEvaluation.add(evaluation);
            }

            BigDecimal purchase = new BigDecimal(infoBean.getPrice() * infoBean.getAmount())
                    .setScale(2, RoundingMode.HALF_UP);
            totalPurchase = totalPurchase.add(purchase);
        }

        BigDecimal totalProfitRate = calculateProfitRate(totalEvaluation, totalPurchase);
        portfolioDAO.updatePortfolioProfitRate(portfolio_idx, totalProfitRate.doubleValue());
    }

    private BigDecimal getStockEvaluation(PortfolioInfoBean infoBean) {
        try {
            Map<String, Object> requestPayload = Map.of("symbol", infoBean.getSymbol());
            String response = restTemplate.postForObject("http://localhost:3000/stock-overview", requestPayload, String.class);

            Map<String, Object> data = objectMapper.readValue(response, new TypeReference<>() {});
            double marketPrice = (double) data.get("marketPrice");

            return new BigDecimal(marketPrice * infoBean.getAmount()).setScale(2, RoundingMode.HALF_UP);
        } catch (Exception e) {
            e.printStackTrace();
            return BigDecimal.ZERO;
        }
    }
    
    private BigDecimal getCoinEvaluation(PortfolioInfoBean infoBean) {
        try {
        	String symbol=infoBean.getSymbol();
            
            String response = restTemplate.getForObject("http://localhost:3000/getCoinInfo?symbol="+symbol,  String.class);

            Map<String, Object> data = objectMapper.readValue(response, new TypeReference<>() {});
            double marketPrice = (double) data.get("price");

            return new BigDecimal(marketPrice * infoBean.getAmount()).setScale(2, RoundingMode.HALF_UP);
        } catch (Exception e) {
            e.printStackTrace();
            return BigDecimal.ZERO;
        }
    }

    private BigDecimal calculateProfitRate(BigDecimal totalEvaluation, BigDecimal totalPurchase) {
        if (totalPurchase.compareTo(BigDecimal.ZERO) > 0) {
            BigDecimal profit = totalEvaluation.subtract(totalPurchase);
            return profit.divide(totalPurchase, 4, RoundingMode.HALF_UP).multiply(new BigDecimal("100"))
                    .setScale(2, RoundingMode.HALF_UP);
        }
        return BigDecimal.ZERO;
    }
	
	public Map<String, Object> stockOverview(String symbol) {
		
		Map<String, Object> processedData = null;
		try {
    		Map<String, Object> requestPayload = new HashMap<>();
        	requestPayload.put("symbol", symbol);
        	
         // Node.js 서버에서 데이터 가져오기
            String viewResponse = restTemplate.postForObject(
                    "http://localhost:3000/stock-overview",requestPayload, String.class);

            // JSON 문자열을 Java 객체로 변환
            processedData = objectMapper.readValue(viewResponse, new TypeReference<Map<String, Object>>() {});
            
            return processedData;
		
		} catch (Exception e) {
			e.printStackTrace();
			return processedData;
		}	
		
	}
	
	public Map<String, Object> getCoinInfo(String symbol) throws Exception {
		
        String nodeResponse = restTemplate.getForObject(
                "http://localhost:3000/getCoinInfo?symbol="+symbol, String.class);
        return objectMapper.readValue(nodeResponse, new TypeReference<Map<String, Object>>() {});
    }
	
	
}
