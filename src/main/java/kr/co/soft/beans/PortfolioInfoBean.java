package kr.co.soft.beans;

public class PortfolioInfoBean {

	private int portfolio_info_idx;
	private int portfolio_idx;
	private String stock_name;
	private String symbol;
	private String asset_type;
	private double price; //매입 가격
	private double amount;
	private String type;

	public int getPortfolio_info_idx() {
		return portfolio_info_idx;
	}

	public void setPortfolio_info_idx(int portfolio_info_idx) {
		this.portfolio_info_idx = portfolio_info_idx;
	}

	public int getPortfolio_idx() {
		return portfolio_idx;
	}

	public void setPortfolio_idx(int portfolio_idx) {
		this.portfolio_idx = portfolio_idx;
	}

	public String getStock_name() {
		return stock_name;
	}

	public void setStock_name(String stock_name) {
		this.stock_name = stock_name;
	}

	public String getAsset_type() {
		return asset_type;
	}

	public void setAsset_type(String asset_type) {
		this.asset_type = asset_type;
	}

	public double getPrice() {
		return price;
	}

	public void setPrice(double price) {
		this.price = price;
	}

	public String getSymbol() {
		return symbol;
	}

	public void setSymbol(String symbol) {
		this.symbol = symbol;
	}

	public double getAmount() {
		return amount;
	}

	public void setAmount(double amount) {
		this.amount = amount;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

}
