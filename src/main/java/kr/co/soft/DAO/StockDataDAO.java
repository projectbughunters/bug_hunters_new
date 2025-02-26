package kr.co.soft.DAO;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.soft.beans.DefensiveStockData;
import kr.co.soft.beans.DividendStockData;
import kr.co.soft.beans.ESGStockData;
import kr.co.soft.beans.GrowthStockData;
import kr.co.soft.beans.StockDataBean;
import kr.co.soft.beans.TechStockData;
import kr.co.soft.beans.ValueStockData;
import kr.co.soft.mapper.StockDataMapper;

@Repository
public class StockDataDAO {
	
	@Autowired
	  private StockDataMapper stockDataMapper;
	
	public void updateStockData(StockDataBean stockDataBean) {
	    try {
	      stockDataMapper.updateStockData(stockDataBean);
	    } catch (Exception e) {
	      throw new RuntimeException("Failed to update stock data", e);
	    }
	  }

	public void insertStockData(StockDataBean stockDataBean) {
	    try {
	      stockDataMapper.insertStockData(stockDataBean);
	    } catch (Exception e) {
	      throw new RuntimeException("Failed to insert stock data", e);
	    }
	  }


	  public List<ESGStockData> getAllESGStocks() {
	    return stockDataMapper.selectAllESGStocks();
	  }

	  public List<DefensiveStockData> getAllDefensiveStocks() {
	    return stockDataMapper.selectAllDefensiveStocks();
	  }

	  public List<TechStockData> getAllTechStocks() {
	    return stockDataMapper.selectAllTechStocks();
	  }

	  public List<ValueStockData> getAllValueStocks() {
	    return stockDataMapper.selectAllValueStocks();
	  }

	  public List<GrowthStockData> getAllGrowthStocks() {
	    return stockDataMapper.selectAllGrowthStocks();
	  }

	  public List<DividendStockData> getAllDividendStocks() {
	    return stockDataMapper.selectAllDividendStocks();
	  }


}
