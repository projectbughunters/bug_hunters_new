package kr.co.soft.beans;

public class CyptoExchangeBean {
    private String name;
    private String url;
    private String image; 
    
    public CyptoExchangeBean(String name, String url, String image) {
        this.name = name;
        this.url = url;
        this.image = image;
    }

    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public String getUrl() {
        return url;
    }
    public void setUrl(String url) {
        this.url = url;
    }
    public String getImage() {
        return image;
    }
    public void setImage(String image) {
        this.image = image;
    }
}
