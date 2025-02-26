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
  <button onclick="fetchData('DAILY')">일</button>
  <button onclick="fetchData('WEEKLY')">주</button>
  <button onclick="fetchData('MONTHLY')">월</button>
</div>

<div style="width: 1000px; height: 800px;">
  <canvas id="myChart"></canvas>
</div>

<script>
  const apiUrl = "http://localhost:3000/economy";
  let myChart; // 차트 인스턴스를 저장할 전역 변수

  async function fetchData(timeframe) {
    try {
      const response = await axios.get(apiUrl, {
        params: {
          symbol: "${symbol}",
          timeframe: timeframe
        }
      });
      const data = response.data;
      renderChart(data, timeframe);
    } catch (error) {
      console.error("API 요청 실패:", error);
    }
  }

  function renderChart(data, timeframe) {
    let labels = [];
    let closeValues = [];
    let openValues = [];
    let highValues = [];
    let lowValues = [];
    let volumeValues = [];

    // timeframe에 따라 데이터를 파싱
    if (timeframe === 'DAILY') {
      if (!data["Time Series (Daily)"]) {
        console.error("일별 데이터가 없습니다.");
        return;
      }
      labels = Object.keys(data["Time Series (Daily)"]);
      closeValues = labels.map(date => parseFloat(data["Time Series (Daily)"][date]["4. close"]));
      openValues = labels.map(date => parseFloat(data["Time Series (Daily)"][date]["1. open"]));
      highValues = labels.map(date => parseFloat(data["Time Series (Daily)"][date]["2. high"]));
      lowValues = labels.map(date => parseFloat(data["Time Series (Daily)"][date]["3. low"]));
      volumeValues = labels.map(date => parseFloat(data["Time Series (Daily)"][date]["5. volume"]));
    } else if (timeframe === 'WEEKLY') {
      if (!data["Weekly Time Series"]) {
        console.error("주별 데이터가 없습니다.");
        return;
      }
      labels = Object.keys(data["Weekly Time Series"]);
      closeValues = labels.map(date => parseFloat(data["Weekly Time Series"][date]["4. close"]));
      openValues = labels.map(date => parseFloat(data["Weekly Time Series"][date]["1. open"]));
      highValues = labels.map(date => parseFloat(data["Weekly Time Series"][date]["2. high"]));
      lowValues = labels.map(date => parseFloat(data["Weekly Time Series"][date]["3. low"]));
      volumeValues = labels.map(date => parseFloat(data["Weekly Time Series"][date]["5. volume"]));
    } else if (timeframe === 'MONTHLY') {
      if (!data["Monthly Time Series"]) {
        console.error("월별 데이터가 없습니다.");
        return;
      }
      labels = Object.keys(data["Monthly Time Series"]);
      closeValues = labels.map(date => parseFloat(data["Monthly Time Series"][date]["4. close"]));
      openValues = labels.map(date => parseFloat(data["Monthly Time Series"][date]["1. open"]));
      highValues = labels.map(date => parseFloat(data["Monthly Time Series"][date]["2. high"]));
      lowValues = labels.map(date => parseFloat(data["Monthly Time Series"][date]["3. low"]));
      volumeValues = labels.map(date => parseFloat(data["Monthly Time Series"][date]["5. volume"]));
    }

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
        datasets: [
          {
            label: '종가',
            data: closeValues,
            borderColor: 'rgba(75, 192, 192, 1)',
            borderWidth: 2,
            fill: true,
            backgroundColor: 'rgba(75, 192, 192, 0.2)',
            pointRadius: 0
          },
          {
            label: '시가',
            data: openValues,
            borderColor: 'rgba(255, 99, 132, 1)',
            borderWidth: 2,
            fill: false,
            pointRadius: 0
          },
          {
            label: '고가',
            data: highValues,
            borderColor: 'rgba(54, 162, 235, 1)',
            borderWidth: 2,
            fill: false,
            pointRadius: 0
          },
          {
            label: '저가',
            data: lowValues,
            borderColor: 'rgba(255, 206, 86, 1)',
            borderWidth: 2,
            fill: false,
            pointRadius: 0
          },
          {
            label: '거래량',
            data: volumeValues,
            borderColor: 'rgba(153, 102, 255, 1)',
            borderWidth: 2,
            fill: false,
            pointRadius: 0
          }
        ]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        interaction: {
          mode: 'index',
          intersect: false
        },
        scales: {
          x: {
            beginAtZero: false,
            reverse: true,
            ticks: {
              autoSkip: true,
              maxTicksLimit: 10
            }
          },
          y: {
            beginAtZero: false,
            ticks: {
              autoSkip: false,
              maxTicksLimit: 5
            }
          }
        }
      }
    });
  }

  // 페이지 로드 시 기본 데이터 로드
  document.addEventListener('DOMContentLoaded', (event) => {
    fetchData('DAILY'); // 기본적으로 'daily' 데이터를 요청
  });
</script>
</body>
</html>

