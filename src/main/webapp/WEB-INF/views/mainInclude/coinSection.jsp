<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<c:set var="root" value='${pageContext.request.contextPath }/' />
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
   
<div class="coin-section">
   <div class="stock-title">
   <div class="title-container">
   <h2>코인</h2>
   </div>
   <div class="button-container">
      <button class="navigate-button" onclick="location.href='${root}coin/coinMain'">&#10095;</button>
   </div>
</div>
	   <!-- 테이블과 차트를 감싸는 컨테이너 -->
	   <div class="coin-content">
	      <div class="coin-table">
		    <img src="${root}image/loading.gif" alt="로딩 중..." />
		  </div>
      <div class="coin-chart-wrapper">
         <div id="coinNameDisplay"></div>
         <div id="coinChartContainer">
            <canvas id="coinChart"></canvas>
            <div class="arrow-btn">
		        <button id="prevCoinBtn">◀</button>
		        <button id="nextCoinBtn">▶</button>
	        </div>
         </div>
      </div>
   </div>
</div>
