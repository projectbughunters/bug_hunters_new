package kr.co.soft.beans;

public class ESGStockData {

	private String symbol;
	private String name;
	private Double returnOnEquityTTM;
	private Double operatingMarginTTM;
	private Double profitMargin;

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

	public Double getReturnOnEquityTTM() {
		return returnOnEquityTTM;
	}

	public void setReturnOnEquityTTM(Double returnOnEquityTTM) {
		this.returnOnEquityTTM = returnOnEquityTTM;
	}

	public Double getOperatingMarginTTM() {
		return operatingMarginTTM;
	}

	public void setOperatingMarginTTM(Double operatingMarginTTM) {
		this.operatingMarginTTM = operatingMarginTTM;
	}

	public Double getProfitMargin() {
		return profitMargin;
	}

	public void setProfitMargin(Double profitMargin) {
		this.profitMargin = profitMargin;
	}

}
