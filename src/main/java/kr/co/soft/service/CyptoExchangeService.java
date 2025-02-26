package kr.co.soft.service;

import kr.co.soft.beans.CyptoExchangeBean;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class CyptoExchangeService {

    public List<CyptoExchangeBean> getcyptoExchangeList() {
        List<CyptoExchangeBean> exchangeList = new ArrayList<>();

        // 전 세계 및 국내 유명 거래소 20개 추가
        exchangeList.add(new CyptoExchangeBean("Binance", "https://www.binance.com/", "binance.png"));
        exchangeList.add(new CyptoExchangeBean("Coinbase", "https://www.coinbase.com/", "coinbase.png"));
        exchangeList.add(new CyptoExchangeBean("Kraken", "https://www.kraken.com/", "kraken.png"));
        exchangeList.add(new CyptoExchangeBean("Bitfinex", "https://www.bitfinex.com/", "bitfinex.png"));
        exchangeList.add(new CyptoExchangeBean("Huobi Global", "https://www.huobi.com/", "huobi.png"));
        exchangeList.add(new CyptoExchangeBean("OKX", "https://www.okx.com/", "okx.png"));
        exchangeList.add(new CyptoExchangeBean("KuCoin", "https://www.kucoin.com/", "kucoin.png"));
        exchangeList.add(new CyptoExchangeBean("Bitstamp", "https://www.bitstamp.net/", "bitstamp.png"));
        exchangeList.add(new CyptoExchangeBean("Gemini", "https://www.gemini.com/", "gemini.png"));
        exchangeList.add(new CyptoExchangeBean("Crypto.com", "https://crypto.com/exchange", "crypto_com.png"));
        exchangeList.add(new CyptoExchangeBean("Gate.io", "https://www.gate.io/", "gateio.png"));
        exchangeList.add(new CyptoExchangeBean("Bybit", "https://www.bybit.com/", "bybit.png"));
        exchangeList.add(new CyptoExchangeBean("Coincheck", "https://coincheck.com/", "coincheck.png"));
        exchangeList.add(new CyptoExchangeBean("BitFlyer", "https://bitflyer.jp/", "bitflyer.png"));
        exchangeList.add(new CyptoExchangeBean("Upbit", "https://upbit.com/", "upbit.png"));
        exchangeList.add(new CyptoExchangeBean("Bithumb", "https://www.bithumb.com/", "bithumb.png"));
        exchangeList.add(new CyptoExchangeBean("Coinone", "https://coinone.co.kr/", "coinone.png"));
        exchangeList.add(new CyptoExchangeBean("Liquid", "https://www.liquid.com/", "liquid.png"));
        exchangeList.add(new CyptoExchangeBean("Poloniex", "https://poloniex.com/", "poloniex.png"));
        exchangeList.add(new CyptoExchangeBean("Deribit", "https://www.deribit.com/", "deribit.png"));
        
        return exchangeList;
    }
}
