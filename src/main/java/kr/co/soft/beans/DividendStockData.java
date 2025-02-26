package kr.co.soft.beans;

public class DividendStockData {

	private String symbol;
	private String name;
	private Double dividendPerShare;
	private Double dividendYield;
	private Double eps;
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

	public Double getDividendPerShare() {
		return dividendPerShare;
	}

	public void setDividendPerShare(Double dividendPerShare) {
		this.dividendPerShare = dividendPerShare;
	}

	public Double getDividendYield() {
		return dividendYield;
	}

	public void setDividendYield(Double dividendYield) {
		this.dividendYield = dividendYield;
	}

	public Double getEps() {
		return eps;
	}

	public void setEps(Double eps) {
		this.eps = eps;
	}

	public Double getReturnOnEquityTTM() {
		return returnOnEquityTTM;
	}

	public void setReturnOnEquityTTM(Double returnOnEquityTTM) {
		this.returnOnEquityTTM = returnOnEquityTTM;
	}

}
