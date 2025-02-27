<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<c:set var="root" value='${pageContext.request.contextPath }/' />
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="${root}css/topMenu.css">

<script>
        // formatEBITDA 함수를 먼저 정의
        function formatEBITDA(value) {
            value = Number(value); // 문자열을 숫자로 변환
            if (isNaN(value)) return "N/A";
            if (value >= 1e12) {            // 1조 이상
                return (value / 1e12).toFixed(2) + "T";
            } else if (value >= 1e9) {       // 10억 이상
                return (value / 1e9).toFixed(2) + "B";
            } else if (value >= 1e6) {       // 1백만 이상
                return (value / 1e6).toFixed(2) + "M";
            } else if (value >= 1e3) {       // 1천 이상
                return (value / 1e3).toFixed(2) + "K";
            }
            return value.toFixed(2);
        }
    </script>

<header>
	<h1>
		<a href="${root}"><image src="${root}image/TMI_Y.png" style="width: 70px; height : 50px"/></a>
	</h1>
	<nav>
		<a href="${root}stock/stockMain">STOCK</a> 
		<a href="${root}coin/coinMain">CRYPTO</a> 
		<a href="${root }ai/aiRecommend">STOCK-AI</a>
		<div class="dropdown">
			<a href="#" class="dropdown-link">PORTFOLIO ▾</a>
			<div class="dropdown-content">
				<a href="${root }portfolio/portfolioMain">PORTFOLIO</a>
				<a href="${root }portfolio/tendencyTest">내 투자성향 검사</a>
			</div>
		</div>
		<a href="${root}news/newsMain">NEWS</a> 
		<a href="${root}board/boardMain">NOTICE</a>
	</nav>
	
	<c:choose>
				<c:when test="${loginUserBean.userLogin == true}">
						<!-- 즐겨찾기 버튼 추가 -->
				         <div class="dropdown">
				            <a href="#" class="dropdown-link" onclick="loadFavorites()">FAVORITES ▾</a>
				            <div class="dropdown-content" id="favoritesDropdown">
				               <!-- AJAX 결과가 여기에 표시됩니다. -->
				            </div>
				         </div>
						<span class="login"><a href="${root }user/myPage" class="nav-link">MYPAGE</a></span>
						<c:if test="${loginUserBean != null && loginUserBean.type == 'google'}">
							<span class="login"><a href="${root }google/logout" class="nav-link">LOGOUT</a></span>
						</c:if>
						<c:if test="${loginUserBean != null && loginUserBean.type == 'user'}">
							<span class="login"><a href="${root }user/logout" class="nav-link">LOGOUT</a></span>
						</c:if>
				</c:when>
				<c:otherwise>
						<span class="login"><a href="${root }user/login" class="nav-link">LOGIN</a></span>
						<span class="login"><a href="${root }user/createMember" class="nav-link">SIGN IN</a></span>
				</c:otherwise>
	</c:choose>
	
</header>

<script type="text/javascript">
function loadFavorites() {
    $.ajax({
       url: '${root}favorite/select',
       type: 'POST',
       dataType: 'json',
       success: function(data) {
          var favorites = '<tbody>';
          $.each(data, function(index, item) {
             if (item.type === 'stock') {
                favorites += '<tr>' +
                   '<td><a href="${root}stock/info/' + item.symbol + '">' + item.symbol + '</a></td>' +
                   '<td><button class="delete-fav-btn" data-symbol="' + item.symbol + '" data-type="stock">삭제</button></td>' +
                   '</tr>';
             } else {
                favorites += '<tr>' +
                   '<td><a href="${root}coin/info/' + item.symbol + '/' + item.type + '">' + item.symbol + '</a></td>' +
                   '<td><button class="delete-fav-btn" data-symbol="' + item.symbol + '" data-type="' + item.type + '">삭제</button></td>' +
                   '</tr>';
             }
          });
          favorites += '</tbody>';
          $('#favoritesDropdown').html(favorites);
       },
       error: function() {
          alert('즐겨찾기 목록을 불러오는 데 실패했습니다.');
       }
    });
 }
</script>
