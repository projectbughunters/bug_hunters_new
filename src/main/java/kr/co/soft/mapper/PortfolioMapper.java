package kr.co.soft.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import kr.co.soft.beans.PortfolioBean;
import kr.co.soft.beans.PortfolioInfoBean;
import kr.co.soft.beans.StockInfoBean;

public interface PortfolioMapper {

	@Insert("insert into portfolio(portfolio_idx, personal_tendency_code, member_idx, title, create_at, deposit, profit_Rate) "
			+ "values(portfolio_seq.nextval, #{personal_tendency_code}, "
			+ "#{member_idx}, #{title}, TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI'), 0, 0)")
	void addPortfolio(PortfolioBean joinPortfolioBean);
	
	@Select("select portfolio_idx, personal_tendency_code, member_idx, title, create_at, deposit, profit_Rate from portfolio where member_idx=#{member_idx} order by create_at")
	List<PortfolioBean> getPortfolio(@Param("member_idx")int member_idx);
	
	@Select("select portfolio_idx, personal_tendency_code, member_idx, title, create_at, deposit, profit_Rate from portfolio where portfolio_idx=#{portfolio_idx}")
	PortfolioBean getPortfolioInfo(int portfolio_idx);
	
	@Insert("INSERT INTO STOCK_INFO (symbol, company_name, type) " +
            "VALUES (#{symbol}, #{company_name}, 'crypto')")
	void insertStockInfo(StockInfoBean StockInfoBean);
	
	@Select("SELECT symbol, company_name, type " +
	        "FROM stock_info " +
	        "WHERE UPPER(company_name) LIKE UPPER(#{company_name}) || '%'")
	List<StockInfoBean> searchStocksByCompanyName(String company_name);
	
	@Insert("insert into portfolio_info(portfolio_info_idx, portfolio_idx, stock_name, symbol, asset_type, price, amount) "
			+ "values(portfolio_info_seq.nextval, #{portfolio_idx}, #{stock_name}, #{symbol}, "
			+ "#{asset_type}, #{price}, #{amount})")
	void addPortfolioInfo(PortfolioInfoBean newPortfolioInfoBean);

	@Select("select portfolio_info_idx, portfolio_idx, stock_name, symbol, asset_type, price, amount from portfolio_info where portfolio_idx=#{portfolio_idx}")
	List<PortfolioInfoBean> getPortfolioInfoBean(int portfolio_idx);
	
	@Delete("DELETE FROM portfolio_info WHERE portfolio_info_idx = #{portfolio_info_idx}")
    void deletePortfolioInfoById(@Param("portfolio_info_idx") int portfolio_info_idx);
	
	@Update("UPDATE portfolio " +
	        "SET deposit = (" +
	        "   SELECT NVL(SUM(price * amount), 0) " +
	        "   FROM portfolio_info " +
	        "   WHERE portfolio_idx = #{portfolio_idx}) " +
	        "WHERE portfolio_idx = #{portfolio_idx}")
	void updatePortfolioDeposit(@Param("portfolio_idx") int portfolio_idx);
	
	@Update("UPDATE portfolio SET profit_Rate = #{totalProfitRate} WHERE portfolio_idx = #{portfolio_idx}")
	void updatePortfolioProfitRate(@Param("portfolio_idx") int portfolio_idx, @Param("totalProfitRate") double totalProfitRate);
	
	@Delete("DELETE FROM portfolio WHERE portfolio_idx = #{portfolio_idx}")
	void deletePortfolio(@Param("portfolio_idx") int portfolio_idx);

}
