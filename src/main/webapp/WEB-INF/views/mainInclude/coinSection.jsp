<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<c:set var="root" value='${pageContext.request.contextPath }/' />
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
   
<div class="coin-section">
   <div class="stock-title">
   <div class="title-container">
   <h2>코인</h2>
   </div>
   <div class="button-container">
      <button class="navigate-button" onclick="location.href='${root}coin/coinMain'">&#10095;</button>
   </div>
</div>
   <!-- 테이블과 차트를 감싸는 컨테이너 -->
   <div class="coin-content">
      <div class="coin-table">
         <table>
            <thead>
               <tr>
                  <th class="headCol nameCol">종목</th>
                  <th>기호</th>
                  <th>가격(KRW)</th>
                  <th>총 시가</th>
                  <th>거래량(24H)</th>
                  <th>변동(24H)</th>
                  <th>변동(7D)</th>
               </tr>
            </thead>
            <tbody>
               <c:forEach var="coin" items="${pageBeanForCoins.list}">
                  <tr>
                     <td class="headCol nameCol"
                        onclick="location.href='${root}coin/info/${coin.symbol}/${coin.name}'">
                        <img
                        src="https://cryptologos.cc/logos/${coin.name.toLowerCase()}-${coin.symbol.toLowerCase()}-logo.png?v=040"
                        style="width: 30px; height: 30px; margin-right: 10px;"> ${coin.name}
                     </td>
                     <td>${coin.symbol}</td>
                     <td class="align-right">
                         <script>
                             var price = Number(${coin.quotes.USD.price});
                             // 단위 축약 (K, M, B, T) 적용
                             document.write("$ " + formatEBITDA(price));
                         </script>
                     </td>
                     
                     <!-- 시가총액 (Market Cap) -->
                     <td class="align-right">
                         <script>
                             var marketCap = Number(${coin.quotes.USD.market_cap});
                             document.write("$ " + formatEBITDA(marketCap));
                         </script>
                     </td>
                     
                     <!-- 24시간 거래량 (Volume 24h) -->
                     <td class="align-right">
                         <script>
                             var volume24h = Number(${coin.quotes.USD.volume_24h});
                             document.write("$ " + formatEBITDA(volume24h));
                         </script>
                     </td>
                     
                     <!-- 24시간 변동률 -->
                     <td class="align-right ${coin.quotes.USD.percent_change_24h > 0 ? 'positive-change' : 'negative-change'}">
                         <script>
                             var percentChange24h = Number(${coin.quotes.USD.percent_change_24h});
                             document.write(percentChange24h.toFixed(2) + "%");
                         </script>
                     </td>
                     
                     <!-- 7일 변동률 -->
                     <td class="align-right ${coin.quotes.USD.percent_change_7d > 0 ? 'positive-change' : 'negative-change'}">
                         <script>
                             var percentChange7d = Number(${coin.quotes.USD.percent_change_7d});
                             document.write(percentChange7d.toFixed(2) + "%");
                         </script>
                     </td>
                  </tr>
               </c:forEach>
            </tbody>
         </table>
      </div>
      <div class="coin-chart-wrapper">
         <div id="coinNameDisplay"></div>
         <div id="coinChartContainer">
            <canvas id="coinChart"></canvas>
            <div class="arrow-btn">
		        <button id="prevCoinBtn">◀</button>
		        <button id="nextCoinBtn">▶</button>
	        </div>
         </div>
      </div>
   </div>
</div>
