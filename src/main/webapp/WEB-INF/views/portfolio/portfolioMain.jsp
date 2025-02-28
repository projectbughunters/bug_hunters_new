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
<link rel="stylesheet" href="${root}css/portfolio.css">

<style type="text/css">
body {
	height: 100vh;
}
#portfolio-list, #portfolio-summary, #portfolio-chart, #portfolio-holdings{
	margin: 60px auto;
}

.portfolio-list, .portfolio-summary, .portfolio-chart,
	.portfolio-holdings {
	background-color: f8f8f8;
}

.footer {
	margin-top: 70px;
}
</style>
</head>
<body>

	<c:import url="/WEB-INF/views/include/topMenu.jsp" />
	
	<div class="primary-container">

	<div class="portfolio-container" id="portfolio-container">

		<button id="newPortfolio" onclick="location.href='${root}portfolio/newPortfolio'">새 포트폴리오
			생성</button>


		<div id="portfolio-list" class="portfolio-list" style="opacity: 1; margin-top: 0px;">
		    <h3 class="list-title">내 포트폴리오 리스트</h3>
		    <table class="holdings-table">
		        <thead>
		            <tr>
		                <th>번호</th>
		                <th>포트폴리오 이름</th>
		                <th>보유 자산</th>
		                <th>수익률</th>
		                <th>만든 날짜</th>
		                <th>삭제</th>		                
		            </tr>
		        </thead>
		        <tbody> 
			        <c:forEach var="portfolio" items="${portfolios}" varStatus="status">
		                <tr >
		                	<td>${status.count}</td>
		                    <td class="clickable" onclick="location.href='${root}portfolio/info/${portfolio.portfolio_idx }'">
					            ${portfolio.title}
					        </td>
		                    <td class="align-right">$
							    <script>
							        var marketCap = '${portfolio.deposit}';
							        document.write(marketCap.replace(/\B(?=(\d{3})+(?!\d))/g, ","));
							    </script>
							</td>
		                    <td><span id="profitRate_${portfolio.portfolio_idx}"></span>
							    <script>
							    var profit_Rate = ${portfolio.profit_Rate};
							
							    // profit_Rate가 0보다 큰 경우
							    if (profit_Rate > 0) {
							        document.getElementById("profitRate_${portfolio.portfolio_idx}").style.color = "#2ecc71"; // 초록색
							        document.getElementById("profitRate_${portfolio.portfolio_idx}").textContent = "+" + profit_Rate.toFixed(2) + "%";
							    } 
							    // profit_Rate가 0보다 작은 경우
							    else if (profit_Rate < 0) {
							        document.getElementById("profitRate_${portfolio.portfolio_idx}").style.color = "#e74c3c"; // 빨간색
							        document.getElementById("profitRate_${portfolio.portfolio_idx}").textContent = profit_Rate.toFixed(2) + "%";
							    } 
							    // profit_Rate가 0일 경우
							    else {
							        document.getElementById("profitRate_${portfolio.portfolio_idx}").style.color = "#000000"; // 기본 색상
							        document.getElementById("profitRate_${portfolio.portfolio_idx}").textContent = profit_Rate.toFixed(2) + "%";
							    }
							    </script>
							</td>
		                    <td>${portfolio.create_at}</td>
		                    <td>
					            <a href="#" onclick="return confirmDelete(${portfolio.portfolio_idx})">삭제</a>
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
    function confirmDelete(portfolio_idx) {
        var confirmation = confirm("정말 삭제하시겠습니까?");
        if (confirmation) {
            window.location.href = '${root}portfolio/deletePortfolio/' + portfolio_idx;
        }
        return false; // 링크의 기본 동작을 막는다 (페이지 이동을 방지)
    }
</script>
</body>
</html>