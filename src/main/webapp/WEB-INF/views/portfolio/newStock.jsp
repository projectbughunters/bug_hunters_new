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
<title>Take Money Information | TMI</title>
</head>
<body>

	<c:import url="/WEB-INF/views/include/topMenu.jsp" />
	<h4>거래 추가</h4>
    <form action="${root}portfolio/search" method="post">
    	<input type="hidden" name="portfolio_idx" value="${portfolio_idx }">
        <input type="text" name="company_name" class="form-control" placeholder="검색어를 입력하세요" required>
        <button type="submit" class="btn btn-primary btn-block mt-2">검색</button>
    </form>
    <hr>
    <ul id="searchResults">
    <c:choose>
    <c:when test="${empty searchResults}">
        <li>${message}</li>
    </c:when>
    <c:otherwise>
        <c:forEach var="result" items="${searchResults}">
            <li onclick="location.href='${root}portfolio/stockInfo/${result.symbol}/${result.company_name}/${result.type}/${portfolio_idx}'">
                ${result.company_name}
            </li>
        </c:forEach>
    </c:otherwise>
</c:choose>
</ul>
    <p></p>
    <hr />
    <form:form action="${root }portfolio/newStock_pro" method="post" modelAttribute="newPortfolioInfoBean">
    	<form:hidden path="portfolio_idx" id="portfolio_idx" />
    	<form:hidden path="symbol" id="symbol" />
    	<form:label path="type">타입</form:label>
	    <form:input path="type" id="type" readonly="true"/><br />
    	<form:label path="stock_name">종목</form:label>
	    <form:input path="stock_name" id="stock_name" readonly="true"/><br />
	    <form:label path="price">구매 가격</form:label>
	    <form:input path="price" id="price" /><br />
	    <form:label path="amount">수량</form:label>
	    <form:input path="amount" id="amount" placeholder="0.0" />
	    <p></p>
	    <button type="submit">추가하기</button>
	</form:form>
	
	
	
	<c:import url="/WEB-INF/views/include/bottom.jsp" />
	
	<script type="text/javascript">
	function getStockOverview(symbol, portfolio_idx) {

	    const requestPayload = { symbol: symbol };
	    document.getElementById("searchResults").innerHTML = '';

	    fetch('http://localhost:3000/stock-overview', {
	        method: 'POST',
	        headers: { 'Content-Type': 'application/json' },
	        body: JSON.stringify(requestPayload)
	    })
	    .then(response => response.json())
	    .then(processedData => {
	        console.log(processedData);

	        const marketPriceInput = document.getElementById("price");
	        const stockNameInput = document.getElementById("stock_name");
	        const portfolioIdxInput = document.getElementById("portfolio_idx");
	        if (processedData && processedData.marketPrice) {
	            marketPriceInput.value = processedData.marketPrice;
	            stockNameInput.value = processedData.name;
	            portfolioIdxInput.value = portfolio_idx;
	            
	            // 검색 결과를 sessionStorage에 저장 (새로고침해도 유지)
	            sessionStorage.setItem("selectedStock", JSON.stringify(processedData));
	        } else {
	            marketPriceInput.value = "N/A";
	        }
	    })
	    .catch(error => {
	        console.error('Error fetching data:', error);
	    });
	}
</script>

</body>
</html>