package kr.co.soft.beans;

public class GrowthStockData {

	private String symbol;
	private String name;
	private Double peRatio;
	private Double pegRatio;
	private Double quarterlyRevenueGrowthYOY;
	private Double quarterlyEarningsGrowthYOY;

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

	public Double getPeRatio() {
		return peRatio;
	}

	public void setPeRatio(Double peRatio) {
		this.peRatio = peRatio;
	}

	public Double getPegRatio() {
		return pegRatio;
	}

	public void setPegRatio(Double pegRatio) {
		this.pegRatio = pegRatio;
	}

	public Double getQuarterlyRevenueGrowthYOY() {
		return quarterlyRevenueGrowthYOY;
	}

	public void setQuarterlyRevenueGrowthYOY(Double quarterlyRevenueGrowthYOY) {
		this.quarterlyRevenueGrowthYOY = quarterlyRevenueGrowthYOY;
	}

	public Double getQuarterlyEarningsGrowthYOY() {
		return quarterlyEarningsGrowthYOY;
	}

	public void setQuarterlyEarningsGrowthYOY(Double quarterlyEarningsGrowthYOY) {
		this.quarterlyEarningsGrowthYOY = quarterlyEarningsGrowthYOY;
	}

}
