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
				<div class="text" id="text1">
				<image src="${root}image/TMI_YB.png"
				style="width: 70px; height : 50px" />
				투자 도우미</div>
			</div>

			<button id="newStock" onclick="location.href='${root}portfolio/newStock/${portfolio_idx }'">매수종목 추가</button>
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
				                <th>구매가</th>
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
				                        <td>$ ${portfolioRatioInfo.price }</td>
				                      	<td>
				                      		<a href="#" id="btn-del" onclick="return confirmDelete(${portfolioRatioInfo.portfolio_idx}, ${portfolioRatioInfo.portfolio_info_idx })">삭제</a>
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
				                <th>구매가</th>
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
				                        <td>$ ${portfolioRatioInfo.price }</td>
				                        <td>
				                      		<a href="#" id="btn-del" onclick="return confirmDelete(${portfolioRatioInfo.portfolio_idx}, ${portfolioRatioInfo.portfolio_info_idx })">삭제</a>
				                      	</td>
				                    </tr>
				                </c:if>
				            </c:forEach>
				        </tbody>
				    </table>
				</div>
				</div>
				<div class="portfolio-tendency-slider">
					<!-- 투자 비율 -->
					<div id="portfolio-summary" class="portfolio-summary">
						<h2>투자 비율</h2>
						<div>
							<h4>당신의 투자 성향은 "${profileBean.personal_tendency_code}"입니다.</h4>
						</div>
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
				</div>
				<h5 style="color:darkgrey;">⚠️투자성향의 비율은 추천비율이므로, 변경하여 사용하셔도 됩니다⚠️</h5>
				</div>
				<div class="portfolio-money-input">
					<!-- 자산 입력 칸 -->
					<div id="portfolio-chart" class="portfolio-chart">
						<h2>자산 입력($)</h2>
						<div class="input-group">
							<input type="number" id="totalInvestment" placeholder="투자 금액 입력" value="${portfolioBean.deposit }" />
							<button id="calculateBtn">계산</button>
						</div>
					

						<!-- 계산된 자산 표시 -->
						<div class="calculated-assets" id="calculatedAssets"
							style="display: none;">
							<div class="performance-metrics2">
								<div class="metric-card">
									<div class="metric-label">안전자산 배분액</div>
									<div class="metric-value" id="safeAssetAmount">0</div>
								</div>
								<div class="metric-card">
									<div class="metric-label">위험자산 배분액</div>
									<div class="metric-value" id="riskAssetAmount">0</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				
				<div class="portfolio-table-modify">
					<form id="portfolioForm" action="${root}portfolio/newStockRatio_pro" method="post">
					<input type="hidden" name="portfolio_idx" 
	                                       value="${portfolio_idx}" />
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
					                        <td id="add-assets-name">${portfolioRatioInfo.stock_name}
					                        	<!-- 주식명을 Controller로 전송하기 위한 hidden 필드 -->
				                                <input type="hidden" name="symbol_${portfolioRatioInfo.portfolio_info_idx}" 
				                                       value="${portfolioRatioInfo.symbol}" />
					                        </td>
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
					                                   value="${portfolioRatioInfo.amount}" min="0" step="any"/>
					                        </td>
					                        <td class="total-price" data-price="${portfolioRatioInfo.price}">0</td>
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
					                        <td id="add-assets-name">${portfolioRatioInfo.stock_name}
					                        	<!-- 주식명을 Controller로 전송하기 위한 hidden 필드 -->
				                                <input type="hidden" name="symbol_${portfolioRatioInfo.portfolio_info_idx}" 
				                                       value="${portfolioRatioInfo.symbol}" />
					                        </td>
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
					                                   value="${portfolioRatioInfo.amount}" min="0" step="any"/>
					                        </td>
					                        <td class="total-price" data-price="${portfolioRatioInfo.price}">0</td>
					                    </tr>
					                </c:if>
					            </c:forEach>
					        </tbody>
					    </table>
					    <!-- 위험자산 총 구매금액 합계 표시 -->
	    				<div class="total-sum" id="riskTotalSum"></div>
					</div>
					<!-- 전체 구매금액 합계 표시 -->
					<div class="total-sum" id="grandTotalSum"></div>
					<div id="submit-btn">
						<!-- 제출 버튼 (폼 전송) -->
					    <button type="submit" id="newStock" class="submit-button">제출</button>
			    	</div>
			</form>
			</div>
				
			</div>
		</div>
	</div>


	<c:import url="/WEB-INF/views/include/bottom.jsp" />


	<script>
	function confirmDelete(portfolio_idx, portfolio_info_idx) {
        var confirmation = confirm("정말 삭제하시겠습니까?");
        if (confirmation) {
            window.location.href = '${root}portfolio/ratioDelete/' + portfolio_idx + "/" + portfolio_info_idx;
        }
        return false; // 링크의 기본 동작을 막는다 (페이지 이동을 방지)
    }
	
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
        document.getElementById(sumDivId).textContent = "총 구매금액 합계:$ " + sum.toLocaleString();
    }

 // safeTotalSum와 riskTotalSum의 합계를 계산하여 grandTotalSum에 업데이트하는 함수
	function updateGrandTotal() {
	    var safeText = document.getElementById('safeTotalSum').textContent.replace(/[^0-9.]/g, '');
	    var riskText = document.getElementById('riskTotalSum').textContent.replace(/[^0-9.]/g, '');
	    var safeVal = parseFloat(safeText) || 0;
	    var riskVal = parseFloat(riskText) || 0;
	    var grandTotal = safeVal + riskVal;
	    document.getElementById('grandTotalSum').textContent = "전체 총합: $ " + grandTotal.toLocaleString();
	    
	 // 투자 금액을 가져오기
	    const totalInvestment = parseFloat(document.getElementById('totalInvestment').value) || 0;
	    
	    // 경고 메시지 div가 이미 있는지 확인 (없으면 생성)
	    let warningDiv = document.getElementById('warningMessage');
	    if (grandTotal > totalInvestment) {
	        if (!warningDiv) {
	            warningDiv = document.createElement('div');
	            warningDiv.id = 'warningMessage';
	            warningDiv.style.color = 'red';
	            warningDiv.textContent = "🚨 총 구매금액이 총자산보다 많습니다 🚨";
	            // grandTotalSum 요소의 부모 노드에 추가 (원하는 위치에 맞게 조정 가능)
	            document.getElementById('grandTotalSum').parentNode.appendChild(warningDiv);
	        } else {
	        	warningDiv.style.display = 'block';
	        }
	    } else {
	        if (warningDiv) {
	            warningDiv.style.display = 'none';
	        }
	    }
	}
 

document.addEventListener('DOMContentLoaded', function() {
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
           '$ ' + safeAsset.toLocaleString();
        document.getElementById('riskAssetAmount').textContent = 
           '$ ' + riskAsset.toLocaleString();
        document.getElementById('calculatedAssets').style.display = 'block';

        // ----------------------------------------------------
        // [추가 로직1] 안전자산 테이블 배분
        // ----------------------------------------------------
        // (a) "안전자산 배분액"에서 숫자만 추출
        let safeAssetText = document.getElementById('safeAssetAmount')
                                .textContent.replace(/[^0-9.]/g, '');
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
                	'$ ' + totalPrice.toLocaleString();
            });
        }
     	// 안전자산 테이블 총합 업데이트
        updateTotalSum('#portfolio-holdings-safe', 'safeTotalSum');

        // ----------------------------------------------------
        // [추가 로직2] 위험자산 테이블 배분
        // ----------------------------------------------------
        // (a) "위험자산 배분액"에서 숫자만 추출
        let riskAssetText = document.getElementById('riskAssetAmount')
                                .textContent.replace(/[^0-9.]/g, '');
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
                	'$ ' + totalPrice.toLocaleString();
            });
        }
     	// 위험자산 테이블 총합 업데이트
        updateTotalSum('#portfolio-holdings-risk', 'riskTotalSum');
        updateGrandTotal();
    }

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
               '$ ' + safeAsset.toLocaleString();
            document.getElementById('riskAssetAmount').textContent = 
               '$ ' + riskAsset.toLocaleString();
            document.getElementById('calculatedAssets').style.display = 'block';

            // ----------------------------------------------------
            // [추가 로직1] 안전자산 테이블 배분
            // ----------------------------------------------------
            // (a) "안전자산 배분액"에서 숫자만 추출
            let safeAssetText = document.getElementById('safeAssetAmount')
                                    .textContent.replace(/[^0-9.]/g, '');
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
                    	'$ ' + totalPrice.toLocaleString();
                });
            }
         	// 안전자산 테이블 총합 업데이트
            updateTotalSum('#portfolio-holdings-safe', 'safeTotalSum');

            // ----------------------------------------------------
            // [추가 로직2] 위험자산 테이블 배분
            // ----------------------------------------------------
            // (a) "위험자산 배분액"에서 숫자만 추출
            let riskAssetText = document.getElementById('riskAssetAmount')
                                    .textContent.replace(/[^0-9.]/g, '');
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
                    	'$ ' + totalPrice.toLocaleString();
                });
            }
         	// 위험자산 테이블 총합 업데이트
            updateTotalSum('#portfolio-holdings-risk', 'riskTotalSum');
            updateGrandTotal();
        }
    }); // calculateBtn click end
  //수량 입력시 (구매가 * 수량) 자동계산
    const quantityInputs = document.querySelectorAll('.quantity-input');
    quantityInputs.forEach(input => {
        input.addEventListener('input', function() {
            const tr = input.closest('tr');
            const priceAttr = tr.querySelector('.total-price').getAttribute('data-price');
            const price = parseFloat(priceAttr) || 0; 
            const quantity = parseFloat(input.value) || 0;
            const total = price * quantity;
            tr.querySelector('.total-price').textContent = '$ ' + total.toLocaleString();
         	// 안전자산 테이블 총합 업데이트
            updateTotalSum('#portfolio-holdings-safe', 'safeTotalSum');
         	// 위험자산 테이블 총합 업데이트
            updateTotalSum('#portfolio-holdings-risk', 'riskTotalSum');
         	//전체 자산 총합 업데이트
         	updateGrandTotal();
        });
    });
});
</script>

</body>
</html>