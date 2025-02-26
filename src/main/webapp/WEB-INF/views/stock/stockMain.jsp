<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>   
<c:set var="root" value='${pageContext.request.contextPath }/' /> 
<!DOCTYPE html >
<html>
<head>
<meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="stylesheet" href="${root}css/bugMain.css">
	<link rel="stylesheet" href="${root}css/stockMain.css"> 
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<title>Stock | TMI</title>
</head>
<body>
<c:import url="/WEB-INF/views/include/topMenu.jsp"/>
<c:import url="/WEB-INF/views/stock/exchange.jsp"/>

<div class="primary-container">
<h2>주식 스크리너</h2>
    <table>
        <thead>
            <tr>
            	<th></th>
                <th>심볼</th>
                <th>종목</th>
                <th>통화</th>
                <th>주가수익비율</th>
                <th>현재 가격</th>
                <th>24시간 변동</th>
                <th>시가총액</th>
            </tr>
        </thead>
        <tbody>
		    <!-- stocks 배열을 순회 -->
		    <c:forEach var="stock" items="${pageBean.list}">
		    	
		        <tr>
					<!-- 1. 일단 false로 초기화 -->
			        <c:set var="isFavorited" value="false" />
			
			        <!-- 2. favorites 목록을 돌며, 이 stock이 있는지 확인 -->
			        <c:forEach var="favorite" items="${favorites}">
			            <c:if test="${stock.symbol == favorite.symbol}">
			                <c:set var="isFavorited" value="true" />
			            </c:if>
			        </c:forEach>
					<c:if test="${loginUserBean.userLogin == true }">
							<!-- 3. 최종적으로 isFavorited에 따라 active 클래스 적용 여부 결정 -->
				        <td>
				            <button class="fav-btn ${isFavorited ? 'active' : ''}"
				                    data-symbol="${stock.symbol}"
				                    data-type="stock">
				            </button>
				        </td>
					</c:if>
					<c:if test="${loginUserBean.userLogin == false }">
						<td></td>
					</c:if>
		            <td class="clickable" onclick="location.href='${root}stock/info/${stock.symbol }'">
		                <img src="https://financialmodelingprep.com/image-stock/${stock.symbol}.png" style="width: 30px; height: 30px; margin-right: 10px;" /> ${stock.symbol}
		            </td>
		            <!-- 나머지 칼럼에 light-bg 클래스 추가 -->
		            <td class="light-bg">${stock.name}</td>
		            <td class="light-bg">${stock.currency}</td>
		            <td class="light-bg">
		                <script>
		                    var trailingPE = parseFloat('${stock.trailingPE}').toFixed(2); // 소수점 둘째 자리까지 포맷
		                    trailingPE = trailingPE.slice(0, -1) + 'x'; // 마지막 자리 변경
		                    document.write(trailingPE);
		                </script>
		            </td>
		            <td class="align-right light-bg">$<c:out value="${stock.marketPrice}" /></td>
		            <td class="align-right light-bg ${stock.marketChange > 0 ? 'positive-change' : 'negative-change'}">
		                <script>
		                    var marketChange = ${stock.marketChange};
		                    document.write(marketChange.toFixed(2) + "%");
		                </script>
		            </td>
		            <td class="align-right light-bg">
		                <script>
		                    var marketCap = '${stock.marketCap}';
		                    document.write(formatEBITDA(marketCap));
		                </script>
		            </td>
		        </tr>
		    </c:forEach>
		</tbody>

    </table>
    
    <!-- 페이지네이션 내비게이션 -->
    <div class="pagination">
        <c:if test="${pageBean.currentPage > 1}">
            <a href="?page=${pageBean.currentPage - 1}">이전</a>
        </c:if>
        <c:forEach begin="1" end="${pageBean.totalPage}" var="i">
            <a href="?page=${i}" class="${i == pageBean.currentPage ? 'active' : ''}">
                ${i}
            </a>
        </c:forEach>
        <c:if test="${pageBean.currentPage < pageBean.totalPage}">
            <a href="?page=${pageBean.currentPage + 1}">다음</a>
        </c:if>
    </div>
</div>
<c:import url="/WEB-INF/views/include/bottom.jsp"/>
<script>
    $(document).ready(function() {
        $('.fav-btn').click(function() {
            var button = $(this);
            var symbol = button.data('symbol'); // 버튼의 data-symbol 값
            var type = button.data('type');     // 버튼의 data-type 값

            // 버튼의 상태에 따라 요청 URL을 선택
            var requestUrl = button.hasClass('active')
                ? "${root}favorite/delete" // 즐겨찾기 상태이면 삭제 요청
                : "${root}favorite";        // 그렇지 않으면 추가 요청

            $.ajax({
                url: requestUrl,
                type: "POST",
                data: { symbol: symbol, type: type },
                success: function(response) {
                    // 요청 성공 시 토글: active 클래스 추가/제거하며 텍스트 변경
                    button.toggleClass('active');
                    
                },
                error: function() {
                    alert("즐겨찾기 처리 중 오류가 발생했습니다.");
                }
            });
        });
    });
</script>
</body>
</html>