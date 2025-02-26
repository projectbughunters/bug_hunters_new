package kr.co.soft.controller;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import kr.co.soft.beans.StockDataBean;
import kr.co.soft.service.StockService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import java.util.Arrays;
import java.util.List;

@RestController
@RequestMapping("/react")
public class FinancialReactController {
	
  @Autowired
  private StockService stockService;

  private final RestTemplate restTemplate;
  private final ObjectMapper objectMapper;

  public FinancialReactController() {
      this.restTemplate = new RestTemplate();
      this.objectMapper = new ObjectMapper();
  }

  //재무제표 업데이트
  @CrossOrigin(origins = "http://localhost:5173") // React 개발 서버 주소
  @PutMapping("/dataupdate")
  public String getDataUpdate(Model model) {
    List<String> symbols = Arrays.asList("AAPL", "MSFT", "GOOGL", "AMZN", "TSLA", "KO", "MRK", "PFE", "AVGO",
        "TMO", "COST", "WMT", "DIS", "DHR", "INTC", "ADBE", "CRM", "QCOM",
        "TXN", "LIN", "ACN", "CMCSA", "NKE", "AMAT", "NEE", "ELV", "RTX",
        "CAT", "GS", "AXP", "IBM", "PLD", "BLK", "MS", "GE", "MDT", "PYPL",
        "C", "AMGN", "CVS", "ADI", "NOW", "INTU", "NFLX", "TMUS", "DE",
        "SCHW", "UPS", "AMD", "BKNG", "ADP", "LRCX", "EQIX", "SYK", "ISRG",
        "CSX", "GILD", "T", "ZTS", "PNC", "WM", "CL", "REGN", "MO", "USB",
        "COF", "UNH", "BAC", "HON", "SPGI", "FIS", "APD", "HUM", "CCI",
        "ECL", "ORLY", "VRTX", "DG");
    try {
      for (String symbol : symbols) {
        String url = "http://localhost:3000/stock-ov?symbol=" + symbol; // API URL
// API 요청하여 JSON 응답을 문자열로 가져오기
        String jsonResponse = restTemplate.getForObject(url, String.class);

        // JSON 문자열을 JsonNode로 변환
        JsonNode jsonNode = objectMapper.readTree(jsonResponse);

        // StockDataBean 객체 생성 및 필드 매핑
        StockDataBean stockData = new StockDataBean();
        stockData.setSymbol(jsonNode.get("symbol").asText()); // 수정된 변수명
        stockData.setName(jsonNode.get("name").asText());
        stockData.setCik(jsonNode.get("cik").asText());
        stockData.setExchange(jsonNode.get("exchange").asText());
        stockData.setCurrency(jsonNode.get("currency").asText());
        stockData.setCountry(jsonNode.get("country").asText());
        stockData.setSector(jsonNode.get("sector").asText());
        stockData.setIndustry(jsonNode.get("industry").asText());
        stockData.setAddress(jsonNode.get("address").asText());
        stockData.setOfficialSite(jsonNode.get("officialSite").asText());
        stockData.setFiscalYearEnd(jsonNode.get("fiscalYearEnd").asText());

        // 숫자 필드 변환
        stockData.setMarketCapitalization(jsonNode.get("marketCapitalization").asDouble());
        stockData.setEbitda(jsonNode.get("ebitda").asDouble());
        stockData.setPeRatio(jsonNode.get("peRatio").asDouble());
        stockData.setPegRatio(jsonNode.get("pegRatio").asDouble());
        stockData.setBookValue(jsonNode.get("bookValue").asDouble());
        stockData.setDividendPerShare(jsonNode.get("dividendPerShare").asDouble());
        stockData.setDividendYield(jsonNode.get("dividendYield").asDouble());
        stockData.setEps(jsonNode.get("eps").asDouble());
        stockData.setRevenuePerShareTTM(jsonNode.get("revenuePerShareTTM").asDouble());
        stockData.setProfitMargin(jsonNode.get("profitMargin").asDouble());
        stockData.setOperatingMarginTTM(jsonNode.get("operatingMarginTTM").asDouble());
        stockData.setReturnOnAssetsTTM(jsonNode.get("returnOnAssetsTTM").asDouble());
        stockData.setReturnOnEquityTTM(jsonNode.get("returnOnEquityTTM").asDouble());
        stockData.setRevenueTTM(jsonNode.get("revenueTTM").asDouble());
        stockData.setGrossProfitTTM(jsonNode.get("grossProfitTTM").asDouble());
        stockData.setDilutedEPSTTM(jsonNode.get("dilutedEPSTTM").asDouble());
        stockData.setQuarterlyEarningsGrowthYOY(jsonNode.get("quarterlyEarningsGrowthYOY").asDouble());
        stockData.setQuarterlyRevenueGrowthYOY(jsonNode.get("quarterlyRevenueGrowthYOY").asDouble());
        stockData.setAnalystTargetPrice(jsonNode.get("analystTargetPrice").asDouble());
        stockData.setAnalystRatingStrongBuy(jsonNode.get("analystRatingStrongBuy").asInt());
        stockData.setAnalystRatingBuy(jsonNode.get("analystRatingBuy").asInt());
        stockData.setAnalystRatingHold(jsonNode.get("analystRatingHold").asInt());
        stockData.setAnalystRatingSell(jsonNode.get("analystRatingSell").asInt());
        stockData.setAnalystRatingStrongSell(jsonNode.get("analystRatingStrongSell").asInt());
        stockData.setTrailingPE(jsonNode.get("trailingPE").asDouble());
        stockData.setForwardPE(jsonNode.get("forwardPE").asDouble());
        stockData.setPriceToSalesRatioTTM(jsonNode.get("priceToSalesRatioTTM").asDouble());
        stockData.setPriceToBookRatio(jsonNode.get("priceToBookRatio").asDouble());
        stockData.setEvToRevenue(jsonNode.get("evToRevenue").asDouble());
        stockData.setEvToEBITDA(jsonNode.get("evToEBITDA").asDouble());
        stockData.setBeta(jsonNode.get("beta").asDouble());
        stockData.setFiftyTwoWeekHigh(jsonNode.get("fiftyTwoWeekHigh").asDouble());
        stockData.setFiftyTwoWeekLow(jsonNode.get("fiftyTwoWeekLow").asDouble());
        stockData.setFiftyDayMovingAverage(jsonNode.get("fiftyDayMovingAverage").asDouble());
        stockData.setTwoHundredDayMovingAverage(jsonNode.get("twoHundredDayMovingAverage").asDouble());
        stockData.setSharesOutstanding(jsonNode.get("sharesOutstanding").asLong());

        // 서비스 통해 데이터베이스에 업데이트
        stockService.updateStockData(stockData);
        System.out.println("통신성공");
      }
    } catch (Exception e) {
      e.printStackTrace();
      model.addAttribute("error", "데이터를 불러오지 못했습니다.");
      // 에러 발생 시 React의 에러 페이지로 리다이렉트
      return "redirect:http://localhost:5173/portfolio-analysis";
    }

    // 성공 시 React의 성공 페이지로 리다이렉트
    return "redirect:http://localhost:5173/financial-management";
  }

  //재무제표 저장
  @CrossOrigin(origins = "http://localhost:5173") // React 개발 서버 주소
  @PutMapping("/datasave")
  public String getDataSave(Model model) {
    List<String> symbols = Arrays.asList("AAPL", "MSFT", "GOOGL", "AMZN", "TSLA", "KO", "MRK", "PFE", "AVGO",
        "TMO", "COST", "WMT", "DIS", "DHR", "INTC", "ADBE", "CRM", "QCOM",
        "TXN", "LIN", "ACN", "CMCSA", "NKE", "AMAT", "NEE", "ELV", "RTX",
        "CAT", "GS", "AXP", "IBM", "PLD", "BLK", "MS", "GE", "MDT", "PYPL",
        "C", "AMGN", "CVS", "ADI", "NOW", "INTU", "NFLX", "TMUS", "DE",
        "SCHW", "UPS", "AMD", "BKNG", "ADP", "LRCX", "EQIX", "SYK", "ISRG",
        "CSX", "GILD", "T", "ZTS", "PNC", "WM", "CL", "REGN", "MO", "USB",
        "COF", "UNH", "BAC", "HON", "SPGI", "FIS", "APD", "HUM", "CCI",
        "ECL", "ORLY", "VRTX", "DG");
    try {
      for (String symbol : symbols) {
        String url = "http://localhost:3000/stock-ov?symbol=" + symbol; // API URL
// API 요청하여 JSON 응답을 문자열로 가져오기
        String jsonResponse = restTemplate.getForObject(url, String.class);

        // JSON 문자열을 JsonNode로 변환
        JsonNode jsonNode = objectMapper.readTree(jsonResponse);

        // StockDataBean 객체 생성 및 필드 매핑
        StockDataBean stockData = new StockDataBean();
        stockData.setSymbol(jsonNode.get("symbol").asText()); // 수정된 변수명
        stockData.setName(jsonNode.get("name").asText());
        stockData.setCik(jsonNode.get("cik").asText());
        stockData.setExchange(jsonNode.get("exchange").asText());
        stockData.setCurrency(jsonNode.get("currency").asText());
        stockData.setCountry(jsonNode.get("country").asText());
        stockData.setSector(jsonNode.get("sector").asText());
        stockData.setIndustry(jsonNode.get("industry").asText());
        stockData.setAddress(jsonNode.get("address").asText());
        stockData.setOfficialSite(jsonNode.get("officialSite").asText());
        stockData.setFiscalYearEnd(jsonNode.get("fiscalYearEnd").asText());

        // 숫자 필드 변환
        stockData.setMarketCapitalization(jsonNode.get("marketCapitalization").asDouble());
        stockData.setEbitda(jsonNode.get("ebitda").asDouble());
        stockData.setPeRatio(jsonNode.get("peRatio").asDouble());
        stockData.setPegRatio(jsonNode.get("pegRatio").asDouble());
        stockData.setBookValue(jsonNode.get("bookValue").asDouble());
        stockData.setDividendPerShare(jsonNode.get("dividendPerShare").asDouble());
        stockData.setDividendYield(jsonNode.get("dividendYield").asDouble());
        stockData.setEps(jsonNode.get("eps").asDouble());
        stockData.setRevenuePerShareTTM(jsonNode.get("revenuePerShareTTM").asDouble());
        stockData.setProfitMargin(jsonNode.get("profitMargin").asDouble());
        stockData.setOperatingMarginTTM(jsonNode.get("operatingMarginTTM").asDouble());
        stockData.setReturnOnAssetsTTM(jsonNode.get("returnOnAssetsTTM").asDouble());
        stockData.setReturnOnEquityTTM(jsonNode.get("returnOnEquityTTM").asDouble());
        stockData.setRevenueTTM(jsonNode.get("revenueTTM").asDouble());
        stockData.setGrossProfitTTM(jsonNode.get("grossProfitTTM").asDouble());
        stockData.setDilutedEPSTTM(jsonNode.get("dilutedEPSTTM").asDouble());
        stockData.setQuarterlyEarningsGrowthYOY(jsonNode.get("quarterlyEarningsGrowthYOY").asDouble());
        stockData.setQuarterlyRevenueGrowthYOY(jsonNode.get("quarterlyRevenueGrowthYOY").asDouble());
        stockData.setAnalystTargetPrice(jsonNode.get("analystTargetPrice").asDouble());
        stockData.setAnalystRatingStrongBuy(jsonNode.get("analystRatingStrongBuy").asInt());
        stockData.setAnalystRatingBuy(jsonNode.get("analystRatingBuy").asInt());
        stockData.setAnalystRatingHold(jsonNode.get("analystRatingHold").asInt());
        stockData.setAnalystRatingSell(jsonNode.get("analystRatingSell").asInt());
        stockData.setAnalystRatingStrongSell(jsonNode.get("analystRatingStrongSell").asInt());
        stockData.setTrailingPE(jsonNode.get("trailingPE").asDouble());
        stockData.setForwardPE(jsonNode.get("forwardPE").asDouble());
        stockData.setPriceToSalesRatioTTM(jsonNode.get("priceToSalesRatioTTM").asDouble());
        stockData.setPriceToBookRatio(jsonNode.get("priceToBookRatio").asDouble());
        stockData.setEvToRevenue(jsonNode.get("evToRevenue").asDouble());
        stockData.setEvToEBITDA(jsonNode.get("evToEBITDA").asDouble());
        stockData.setBeta(jsonNode.get("beta").asDouble());
        stockData.setFiftyTwoWeekHigh(jsonNode.get("fiftyTwoWeekHigh").asDouble());
        stockData.setFiftyTwoWeekLow(jsonNode.get("fiftyTwoWeekLow").asDouble());
        stockData.setFiftyDayMovingAverage(jsonNode.get("fiftyDayMovingAverage").asDouble());
        stockData.setTwoHundredDayMovingAverage(jsonNode.get("twoHundredDayMovingAverage").asDouble());
        stockData.setSharesOutstanding(jsonNode.get("sharesOutstanding").asLong());

        // 서비스 통해 데이터베이스에 저장
        stockService.saveStockData(stockData); // saveStockData 호출
        System.out.println("통신성공");
      }
    } catch (Exception e) {
      e.printStackTrace();
      model.addAttribute("error", "데이터를 불러오지 못했습니다.");
      // 에러 발생 시 React의 에러 페이지로 리다이렉트
      return "redirect:http://localhost:5173/portfolio-analysis";
    }

    // 성공 시 React의 성공 페이지로 리다이렉트
    return "redirect:http://localhost:5173/financial-management";
  }

  //재무제표 저장
  @CrossOrigin(origins = "http://localhost:5173") // React 개발 서버 주소
  @PutMapping("/dataedit")
  public String getDataEdit(@RequestBody StockDataBean stockData, Model model) {
    try {
      // 서비스 통해 데이터베이스에 업데이트
      stockService.updateStockData(stockData);
      System.out.println("데이터 업데이트 성공");

      // 성공 시 React의 성공 페이지로 리다이렉트
      return "redirect:http://localhost:5173/financial-management";
    } catch (Exception e) {
      e.printStackTrace();
      model.addAttribute("error", "데이터를 업데이트하지 못했습니다.");

      // 에러 발생 시 React의 에러 페이지로 리다이렉트
      return "redirect:http://localhost:5173/portfolio-analysis";
    }
}
}


