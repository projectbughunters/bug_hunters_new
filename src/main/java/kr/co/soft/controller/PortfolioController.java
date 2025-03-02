package kr.co.soft.controller;

import java.io.File;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import kr.co.soft.beans.PortfolioBean;
import kr.co.soft.beans.PortfolioInfoBean;
import kr.co.soft.beans.ProfileBean;
import kr.co.soft.beans.StockInfoBean;
import kr.co.soft.beans.UserBean;
import kr.co.soft.service.MyPageService;
import kr.co.soft.service.PortfolioService;

@Controller
@RequestMapping("/portfolio")
public class PortfolioController {

	@Autowired
	private ServletContext servletContext;
	
	@Autowired
	private MyPageService myPageService;
	
	@Autowired
	private PortfolioService portfolioService;
	
	@Resource(name = "loginUserBean")
	private UserBean loginUserBean;
	
	@Resource(name = "profileBean")
	private ProfileBean profileBean;
	
	private final RestTemplate restTemplate;
    private final ObjectMapper objectMapper; // JSON 변환을 위한 ObjectMapper

    public PortfolioController() {
        this.restTemplate = new RestTemplate();
        this.objectMapper = new ObjectMapper();
    }
	
    @GetMapping("/portfolioMain")
    public String portfolioMain(Model model) {
        int member_idx = loginUserBean.getMember_idx();
        String name = loginUserBean.getMember_name();
        
        // 투자 성향 코드 조회
        String tendencyCode = portfolioService.getTendencyCode(member_idx);
        if (tendencyCode == null) {
            model.addAttribute("alertMessage", "먼저 투자성향 검사를 진행하세요.");
            return "portfolio/tendencyAlert";
        }

        // 포트폴리오 정보 조회 및 수익률 업데이트
        List<PortfolioBean> portfolioBeans = portfolioService.getUpdatedPortfolios(member_idx);

        // 모델에 데이터 추가
        model.addAttribute("tendencyCode", tendencyCode);
        model.addAttribute("name", name);
        model.addAttribute("portfolios", portfolioBeans);

        return "portfolio/portfolioMain";
    }
    
    @GetMapping("/newPortfolio")
    public String newPortfolio(@ModelAttribute("newPortfolioBean") PortfolioBean newPortfolioBean, Model model) {

    	
        return "portfolio/newPortfolio";
    }
    
    @PostMapping("/newPortfolio_pro")
    public String newPortfolio_pro(@ModelAttribute("newPortfolioBean") PortfolioBean newPortfolioBean, Model model) {

        portfolioService.addPortfolio(newPortfolioBean);

        return "redirect:/portfolio/portfolioMain";
    }
    
    @GetMapping("/info/{portfolio_idx}")
    public String PortfolioInfo(@PathVariable("portfolio_idx") int portfolio_idx, Model model) {
    	
    	PortfolioBean portfolioBean = portfolioService.getPortfolioInfo(portfolio_idx);
    	List<PortfolioInfoBean> portfolioInfoBeans = portfolioService.getPortfolioInfoBean(portfolio_idx);
    	
    	
    	model.addAttribute("portfolioBean", portfolioBean);
    	model.addAttribute("portfolioInfoBeans", portfolioInfoBeans);
    	model.addAttribute("portfolio_idx", portfolio_idx);

    	
        return "portfolio/portfolioInfo";
    }
    
    @GetMapping("/delete/{portfolio_idx}/{portfolio_info_idx}")
    public String deletePortfolioInfo(@PathVariable("portfolio_idx") int portfolio_idx, @PathVariable("portfolio_info_idx") int portfolio_info_idx, Model model) {
    	
    	portfolioService.deletePortfolioInfoById(portfolio_info_idx);
    	portfolioService.updatePortfolioDeposit(portfolio_idx);
    	
    	
    	return "redirect:/portfolio/info/" + portfolio_idx;
    }
    
    @GetMapping("/ratioDelete/{portfolio_idx}/{portfolio_info_idx}")
    public String ratioDeletePortfolioInfo(@PathVariable("portfolio_idx") int portfolio_idx, @PathVariable("portfolio_info_idx") int portfolio_info_idx, Model model) {
    	
    	portfolioService.deletePortfolioInfoById(portfolio_info_idx);
    	portfolioService.updatePortfolioDeposit(portfolio_idx);
    	
    	
    	return "redirect:/portfolio/newStockRatio/" + portfolio_idx;
    }
    
    @GetMapping("/deletePortfolio/{portfolio_idx}")
    public String deletePortfolio(@PathVariable("portfolio_idx") int portfolio_idx, Model model) {
    	
    	portfolioService.deletePortfolio(portfolio_idx);
    	
    	
    	return "redirect:/portfolio/portfolioMain";
    }
    
    @GetMapping("/updateProfit")
    public String updateProfit(@RequestParam("portfolio_idx") int portfolio_idx, 
            @RequestParam("totalProfitRate") double totalProfitRate, Model model) {
    	
    	
    	portfolioService.updatePortfolioProfitRate(portfolio_idx, totalProfitRate);
    	
    	
    	return "success";
    }
    
    @GetMapping("/newStock/{portfolio_idx}")
    public String newStock(@PathVariable("portfolio_idx") int portfolio_idx,
    		@ModelAttribute("newPortfolioInfoBean") PortfolioInfoBean newPortfolioInfoBean,
    		Model model) {
		newPortfolioInfoBean.setPortfolio_idx(portfolio_idx);

    	model.addAttribute("portfolio_idx", portfolio_idx);
        return "portfolio/newStock";
    }
    
    @PostMapping("/search")
	   public String search(@RequestParam("company_name") String company_name, @RequestParam("portfolio_idx") int portfolio_idx, 
			   @ModelAttribute("newPortfolioInfoBean") PortfolioInfoBean newPortfolioInfoBean,
			   Model model) {
		
		   List<StockInfoBean> searchResults=portfolioService.searchStocksByCompanyName(company_name);
		   newPortfolioInfoBean.setPortfolio_idx(portfolio_idx);
		   String message = "";
		   if (searchResults == null || searchResults.isEmpty()) {
			   message = "검색된 결과가 없습니다";
		   }
		   
		   model.addAttribute("searchResults", searchResults);
		   model.addAttribute("portfolio_idx", portfolio_idx);
		   model.addAttribute("message", message);
		   
		   return "portfolio/newStock";
	}
    
    @GetMapping("/stockInfo/{symbol}/{company_name}/{type}/{portfolio_idx}")
    public String stockInfo(@PathVariable("symbol") String symbol, @PathVariable("company_name") String company_name, 
    		@PathVariable("type") String type,
    		@PathVariable("portfolio_idx") int portfolio_idx,
    		@ModelAttribute("newPortfolioInfoBean") PortfolioInfoBean newPortfolioInfoBean,
    		Model model) {
    	
    	try {
    		if(type.equals("stock")) {
            // JSON 문자열을 Java 객체로 변환
	            Map<String, Object> processedData = portfolioService.stockOverview(symbol);
	            Object marketPriceObj = processedData.get("marketPrice");
	            
	            newPortfolioInfoBean.setPortfolio_idx(portfolio_idx);
	            newPortfolioInfoBean.setStock_name(company_name);
	            newPortfolioInfoBean.setSymbol(processedData.get("symbol").toString());
	            newPortfolioInfoBean.setPrice(((Number) marketPriceObj).doubleValue());
	            newPortfolioInfoBean.setType(type);
    		}
    		if(type.equals("crypto")) {
                // JSON 문자열을 Java 객체로 변환
                Map<String, Object> processedData = portfolioService.getCoinInfo(symbol);
                Object marketPriceObj = processedData.get("price");
                
                newPortfolioInfoBean.setPortfolio_idx(portfolio_idx);
                newPortfolioInfoBean.setStock_name(company_name);
                newPortfolioInfoBean.setSymbol(processedData.get("symbol").toString());
                newPortfolioInfoBean.setPrice(Math.round(((Number) marketPriceObj).doubleValue() * 100.0) / 100.0);
                newPortfolioInfoBean.setType(type);
        	}
    		
    		

        	model.addAttribute("portfolio_idx", portfolio_idx);
			
		} catch (Exception e) {
			e.printStackTrace();
            model.addAttribute("error", "데이터를 불러오지 못했습니다.");
		}
    	
        return "portfolio/newStock";
    }

    @PostMapping("/newStock_pro")
    public String newStock_pro(@ModelAttribute("newPortfolioInfoBean") PortfolioInfoBean newPortfolioInfoBean, Model model) {
        int portfolio_idx = newPortfolioInfoBean.getPortfolio_idx();
        String tendency_code=profileBean.getPersonal_tendency_code();
        try {
                portfolioService.addPortfolioInfo(newPortfolioInfoBean);
        } catch (DuplicateKeyException e) {
            // 중복된 symbol 발생 시 경고창에 띄울 메시지 설정
            model.addAttribute("errorMessage", "중복된 종목입니다. 다른 종목을 추가해 주세요.");
            model.addAttribute("portfolio_idx", portfolio_idx);
            // 에러 메시지를 보여줄 별도의 JSP 페이지로 이동
            return "portfolio/portfolioError";
        }
        
        List<PortfolioInfoBean> portfolioRatioInfos = portfolioService.getPortfolioInfoBean(portfolio_idx);
        model.addAttribute("portfolio_idx", portfolio_idx);
        model.addAttribute("portfolioRatioInfos", portfolioRatioInfos);
        model.addAttribute("tendency_code", tendency_code);
        
        return "portfolio/portfolioRatio";
    }
	
	@GetMapping("/newStockRatio/{portfolio_idx}")
	   public String newStockRatio(@PathVariable("portfolio_idx") int portfolio_idx, Model model) {
		  
			String tendency_code=profileBean.getPersonal_tendency_code();
		   
		   List<PortfolioInfoBean> portfolioRatioInfos = portfolioService.getPortfolioInfoBean(portfolio_idx);
	        model.addAttribute("portfolio_idx", portfolio_idx);
	        model.addAttribute("portfolioRatioInfos", portfolioRatioInfos);
	        model.addAttribute("tendency_code", tendency_code);
		   
		   return "portfolio/portfolioRatio";
	}
	
	@PostMapping("/newStockRatio_pro")
	   public String newStockRatio_pro(HttpServletRequest request, Model model) {
		  
		// 폼에서 전체 portfolio_idx를 전달받음
	    int portfolio_idx = Integer.parseInt(request.getParameter("portfolio_idx"));
	    
	    // 폼에 전달된 모든 파라미터를 가져옴
	    Map<String, String[]> paramMap = request.getParameterMap();
	    
	    // "quantity_"로 시작하는 파라미터를 순회하며 각 행의 값을 처리
	    for (String key : paramMap.keySet()) {
	        if (key.startsWith("quantity_")) {
	            // 예: key="quantity_101"이면 idStr = "101"
	            String idStr = key.substring("quantity_".length());
	            double quantity = 0;
	            try {
	                quantity = Double.parseDouble(request.getParameter(key));
	            } catch (NumberFormatException e) {
	                // 수량이 숫자로 변환되지 않으면 0으로 처리
	                quantity = 0;
	            }
	            
	            // symbol 정보가 있을 경우 사용, 없으면 stockName을 대신 사용 (실제 업데이트에 필요한 값)
	            String symbol = request.getParameter("symbol_" + idStr);
	            if (symbol == null || symbol.isEmpty()) {
	                symbol = request.getParameter("stockName_" + idStr);
	            }
	            
	            // 서비스 메서드를 통해 DB 업데이트 호출
	            // updatePortfolioInfoAmount(portfolio_idx, amount, symbol)
	            portfolioService.updatePortfolioInfoAmount(portfolio_idx, quantity, symbol);
	        }
	    }
		   
		   return "redirect:/portfolio/info/" + portfolio_idx;
	}
	
    
	@GetMapping("/tendencyTest")
	public String tendencyMain(Model model) {

		try {
			// JSON 파일의 절대 경로 지정
			String filePath = servletContext.getRealPath("/resources/question.json");
			File file = new File(filePath);

			if (!file.exists()) {
				throw new RuntimeException("JSON 파일을 찾을 수 없습니다: " + filePath);
			}

			// 파일 내용을 읽고 JSON 파싱
			ObjectMapper mapper = new ObjectMapper();
			List<Map<String, Object>> questions = mapper.readValue(file, new TypeReference<>() {
			});

			// 모델에 데이터 추가
			model.addAttribute("questions", questions);

		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("errorMessage", "질문 데이터를 로드하는 중 문제가 발생했습니다.");
		}

		return "portfolio/tendencyTest";
	}

	@PostMapping("/tendencyResult")
	public String tendencyResult(HttpServletRequest request, Model model) {

		int total = 0;

		// tendencyTest.jsp에서 각 질문에 대한 답변을 받아 점수 계산
		for (int i = 1; i <= 10; i++) {
			String answer = request.getParameter("q" + i);
			if (answer != null) {
				total += Integer.parseInt(answer);
			}
		}

		// 투자 성향에 따라 타입 및 설명 설정
		String type = "";
		String description = "";

		if (total >= 31) {
			type = "공격형";
			description = "높은 리스크를 감수하고 빠른 성장을 추구합니다. 주식과 고위험 자산에 과감히 투자하는 성향입니다.";
		} else if (total >= 21) {
			type = "중립형";
			description = "적절한 리스크를 감수하며 안정성과 성장을 동시에 추구합니다. 다양한 자산에 분산 투자하여 리스크를 관리하는 성향입니다.";
		} else {
			type = "보수형";
			description = "리스크를 최소화하고 안정적인 수익을 선호합니다. 안전한 자산에 투자하며, 시장의 변동성을 싫어하는 성향입니다.";
		}

		// 결과를 jsp로 전달
		model.addAttribute("total", total);
		model.addAttribute("type", type);
		model.addAttribute("description", description);
		
		profileBean.setPersonal_tendency_code(type);
		
		int member_idx=loginUserBean.getMember_idx();

		//DB에 개인투자성향코드 업데이트 
		myPageService.updateTendencyCode(type, member_idx);
		

		return "portfolio/tendencyResult";
	}
	
	@GetMapping("/portfolioStart")
	public String portfolioStart() {
		
		return "portfolio/portfolioStart";
	}
	
	@GetMapping("/loginError")
	public String loginError() {
	    return "portfolio/loginError";
	}
}