<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="root" value='${pageContext.request.contextPath }/' />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<!-- 스톡인포 스타일 CSS -->
<link rel="stylesheet" href="${root}css/coinInfo.css">
<!-- jQuery 추가 -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- Chart.js 및 기타 라이브러리 -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-crosshair"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-zoom"></script>
<link rel="icon" href="${root}image/TMI_YB.png" type="image/png">
<title>Crypto | TMI</title>
</head>
<body>
   <c:import url="/WEB-INF/views/include/topMenu.jsp" />

   <div class="primary-container">
   <div class="coin-name">
      <c:forEach var="coin" items="${coins}">
         <c:if test="${coin.symbol == symbol}">
            <h1 id="symbolImg">
               <img
                  src="https://cryptologos.cc/logos/${coin.name.toLowerCase()}-${coin.symbol.toLowerCase()}-logo.png?v=040"
                  style="height: 50px; margin-right: 20px;"> ${coin.name}
               (${coin.symbol})
            </h1>

            <h3 id="explaneCompany">
               <span id="closingPrice"></span> <span
                  class="${coin.quotes.USD.percent_change_24h > 0 ? 'positive-change' : 'negative-change'}">
                  <script> (function(){ var value = (${coin.quotes.USD.percent_change_24h}).toFixed(2) + "%";
                                            document.currentScript.parentElement.innerText = "(" + value + ")"; })(); </script>
               </span>
            
            <script> (function(){  var price = ${coin.quotes.USD.price};
                                       var closingPriceEl = document.getElementById("closingPrice");
                                           closingPriceEl.innerText ="$ " + price.toFixed(2);
                                           closingPriceEl.style.fontSize = "50px"; })(); </script></h3>
         </c:if>
      </c:forEach>
	</div>
   <!-- 차트와 뉴스 영역을 감싸는 컨테이너 -->
   <div class="chart-and-info">
      <div class="left-column">
         <!-- 코인인포의 버튼과 차트 영역 -->
         <div id="chartContainer">
            <div class="buttonGroup">
               <button class="coinButton" onclick="fetchData('DAILY')">1D</button>
               <button class="coinButton" onclick="fetchData('WEEKLY')">1W</button>
               <button class="coinButton" onclick="fetchData('MONTHLY')">1M</button>
            </div>
            <canvas id="coinChart"></canvas>
         </div>

         <hr class="section-divider">

         <!-- 코인인포의 뉴스 섹션 -->
         <div class="news-section">
            <h2>${symbol}경제뉴스</h2>
            <div class="content">
               <div class="advertisement-slider">
                  <div class="list-container">
                     <ul id="coinNewsList">
                        <c:forEach var="coinInfoNew" items="${coinInfoNews}"
                           varStatus="status">
                           <c:if test="${status.index % 3 == 0}">
                              <li class="news-group">
                           </c:if>
                           <div class="news-item">
                              <a class="news-title" href="${coinInfoNew.link}"
                                 target="_blank">${coinInfoNew.title}</a><br /> <br />
                              ${coinInfoNew.description}
                           </div>
                           <!-- 각 뉴스 아이템 사이 구분선 (원한다면) -->
                           <c:if test="${(status.index % 3) != 2 && !status.last}">
                              <br />
                              <hr />
                              <br />
                           </c:if>
                           <c:if test="${status.index % 3 == 2 || status.last}">
                              </li>
                           </c:if>
                        </c:forEach>
                     </ul>
                  </div>
                  <button class="advertisement-arrow advertisement-arrow-left">&#10094;</button>
                  <button class="advertisement-arrow advertisement-arrow-right">&#10095;</button>
               </div>
            </div>
         </div>
      </div>

      <!-- 오른쪽 컬럼: 코인인포의 테이블 영역 -->
      <div class="container">
         <div class="table">
            <h3>코인 정보</h3>

            <c:forEach var="coin" items="${coins}">
               <c:if test="${coin.symbol == symbol}">

                  <!-- 코인 -->
                  <div class="row">
                     <strong>코인</strong> <span>${coin.symbol}</span>
                  </div>

                  <!-- 최대 공급량 -->
                  <div class="row">
                      <strong>최대 공급량</strong>
                      <span>
                          <c:choose>
                              <c:when test="${coin.quotes.USD.max_supply == 0}">
                                  ∞
                              </c:when>
                              <c:otherwise>
                                  <script>
					                    var maxSupply = parseFloat("${coin.quotes.USD.max_supply}");
					                    document.write(maxSupply.toLocaleString());
					                </script>
                              </c:otherwise>
                          </c:choose>
                      </span>
                  </div>

                  <!-- 총 공급량 -->
                  <div class="row">
                     <strong>총 공급량</strong> <span><script>
            var totalSupply = parseFloat("${coin.quotes.USD.total_supply}");
            document.write(totalSupply.toLocaleString());
        </script></span>
                  </div>

                  <!-- 가격 -->
                  <div class="row">
                     <strong>가격 (KRW)</strong> <span> $<script>
              (function(){
                var value = (${coin.quotes.USD.price} / 1000).toFixed(1) + 'K';
                document.write(value);
              })();
            </script>
                     </span>
                  </div>

                  <!-- 총 시가 -->
                  <div class="row">
                     <strong>총 시가</strong> <span> $<script>
              (function(){
                var value = (${coin.quotes.USD.market_cap} / 1000000000000).toFixed(2) + 'T';
                document.write(value);
              })();
            </script>
                     </span>
                  </div>

                  <!-- 거래량 (24H) -->
                  <div class="row">
                     <strong>거래량 (24H)</strong> <span> $<script>
              (function(){
                var value = (${coin.quotes.USD.volume_24h} / 1000000000000).toFixed(2) + 'T';
                document.write(value);
              })();
            </script>
                     </span>
                  </div>

                  <!-- 변동 (24H) -->
                  <div class="row">
                     <strong>변동 (24H)</strong> <span
                        class="${coin.quotes.USD.percent_change_24h > 0 ? 'positive-change' : 'negative-change'}">
                        <script>
              (function(){
                var percentChange24h = ${coin.quotes.USD.percent_change_24h};
                document.write(percentChange24h.toFixed(2) + "%");
              })();
            </script>
                     </span>
                  </div>

                  <!-- 변동 (7D) -->
                  <div class="row">
                     <strong>변동 (7D)</strong> <span
                        class="${coin.quotes.USD.percent_change_7d > 0 ? 'positive-change' : 'negative-change'}">
                        <script>
              (function(){
                var percentChange7d = ${coin.quotes.USD.percent_change_7d};
                document.write(percentChange7d.toFixed(2) + "%");
              })();
            </script>
                     </span>
                  </div>

               </c:if>
            </c:forEach>
         </div>

         <div class="table">
            <h3>${symbol} 과거 가격</h3>
            <c:forEach var="coin" items="${coins}">
               <c:if test="${coin.symbol == symbol}">

                  <!-- 최고가 -->
                  <div class="row">
                     <strong>최고가</strong> <span> $<script>
              (function(){
                var value = ${coin.quotes.USD.ath_price}.toFixed(2);
                document.write(value);
              })();
            </script>
                     </span>
                  </div>

                  <!-- 최고가 기록일 -->
                  <div class="row">
                     <strong>최고가 기록일</strong> <span>${fn:substring(coin.quotes.USD.ath_date, 0, 10)}</span>
                  </div>

                  <!-- 최고가 대비 변동 -->
                  <div class="row">
                     <strong>최고가 대비 변동</strong> <span
                        class="${coin.quotes.USD.percent_from_price_ath > 0 ? 'positive-change' : 'negative-change'}">
                        ${coin.quotes.USD.percent_from_price_ath}% </span>
                  </div>

                  <!-- 시가총액 변화 (24H) -->
                  <div class="row">
                     <strong>시가총액 변화 (24H)</strong> <span
                        class="${coin.quotes.USD.market_cap_change_24h > 0 ? 'positive-change' : 'negative-change'}">
                        ${coin.quotes.USD.market_cap_change_24h}% </span>
                  </div>

                  <!-- 가격 변화 (24H) -->
                  <div class="row">
                     <strong>가격 변화 (24H)</strong> <span
                        class="${coin.quotes.USD.percent_change_24h > 0 ? 'positive-change' : 'negative-change'}">
                        ${coin.quotes.USD.percent_change_24h}% </span>
                  </div>

               </c:if>
            </c:forEach>
         </div>
         <div class="table">
                <h3>시장 점유율</h3>
                <c:forEach var="entry" items="${dominanceData}">
                    <div class="row">
                        <strong>${entry.key}</strong> 
                        <span>${entry.value}%</span>
                    </div>
                </c:forEach>
           </div>
      </div>
   </div>

</div>

   <script>
    const apiUrl = "http://localhost:3000/coin";
    let myChart; // 차트 인스턴스 저장

    async function fetchData(timeframe) {
      try {
        const response = await axios.get(apiUrl, {
          params: {
            symbol: "${symbol}",
            timeframe: timeframe
          }
        });
        const data = response.data;
        renderChart(data);
      } catch (error) {
        console.error("API 요청 실패:", error);
      }
    }

    function renderChart(data) {
      const labels = data.map(d => d.date);
      const openPrices = data.map(d => d.open);
      const highPrices = data.map(d => d.high);
      const lowPrices = data.map(d => d.low);
      const closePrices = data.map(d => d.close);
      const volumes = data.map(d => d.volume);

      const chartData = {
        labels: labels,
        datasets: [{
          label: '종가',
          data: closePrices,
          backgroundColor: 'rgba(75, 192, 192, 0.2)',
          borderColor: 'rgba(75, 192, 192, 1)',
          borderWidth: 1,
          fill: true,
          type: 'line',
          pointRadius: 0
        }]
      };

      const ctx = document.getElementById('coinChart').getContext('2d');
      if (myChart) {
        myChart.destroy();
      }
      myChart = new Chart(ctx, {
        type: 'line',
        data: chartData,
        options: {
          responsive: true,
          maintainAspectRatio: false,
          interaction: {
            mode: 'index',
            intersect: false
          },
          plugins: {
            crosshair: {
              line: { color: '#96FFFF', width: 1 },
              sync: { enabled: false },
              zoom: {
                enabled: true,
                mode: 'xy',
                speed: 0.1,
                reset: { enabled: false }
              },
              x: { line: { color: '#000', width: 1 } },
              y: { line: { color: '#000', width: 1 }, enabled: true }
            },
            tooltip: {
              displayColors: false,
              callbacks: {
                title: function(tooltipItems) {
                  const index = tooltipItems[0].dataIndex;
                  return '날짜: ' + chartData.labels[index];
                },
                label: function(tooltipItem) {
                  const index = tooltipItem.dataIndex;
                  return [
                    '종가: ' + closePrices[index],
                    '시가: ' + openPrices[index],
                    '고가: ' + highPrices[index],
                    '저가: ' + lowPrices[index],
                    '거래량: ' + volumes[index]
                  ];
                }
              }
            },   
            legend: { display: false }
          },
          scales: {
            x: {
              beginAtZero: false,
              grid: { display: true },
              ticks: { autoSkip: true, maxTicksLimit: 8, display: true }
            },
            y: {
              beginAtZero: false,
              grid: { display: true },
              ticks: { autoSkip: false, maxTicksLimit: 5, display: true }
            }
          }
        }
      });
    }

    document.addEventListener('DOMContentLoaded', (event) => {
      fetchData('DAILY');
    });
    
    // jQuery 사용 코드 (슬라이더)
    $(document).ready(function() {
    fetchData('DAILY'); // 기본 'daily' 데이터 요청
    
    var $slider = $('.list-container');
    var $ul = $slider.find('ul');
    var $slides = $ul.find('.news-group');
    var count = $slides.length;
    var currentIndex = 0;
    var slideWidth = $slider.width();

    $slides.width(slideWidth);
    $ul.width(slideWidth * count);

    var $leftArrow = $('.advertisement-arrow-left');
    var $rightArrow = $('.advertisement-arrow-right');
    var slideInterval;

    function goToSlide(index) {
        if(index < 0) {
            index = count - 1;
        } else if(index >= count) {
            index = 0;
        }
        $ul.animate({ marginLeft: -index * slideWidth }, 500);
        currentIndex = index;
    }
    function nextSlide() { goToSlide(currentIndex + 1); }
    function prevSlide() { goToSlide(currentIndex - 1); }

    $rightArrow.on('click', function(e) {
        e.stopPropagation();
        nextSlide();
        resetInterval();
    });
    $leftArrow.on('click', function(e) {
        e.stopPropagation();
        prevSlide();
        resetInterval();
    });

    function startInterval() { slideInterval = setInterval(nextSlide, 5000); }
    function resetInterval() { clearInterval(slideInterval); startInterval(); }
    startInterval();
});

  </script>
</body>
</html>
