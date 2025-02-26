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
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@400&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${root}css/bugMain.css">
    <link rel="stylesheet" href="${root}css/coinMain.css"> 
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
    <!-- 플러그인 추가 -->
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-crosshair"></script>
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-zoom"></script>
<title>Take Money Information | TMI</title>
</head>
<body>
<h2>${symbol} 가격 정보</h2>
<div>
    <button onclick="fetchData('daily')">일</button>
    <button onclick="fetchData('weekly')">주</button>
    <button onclick="fetchData('monthly')">월</button>
</div>

<div style="width: 1000px; height: 800px;">
<canvas id="myChart"></canvas>
</div>

<script>
    const apiUrl = "http://localhost:3000/commodities";
    let myChart; // 차트 인스턴스를 저장할 전역 변수

    async function fetchData(timeframe) {
        try {
            const response = await axios.get(apiUrl, {
                params: {
                    symbol: "${symbol}",
                    timeframe: timeframe
                }
            });
            const data = response.data.data;
            renderChart(data);
        } catch (error) {
            console.error("API 요청 실패:", error);
        }
    }

    function renderChart(data) {
        const labels = data.map(item => item.date);
        const values = data.map(item => parseFloat(item.value));

        const ctx = document.getElementById('myChart').getContext('2d');

        // 기존 차트가 존재하면 파괴
        if (myChart) {
            myChart.destroy();
        }

        // 새로운 차트 생성
        myChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: "${symbol} 가격",
                    data: values,
                    borderColor: 'rgba(75, 192, 192, 1)',
                    borderWidth: 2,
                    fill: true, // 선 아래를 색상으로 채우기
                    backgroundColor: 'rgba(75, 192, 192, 0.2)', // 채우기 색상
                    pointRadius: 0 // 차트의 점을 숨기기
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                interaction: {
                    mode: 'index', // 인터랙션 모드를 index로 설정
                    intersect: false
                },
                scales: {
                    x: {
                        beginAtZero: false, // x축이 0부터 시작하지 않도록 설정
                        reverse: true, // x축을 거꾸로 설정
                        ticks: {
                            autoSkip: true, // 자동으로 값을 건너뛰지 않도록 설정
                            maxTicksLimit: 10 // 표시할 최대 tick 수
                        }
                    },
                    y: {
                        beginAtZero: false, // y축이 0부터 시작하지 않도록 설정
                        ticks: {
                            autoSkip: false, // 자동으로 값을 건너뛰지 않도록 설정
                            maxTicksLimit: 5 // 표시할 최대 tick 수
                        }
                    }
                }
            }
        });
    }

    // 페이지 로드 시 기본 데이터 로드
    document.addEventListener('DOMContentLoaded', (event) => {
        fetchData('daily'); // 기본적으로 'daily' 데이터를 요청
    });
</script>
</body>
</html>
