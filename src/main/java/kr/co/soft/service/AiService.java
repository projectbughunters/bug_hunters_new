package kr.co.soft.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.soft.DAO.StockDataDAO;
import kr.co.soft.beans.DefensiveStockData;
import kr.co.soft.beans.DividendStockData;
import kr.co.soft.beans.ESGStockData;
import kr.co.soft.beans.GrowthStockData;
import kr.co.soft.beans.StockDataBean;
import kr.co.soft.beans.TechStockData;
import kr.co.soft.beans.ValueStockData;

@Service
public class AiService {

	  @Autowired
	  private StockDataDAO stockDataDAO;

	  public void saveStockData(StockDataBean stockDataBean) {
	    // 데이터 저장 로직
	    stockDataDAO.insertStockData(stockDataBean);
	  }

	  public List<ESGStockData> getAllESGStocks() {
	    return stockDataDAO.getAllESGStocks();
	  }

	  public List<DefensiveStockData> getAllDefensiveStocks() {
	    return stockDataDAO.getAllDefensiveStocks();
	  }

	  public List<TechStockData> getAllTechStocks() {
	    return stockDataDAO.getAllTechStocks();
	  }

	  public List<ValueStockData> getAllValueStocks() {
	    return stockDataDAO.getAllValueStocks();
	  }

	  public List<GrowthStockData> getAllGrowthStocks() {
	    return stockDataDAO.getAllGrowthStocks();
	  }

	  public List<DividendStockData> getAllDividendStocks() {
	    return stockDataDAO.getAllDividendStocks();
	  }

}
