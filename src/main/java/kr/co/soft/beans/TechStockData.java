package kr.co.soft.beans;

public class TechStockData {
	private String symbol;
	private String name;
	private Double revenueTTM;
	private Double operatingMarginTTM;

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

	public Double getRevenueTTM() {
		return revenueTTM;
	}

	public void setRevenueTTM(Double revenueTTM) {
		this.revenueTTM = revenueTTM;
	}

	public Double getOperatingMarginTTM() {
		return operatingMarginTTM;
	}

	public void setOperatingMarginTTM(Double operatingMarginTTM) {
		this.operatingMarginTTM = operatingMarginTTM;
	}

}
