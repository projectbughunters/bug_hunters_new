<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<c:set var="root" value='${pageContext.request.contextPath }/' />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="${root}css/coinInfo.css">
<link rel="stylesheet" href="${root}css/bugMain.css">
<link rel="stylesheet" href="${root}css/news.css">
<title>Take Money Information | TMI</title>
<!-- Chart.js 라이브러리 -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<!-- 플러그인 추가 -->
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-crosshair"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-zoom"></script>
</head>

<body>
   <c:import url="/WEB-INF/views/include/topMenu.jsp" />

   <div class="">

      <button id="coinDateBtn" onclick="fetchData('DAILY')">일</button>
      <button id="coinDateBtn" onclick="fetchData('WEEKLY')">주</button>
      <button id="coinDateBtn" onclick="fetchData('MONTHLY')">월</button>


      <h1>${name}가격변동차트</h1>
      <div class="container">
         <!-- 차트가 들어가는 부분 -->
         <div class="chart-container">
            <canvas id="coinChart"></canvas>
         </div>
      </div>

      <script>
   
   const apiUrl = "http://localhost:3000/coin";
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
           renderChart(data);
       } catch (error) {
           console.error("API 요청 실패:", error);
       }
   }
   

    function renderChart(data) {
       // 날짜, 시가, 고가, 저가, 종가, 거래량 데이터를 추출
        const labels = data.map(d => d.date); // 날짜 데이터
        const openPrices = data.map(d => d.open); // 시가 데이터
        const highPrices = data.map(d => d.high); // 고가 데이터
        const lowPrices = data.map(d => d.low); // 저가 데이터
        const closePrices = data.map(d => d.close); // 종가 데이터
        const volumes = data.map(d => d.volume); // 거래량 데이터

        // 차트 데이터 구성
        const chartData = {
            labels: labels, // 날짜 레이블
            datasets: [
                {
                    label: '종가',
                    data: closePrices,
                    backgroundColor: 'rgba(75, 192, 192, 0.2)',
                    borderColor: 'rgba(75, 192, 192, 1)',
                    borderWidth: 1,
                    fill: true, // 차트 아래쪽에 색을 칠함
                    fillColor: 'rgba(75, 192, 192, 0.2)', // 배경 색상 설정
                    type: 'line',
                    pointRadius: 0
                }
            ]
        };

        // 차트 그리기
        const ctx = document.getElementById('coinChart').getContext('2d');
        
        // 기존 차트가 존재하면 파괴
        if (myChart) {
            myChart.destroy();
        }
     
        myChart = new Chart(ctx, {
            type: 'line',
            data: chartData,
            options: {
                responsive: true,
                maintainAspectRatio: false, // 부모 요소의 크기에 맞춰 차트 크기 자동 조정
                interaction: {
                    mode: 'index', // 교차선이 x, y 축을 따라 함께 나타나도록 설정
                    intersect: false // 마우스가 정확히 데이터 포인트에 있어야만 하는 것을 방지
                },
                plugins: {
                    crosshair: { // 플러그인 설정
                        line: {
                            color: '#96FFFF', // 교차선 색상: 검정색
                            width: 1 // 교차선 두께
                        },
                        sync: {
                            enabled: false, // 여러 차트에서 교차선 동기화 여부
                        },
                        zoom: {
                            enabled: true, // 줌 기능 활성화
                            mode: 'xy',  // 'x', 'y', 'xy' 중에서 선택 가능. 여기서는 x, y축 모두에서 줌을 사용할 수 있도록 설정
                            speed: 0.1, // 줌 속도
                            reset: {
                                enabled: false, // Reset 버튼 비활성화
                            }
                        },
                        x: {
                            line: {
                                color: '#000', // x축 크로스헤어 색상
                                width: 1
                            }
                        },
                        y: {
                            line: {
                                color: '#000', // y축 크로스헤어 색상
                                width: 1
                            },
                            enabled: true // y축 크로스헤어 활성화
                        }
                    },
                    tooltip: {
                        displayColors: false, // 툴팁에 색상 박스 숨기기
                        callbacks: {
                            title: function(tooltipItems) {
                                const index = tooltipItems[0].dataIndex;
                                return '날짜: ' + chartData.labels[index];
                            },
                            label: function(tooltipItem) {
                                const index = tooltipItem.dataIndex;
                                const open = openPrices[index]; // 시가
                                const high = highPrices[index]; // 고가
                                const low = lowPrices[index];   // 저가
                                const close = closePrices[index]; // 종가
                                const volume = volumes[index]; // 거래량
                                return [
                                    '종가: ' + close,
                                    '시가: ' + open,
                                    '고가: ' + high,
                                    '저가: ' + low,
                                    '거래량: ' + volume
                                ];
                            }
                        }
                    },
                    title: {
                        display: true,
                        text: '${name} 가격 변동 차트'
                    },
                    legend: {
                        display: false, // 범례 표시하지 않도록 설정
                    }
                },
                scales: {
                    x: {
                        beginAtZero: false,  // x축이 0부터 시작하지 않도록 설정
                        grid: {
                            display: true, // x축의 그리드 표시
                        },
                        ticks: {
                            autoSkip: true,  // 너무 많은 값을 표시하지 않도록 설정
                            maxTicksLimit: 10,  // 표시할 최대 tick 수
                            display: true,
                        }
                    },
                    y: {
                        beginAtZero: false, // y축이 0부터 시작하지 않도록 설정
                        grid: {
                            display: true, // y축의 그리드 표시
                        },
                        ticks: {
                            autoSkip: false, // 자동으로 값을 건너뛰지 않도록 설정
                            maxTicksLimit: 5, // 표시할 최대 tick 수
                            display: true, // y축 값이 표시되도록 설정
                        }
                    }
                }
            }
        });
        
    }
    document.querySelectorAll(".timeframe").forEach(button => {
        button.addEventListener("click", () => {
            const timeframe = button.value; // 버튼에서 타임프레임 값을 가져옴
            fetchData(timeframe); // 선택된 타임프레임에 대한 데이터 가져오기
        });
    });
    
    // 페이지 로드 시 기본 데이터 로드
    document.addEventListener('DOMContentLoaded', (event) => {
        fetchData('DAILY'); // 기본적으로 'daily' 데이터를 요청
    });
    
    </script>
   </div>
<div class="coinTableContainer">
  <table id="coinTable">
    <thead>
      <tr>
        <th class="rankCol">순위</th>
        <th>코인</th>
        <th>가격 (KRW)</th>
        <th>총 시가</th>
        <th>거래량 (24H)</th>
        <th>변동 (24H)</th>
        <th>변동 (7D)</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="coin" items="${coins}">
          <c:if test="${coin.symbol == symbol}">
          <tr>
            <td class="row">${coin.rank}</td>
                  <td>${coin.symbol}</td>
                  <td class="row">₩<script>document.write((${coin.quotes.USD.price} / 1000).toFixed(1) + 'K');</script></td>
                  <td class="row">₩<script>document.write((${coin.quotes.USD.market_cap} / 1000000000000).toFixed(2) + 'T');</script></td>
                  <td class="row">₩<script>document.write((${coin.quotes.USD.volume_24h} / 1000000000000).toFixed(2) + 'T');</script></td>
                  <td
                     class="row ${coin.quotes.USD.percent_change_24h > 0 ? 'positive-change' : 'negative-change'}">
                     <script>
            var percentChange24h = ${coin.quotes.USD.percent_change_24h};
            document.write((percentChange24h).toFixed(2) + "%");
        </script>
                  </td>
                  <td
                     class="row ${coin.quotes.USD.percent_change_7d > 0 ? 'positive-change' : 'negative-change'}">
                     <script>
            var percentChange7d = ${coin.quotes.USD.percent_change_7d};
            document.write((percentChange7d).toFixed(2) + "%");
        </script></td>
        </tr>
          </c:if>
        
      </c:forEach>
      
    </tbody>
  </table>
</div>

   
    <script>
        // 모든 FAQ 제목(h2)에 이벤트 리스너 추가
        document.querySelectorAll('.faq h2').forEach(function(header) {
            header.addEventListener('click', function() {
                const faq = this.parentElement; // 현재 클릭한 h2의 부모 요소 (FAQ 전체)
                const allFaqs = document.querySelectorAll('.faq'); // 모든 FAQ 요소 가져오기
                
                // 다른 FAQ가 열려있으면 닫기
                allFaqs.forEach(function(item) {
                    if (item !== faq) {
                        item.classList.remove('open'); // 다른 FAQ에서 open 클래스 제거
                    }
                });

                // 현재 FAQ는 열거나 닫기
                faq.classList.toggle('open');
            });
        });
    </script>

   <div class="row">
      <!-- 코인 뉴스 -->
      <div class="news-section">
         <h2>코인 뉴스</h2>
         <div class="content">
            <div class="image-container">
               <img alt="코인 뉴스 이미지" src="${root }image/coin.jpg">
            </div>
            <div class="list-container">
               <ul id="coinNewsList">
                  <c:forEach var="coinNews" items="${coinItems}">
                     <li><a href="${coinNews.link}" target="_blank">${coinNews.title}</a>
                     </li>
                  </c:forEach>
               </ul>
               <div class="pagination">
                  <button id="coinPrevBtn" disabled>이전</button>
                  <button id="coinNextBtn">다음</button>
               </div>
            </div>
         </div>
      </div>
      
      <c:import url="/WEB-INF/views/include/bottom.jsp" />
</body>
</html>
