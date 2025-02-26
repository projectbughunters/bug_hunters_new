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
    var stockSymbols = JSON.parse('${stockSymbolsJson}');
    var coinSymbols = JSON.parse('${coinSymbolsJson}');
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
    
});
</script>
	