<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<c:set var="root" value='${pageContext.request.contextPath }/' />
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-crosshair"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	
<script>
$(document).ready(function() {
	
	// 서버 또는 Node 서버에서 주식 심볼 목록을 가져오는 함수
    function loadStockSymbols() {
        $.ajax({
            url: "${root}loadStocks",  // 실제 매핑된 URL로 수정
            type: "GET",
            dataType: "json",
            success: function(data) {
                // data가 예: [ {symbol: "AAPL"}, {symbol: "MSFT"}, ... ]
                // 심볼만 추출
                stockSymbols = data.map(function(item) { 
                    return item.symbol; 
                });
                // top 5만 사용하려면 slice(0,5)
                stockSymbols = stockSymbols.slice(0, 5);
                
                // 심볼이 로드된 후 차트 업데이트
                currentStockIndex = 0;
                updateStockChart();
            },
            error: function(xhr, status, error) {
                console.error("Error loading stock symbols:", error);
            }
        });
    }

    // 서버 또는 Node 서버에서 코인 심볼 목록을 가져오는 함수
    function loadCoinSymbols() {
        $.ajax({
            url: "${root}loadCoins", // 실제 매핑된 URL로 수정
            type: "GET",
            dataType: "json",
            success: function(data) {
                // data가 예: [ {symbol: "BTC"}, {symbol: "ETH"}, ... ]
                coinSymbols = data.map(function(item) { 
                    return item.symbol; 
                });
                // top 5만 사용하려면 slice(0,5)
                coinSymbols = coinSymbols.slice(0, 5);
                
                // 심볼이 로드된 후 차트 업데이트
                currentCoinIndex = 0;
                updateCoinChart();
            },
            error: function(xhr, status, error) {
                console.error("Error loading coin symbols:", error);
            }
        });
    }
    // 즐겨찾기 삭제 처리
    $('.delete-fav-btn').click(function() {
        var button = $(this);
        var symbol = button.data('symbol');
        var type = button.data('type');
        $.ajax({
            url: "${root}favorite/delete",
            type: "POST",
            data: { symbol: symbol, type: type },
            success: function(response) {
                alert("즐겨찾기에서 삭제되었습니다.");
                $(button).closest('tr').remove();
            },
            error: function() {
                alert("즐겨찾기 삭제 중 오류가 발생했습니다.");
            }
        });
    });

    // 차트 업데이트 관련 변수 및 함수
    var stockSymbols = [];
    var coinSymbols = [];
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

    // 초기 데이터 표시
    loadStockSymbols();
    loadCoinSymbols();
    updateStockChart();
    updateCoinChart();
    selectCommodity('WTI', '원유(WTI)');

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
    
    const $slides = $('.advertisement-slides');
    const $slideElements = $('.advertisement-slide');
    const $leftArrow = $('.advertisement-arrow-left');
    const $rightArrow = $('.advertisement-arrow-right');
    const $indicators = $('.advertisement-indicator');
    
    let currentIndex = 0;
    const totalSlides = $slideElements.length;
    let slideInterval;
    
    function goToSlide(index) {
        if (index < 0) {
            index = totalSlides - 1;
        } else if (index >= totalSlides) {
            index = 0;
        }
        $slides.css('transform', 'translateX(' + (-index * 100) + '%)');
        currentIndex = index;
        updateIndicators();
    }
    
    function updateIndicators() {
        $indicators.removeClass('active');
        $indicators.eq(currentIndex).addClass('active');
    }
    
    function nextSlide() {
        goToSlide(currentIndex + 1);
    }
    
    function prevSlide() {
        goToSlide(currentIndex - 1);
    }
    
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
    
    $indicators.on('click', function() {
        let index = parseInt($(this).attr('data-index'));
        goToSlide(index);
        resetInterval();
    });
    
    function startInterval() {
        slideInterval = setInterval(nextSlide, 10000); // 3초마다 슬라이드 전환
    }
    
    function resetInterval() {
        clearInterval(slideInterval);
        startInterval();
    }
    
    startInterval();
    loadStocks();
    loadCoins();

    
});

function loadStocks() {
    $.ajax({
        url: '${root}loadStocks',
        type: 'GET',
        dataType: 'json',
        success: function(data) {
            var html = '<table>';
            html += '<thead><tr>' +
                '<th colspan="2">심볼</th>' +
                '<th>종목</th>' +
                '<th>통화</th>' +
                '<th>주가수익비율</th>' +
                '<th>현재 가격</th>' +
                '<th>24시간 변동</th>' +
                '<th>시가총액</th>' +
                '</tr></thead><tbody>';
            $.each(data, function(index, stock) {
                html += '<tr>';
                html += '<td><img src="https://financialmodelingprep.com/image-stock/' + stock.symbol + '.png" style="width:30px;height:30px;"/></td>';
                html += '<td class="clickable" onclick="location.href=\'' + '${root}stock/info/' + stock.symbol + '\'">' + stock.symbol + '</td>';
                html += '<td class="light-bg">' + stock.name + '</td>';
                html += '<td class="light-bg">' + stock.currency + '</td>';
                html += '<td class="light-bg">' + parseFloat(stock.trailingPE).toFixed(2) + 'x</td>';
                html += '<td class="align-right light-bg">$' + stock.marketPrice + '</td>';
                html += '<td class="align-right light-bg">' + parseFloat(stock.marketChange).toFixed(2) + '%</td>';
                html += '<td class="align-right light-bg">' + stock.marketCap + '</td>';
                html += '</tr>';
            });
            html += '</tbody></table>';
            $('.stock-table').html(html);
        },
        error: function(xhr, status, error) {
            console.error('Error loading stocks: ' + error);
        }
    });
}

function loadCoins() {
    $.ajax({
        url: '${root}loadCoins',  // API 호출 URL
        type: 'GET',              // GET 요청
        dataType: 'json',         // 응답 데이터 형식
        success: function(data) {
            console.log(data);    // 데이터 구조 확인

            var html = '<table>';
            html += '<thead><tr>' +
                '<th class="headCol rankCol">순위</th>' +
                '<th class="headCol nameCol">종목</th>' +
                '<th>기호</th>' +
                '<th>가격(KRW)</th>' +
                '<th>총 시가</th>' +
                '<th>거래량(24H)</th>' +
                '<th>변동(24H)</th>' +
                '<th>변동(7D)</th>' +
                '</tr></thead><tbody>';

            // 각 코인 데이터 반복
            $.each(data, function(index, coin) {
                html += '<tr>';
                html += '<td class="headCol rankCol">' + coin.rank + '</td>';
                html += '<td class="headCol nameCol" onclick="location.href=\'${root}coin/info/' + coin.symbol + '/' + coin.name + '\'">' +
                    '<img src="https://cryptologos.cc/logos/' + coin.name.toLowerCase() + '-' + coin.symbol.toLowerCase() + '-logo.png?v=040" style="height:20px;margin-right:5px;"> ' +
                    coin.name + '</td>';
                html += '<td>' + coin.symbol + '</td>';
                html += '<td class="align-right">₩' + parseFloat(coin.quotes.USD.price).toFixed(2) + '</td>';
                html += '<td class="align-right">₩' + parseInt(coin.quotes.USD.market_cap).toLocaleString() + '</td>';
                html += '<td class="align-right">₩' + parseFloat(coin.quotes.USD.volume_24h).toFixed(2) + '</td>';
                html += '<td class="align-right ' + (coin.quotes.USD.percent_change_24h > 0 ? 'positive-change' : 'negative-change') + '">' +
                    parseFloat(coin.quotes.USD.percent_change_24h).toFixed(2) + '%</td>';
                html += '<td class="align-right ' + (coin.quotes.USD.percent_change_7d > 0 ? 'positive-change' : 'negative-change') + '">' +
                    parseFloat(coin.quotes.USD.percent_change_7d).toFixed(2) + '%</td>';
                html += '</tr>';
            });

            html += '</tbody></table>';
            $('.coin-table').html(html);  // HTML 내용 업데이트
        },
        error: function(xhr, status, error) {
            console.error('Error loading coins: ' + error);  // 오류 로그
        }
    });
}
</script>
	