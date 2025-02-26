<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>  
<c:set var="root" value='${pageContext.request.contextPath }/' />   
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" >
    <link href="https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@400&display=swap" rel="stylesheet">
	<link rel="stylesheet" href="${root}css/bugMain.css"> 
	<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-crosshair"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<%@ page import="org.jsoup.Jsoup"%>
<%@ page import="org.jsoup.nodes.Document"%>
<%@ page import="org.jsoup.nodes.Element"%>
<%@ page import="java.util.List"%>
    <title>Take Money Information | TMI</title>
</head>

<body>
    <c:import url="/WEB-INF/views/include/topMenu.jsp"/>
    
     <div class="container">
      <div class="advertisement">
         <h2>광고</h2>
         <p>광고 공간</p>
      </div>

      <div class="content-container">
         <div class="news-section">
            <h2>실시간 뉴스</h2>
            <ul>
               <c:forEach var="news" items="${newsList}">
                  <li>
                     <!-- 기사 ID와 언론사 코드로 네이버 뉴스 URL 생성 -->
                     <a href="https://n.news.naver.com/mnews/article/${news.officeId}/${news.articleId}" target="_blank">
                        ${news.title}
                     </a>
                     <!-- 이미지가 있으면 표시 -->
                     <c:if test="${not empty news.image}">
                        <img src="${news.image}" alt="${news.title}"
                           style="width: 50px; height: 50px; margin-left: 10px;" />
                     </c:if>
                  </li>
               </c:forEach>
            </ul>
         </div>
         <div class="youtube">
            <iframe
               src="https://www.youtube.com/embed?listType=playlist&list=PLT6yxVwBEbi0AKJXT8tseRoYHctKpD1Fj&autoplay=1&mute=1&controls=0&loop=1"
               title="YouTube video player" frameborder="0"
               allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
               allowfullscreen> </iframe>
         </div>
      </div>
      
      <div class="market-container">
         <div class="stock-section">
            <h2>
               주식
               <!-- 주식 바로가기 버튼 -->
               <button onclick="location.href='${root}stock/stockMain'" style="margin-left: 10px;">바로가기</button>
            </h2>
            <table>
               <thead>
                  <tr>
                     <th colspan="2">심볼</th>
                     <th>종목</th>
                     <th>통화</th>
                     <th>주가수익비율</th>
                     <th>현재 가격</th>
                     <th>24시간 변동</th>
                     <th>시가총액</th>
                  </tr>
               </thead>
               <tbody>
                  <!-- stocks 배열을 순회 -->
                  <c:forEach var="stock" items="${pageBeanForStocks.list}">
                     <tr>
                        <td><img
                           src="https://financialmodelingprep.com/image-stock/${stock.symbol}.png"
                           style="width: 30px; height: 30px; margin-right: 10px;" /></td>
                        <td class="clickable"
                           onclick="location.href='${root}stock/info/${stock.symbol }'">
                           ${stock.symbol}</td>
                        <td class="light-bg">${stock.name}</td>
                        <td class="light-bg">${stock.currency}</td>
                        <td class="light-bg">
                           <script>
                                      var trailingPE = parseFloat('${stock.trailingPE}').toFixed(2);
                                      trailingPE = trailingPE.slice(0, -1) + 'x';
                                      document.write(trailingPE);
                                  </script>
                        </td>
                        <td class="align-right light-bg">$<c:out value="${stock.marketPrice}" /></td>
                        <td class="align-right light-bg ${stock.marketChange > 0 ? 'positive-change' : 'negative-change'}">
                           <script>
                                      var marketChange = ${stock.marketChange};
                                      document.write(marketChange.toFixed(2) + "%");
                                  </script>
                        </td>
                        <td class="align-right light-bg">
                           <script>
                                      var marketCap = '${stock.marketCap}';
                                      document.write(formatEBITDA(marketCap));
                                  </script>
                        </td>
                     </tr>
                  </c:forEach>
               </tbody>
            </table>
         </div>

         <div class="coin-section">
            <h2>
               코인
               <!-- 코인 바로가기 버튼 -->
               <button onclick="location.href='${root}coin/coinMain'" style="margin-left: 10px;">바로가기</button>
            </h2>
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
                  <!-- coins 배열을 순회 -->
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
                        <td class="align-right ${coin.quotes.USD.percent_change_24h > 0 ? 'positive-change' : 'negative-change'}">
                           <script>
                              var percentChange24h = ${coin.quotes.USD.percent_change_24h};
                              document.write((percentChange24h).toFixed(2) + "%");
                          </script>
                        </td>
                        <td class="align-right ${coin.quotes.USD.percent_change_7d > 0 ? 'positive-change' : 'negative-change'}">
                           <script>
                              var percentChange7d = ${coin.quotes.USD.percent_change_7d};
                              document.write((percentChange7d).toFixed(2) + "%");
                          </script>
                        </td>
                     </tr>
                  </c:forEach>
               </tbody>
            </table>
         </div>
      </div>

      <div class="content-container">
         <div class="widget">
            <h1>캘린더</h1>
            <iframe
               src="https://sslecal2.investing.com?columns=exc_flags,exc_currency,exc_importance,exc_actual,exc_forecast,exc_previous&amp;category=_employment,_economicActivity,_inflation,_credit,_centralBanks,_confidenceIndex,_balance,_Bonds&amp;importance=1,2,3&amp;features=datepicker,timezone,timeselector,filters&amp;countries=110,43,17,42,5,178,32,12,26,36,4,72,10,14,48,35,37,6,122,41,22,11,25,39&amp;calType=week&amp;timeZone=88&amp;lang=18"
               width="700" height="400" frameborder="0" allowtransparency="true"
               marginwidth="0" marginheight="0"></iframe>
         </div>

         <div class="chart-container">
            <h1>차트</h1>
            <!-- 주식 차트 -->
            <div class="stock-chart-wrapper">
               <button id="prevStockBtn">◀</button>
               <button id="nextStockBtn">▶</button>
               <!-- 주식 차트 바로가기 버튼 -->
               <button onclick="location.href='${root}stockMain'" style="margin-left: 10px;">바로가기</button>
               <div id="stockNameDisplay"></div>
               <div id="stockChartContainer">
                  <canvas id="stockChart"></canvas>
               </div>
            </div>
            <!-- 코인 차트 -->
            <div class="coin-chart-wrapper">
               <button id="prevCoinBtn">◀</button>
               <button id="nextCoinBtn">▶</button>
               <!-- 코인 차트 바로가기 버튼 -->
               <button onclick="location.href='${root}coinMain'" style="margin-left: 10px;">바로가기</button>
               <div id="coinNameDisplay"></div>
               <div id="coinChartContainer">
                  <canvas id="coinChart"></canvas>
               </div>
            </div>
         </div>
      </div>
      </div>
	  <div class="favorite-container">
            <h1>즐겨찾기</h1>
            <table>
            	<thead>
            	<tr>
            		<th>종목</th>
            		<th></th>
            	</tr>
            	</thead>
            	<tbody>
            		<c:forEach var="favorite" items="${favorites}">
					    <c:choose>
					        <c:when test="${favorite.type == 'stock'}">
					            <tr>
					                <td>
					                    <a href="${root}stock/info/${favorite.symbol}">
					                        ${favorite.symbol}
					                    </a>
					                </td>
					                <td>
					                    <button class="delete-fav-btn" data-symbol="${favorite.symbol}" data-type="stock">삭제</button>
					                </td>
					            </tr>
					        </c:when>
					        <c:otherwise>
					            <tr>
					                <td>
					                    <a href="${root}coin/info/${favorite.symbol}/${favorite.type}">
					                        ${favorite.symbol}
					                    </a>
					                </td>
					                <td>
					                    <button class="delete-fav-btn" data-symbol="${favorite.symbol}" data-type="${favorite.type }" >삭제</button>
					                </td>
					            </tr>
					        </c:otherwise>
					    </c:choose>
					</c:forEach>
            	</tbody>
            </table>
        </div>
      <script>
		$(document).ready(function() {
			
			 $('.delete-fav-btn').click(function() {
	            	var button = $(this);
	                var symbol = button.data('symbol'); // 버튼의 data-symbol 값
	                var type = button.data('type'); 
	                
	                $.ajax({
	                    url: "${root}favorite/delete", // 요청을 보낼 URL (서블릿/컨트롤러 매핑)
	                    type: "POST",
	                    data: { symbol: symbol, type: type },
	                    success: function(response) {
	                        alert("즐겨찾기에서 삭제되었습니다.");
	                        // 삭제 성공 후 해당 행을 제거
	                        $(this).closest('tr').remove();
	                    }.bind(this), // this를 바인딩하여 클릭한 버튼을 참조
	                    error: function() {
	                        alert("즐겨찾기 삭제 중 오류가 발생했습니다.");
	                    }
	                });
	            });
	        });
		    // 서버에서 전달된 JSON 문자열을 파싱 (실제 환경에서는 서버에서 값이 주입됨)
		    var stockSymbols = JSON.parse('${stockSymbolsJson}');  // 예: ["MSFT", "AAPL", "GOOG"]
		    var coinSymbols = JSON.parse('${coinSymbolsJson}');      // 예: ["BTC", "ETH", "XRP"]
		
		    var stockChartInstance = null;
		    var coinChartInstance = null;
		
		    var currentStockIndex = 0;
		    var currentCoinIndex = 0;
		
		    function createStockChart(stockData) {
		        if (stockChartInstance) {
		            stockChartInstance.destroy();
		        }
		        var dates = [];
		        var datasets = $.map(stockData, function(info) {
		            var prices = $.map(info.data, function(item) { return item.close; });
		            dates = $.map(info.data, function(item) { return item.date; });
		            return {
		                label: info.symbol,
		                data: prices,
		                fill: true,
		                backgroundColor: 'rgba(75, 192, 192, 0.2)',
		                borderColor: 'rgba(75, 192, 192, 1)',
		                tension: 0.1,
		                pointRadius: 0
		            };
		        });
		        var ctx = $("#stockChart")[0].getContext("2d");
		        stockChartInstance = new Chart(ctx, {
		            type: "line",
		            data: {
		                labels: dates,
		                datasets: datasets
		            },
		            options: {
		                responsive: true,
		                maintainAspectRatio: false,
		                interaction: { mode: "index", intersect: false },
		                plugins: {
		                    legend: { position: "top", display: false },
		                    tooltip: { enabled: true },
		                    crosshair: {
		                        line: { color: 'rgba(75, 192, 192, 1)', width: 1 },
		                        sync: { enabled: false },
		                        zoom: { enabled: false }
		                    }
		                },
		                scales: {
		                    x: { display: false },
		                    y: { beginAtZero: true }
		                },
		                hover: { mode: 'nearest', intersect: true },
		                elements: {
		                    line: { borderWidth: 2 },
		                    point: { radius: 0 }
		                }
		            }
		        });
		    }
		
		    function createCoinChart(coinData) {
		        if (coinChartInstance) {
		            coinChartInstance.destroy();
		        }
		        var dates = [];
		        var datasets = $.map(coinData, function(info) {
		            var prices = $.map(info.data, function(item) { return item.close; });
		            dates = $.map(info.data, function(item) { return item.date; });
		            return {
		                label: info.symbol,
		                data: prices,
		                fill: true,
		                backgroundColor: 'rgba(153, 102, 255, 0.2)',
		                borderColor: 'rgba(153, 102, 255, 1)',
		                tension: 0.1,
		                pointRadius: 0
		            };
		        });
		        var ctx = $("#coinChart")[0].getContext("2d");
		        coinChartInstance = new Chart(ctx, {
		            type: "line",
		            data: {
		                labels: dates,
		                datasets: datasets
		            },
		            options: {
		                responsive: true,
		                maintainAspectRatio: false,
		                interaction: { mode: "index", intersect: false },
		                plugins: {
		                    legend: { position: "top", display: false },
		                    tooltip: { enabled: true },
		                    crosshair: {
		                        line: { color: 'rgba(153, 102, 255, 1)', width: 1 },
		                        sync: { enabled: false },
		                        zoom: { enabled: false }
		                    }
		                },
		                scales: {
		                    x: { display: false },
		                    y: { beginAtZero: true }
		                },
		                hover: { mode: 'nearest', intersect: true },
		                elements: {
		                    line: { borderWidth: 2 },
		                    point: { radius: 0 }
		                }
		            }
		        });
		    }
		
		    function updateStockChart() {
		        var symbol = stockSymbols[currentStockIndex];
		        $("#stockNameDisplay").text("종목명: " + symbol);
		        $.ajax({
		            url: "http://localhost:3000/stock-info",
		            type: "GET",
		            data: { symbol: symbol, timeframe: 'DAILY' },
		            success: function(response) {
		                createStockChart([{ symbol: symbol, data: response }]);
		            },
		            error: function(error) {
		                console.error("Error fetching stock data:", error);
		            }
		        });
		    }
		
		    function updateCoinChart() {
		        var symbol = coinSymbols[currentCoinIndex];
		        $("#coinNameDisplay").text("종목명: " + symbol);
		        $.ajax({
		            url: "http://localhost:3000/coin",
		            type: "GET",
		            data: { symbol: symbol, timeframe: 'DAILY' },
		            success: function(response) {
		                createCoinChart([{ symbol: symbol, data: response }]);
		            },
		            error: function(error) {
		                console.error("Error fetching coin data:", error);
		            }
		        });
		    }
		
		    // 초기 로드시 첫 번째 종목 데이터 표시
		    updateStockChart();
		    updateCoinChart();
		
		    // 주식 차트 이전/다음 버튼 이벤트
		    $("#prevStockBtn").on("click", function() {
		        currentStockIndex = (currentStockIndex - 1 + stockSymbols.length) % stockSymbols.length;
		        updateStockChart();
		    });
		    $("#nextStockBtn").on("click", function() {
		        currentStockIndex = (currentStockIndex + 1) % stockSymbols.length;
		        updateStockChart();
		    });
		
		    // 코인 차트 이전/다음 버튼 이벤트
		    $("#prevCoinBtn").on("click", function() {
		        currentCoinIndex = (currentCoinIndex - 1 + coinSymbols.length) % coinSymbols.length;
		        updateCoinChart();
		    });
		    $("#nextCoinBtn").on("click", function() {
		        currentCoinIndex = (currentCoinIndex + 1) % coinSymbols.length;
		        updateCoinChart();
		    });
		});
</script>


   <c:import url="/WEB-INF/views/include/bottom.jsp" />

    

</body>

</html>
