<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="root" value='${pageContext.request.contextPath }/' /> 
<!DOCTYPE html >
<html>
<head>
<meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="stylesheet" href="${root}css/stockMain.css"> 
	<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
	<!-- 플러그인 추가 -->
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-crosshair"></script>
 <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-zoom"></script>
<title>Stock | TMI</title>
</head>
<body>
<c:import url="/WEB-INF/views/include/topMenu.jsp"/>
<c:import url="/WEB-INF/views/stock/aiBot.jsp"/>
<div class="primary-container">
 <div class="stock-name">
	 <h1 id="symbolImg">
	 <img src="https://financialmodelingprep.com/image-stock/${symbol}.png"  />
	  ${processedData.name} (${symbol})
	 </h1>
 </div>
    <h3 id="explaneCompany">${processedData.marketPrice } 
    	<span class="${processedData.marketChange > 0 ? 'positive-change' : 'negative-change'}">(
    		<script>
		        var marketChange = ${processedData.marketChange};
		        document.write(marketChange.toFixed(2) + "%");
	    	</script>)</span> </h3>

	<div class="chart-and-info">
	<div class="left-column">
	<div id="chartContainer" >
		<div class="buttonGroup">
		    <button class="stockButton" onclick="fetchData('DAILY')">1D</button>
		    <button class="stockButton" onclick="fetchData('WEEKLY')">1W</button>
		    <button class="stockButton" onclick="fetchData('MONTHLY')">1M</button>
	  	</div> 
	    <canvas id="stockChart"></canvas>
	</div>
	<div class="news-section">
    <h2>${symbol} 경제 뉴스</h2>
    <div class="content">
        <!-- advertisement-slider 클래스 추가 -->
        <div class="advertisement-slider">
            <div class="list-container">
                <ul id="stockNewsList">
				    <c:forEach var="stockInfoNew" items="${stockInfoNews}" varStatus="status">
				        <!-- 3개 단위로 <li> 태그를 시작 -->
				        <c:if test="${status.index % 3 == 0}">
				            <li class="news-slide"> 
				                <!-- 슬라이드 하나에 최대 3개의 뉴스 아이템을 담음 -->
				        </c:if>
				        <!-- 단일 뉴스 아이템 영역 -->
				        <div class="news-item">
				            <a class="news-title" href="${stockInfoNew.link}" target="_blank">${stockInfoNew.title}</a><br/>
				            <br />
				            ${stockInfoNew.description}
				        </div>
				        <!-- 각 뉴스 아이템 사이 구분선 (원한다면) -->
				        <c:if test="${(status.index % 3) != 2 && !status.last}">
				        	<br />
				            <hr/>
				            <br />
				        </c:if>
				        <!-- 3개를 채웠거나 마지막 항목이면 </li> 닫기 -->
				        <c:if test="${status.index % 3 == 2 || status.last}">
				            </li>
				        </c:if>
				    </c:forEach>
				</ul>
            </div>
            <!-- 좌우 화살표 버튼을 advertisement-slider 내부로 이동 -->
            <button class="advertisement-arrow advertisement-arrow-left">&#10094;</button>
            <button class="advertisement-arrow advertisement-arrow-right">&#10095;</button>
        </div>
    </div>
</div>


   	</div>
	<div class="container">
	    <div class="table">
		  <h3>주요 통계</h3>
		  <div class="row"><strong>전일 종가:</strong><span>${processedData.previousClose}</span></div>
		  <div class="row"><strong>금일 시가:</strong><span>${processedData.openPrice}</span></div>
		  <div class="row"><strong>금일 변동:</strong><span>${processedData.dayRange}</span></div>
		  <div class="row"><strong>52주 변동폭:</strong><span>${processedData.fiftyTwoWeekRange}</span></div>
		  <div class="row"><strong>거래량:</strong><span>
			<script>
		        var volume = '${processedData.volume}';
		        document.write(formatEBITDA(volume));
		    </script>
		  </span></div>
		  <div class="row"><strong>평균 거래량:</strong>
		  	<span>
		  		<script>
		        var volume = '${processedData.averageVolume}';
		        document.write(formatEBITDA(volume));
		    	</script>
		  	</span></div>
		  <div class="row"><strong>장부가치:</strong><span>${processedData.bookValue}</span></div>
		</div>
	
	    <div class="table">
	      <h3>추가 정보</h3>
	      <div class="row"><strong>총 시가:</strong>
	      	<span>$ 
	      		<script>
		        var volume = '${processedData.marketCap}';
		        document.write(formatEBITDA(volume));
		    	</script>
	      	</span></div>
	  	  <div class="row"><strong>발행 주식 수:</strong><span>
	  	  		<script>
		        var volume = '${processedData.sharesOutstanding}';
		        document.write(formatEBITDA(volume));
		    	</script>
	  	  	</span></div>
	      <div class="row"><strong>주당순이익:</strong><span>${processedData.eps}</span></div>
		  <div class="row"><strong>다음 실적 발표일:</strong><span>${processedData.earningsDate}</span></div>
		  <div class="row"><strong>배당금:</strong><span>${processedData.dividendRate}</span></div>
	    </div>
	
	    <div class="table">
	      <h3>${symbol}의 지표</h3>
	      <div class="row"><strong>주가수익비율:</strong><span>
	      		<script>
		        var volume = '${processedData.trailingPE}';
		        document.write(formatEBITDA(volume));
		    	</script>
	      	</span></div>
	  	  <div class="row"><strong>매출총이익:</strong><span>
				<script>
		        var volume = '${overData.grossProfitTTM}';
		        document.write(formatEBITDA(volume));
		    	</script>  	  
	  	  	</span></div>
	      <div class="row"><strong>EBITDA:</strong><span>
	      		<script>
		        var volume = '${overData.ebitda}';
		        document.write(formatEBITDA(volume));
		    	</script> 
	      	</span></div>
	      <div class="row"><strong>EV/EBITDA:</strong><span>${overData.evToEBITDA}</span></div>
	    </div>
	  </div>
  </div>
  
</div>
<c:import url="/WEB-INF/views/include/bottom.jsp"/>
<script>
var chartInstance = null; // 차트 인스턴스를 저장할 변수

//데이터를 가져오고 표시하는 함수 (jQuery AJAX 사용)
function fetchData(timeframe) {
 $.ajax({
     url: "http://localhost:3000/stock-info",
     type: "GET",
     data: {
         symbol: "${symbol}",
         timeframe: timeframe
     },
     dataType: "json",
     success: function(stockInfo) {
         createChart(stockInfo);
     },
     error: function(xhr, status, error) {
         console.error("Request failed:", error);
         alert("Failed to fetch stock data. Please try again.");
     }
 });
}

//차트를 생성하는 함수
function createChart(stockInfo) {
 // 기존 차트가 있으면 삭제
 if (chartInstance) {
     chartInstance.destroy();
 }
 var recentData = stockInfo.slice(-100);

 var labels = recentData.map(function(item) {
     return item.date;
 });
 var closePrices = recentData.map(function(item) {
     return item.close;
 });
 var openPrices = recentData.map(function(item) {
     return item.open;
 });
 var volumes = recentData.map(function(item) {
     return item.volume;
 });

 var ctx = $("#stockChart")[0].getContext("2d");
 var stockData = {
     labels: labels,
     datasets: [{
         label: "Close Price",
         data: closePrices,
         backgroundColor: "rgba(255, 165, 0, 0.2)",
         borderColor: "rgba(255, 165, 0, 1)",
         borderWidth: 1,
         fill: true,
         type: "line",
         pointRadius: 0
     }]
 };

 chartInstance = new Chart(ctx, {
     type: "line",
     data: stockData,
     options: {
         responsive: true,
         maintainAspectRatio: false,
         interaction: {
             mode: "index",
             intersect: false
         },
         plugins: {
             legend: {
                 position: "top",
                 display: false
             },
             tooltip: {
                 displayColors: false,
                 callbacks: {
                     title: function(tooltipItems) {
                         var index = tooltipItems[0].dataIndex;
                         return "날짜: " + stockData.labels[index];
                     },
                     label: function(tooltipItem) {
                         var index = tooltipItem.dataIndex;
                         var open = openPrices[index]; // 시가
                         var close = closePrices[index]; // 종가
                         var volume = volumes[index]; // 거래량
                         return [
                             '종가: ' + close,
                             '시가: ' + open,
                             '거래량: ' + volume
                         ];
                     }
                 }
             },
             zoom: {
                 pan: {
                     enabled: true,
                     mode: "x"
                 },
                 zoom: {
                     enabled: true,
                     mode: "x"
                 },
                 resetZoomButton: {
                     display: false
                 }
             }
         },
         scales: {
             x: {
                 beginAtZero: false,
                 grid: {
                     display: true
                 },
                 ticks: {
                     autoSkip: true,
                     maxTicksLimit: 10,
                     display: true
                 }
             },
             y: {
                 beginAtZero: false,
                 grid: {
                     display: true
                 },
                 ticks: {
                     autoSkip: false,
                     maxTicksLimit: 10,
                     display: true
                 }
             }
         }
     }
 });
}

//페이지 로드 시 기본 데이터 로드 (jQuery DOM Ready 사용)
$(document).ready(function() {
 fetchData('DAILY'); // 기본적으로 'daily' 데이터를 요청
 
 var $slider = $('.list-container');
 var $ul = $slider.find('ul');
 var $slides = $ul.find('.news-slide');
 var count = $slides.length;
 var currentIndex = 0;
 var slideWidth = $slider.width();

 // 각 li의 너비를 슬라이더 너비로 설정
 $slides.width(slideWidth);

 // ul의 전체 너비 설정 (슬라이드 개수 * 슬라이더 너비)
 $ul.width(slideWidth * count);

 // 좌우 화살표 버튼 선택
 var $leftArrow = $('.advertisement-arrow-left');
 var $rightArrow = $('.advertisement-arrow-right');
 var slideInterval;

 // 슬라이드 전환 함수
 function goToSlide(index) {
    if(index < 0) {
        index = count - 1;
    } else if(index >= count) {
        index = 0;
    }
    $ul.animate({
        marginLeft: -index * slideWidth
    }, 500);
    currentIndex = index;
}

 // 다음, 이전 슬라이드 함수
 function nextSlide() {
     goToSlide(currentIndex + 1);
 }
 function prevSlide() {
     goToSlide(currentIndex - 1);
 }

 // 화살표 버튼 이벤트 핸들러
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

 // 자동 슬라이드 타이머 시작 및 리셋 함수
 function startInterval() {
     slideInterval = setInterval(nextSlide, 5000); // 5초마다 다음 슬라이드
 }
 function resetInterval() {
     clearInterval(slideInterval);
     startInterval();
 }
 startInterval();
});
</script>

</body>
</html>