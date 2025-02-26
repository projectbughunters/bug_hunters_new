package kr.co.soft.DAO;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.soft.beans.PortfolioBean;
import kr.co.soft.beans.PortfolioInfoBean;
import kr.co.soft.beans.StockInfoBean;
import kr.co.soft.mapper.PortfolioMapper;


@Repository
public class PortfolioDAO {

	@Autowired
	private PortfolioMapper portfolioMapper;
	
	@Autowired
	private SqlSession sqlSession;
	
	private final String namespace="kr.co.soft.mapper.PortfolioMapper";
	
	public void addPortfolio(PortfolioBean joinPortfolioBean) {
		portfolioMapper.addPortfolio(joinPortfolioBean);
	}
	
	public List<PortfolioBean> getPortfolio(int member_idx) {
		
		return portfolioMapper.getPortfolio(member_idx);
	}
	
	public PortfolioBean getPortfolioInfo(int portfolio_idx) {
		
		return portfolioMapper.getPortfolioInfo(portfolio_idx);
	}
	
	public void insertStockInfo(StockInfoBean StockInfoBean) {
		portfolioMapper.insertStockInfo(StockInfoBean);
	}
	
	//sqlSession: MyBaris의 객체로 데이터 조회, 삽입, 업데이트를 담당
	   //namespace:sql문 식별
	public List<StockInfoBean> searchStocksByCompanyName(String company_name) {
		
		   return sqlSession.selectList(namespace+".searchStocksByCompanyName", company_name);
	}
	
	public void deletePortfolioInfoById(int portfolio_info_idx) {
		portfolioMapper.deletePortfolioInfoById(portfolio_info_idx);
	}
	
	public void addPortfolioInfo(PortfolioInfoBean newPortfolioInfoBean) {
		portfolioMapper.addPortfolioInfo(newPortfolioInfoBean);
	}
	
	public List<PortfolioInfoBean> getPortfolioInfoBean(int portfolio_idx) {
		
		return portfolioMapper.getPortfolioInfoBean(portfolio_idx);
	}
	
	public void updatePortfolioDeposit(int portfolio_idx) {
		portfolioMapper.updatePortfolioDeposit(portfolio_idx);
	}
	
	public void updatePortfolioProfitRate(int portfolio_idx, double totalProfitRate) {
		portfolioMapper.updatePortfolioProfitRate(portfolio_idx, totalProfitRate);
	}
	
	public void deletePortfolio(int portfolio_idx) {
		portfolioMapper.deletePortfolio(portfolio_idx);
	}
}
