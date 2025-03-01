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
<title>Portfolio | TMI</title>
<link rel="stylesheet" href="${root}css/portfolioInfo.css">
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
	<c:import url="/WEB-INF/views/stock/exchange.jsp" />
	<div class="primary-container">
		<div class="portfolio-container" id="portfolio-container">


			<div class="section">
				<div class="text" id="text1">투자 계획 수립</div>
			</div>

			<div class="portfolio-container">
				<!-- 안전자산, 위험자산 선택 -->
				<div id="portfolio-list" class="portfolio-list">
					<h2>자산 유형 선택</h2>
					<table class="holdings-table">
						<thead>
							<tr>
								<th>안전자산</th>
								<th>위험자산</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>국채</td>
								<td>주식</td>
							</tr>
							<tr>
								<td>금</td>
								<td>암호화폐</td>
							</tr>
							<tr>
								<td>부동산</td>
								<td>선물</td>
							</tr>
						</tbody>
					</table>
				</div>

				<!-- 투자 비율 -->
				<div id="portfolio-summary" class="portfolio-summary">
					<h2>투자 비율</h2>
					<div class="performance-metrics">
						<div class="metric-card">
							<div class="metric-value">60%</div>
							<div class="metric-label">안전자산</div>
						</div>
						<div class="metric-card">
							<div class="metric-value">40%</div>
							<div class="metric-label">위험자산</div>
						</div>
					</div>
				</div>

				<!-- 자산 입력 칸 -->
				<div id="portfolio-chart" class="portfolio-chart">
					<h2>자산 입력</h2>
					<div class="input-group">
						<input type="number" id="totalInvestment" placeholder="투자 금액 입력" />
						<button id="newStock">계산</button>
					</div>

					<!-- 계산된 자산 표시 -->
					<div class="calculated-assets" id="calculatedAssets"
						style="display: none;">
						<div class="performance-metrics">
							<div class="metric-card">
								<div class="metric-value" id="safeAssetAmount">0원</div>
								<div class="metric-label">안전자산 배분액</div>
							</div>
							<div class="metric-card">
								<div class="metric-value" id="riskAssetAmount">0원</div>
								<div class="metric-label">위험자산 배분액</div>
							</div>
						</div>
					</div>
				</div>

				<!-- 현재 가격 표시 -->
				<div id="portfolio-holdings" class="portfolio-holdings">
					<h2>현재 가격</h2>
					<div class="performance-metrics">
						<div class="metric-card">
							<h3>안전자산 가격</h3>
							<div class="metric-value" id="safeAssetPrice">0원</div>
							<input type="number" placeholder="투자 금액" class="investment-input" />
						</div>
						<div class="metric-card">
							<h3>위험자산 가격</h3>
							<div class="metric-value" id="riskAssetPrice">0원</div>
							<input type="number" placeholder="투자 금액" class="investment-input" />
						</div>
					</div>

					<!-- 제출 버튼 -->
					<button id="newStock" class="submit-button">제출</button>
				</div>
			</div>
		</div>
	</div>


	<c:import url="/WEB-INF/views/include/bottom.jsp" />


	<script>
document.addEventListener('DOMContentLoaded', function() {
    // 스크롤 애니메이션
    function checkScroll() {
        const elements = document.querySelectorAll('.portfolio-list, .portfolio-summary, .portfolio-chart, .portfolio-holdings');
        
        elements.forEach(element => {
            const elementTop = element.getBoundingClientRect().top;
            const windowHeight = window.innerHeight;
            
            if (elementTop < windowHeight * 0.75) {
                element.classList.add('visible');
            }
        });
    }

    // 초기 체크 및 스크롤 이벤트 리스너 추가
    checkScroll();
    window.addEventListener('scroll', checkScroll);

    // 계산 버튼 기능
    document.getElementById('calculateBtn').addEventListener('click', function() {
        const totalInvestment = parseFloat(document.getElementById('totalInvestment').value);
        if (!isNaN(totalInvestment)) {
            const safeAsset = totalInvestment * 0.6;
            const riskAsset = totalInvestment * 0.4;
            
            document.getElementById('safeAssetAmount').textContent = safeAsset.toLocaleString() + '원';
            document.getElementById('riskAssetAmount').textContent = riskAsset.toLocaleString() + '원';
            document.getElementById('calculatedAssets').style.display = 'block';
        }
    });
});
</script>

</body>
</html>