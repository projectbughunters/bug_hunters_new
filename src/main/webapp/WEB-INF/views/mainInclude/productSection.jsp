<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<c:set var="root" value='${pageContext.request.contextPath }/' />
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- 차트 제목 -->
<div class="product-section">
   <h2 id="chartTitle">가격 정보</h2>


   <!-- timeframe 버튼 영역 -->
   <div id="timeframeButtons" class="timeframe-buttons"></div>
   <div class="chart-select">
      <!-- Chart.js를 위한 차트 캔버스 -->
      <div class="chart-box">
         <canvas id="productChart"></canvas>
      </div>
      <!-- 상품 버튼 (클릭 시 selectCommodity 함수 호출) -->
      <div class="commodity-buttons">
         <button type="button" onclick="selectCommodity('WTI', '원유(WTI)')">원유(WTI)</button>
         <button type="button" onclick="selectCommodity('BRENT', '원유(브렌트)')">원유(브렌트)</button>
         <button type="button" onclick="selectCommodity('NATURAL_GAS', '천연가스')">천연가스</button>
         <button type="button" onclick="selectCommodity('COPPER', '구리')">구리</button>
         <button type="button" onclick="selectCommodity('ALUMINUM', '알루미늄')">알루미늄</button>
         <button type="button" onclick="selectCommodity('WHEAT', '밀')">밀</button>
         <button type="button" onclick="selectCommodity('CORN', '옥수수')">옥수수</button>
         <button type="button" onclick="selectCommodity('COTTON', '면')">면</button>
         <button type="button" onclick="selectCommodity('SUGAR', '설탕')">설탕</button>
         <button type="button" onclick="selectCommodity('COFFEE', '커피')">커피</button>
      </div>
   </div>
</div>


<script>
   const apiUrl = "http://localhost:3000/commodities";
   let myChart; // 차트 인스턴스
   let currentSymbol = '';
   let currentName = '';
   let currentTimeframe = 'monthly'; // 기본값은 monthly

   // 선택된 상품에 따라 timeframe 버튼을 동적으로 생성
   function updateTimeframeButtons() {
      const $container = $('#timeframeButtons');
      $container.empty(); // 기존 버튼 초기화

      let timeframes = [];
      // 'WTI', 'BRENT', 'NATURAL_GAS'는 일, 주, 월 단위
      if ([ 'WTI', 'BRENT', 'NATURAL_GAS' ].includes(currentSymbol)) {
         timeframes = [ {
            value : 'daily',
            label : '일'
         }, {
            value : 'weekly',
            label : '주'
         }, {
            value : 'monthly',
            label : '월'
         } ];
      } else {
         // 기타 상품은 월, 분기, 연 단위
         timeframes = [ {
            value : 'monthly',
            label : '월'
         }, {
            value : 'quarterly',
            label : '분기'
         }, {
            value : 'yearly',
            label : '년'
         } ];
      }

      // 버튼 생성
      $.each(timeframes, function(i, item) {
         const $btn = $('<button>').text(item.label);

         $btn.on('click', function() {
            currentTimeframe = item.value;
            // 모든 버튼에서 active 클래스 제거
            $container.find('button').removeClass('active-button');
            // 현재 클릭된 버튼에 active 클래스 추가
            $btn.addClass('active-button');
            // 데이터 다시 불러오기
            fetchData(currentTimeframe);
         });

         // 현재 timeframe과 동일하면 active 클래스 부여
         if (item.value === currentTimeframe) {
            $btn.addClass('active-button');
         }

         $container.append($btn);
      });
   }

   // 상품 버튼 클릭 시 호출되는 함수
   function selectCommodity(symbol, name) {
      currentSymbol = symbol;
      currentName = name;
      $('#chartTitle').text(name + " 가격 정보");
      currentTimeframe = 'monthly'; // 기본값 재설정

      updateTimeframeButtons();
      fetchData(currentTimeframe);
   }

   // API로부터 데이터를 받아와 차트를 렌더링
   function fetchData(timeframe) {
      if (!currentSymbol) {
         console.error("선택된 상품이 없습니다.");
         return;
      }

      $.ajax({
         url : apiUrl,
         type : 'GET',
         data : {
            symbol : currentSymbol,
            timeframe : timeframe
         },
         success : function(response) {
            // 서버에서 받는 응답 구조에 맞춰 조정
            // 예: { data: [ { date: '2023-01-01', value: '77.5' }, ... ] }
            const data = response.data;
            renderChart(data);
         },
         error : function(xhr, status, error) {
            console.error("API 요청 실패:", error);
         }
      });
   }

   // Chart.js를 활용하여 차트를 그리는 함수
   function renderChart(data) {
      var recentData = data.slice(0, 260);
      const labels = $.map(recentData, function(item) {
         return item.date;
      });
      const values = $.map(recentData, function(item) {
         return parseFloat(item.value);
      });
      const ctx = $('#productChart')[0].getContext('2d');

      // 기존 차트가 있으면 삭제
      if (myChart) {
         myChart.destroy();
      }

      myChart = new Chart(ctx, {
          type: 'line',
          data: {
              labels: labels,
              datasets: [{
                  label: currentName + " 가격",
                  data: values,
                  borderColor: 'rgba(75, 192, 192, 1)',
                  borderWidth: 2,
                  fill: true,
                  backgroundColor: 'rgba(75, 192, 192, 0.2)',
                  pointRadius: 0
              }]
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
                      reverse: false,  // X축 방향 정상
                      grid: {
                          display: true,
                          color: "rgba(200, 200, 200, 0.5)"
                      },
                      ticks: {
                          autoSkip: true,
                          maxTicksLimit: 10,
                          color: "black"
                      }
                  },
                  y: {
                      beginAtZero: false,
                      grid: {
                          display: true,
                          color: "rgba(200, 200, 200, 0.5)"
                      },
                      ticks: {
                          autoSkip: false,
                          maxTicksLimit: 5,
                          color: "black"
                      }
                  }
              },
              plugins: {
                  annotation: {
                      annotations: {
                          xLine: {
                              type: 'line',
                              scaleID: 'x', // X축을 기준으로 선을 그림
                              value: labels[Math.floor(labels.length / 2)], // 중앙값 기준
                              borderColor: 'rgba(75, 192, 192, 1)', // 차트와 동일한 색상
                              borderWidth: 2,
                              borderDash: [6, 6], // 점선 스타일
                              label: {
                                  content: 'X축 기준선',
                                  enabled: true,
                                  position: "top",
                                  color: 'rgba(75, 192, 192, 1)', // 라벨 색상도 동일하게 설정
                                  font: {
                                      weight: 'bold'
                                  }
                              }
                          }
                      }
                  }
              }

          }
      });

   }
</script>