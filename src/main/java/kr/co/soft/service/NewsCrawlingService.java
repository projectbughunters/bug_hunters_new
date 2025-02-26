package kr.co.soft.service;

import kr.co.soft.beans.NewsBean;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

@Service
public class NewsCrawlingService {

    public List<NewsBean> getNewsArticles() {
        List<NewsBean> newsList = new ArrayList<>();
        String url = "https://finance.naver.com/news/mainnews.naver"; // 네이버 금융 뉴스 페이지 URL

        try {
            Document document = Jsoup.connect(url).get(); // 페이지 HTML 가져오기

            // 크롤링된 뉴스 항목을 찾기 위한 선택자
            Elements newsElements = document.select("li.block1"); // <li class="block1"> 요소 선택

            for (Element newsElement : newsElements) {
                // 뉴스 제목 및 링크 가져오기
                Element titleElement = newsElement.selectFirst("dd.articleSubject a");
                String title = (titleElement != null) ? titleElement.text() : "제목 없음";
                String link = (titleElement != null) ? titleElement.attr("href") : "#";

                // 뉴스 이미지 가져오기
                Element imgElement = newsElement.selectFirst("dt.thumb img");
                String image = (imgElement != null) ? imgElement.attr("src") : ""; // 이미지 없으면 빈 문자열

                // 네이버 뉴스 링크에서 articleId와 officeId 추출
                String articleId = extractArticleId(link);
                String officeId = extractOfficeId(link);

                // NewsBean에 추가
                newsList.add(new NewsBean(title, link, image, articleId, officeId));
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
 
        return newsList;
    }

    // 네이버 뉴스 링크에서 articleId 추출
    private String extractArticleId(String link) {
        // 쿼리 파라미터에서 article_id 추출 시도
        String articleId = getQueryParam(link, "article_id");
        if (articleId != null) {
            return articleId;
        }
        // 쿼리 파라미터가 없으면 기존 방식으로 추출 (URL 경로 기준)
        String[] parts = link.split("/");
        if (parts.length > 3) {
            return parts[3]; // 예: https://n.news.naver.com/mnews/article/{officeId}/{articleId}
        }
        return null;
    }

    // 네이버 뉴스 링크에서 officeId 추출
    private String extractOfficeId(String link) {
        // 쿼리 파라미터에서 office_id 추출 시도
        String officeId = getQueryParam(link, "office_id");
        if (officeId != null) {
            return officeId;
        }
        // 쿼리 파라미터가 없으면 기존 방식으로 추출 (URL 경로 기준)
        String[] parts = link.split("/");
        if (parts.length > 2) {
            return parts[2];
        }
        return null;
    }

    // 주어진 URL에서 특정 쿼리 파라미터 값을 추출하는 헬퍼 메서드
    private String getQueryParam(String url, String key) {
        try {
            // URL이 절대 경로가 아니라면 기본 도메인을 붙여줌
            if (!url.startsWith("http://") && !url.startsWith("https://")) {
                url = "https://n.news.naver.com" + url;
            }
            URL urlObj = new URL(url);
            String query = urlObj.getQuery();
            if (query != null) {
                String[] params = query.split("&");
                for (String param : params) {
                    if (param.startsWith(key + "=")) {
                        return param.substring((key + "=").length());
                    }
                }
            }
        } catch (MalformedURLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
