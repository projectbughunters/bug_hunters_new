package kr.co.soft.beans;

public class DefensiveStockData {

	private String symbol;
	private String name;
	private Double profitMargin;
	private Double returnOnEquityTTM;

	public String getSymbol() {
		return symbol;
	}

	public void setSymbol(String symbol) {
		this.symbol = symbol;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Double getProfitMargin() {
		return profitMargin;
	}

	public void setProfitMargin(Double profitMargin) {
		this.profitMargin = profitMargin;
	}

	public Double getReturnOnEquityTTM() {
		return returnOnEquityTTM;
	}

	public void setReturnOnEquityTTM(Double returnOnEquityTTM) {
		this.returnOnEquityTTM = returnOnEquityTTM;
	}

}
