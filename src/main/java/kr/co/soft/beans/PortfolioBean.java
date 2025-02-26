package kr.co.soft.beans;

public class PortfolioBean {

	private int portfolio_idx;
	private String personal_tendency_code;
	private int member_idx;
	private String member_name;
	private String title;
	private String create_at;
	private double deposit;
	private double profit_Rate;

	public int getPortfolio_idx() {
		return portfolio_idx;
	}

	public void setPortfolio_idx(int portfolio_idx) {
		this.portfolio_idx = portfolio_idx;
	}

	public String getPersonal_tendency_code() {
		return personal_tendency_code;
	}

	public void setPersonal_tendency_code(String personal_tendency_code) {
		this.personal_tendency_code = personal_tendency_code;
	}

	public int getMember_idx() {
		return member_idx;
	}

	public void setMember_idx(int member_idx) {
		this.member_idx = member_idx;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getMember_name() {
		return member_name;
	}

	public void setMember_name(String member_name) {
		this.member_name = member_name;
	}

	public String getCreate_at() {
		return create_at;
	}

	public void setCreate_at(String create_at) {
		this.create_at = create_at;
	}

	public double getDeposit() {
		return deposit;
	}

	public void setDeposit(double deposit) {
		this.deposit = deposit;
	}

	public double getProfit_Rate() {
		return profit_Rate;
	}

	public void setProfit_Rate(double profit_Rate) {
		this.profit_Rate = profit_Rate;
	}

}
