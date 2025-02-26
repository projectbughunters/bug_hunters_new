package kr.co.soft.beans;

public class NewsBean {

    private String title;
    private String link;
    private String image;
    private String articleId;
    private String officeId;

    public NewsBean() {
    } 

    public NewsBean(String title, String link, String image, String articleId, String officeId) {
        this.title = title;
        this.link = link;
        this.image = image;
        this.articleId = articleId;
        this.officeId = officeId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getLink() {
        return link;
    }

    public void setLink(String link) {
        this.link = link;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getArticleId() {
        return articleId;
    }

    public void setArticleId(String articleId) {
        this.articleId = articleId;
    }

    public String getOfficeId() {
        return officeId;
    }

    public void setOfficeId(String officeId) {
        this.officeId = officeId;
    }

    // 네이버 뉴스 URL을 동적으로 생성하는 메서드 추가
    public String generateNaverNewsUrl() {
        if (articleId != null && officeId != null) {
            return "https://n.news.naver.com/mnews/article/" + officeId + "/" + articleId;
        }
        return null;  // 값이 없다면 null 반환
    }
}
