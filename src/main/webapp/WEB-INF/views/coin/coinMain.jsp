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
   <link rel="stylesheet" href="${root}css/coinMain.css">
   <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<title>Crypto | TMI</title>

<style>
    .iframe-container {
        width: 500px; 
        height: 300px; 
        resize: both;
        overflow: hidden;
        margin-right: 100px;
    }
    iframe {
        width: 100%;  
        height: 100%; 
        border: none;
        object-fit: cover;
    }</style>
</head>
<body>
<c:import url="/WEB-INF/views/include/topMenu.jsp"/>
<c:import url="/WEB-INF/views/stock/exchange.jsp"/>

<div class="primary-container">
<h2>암호화폐 테이블</h2>
<table>
    <thead>
        <tr>
           <th ></th>
            <th class="headCol nameCol">종목</th>
            <th>기호</th>
            <th>가격(KRW)</th>
            <th>총 시가</th>
            <th>거래량(24H)</th>
            <th>변동(24H)</th>
            <th>변동(7D)</th>
        </tr>
    </thead>
          <tbody>
          <!-- coins 배열을 순회 -->
          <c:forEach var="coin" items="${pageBean.list}">
              <tr>
                  <!-- 1. 일단 false로 초기화 -->
                  <c:set var="isFavorited" value="false" />
          
                  <!-- 2. favorites 목록을 돌며, 이 stock이 있는지 확인 -->
                  <c:forEach var="favorite" items="${favorites}">
                      <c:if test="${coin.symbol == favorite.symbol}">
                          <c:set var="isFavorited" value="true" />
                      </c:if>
                  </c:forEach>
      
                  <c:if test="${loginUserBean.userLogin == true }">
                      <!-- 3. 최종적으로 isFavorited에 따라 active 클래스 적용 여부 결정 -->
                      <td class="favorite-type">
                          <button class="fav-btn ${isFavorited ? 'active' : ''}"
                                  data-symbol="${coin.symbol}"
                                  data-type="${coin.name}">
                          </button>
                      </td>
                  </c:if>
                  <c:if test="${loginUserBean.userLogin == false }">
                      <td class="favorite-type"></td>
                  </c:if>
      
                  <!-- 코인 이름/심볼 -->
                  <td class="headCol-nameCol"
                      onclick="location.href='${root}coin/info/${coin.symbol}/${coin.name}'">
                      <img src="https://cryptologos.cc/logos/${coin.name.toLowerCase()}-${coin.symbol.toLowerCase()}-logo.png?v=040"
                           style="height: 20px; margin-right: 5px;">
                      ${coin.name}
                  </td>
                  <td>${coin.symbol}</td>
      
                  <!-- 가격 (Price) -->
                  <td class="align-right">
                      <script>
                          var price = Number(${coin.quotes.USD.price});
                          document.write("$ " + formatEBITDA(price));
                      </script>
                  </td>
      
                  <!-- 시가총액 (Market Cap) -->
                  <td class="align-right">
                      <script>
                          var marketCap = Number(${coin.quotes.USD.market_cap});
                          document.write("$ " + formatEBITDA(marketCap));
                      </script>
                  </td>
      
                  <!-- 24시간 거래량 (Volume 24h) -->
                  <td class="align-right">
                      <script>
                          var volume24h = Number(${coin.quotes.USD.volume_24h});
                          document.write("$ " + formatEBITDA(volume24h));
                      </script>
                  </td>
      
                  <!-- 24시간 변동률 -->
                  <td class="align-right ${coin.quotes.USD.percent_change_24h > 0 ? 'positive-change' : 'negative-change'}">
                      <script>
                          var percentChange24h = Number(${coin.quotes.USD.percent_change_24h});
                          document.write(percentChange24h.toFixed(2) + "%");
                      </script>
                  </td>
      
                  <!-- 7일 변동률 -->
                  <td class="align-right ${coin.quotes.USD.percent_change_7d > 0 ? 'positive-change' : 'negative-change'}">
                      <script>
                          var percentChange7d = Number(${coin.quotes.USD.percent_change_7d});
                          document.write(percentChange7d.toFixed(2) + "%");
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
                    if (button.hasClass('active')) {
                        button.text("★"); // 즐겨찾기 추가
                    } else {
                        button.text("☆"); // 즐겨찾기 제거
                    }
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
