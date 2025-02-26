package kr.co.soft.controller;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import kr.co.soft.service.NewsService;

@Controller
@RequestMapping("/news")
public class NewsController {  

    private final NewsService newsService;

    public NewsController(NewsService newsService) {
        this.newsService = newsService;
    }

    @GetMapping("/newsMain")
    public String newsMain(Model model) {
        Map<String, List<Map<String, Object>>> newsData = newsService.fetchAllNews();

        model.addAttribute("economyItems", newsData.get("economyItems"));
        model.addAttribute("coinItems", newsData.get("coinItems"));
        model.addAttribute("stockItems", newsData.get("stockItems"));

        return "news/newsMain";
    }
}



