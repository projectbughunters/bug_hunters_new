<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<c:set var="root" value='${pageContext.request.contextPath }/' />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="icon" href="${root}image/TMI_YB.png" type="image/png">
<title>Portfolio | TMI</title>
<link rel="stylesheet" href="${root}css/portfolioInfo.css">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>


<style type="text/css">
body {
	height: 100vh;
}



.footer {
	margin-top: 70px;
}
</style>
</head>
<body>

	<c:import url="/WEB-INF/views/include/topMenu.jsp" />
	<c:import url="/WEB-INF/views/stock/exchange.jsp"/>
	<div class="primary-container">
	<div class="portfolio-container" id="portfolio-container">
	<div id="helping-btn">
	<button id="newStock" onclick="location.href='${root}portfolio/newStockRatio/${portfolio_idx }'">포트폴리오 도우미</button>
	</div>
	<div class="portfolio-summary" id="portfolio-summary"
			style="opacity: 1;">
			<div class="yours-title">
			<h2>당신의 포트폴리오</h2>
			<button id="convertButton" style="display:inline-block;" onclick="convertCurrency()">원화 변환</button>
			</div>
			<div class="performance-metrics">
				<div class="metric-card">
					<div class="metric-value">$
					    <script>
					        var marketCap = '${portfolioBean.deposit}';
					        document.write(marketCap.replace(/\B(?=(\d{3})+(?!\d))/g, ","));
					    </script>
					</div>
					<div class="metric-label">총 자산</div>
				</div>
				<div class="metric-card">
					<div class="metric-value">계산중..</div>
					<div class="metric-label">전체 수익률</div>
				</div>
				<div class="metric-card">
					<div class="metric-value">계산중..</div>
					<div class="metric-label">총 수익금</div>
				</div>
			</div>

			
		</div>

		<div class="portfolio-chart" id="portfolio-chart" style="opacity: 1; display: flex; justify-content: space-around; align-items: center;">
			<!-- <h2>포트폴리오 차트</h2> -->
			<div style="width: 45%; height: 300px;">
		        <canvas id="portfolioBarChart"></canvas>
		    </div>
		    <div style="width: 45%; height: 300px;">
		        <canvas id="portfolioDonutChart"></canvas>
		    </div>
			
		</div>

		<div class="portfolio-holdings" id="portfolio-holdings"
			style="opacity: 1;">
			<h2>보유 자산 현황</h2>
			<table class="holdings-table">
				<thead>
					<tr>
						<th>자산명</th>
						<th>심볼</th>
						<th>타입</th>
						<th>보유수량</th>
						<th>구매가</th>
						<th>매수금액</th>
						<th>평가금액</th>
						<th>수익률</th>
						<th>삭제</th>
					</tr>
				</thead>
				<tbody>
				<c:forEach var="portfolioInfoBean" items="${portfolioInfoBeans}" varStatus="status">
		                <tr >
		                	<td>${portfolioInfoBean.stock_name}</td>
		                	<td>${portfolioInfoBean.symbol}</td>
		                	<td>${portfolioInfoBean.type}</td>
		                    <td>
					            ${portfolioInfoBean.amount}
					        </td>
					        <td>$
					            ${portfolioInfoBean.price}
					        </td>
		                    <td class="align-right">$
							    <script>
								    var totalPrice = (${portfolioInfoBean.amount} * ${portfolioInfoBean.price}).toFixed(2);
								    document.write(totalPrice.replace(/\B(?=(\d{3})+(?!\d))/g, ","));
								</script>
							</td>
							<td>로딩 중..</td>
		                    <td class="profit-rate">로딩 중...</td>
		                    <td>
		                    	<a href="#" onclick="return confirmDelete(${portfolioInfoBean.portfolio_idx}, ${portfolioInfoBean.portfolio_info_idx })">삭제</a>
		                    </td>
		                </tr>
	            	</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
	</div>

	<c:import url="/WEB-INF/views/include/bottom.jsp" />
	
	<script>
    function confirmDelete(portfolio_idx, portfolio_info_idx) {
        var confirmation = confirm("정말 삭제하시겠습니까?");
        if (confirmation) {
            window.location.href = '${root}portfolio/delete/' + portfolio_idx + "/" + portfolio_info_idx;
        }
        return false; // 링크의 기본 동작을 막는다 (페이지 이동을 방지)
    }
    
		document.addEventListener("DOMContentLoaded", async function () {
			
			
	    const donutCtx = document.getElementById('portfolioDonutChart').getContext('2d');
	    const barCtx = document.getElementById('portfolioBarChart').getContext('2d');

	    let dataLabels = [];
	    let dataValues = [];
	    let backgroundColors = [
    	  'rgba(13, 59, 102, 0.6)',  // #0D3B66 + 투명도 0.2
    	  'rgba(20, 83, 116, 0.6)', // #145374 + 0.35
    	  'rgba(30, 129, 176, 0.6)', // #1E81B0 + 0.5
    	  'rgba(113, 169, 247, 0.6)', // #71A9F7 + 0.65
    	  'rgba(165, 216, 255, 0.6)'   // #A5D8FF + 0.8
    	];

    	// Hover 시 약간 더 진하게 (또는 채도를 높여서 더 선명하게)
    	let hoverBackgroundColors = [
    	  '#0C355C',
    	  '#114765',
    	  '#1A6C93',
    	  '#5F8FDC',
    	  '#91C6E5'
    	];

	    const rows = document.querySelectorAll('.holdings-table tbody tr');
	    console.log("찾은 행들:", rows);
	    for (const row of rows) {
	        const symbol = row.cells[0].innerText.trim();
	        const totalPrice = parseFloat(row.cells[5].innerText.replace(/[^\d.-]/g, '')); 

	        if (!isNaN(totalPrice)) {
	            dataLabels.push(symbol);
	            dataValues.push(totalPrice);
	        }
	    }

	    if (dataLabels.length === 0 || dataValues.length === 0) {
	        console.error("차트 데이터를 찾을 수 없음");
	        return;
	    }

	    new Chart(donutCtx, {
	        type: 'doughnut',
	        data: {
	            labels: dataLabels,
	            datasets: [{
	                data: dataValues,
	                backgroundColor: backgroundColors.slice(0, dataLabels.length),
	                hoverBackgroundColor: hoverBackgroundColors.slice(0, dataLabels.length)
	            }]
	        },
	        options: {
	            responsive: true,
	            maintainAspectRatio: false,
	            plugins: {
	                legend: { position: 'bottom' }
	            }
	        }
	    });

	    new Chart(barCtx, {
	        type: 'bar',
	        data: {
	            labels: dataLabels,
	            datasets: [{
	                data: dataValues,
	                backgroundColor: backgroundColors.slice(0, dataLabels.length),
	                hoverBackgroundColor: hoverBackgroundColors.slice(0, dataLabels.length),
	                borderWidth: 1
	            }]
	        },
	        options: {
	            responsive: true,
	            maintainAspectRatio: false,
	            plugins: {
	                legend: { display: false }
	            },
	            scales: {
	                y: { beginAtZero: true },
	                x: { title: { display: true } }
	            }
	        }
	    });
	    console.log(`찾은 행 개수: ${rows.length}`);
	    
	    await updateProfitRates();
	    
	   
	});
    

		async function updateProfitRates() {
		    console.log("updateProfitRates 시작됨");

		    const rows = document.querySelectorAll('.holdings-table tbody tr');
		    var profitRateElement = document.querySelector('.performance-metrics .metric-card:nth-child(2) .metric-value');
		    var totalProceedElement = document.querySelector('.performance-metrics .metric-card:nth-child(3) .metric-value');
		    var eval = 0.00;
		    var pur = 0.00;
		    console.log("찾은 행들:", rows);

		    for (const row of rows) {
		        const symbol = row.cells[1]?.innerText.trim();
		        const type = row.cells[2]?.innerText.trim();
		        const amount = parseFloat(row.cells[3]?.innerText.replace(',', '') || '0');
		        const purchasePrice = parseFloat(row.cells[4]?.innerText.replace(/[^\d.-]/g, ''));

		        console.log(`처리 중: ${symbol}, 보유량: ${amount}, 구매가: ${purchasePrice}`);
		        console.log(`구매가: `, purchasePrice);
		        
		        if (!row) {
		           
		            continue;
		        }

		        try {
		        	if(type.toLowerCase() === "stock") {
		        		const stockData = await stockOverview(symbol);
			            console.log(`받은 데이터:`, stockData.marketPrice);

			            if (stockData && stockData.marketPrice) {
			                const currentPrice = parseFloat(stockData.marketPrice); //현재가 
			                const evaluation = parseFloat((currentPrice * amount).toFixed(2));  //평가금액
			                const purchase = parseFloat((purchasePrice * amount).toFixed(2));   //매수금액
			                const totalProfitRate = Number(((evaluation - purchase) / purchase * 100).toFixed(2)); //전체 수익률
			                const profitRate = Number(((currentPrice - purchasePrice) / purchasePrice * 100).toFixed(2));  //수익률


			                console.log(`계산된 현재가: `, currentPrice);
			                console.log(`계산된 평가금액: `, evaluation);
			                console.log(`계산된 구매평가금액: `, purchase);
			                console.log(`계산된 수익률: `, profitRate);
			                console.log(typeof profitRate, profitRate);
			                
			                eval = eval + evaluation;
			                pur = pur + purchase;

							row.cells[6].innerHTML = '<span>$ '+evaluation+'</span>';
			                row.cells[7].innerHTML = '<span style="color: ' + (profitRate > 0 ? '#2ecc71' : '#e74c3c') + ';">' +
			                    (profitRate > 0 ? '+' : '') + profitRate + '%' +
			                    '</span>';
	                            
			                console.log("적용된 innerHTML: ", row.cells[7].innerHTML);
			            }	        		
		        	}
		        	if(type.toLowerCase() === "crypto") {
		        		const coinData = await getCoinInfo(symbol);
			            console.log(`받은 데이터:`, coinData.price);

			            if (coinData && coinData.price) {
			                const currentPrice = parseFloat(coinData.price); //현재가 
			                const evaluation = parseFloat((currentPrice * amount).toFixed(2));  //평가금액
			                const purchase = parseFloat((purchasePrice * amount).toFixed(2));   //매수금액
			                const totalProfitRate = Number(((evaluation - purchase) / purchase * 100).toFixed(2)); //전체 수익률
			                const profitRate = Number(((currentPrice - purchasePrice) / purchasePrice * 100).toFixed(2));  //수익률


			                console.log(`계산된 현재가: `, currentPrice);
			                console.log(`계산된 평가금액: `, evaluation);
			                console.log(`계산된 구매평가금액: `, purchase);
			                console.log(`계산된 수익률: `, profitRate);
			                console.log(typeof profitRate, profitRate);
			                
			                eval = eval + evaluation;
			                pur = pur + purchase;

							row.cells[6].innerHTML = '<span>$ '+evaluation+'</span>';
			                row.cells[7].innerHTML = '<span style="color: ' + (profitRate > 0 ? '#2ecc71' : '#e74c3c') + ';">' +
			                    (profitRate > 0 ? '+' : '') + profitRate + '%' +
			                    '</span>';
	                            
			                console.log("적용된 innerHTML: ", row.cells[7].innerHTML);
			            }	     
		        		
		        	}
		            
		        } catch (error) {
		            console.error(`오류 발생 (${symbol}):`, error);
		        }
		    }
		    
		    const marketCap = ${portfolioBean.deposit};
		    const totalProfitRate = Number(((eval - pur) / pur * 100).toFixed(2));
		    const totalProceed = parseFloat(((marketCap * totalProfitRate)/100).toFixed(2));
		    
		    profitRateElement.innerHTML = '<span style="color: ' + (totalProfitRate > 0 ? '#2ecc71' : '#e74c3c') + ';">' +
            (totalProfitRate > 0 ? '+' : '') + totalProfitRate + '%' +
            '</span>';
            
            totalProceedElement.innerHTML = '<span style="color: ' + (totalProceed > 0 ? '#2ecc71' : '#e74c3c') + ';">' +
            (totalProceed > 0 ? '+' : '') + "$ "+ totalProceed + 
            '</span>';
            
		    console.log("updateProfitRates 완료됨");
	        
	        
		}
		
		// 전역 변수로 현재 표시 상태를 저장 (false: USD, true: KRW)
		var conversionToggle = false;

		function convertCurrency() {
		    var $assetElem = $(".performance-metrics .metric-card").eq(0).find(".metric-value");
		    var $profitElem = $(".performance-metrics .metric-card").eq(2).find(".metric-value");

		    if (!conversionToggle) {
		        // USD → KRW 변환
		        var assetText = $assetElem.text();
		        var profitText = $profitElem.text();

		        var assetValue = parseFloat(assetText.replace(/[^0-9.-]/g, ''));
		        var profitValue = parseFloat(profitText.replace(/[^0-9.-]/g, ''));

		        if (isNaN(assetValue)) {
		            alert("총 자산 값이 올바르지 않습니다.");
		            return;
		        }
		        if (isNaN(profitValue)) {
		            alert("총 수익금 값이 올바르지 않습니다.");
		            return;
		        }

		        // 원래의 USD 값을 data 속성에 저장
		        $assetElem.data("usd", assetValue);
		        $profitElem.data("usd", profitValue);

		        $.when(
		            $.ajax({
		                url: 'http://localhost:3000/currency',
		                method: 'POST',
		                contentType: 'application/json',
		                data: JSON.stringify({
		                    amount: assetValue.toFixed(2),
		                    fromCurrency: 'USD',
		                    toCurrency: 'KRW'
		                }),
		                dataType: 'json'
		            }),
		            $.ajax({
		                url: 'http://localhost:3000/currency',
		                method: 'POST',
		                contentType: 'application/json',
		                data: JSON.stringify({
		                    amount: profitValue.toFixed(2),
		                    fromCurrency: 'USD',
		                    toCurrency: 'KRW'
		                }),
		                dataType: 'json'
		            })
		        ).done(function(assetData, profitData) {
		            if (assetData[0].convertedAmount && profitData[0].convertedAmount) {
		                var convertedAsset = parseFloat(assetData[0].convertedAmount).toFixed(2);
		                var convertedProfit = parseFloat(profitData[0].convertedAmount).toFixed(2);

		                $assetElem.text("₩ " + Number(convertedAsset).toLocaleString());
		                // 수정: 수익금 표시 형식을 아래와 같이 변경
		                $profitElem.html(
		                    '<span style="color: ' + (convertedProfit > 0 ? '#2ecc71' : '#e74c3c') + ';">' +
		                    (convertedProfit > 0 ? '+' : '') + "₩ " + Number(convertedProfit).toLocaleString() +
		                    '</span>'
		                );

		                conversionToggle = true;
		                $("#convertButton").text("달러 변환");
		            } else {
		                alert("환산에 실패했습니다.");
		            }
		        }).fail(function() {
		            alert("환산 중 서버 오류가 발생했습니다.");
		        });
		    } else {
		    	// KRW → USD 변환 (AJAX 없이 data 속성에 저장된 원래의 USD 값을 사용)
		        var assetUSD = $assetElem.data("usd");
		        var profitUSD = $profitElem.data("usd");

		        if (assetUSD === undefined) {
		            alert("원래의 자산 값이 저장되어 있지 않습니다.");
		            return;
		        }
		        if (profitUSD === undefined) {
		            alert("원래의 수익금 값이 저장되어 있지 않습니다.");
		            return;
		        }

		        $assetElem.text("$ " + Number(assetUSD).toLocaleString());
		        $profitElem.html(
		            '<span style="color: ' + (profitUSD > 0 ? '#2ecc71' : '#e74c3c') + ';">' +
		            (profitUSD > 0 ? '+' : '') + "$ " + Number(profitUSD).toLocaleString() +
		            '</span>'
		        );

		        conversionToggle = false;
		        $("#convertButton").text("원화 변환");
		    }
		}

		async function stockOverview(symbol) {
		    try {
		        const response = await axios.post('http://localhost:3000/stock-overview', { symbol });
		        console.log(`Received response for ${symbol}:`, response.data);
		        return response.data;
		    } catch (error) {
		        console.error(`Error fetching stock data for ${symbol}:`, error);
		        return null;
		    }
		}
		
		async function getCoinInfo(symbol) {
			  try {
			    const url = "http://localhost:3000/getCoinInfo?symbol=" + symbol;
			    const response = await axios.get(url);
			    return response.data;
			  } catch (error) {
			    console.error("Error fetching coin info for " + symbol + ":", error);
			    return null;
			  }
			}

</script>

</body>
</html>