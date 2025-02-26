<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="root" value='${pageContext.request.contextPath }/' /> 
<!DOCTYPE html >
<html>
<head>
<meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" >
    <link href="https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@400&display=swap" rel="stylesheet">
	<link rel="stylesheet" href="${root}css/bugMain.css">
	<link rel="stylesheet" href="${root}css/coinMain.css"> 
	<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<!-- 플러그인 추가 -->
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-crosshair"></script>
 <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-zoom"></script>
<title>Take Money Information | TMI</title>
<style>
    .indicator-wrapper {
      display: flex;
      justify-content: space-between;
      width: 100%; /* 전체 폭을 사용 */
    }
    .indicator-container {
      width: 48%; /* 각 테이블의 폭을 조정 */
    }
    .indicator-table {
      width: 100%; /* 테이블의 폭을 100%로 설정 */
    }
  </style>
</head>
<body>
<c:import url="/WEB-INF/views/include/topMenu.jsp"/>
<div class="indicator-wrapper">
  <div class="indicator-container">
    <h2>주요 주가지수</h2>
    <table class="indicator-table">
      <thead>
      <tr>
        <th>지수</th>
        <th>값</th>
      </tr>
      </thead>
      <tbody>
      <tr>
        <td><a href="${root}economy/searchPro?symbol=KOSPI">코스피</a></td>
        <td>${kospi}</td>
      </tr>
      <tr>
        <td><a href="${root}economy/searchPro?symbol=KOSDAQ">코스닥</a></td>
        <td>${kosdaq}</td>
      </tr>
      <tr>
        <td><a href="${root}economy/searchPro?symbol=NASDAQ">나스닥</a></td>
        <td>${nasdaq}</td>
      </tr>
      <tr>
        <td><a href="${root}economy/searchPro?symbol=SPY">S&P 500</a></td>
        <td>${snp500}</td>
      </tr>
      <tr>
        <td><a href="${root}economy/searchPro?symbol=DJIA">다우 존스 산업평균지수</a></td>
        <td>${dowJones}</td>
      </tr>
      <tr>
        <td><a href="${root}economy/searchPro?symbol=UKX">FTSE 100</a></td>
        <td>${ftse100}</td>
      </tr>
      <tr>
        <td><a href="${root}economy/searchPro?symbol=NIKKEI225">닛케이 225</a></td>
        <td>${nikkei225}</td>
      </tr>
      <tr>
        <td><a href="${root}economy/searchPro?symbol=SHCOMP">상해 종합지수</a></td>
        <td>${shanghaiComposite}</td>
      </tr>
      <tr>
        <td><a href="${root}economy/searchPro?symbol=HSI">홍콩 항셍지수</a></td>
        <td>${hangSeng}</td>
      </tr>
      <tr>
        <td><a href="${root}economy/searchPro?symbol=DAX">DAX</a></td>
        <td>${dax}</td>
      </tr>
      </tbody>
    </table>
  </div>
  <div class="indicator-container">
    <h2>상품</h2>
    <table class="indicator-table">
      <thead>
      <tr>
        <th>상품명</th>
        <th>값</th>
      </tr>
      </thead>
      <tbody>
      <tr>
        <td><a href="${root}economy/searchCommodities1?symbol=WTI">원유(WTI)</a></td>
        <td></td>
      </tr>
      <tr>
        <td><a href="${root}economy/searchCommodities1?symbol=BRENT">원유(브렌트)</a></td>
        <td></td>
      </tr>
      <tr>
        <td><a href="${root}economy/searchCommodities1?symbol=NATURAL_GAS">천연가스</a></td>
        <td></td>
      </tr>
      <tr>
        <td><a href="${root}economy/searchCommodities2?symbol=COPPER">구리</a></td>
        <td></td>
      </tr>
      <tr>
        <td><a href="${root}economy/searchCommodities2?symbol=ALUMINUM">알루미늄</a></td>
        <td></td>
      </tr>
      <tr>
        <td><a href="${root}economy/searchCommodities2?symbol=WHEAT">밀</a></td>
        <td></td>
      </tr>
      <tr>
        <td><a href="${root}economy/searchCommodities2?symbol=CORN">옥수수</a></td>
        <td></td>
      </tr>
      <tr>
        <td><a href="${root}economy/searchCommodities2?symbol=COTTON">면</a></td>
        <td></td>
      </tr>
      <tr>
        <td><a href="${root}economy/searchCommodities2?symbol=SUGAR">설탕</a></td>
        <td></td>
      </tr>
      <tr>
        <td><a href="${root}economy/searchCommodities2?symbol=COFFEE">커피</a></td>
        <td></td>
      </tr>
      </tbody>
    </table>
  </div>
</div>

<c:import url="/WEB-INF/views/include/bottom.jsp"/>
</body>
</html>
