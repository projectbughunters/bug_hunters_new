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
<link rel="stylesheet" href="${root}css/portfolioRatio.css">
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
		<div class="portfolio-container_top" id="portfolio-container">

			<div class="section">
				<div class="text" id="text1">투자 계획 수립</div>
			</div>

			<div class="portfolio-container">
			<div class="asset-table">
				<!-- 안전자산 테이블 -->
				<div id="safe-assets" class="portfolio-list">
				    <h2>안전자산</h2>
				    <table class="holdings-table">
				        <thead>
				            <tr>
				                <th>자산명</th>
				                <th>타입</th>
				                <th class="del-btn"/>
				            </tr>
				        </thead>
				        <tbody>
				            <c:forEach var="portfolioRatioInfo" items="${portfolioRatioInfos}">
				                <c:if test="${portfolioRatioInfo.asset_type eq '안전'}">
				                    <tr>
				                        <td>${portfolioRatioInfo.stock_name}</td>
				                        <td>
					                        <c:if test="${portfolioRatioInfo.type == 'stock'}">
					                        	주식
					                        </c:if>
					                        <c:if test="${portfolioRatioInfo.type == 'crypto'}">
					                        	암호화폐
					                        </c:if>
				                        </td>
				                      	<td>
				                      		<button>삭제</button>
				                      	</td>
				                    </tr>
				                </c:if>
				            </c:forEach>
				        </tbody>
				    </table>
				</div>
				
				<!-- 위험자산 테이블 -->
				<div id="risk-assets" class="portfolio-list">
				    <h2>위험자산</h2>
				    <table class="holdings-table">
				        <thead>
				            <tr>
				                <th>자산명</th>
				                <th>타입</th>
				                <th class="del-btn"/>
				            </tr>
				        </thead>
				        <tbody>
				            <c:forEach var="portfolioRatioInfo" items="${portfolioRatioInfos}">
				                <c:if test="${portfolioRatioInfo.asset_type eq '위험'}">
				                    <tr>
				                        <td>${portfolioRatioInfo.stock_name}</td>
				                        <td>
				                        	<c:if test="${portfolioRatioInfo.type == 'stock'}">
					                        	주식
					                        </c:if>
					                        <c:if test="${portfolioRatioInfo.type == 'crypto'}">
					                        	암호화폐
					                        </c:if>
				                        </td>
				                        <td>
				                      		<button>삭제</button>
				                      	</td>
				                    </tr>
				                </c:if>
				            </c:forEach>
				        </tbody>
				    </table>
				</div>
				</div>

				<!-- 투자 비율 -->
				<div id="portfolio-summary" class="portfolio-summary">
					<h2>투자 비율</h2>
			    <div class="performance-metrics">
			        <c:choose>
			            <c:when test="${tendency_code == '보수형'}">
			                <div>
						        <label for="safeRatioSlider">안전자산 비율: <span id="safeRatioDisplay">70</span>%</label>
						        <input type="range" id="safeRatioSlider" min="0" max="100" value="70" oninput="updateRatios()">
						    </div>
						    <!-- 위험자산 비율은 안전자산 비율의 보완 값 -->
						    <div>
						        <label>위험자산 비율: <span id="riskRatioDisplay">30</span>%</label>
						    </div>
			            </c:when>
			            <c:when test="${tendency_code == '중립형'}">
			                <div>
						        <label for="safeRatioSlider">안전자산 비율: <span id="safeRatioDisplay">50</span>%</label>
						        <input type="range" id="safeRatioSlider" min="0" max="100" value="50" oninput="updateRatios()">
						    </div>
						    <!-- 위험자산 비율은 안전자산 비율의 보완 값 -->
						    <div>
						        <label>위험자산 비율: <span id="riskRatioDisplay">50</span>%</label>
						    </div>
			            </c:when>
			            <c:when test="${tendency_code == '공격형'}">
			                <div>
						        <label for="safeRatioSlider">안전자산 비율: <span id="safeRatioDisplay">30</span>%</label>
						        <input type="range" id="safeRatioSlider" min="0" max="100" value="30" oninput="updateRatios()">
						    </div>
						    <!-- 위험자산 비율은 안전자산 비율의 보완 값 -->
						    <div>
						        <label>위험자산 비율: <span id="riskRatioDisplay">70</span>%</label>
						    </div>
			            </c:when>
		            </c:choose>
				</div>

				<!-- 자산 입력 칸 -->
				<div id="portfolio-chart" class="portfolio-chart">
					<h2>자산 입력</h2>
					<div class="input-group">
						<input type="number" id="totalInvestment" placeholder="투자 금액 입력" />
						<button id="calculateBtn">계산</button>
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

				<!-- 안전자산 테이블 -->
				<div id="portfolio-holdings-safe" class="portfolio-holdings">
				    <h2>안전자산 보유 종목 정보</h2>
				    <table class="holdings-table">
				        <thead>
				            <tr>
				                <th>주식명</th>
				                <th>타입</th>
				                <th>구매가</th>
				                <th>수량</th>
				                <th>총 구매금액</th>
				            </tr>
				        </thead>
				        <tbody>
				            <c:forEach var="portfolioRatioInfo" items="${portfolioRatioInfos}">
				                <c:if test="${portfolioRatioInfo.asset_type eq '안전'}">
				                    <tr>
				                        <td>${portfolioRatioInfo.stock_name}</td>
				                        <td>
				                            <c:choose>
				                                <c:when test="${portfolioRatioInfo.type eq 'stock'}">
				                                    주식
				                                </c:when>
				                                <c:when test="${portfolioRatioInfo.type eq 'crypto'}">
				                                    암호화폐
				                                </c:when>
				                            </c:choose>
				                        </td>
				                        <td>${portfolioRatioInfo.price}</td>
				                        <td>
				                            <input type="number" class="quantity-input"
				                                   name="quantity_${portfolioRatioInfo.portfolio_info_idx}"
				                                   value="0" min="0" />
				                        </td>
				                        <td class="total-price" data-price="${portfolioRatioInfo.price}">0원</td>
				                    </tr>
				                </c:if>
				            </c:forEach>
				        </tbody>
				    </table>
				    <!-- 안전자산 총 구매금액 합계 표시 -->
    				<div class="total-sum" id="safeTotalSum"></div>
				</div>
				<!-- 위험자산 테이블 -->
				<div id="portfolio-holdings-risk" class="portfolio-holdings">
				    <h2>위험자산 보유 종목 정보</h2>
				    <table class="holdings-table">
				        <thead>
				            <tr>
				                <th>주식명</th>
				                <th>타입</th>
				                <th>구매가</th>
				                <th>수량</th>
				                <th>총 구매금액</th>
				            </tr>
				        </thead>
				        <tbody>
				            <c:forEach var="portfolioRatioInfo" items="${portfolioRatioInfos}">
				                <c:if test="${portfolioRatioInfo.asset_type eq '위험'}">
				                    <tr>
				                        <td>${portfolioRatioInfo.stock_name}</td>
				                        <td>
				                            <c:choose>
				                                <c:when test="${portfolioRatioInfo.type eq 'stock'}">
				                                    주식
				                                </c:when>
				                                <c:when test="${portfolioRatioInfo.type eq 'crypto'}">
				                                    암호화폐
				                                </c:when>
				                            </c:choose>
				                        </td>
				                        <td>${portfolioRatioInfo.price}</td>
				                        <td>
				                            <input type="number" class="quantity-input"
				                                   name="quantity_${portfolioRatioInfo.portfolio_info_idx}"
				                                   value="0" min="0" />
				                        </td>
				                        <td class="total-price" data-price="${portfolioRatioInfo.price}">0원</td>
				                    </tr>
				                </c:if>
				            </c:forEach>
				        </tbody>
				    </table>
				    <!-- 위험자산 총 구매금액 합계 표시 -->
    				<div class="total-sum" id="riskTotalSum"></div>
				</div>
				<!-- 제출 버튼 -->
					<button id="newStock" class="submit-button">제출</button>
				
			</div>
		</div>
	</div>
</div>

	<c:import url="/WEB-INF/views/include/bottom.jsp" />


	<script>
    function updateRatios() {
        var safeSlider = document.getElementById("safeRatioSlider");
        var safeValue = parseInt(safeSlider.value);
        var riskValue = 100 - safeValue;
        document.getElementById("safeRatioDisplay").innerText = safeValue;
        document.getElementById("riskRatioDisplay").innerText = riskValue;
    }
    
 // 테이블의 모든 행에서 '총 구매금액'을 합산하여 지정한 div에 업데이트하는 함수
    function updateTotalSum(tableSelector, sumDivId) {
        const rows = document.querySelectorAll(tableSelector + " tbody tr");
        let sum = 0;
        rows.forEach(row => {
            let totalText = row.querySelector('.total-price').textContent;
            // 숫자와 소수점만 남기고 파싱 (예: "1,200원" -> "1200")
            totalText = totalText.replace(/[^0-9.]/g, '');
            let totalVal = parseFloat(totalText) || 0;
            sum += totalVal;
        });
        document.getElementById(sumDivId).textContent = "총 구매금액 합계: " + sum.toLocaleString() + "원";
    }

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
        // 1) 전체 투자 금액
        const totalInvestment = parseFloat(document.getElementById('totalInvestment').value);
        if (!isNaN(totalInvestment)) {
            // 2) 안전/위험 자산 비율 계산
            var safeSlider = document.getElementById("safeRatioSlider");
            var safeValue = parseInt(safeSlider.value);
            var riskValue = 100 - safeValue;

            // 3) 안전자산, 위험자산 배분액
            const safeAsset = totalInvestment * (safeValue / 100);
            const riskAsset = totalInvestment * (riskValue / 100);

            // 4) 화면에 표시
            document.getElementById('safeAssetAmount').textContent = 
                safeAsset.toLocaleString() + '원';
            document.getElementById('riskAssetAmount').textContent = 
                riskAsset.toLocaleString() + '원';
            document.getElementById('calculatedAssets').style.display = 'block';

            // ----------------------------------------------------
            // [추가 로직1] 안전자산 테이블 배분
            // ----------------------------------------------------
            // (a) "안전자산 배분액"에서 숫자만 추출
            let safeAssetText = document.getElementById('safeAssetAmount')
                                    .textContent.replace('원','').replaceAll(',','');
            let safeAssetValue = parseFloat(safeAssetText) || 0;
            
            // (b) 안전자산 테이블의 모든 행(tr) 수집
            let safeRows = document.querySelectorAll('#portfolio-holdings-safe tbody tr');
            let rowCountSafe = safeRows.length;
            
            if (rowCountSafe > 0 && safeAssetValue > 0) {
                // (c) 종목별 균등 분배금
                let allocatedPerSafeRow = safeAssetValue / rowCountSafe;
                
                safeRows.forEach(row => {
                    let priceAttr = row.querySelector('.total-price').getAttribute('data-price');
                    let price = parseFloat(priceAttr) || 0;
                    
                    let quantity = 0;
                    if (price > 0) {
                        // (d) 수량 = 분배금 / 구매가 의 정수 몫
                        quantity = Math.floor(allocatedPerSafeRow / price);
                    }
                    
                    // 수량 업데이트
                    let quantityInput = row.querySelector('.quantity-input');
                    quantityInput.value = quantity;
                    
                    // 총 구매금액 계산
                    let totalPrice = price * quantity;
                    row.querySelector('.total-price').textContent = 
                        totalPrice.toLocaleString() + '원';
                });
            }
         	// 안전자산 테이블 총합 업데이트
            updateTotalSum('#portfolio-holdings-safe', 'safeTotalSum');

            // ----------------------------------------------------
            // [추가 로직2] 위험자산 테이블 배분
            // ----------------------------------------------------
            // (a) "위험자산 배분액"에서 숫자만 추출
            let riskAssetText = document.getElementById('riskAssetAmount')
                                    .textContent.replace('원','').replaceAll(',','');
            let riskAssetValue = parseFloat(riskAssetText) || 0;

            // (b) 위험자산 테이블의 모든 행(tr) 수집
            let riskRows = document.querySelectorAll('#portfolio-holdings-risk tbody tr');
            let rowCountRisk = riskRows.length;

            if (rowCountRisk > 0 && riskAssetValue > 0) {
                // (c) 종목별 균등 분배금
                let allocatedPerRiskRow = riskAssetValue / rowCountRisk;

                riskRows.forEach(row => {
                    let priceAttr = row.querySelector('.total-price').getAttribute('data-price');
                    let price = parseFloat(priceAttr) || 0;
                    
                    let quantity = 0;
                    if (price > 0) {
                        // (d) 수량 = 분배금 / 구매가 의 정수 몫
                        quantity = Math.floor(allocatedPerRiskRow / price);
                    }

                    // 수량 업데이트
                    let quantityInput = row.querySelector('.quantity-input');
                    quantityInput.value = quantity;
                    
                    // 총 구매금액 계산
                    let totalPrice = price * quantity;
                    row.querySelector('.total-price').textContent = 
                        totalPrice.toLocaleString() + '원';
                });
            }
         	// 위험자산 테이블 총합 업데이트
            updateTotalSum('#portfolio-holdings-risk', 'riskTotalSum');
        }
    }); // calculateBtn click end

    // 수량 입력시 (구매가 * 수량) 자동계산
    const quantityInputs = document.querySelectorAll('.quantity-input');
    quantityInputs.forEach(input => {
        input.addEventListener('input', function() {
            const tr = input.closest('tr');
            const priceAttr = tr.querySelector('.total-price').getAttribute('data-price');
            const price = parseFloat(priceAttr) || 0; 
            const quantity = parseFloat(input.value) || 0;
            const total = price * quantity;
            tr.querySelector('.total-price').textContent = total.toLocaleString() + '원';
         	// 안전자산 테이블 총합 업데이트
            updateTotalSum('#portfolio-holdings-safe', 'safeTotalSum');
         	// 위험자산 테이블 총합 업데이트
            updateTotalSum('#portfolio-holdings-risk', 'riskTotalSum');
        });
    });
});
</script>

</body>
</html>