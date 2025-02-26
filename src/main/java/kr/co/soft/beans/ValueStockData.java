package kr.co.soft.beans;

public class ValueStockData {
	private String symbol;
	private String name;
	private Double priceToBookRatio;
	private Double priceToSalesRatioTTM;
	private Double dividendPerShare;
	private Double eps;

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

	public Double getPriceToBookRatio() {
		return priceToBookRatio;
	}

	public void setPriceToBookRatio(Double priceToBookRatio) {
		this.priceToBookRatio = priceToBookRatio;
	}

	public Double getPriceToSalesRatioTTM() {
		return priceToSalesRatioTTM;
	}

	public void setPriceToSalesRatioTTM(Double priceToSalesRatioTTM) {
		this.priceToSalesRatioTTM = priceToSalesRatioTTM;
	}

	public Double getDividendPerShare() {
		return dividendPerShare;
	}

	public void setDividendPerShare(Double dividendPerShare) {
		this.dividendPerShare = dividendPerShare;
	}

	public Double getEps() {
		return eps;
	}

	public void setEps(Double eps) {
		this.eps = eps;
	}

}
