<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<c:set var="root" value='${pageContext.request.contextPath }/' />
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
   
<div class="coin-section">
   <h2>
      코인
      <button onclick="location.href='${root}coin/coinMain'"
         style="margin-left: 10px;">바로가기</button>
   </h2>
   <!-- 테이블과 차트를 감싸는 컨테이너 -->
   <div class="coin-content">
      <div class="coin-table">
         <table>
            <thead>
               <tr>
                  <th class="headCol rankCol">순위</th>
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
                     <td class="headCol rankCol">${coin.rank}</td>
                     <td class="headCol nameCol"
                        onclick="location.href='${root}coin/info/${coin.symbol}/${coin.name}'">
                        <img
                        src="https://cryptologos.cc/logos/${coin.name.toLowerCase()}-${coin.symbol.toLowerCase()}-logo.png?v=040"
                        style="height: 20px; margin-right: 5px;"> ${coin.name}
                     </td>
                     <td>${coin.symbol}</td>
                     <td class="align-right">$ <script>
                                    var price = (${coin.quotes.USD.price}).toFixed(2);
                                    document.write(price.replace(/\B(?=(\d{3})+(?!\d))/g, ","));
                                </script>
                     </td>
                     <td class="align-right">$ <script>
                                    var market_cap = (${coin.quotes.USD.market_cap}).toFixed(0);
                                    document.write(market_cap.replace(/\B(?=(\d{3})+(?!\d))/g, ","));
                                </script>
                     </td>
                     <td class="align-right">$ <script>
                                    var volume_24h = (${coin.quotes.USD.volume_24h}).toFixed(2);
                                    document.write(volume_24h.replace(/\B(?=(\d{3})+(?!\d))/g, ","));
                                </script>
                     </td>
                     <td
                        class="align-right ${coin.quotes.USD.percent_change_24h > 0 ? 'positive-change' : 'negative-change'}">
                        <script>
                                    var percentChange24h = ${coin.quotes.USD.percent_change_24h};
                                    document.write(percentChange24h.toFixed(2) + "%");
                                </script>
                     </td>
                     <td
                        class="align-right ${coin.quotes.USD.percent_change_7d > 0 ? 'positive-change' : 'negative-change'}">
                        <script>
                                    var percentChange7d = ${coin.quotes.USD.percent_change_7d};
                                    document.write(percentChange7d.toFixed(2) + "%");
                                </script>
                     </td>
                  </tr>
               </c:forEach>
            </tbody>
         </table>
      </div>
      <div class="coin-chart-wrapper">
         <button id="prevCoinBtn">◀</button>
         <button id="nextCoinBtn">▶</button>
         <div id="coinNameDisplay"></div>
         <div id="coinChartContainer">
            <canvas id="coinChart"></canvas>
         </div>
      </div>
   </div>
</div>
