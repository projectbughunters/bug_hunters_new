package kr.co.soft.controller;

import kr.co.soft.beans.FavoriteBean;
import kr.co.soft.beans.PageBean;
import kr.co.soft.beans.StockInfoBean;
import kr.co.soft.beans.UserBean;
import kr.co.soft.service.CoinService;
import kr.co.soft.service.FavoriteService;
import kr.co.soft.service.NewsService;
import kr.co.soft.service.PortfolioService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

@Controller
@RequestMapping("/coin")
public class CoinController {

    @Autowired
    private CoinService coinService;
    
    @Autowired
    private NewsService newsService;
    
    @Autowired
	private FavoriteService favoriteService;
    
    @Resource(name = "loginUserBean")
	private UserBean loginUserBean;
    
    @Autowired
	private PortfolioService portfolioService;

    @GetMapping("/coinMain")
    public String main(@RequestParam(defaultValue = "1") int page, Model model) {
        try {
        	int member_idx=loginUserBean.getMember_idx();
        	int pageSize = 15;
        	PageBean<Map<String, Object>> pageBean = coinService.getPageCoins(page, pageSize);
        	List<FavoriteBean> favorites = favoriteService.selectFavoritesByMemberIdx(member_idx);
            model.addAttribute("pageBean", pageBean);
            model.addAttribute("favorites", favorites);
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "데이터를 불러오지 못했습니다.");
        }
        return "/coin/coinMain";
    }
    
    @GetMapping("/info/{symbol}/{name}")
    public String getCoinInfo(@PathVariable("symbol") String symbol, 
                              @PathVariable("name") String name, Model model) {
    	//StockInfoBean stockInfo = new StockInfoBean();
        try {
            List<Map<String, Object>> coins = coinService.getAllCoins();
              
            List<Map<String, Object>> coinInfoNews=newsService.coinInfoNews(symbol);
            Map<String, Object> dominanceData = coinService.getCryptoDominance();
            
            model.addAttribute("coins", coins);
            model.addAttribute("symbol", symbol);
            model.addAttribute("name", name);
            model.addAttribute("coinInfoNews", coinInfoNews);
            model.addAttribute("dominanceData", dominanceData);
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "차트 데이터를 불러오지 못했습니다.");
        }
        return "coin/coinInfo";
    }
}
