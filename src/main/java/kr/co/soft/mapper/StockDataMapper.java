package kr.co.soft.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import kr.co.soft.beans.DefensiveStockData;
import kr.co.soft.beans.DividendStockData;
import kr.co.soft.beans.ESGStockData;
import kr.co.soft.beans.GrowthStockData;
import kr.co.soft.beans.StockDataBean;
import kr.co.soft.beans.TechStockData;
import kr.co.soft.beans.ValueStockData;

public interface StockDataMapper {
	
	@Update("UPDATE CompanyInfo SET " +
		      "name = #{name}, cik = #{cik}, exchange = #{exchange}, currency = #{currency}, " +
		      "country = #{country}, sector = #{sector}, industry = #{industry}, " +
		      "address = #{address}, officialSite = #{officialSite}, fiscalYearEnd = #{fiscalYearEnd}, " +
		      "marketCapitalization = #{marketCapitalization}, ebitda = #{ebitda}, " +
		      "peRatio = #{peRatio}, pegRatio = #{pegRatio}, bookValue = #{bookValue}, " +
		      "dividendPerShare = #{dividendPerShare}, dividendYield = #{dividendYield}, " +
		      "eps = #{eps}, revenuePerShareTTM = #{revenuePerShareTTM}, " +
		      "profitMargin = #{profitMargin}, operatingMarginTTM = #{operatingMarginTTM}, " +
		      "returnOnAssetsTTM = #{returnOnAssetsTTM}, returnOnEquityTTM = #{returnOnEquityTTM}, " +
		      "revenueTTM = #{revenueTTM}, grossProfitTTM = #{grossProfitTTM}, " +
		      "dilutedEPSTTM = #{dilutedEPSTTM}, quarterlyEarningsGrowthYOY = #{quarterlyEarningsGrowthYOY}, " +
		      "quarterlyRevenueGrowthYOY = #{quarterlyRevenueGrowthYOY}, analystTargetPrice = #{analystTargetPrice}, " +
		      "analystRatingStrongBuy = #{analystRatingStrongBuy}, analystRatingBuy = #{analystRatingBuy}, " +
		      "analystRatingHold = #{analystRatingHold}, analystRatingSell = #{analystRatingSell}, " +
		      "analystRatingStrongSell = #{analystRatingStrongSell}, trailingPE = #{trailingPE}, " +
		      "forwardPE = #{forwardPE}, priceToSalesRatioTTM = #{priceToSalesRatioTTM}, " +
		      "priceToBookRatio = #{priceToBookRatio}, evToRevenue = #{evToRevenue}, " +
		      "evToEBITDA = #{evToEBITDA}, beta = #{beta}, fiftyTwoWeekHigh = #{fiftyTwoWeekHigh}, " +
		      "fiftyTwoWeekLow = #{fiftyTwoWeekLow}, fiftyDayMovingAverage = #{fiftyDayMovingAverage}, " +
		      "twoHundredDayMovingAverage = #{twoHundredDayMovingAverage}, sharesOutstanding = #{sharesOutstanding} " +
		      "WHERE symbol = #{symbol}")
		  void updateStockData(StockDataBean stockData);
	
	@Insert("INSERT INTO Company_info (" +
		      "symbol, name, cik, exchange, currency, country, sector, industry, address, " +
		      "officialSite, fiscalYearEnd, marketCapitalization, ebitda, " +
		      "peRatio, pegRatio, bookValue, dividendPerShare, dividendYield, eps, " +
		      "revenuePerShareTTM, profitMargin, operatingMarginTTM, returnOnAssetsTTM, " +
		      "returnOnEquityTTM, revenueTTM, grossProfitTTM, dilutedEPSTTM, " +
		      "quarterlyEarningsGrowthYOY, quarterlyRevenueGrowthYOY, analystTargetPrice, " +
		      "analystRatingStrongBuy, analystRatingBuy, analystRatingHold, " +
		      "analystRatingSell, analystRatingStrongSell, trailingPE, forwardPE, " +
		      "priceToSalesRatioTTM, priceToBookRatio, evToRevenue, evToEBITDA, beta, " +
		      "fiftyTwoWeekHigh, fiftyTwoWeekLow, fiftyDayMovingAverage, " +
		      "twoHundredDayMovingAverage, sharesOutstanding) " +
		      "VALUES (" +
		      "#{symbol}, #{name}, #{cik}, #{exchange}, #{currency}, #{country}, #{sector}, " +
		      "#{industry}, #{address}, #{officialSite}, #{fiscalYearEnd}, " +
		      "#{marketCapitalization}, #{ebitda}, #{peRatio}, #{pegRatio}, #{bookValue}, " +
		      "#{dividendPerShare}, #{dividendYield}, #{eps}, #{revenuePerShareTTM}, " +
		      "#{profitMargin}, #{operatingMarginTTM}, #{returnOnAssetsTTM}, " +
		      "#{returnOnEquityTTM}, #{revenueTTM}, #{grossProfitTTM}, #{dilutedEPSTTM}, " +
		      "#{quarterlyEarningsGrowthYOY}, #{quarterlyRevenueGrowthYOY}, " +
		      "#{analystTargetPrice}, #{analystRatingStrongBuy}, #{analystRatingBuy}, " +
		      "#{analystRatingHold}, #{analystRatingSell}, #{analystRatingStrongSell}, " +
		      "#{trailingPE}, #{forwardPE}, #{priceToSalesRatioTTM}, #{priceToBookRatio}, " +
		      "#{evToRevenue}, #{evToEBITDA}, #{beta}, #{fiftyTwoWeekHigh}, " +
		      "#{fiftyTwoWeekLow}, #{fiftyDayMovingAverage}, #{twoHundredDayMovingAverage}, " +
		      "#{sharesOutstanding})")
		  void insertStockData(StockDataBean stockData);

		  @Select("SELECT symbol, name, returnOnEquityTTM, operatingMarginTTM, profitMargin FROM Company_info")
		  List<ESGStockData> selectAllESGStocks();

		  @Select("SELECT symbol, name, profitMargin, returnOnEquityTTM FROM Company_info")
		  List<DefensiveStockData> selectAllDefensiveStocks();

		  @Select("SELECT symbol, name, revenueTTM, operatingMarginTTM FROM Company_info")
		  List<TechStockData> selectAllTechStocks();

		  @Select("SELECT symbol, name, priceToBookRatio, priceToSalesRatioTTM, dividendPerShare, eps FROM Company_info")
		  List<ValueStockData> selectAllValueStocks();

		  @Select("SELECT symbol, name, peRatio, pegRatio, quarterlyRevenueGrowthYOY, quarterlyEarningsGrowthYOY FROM Company_info")
		  List<GrowthStockData> selectAllGrowthStocks();

		  @Select("SELECT symbol, name, dividendPerShare, dividendYield, eps, returnOnEquityTTM FROM Company_info")
		  List<DividendStockData> selectAllDividendStocks();
		  
		  


}
