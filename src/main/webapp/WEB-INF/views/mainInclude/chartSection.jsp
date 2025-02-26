<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<c:set var="root" value='${pageContext.request.contextPath }/' />
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
	
<div class="chart-container">
    <h1>차트</h1>
    <!-- 주식 차트 -->
    <div class="stock-chart-wrapper">
        <button id="prevStockBtn">◀</button>
        <button id="nextStockBtn">▶</button>
        <button onclick="location.href='${root}stockMain'" style="margin-left: 10px;">바로가기</button>
        <div id="stockNameDisplay"></div>
        <div id="stockChartContainer">
            <canvas id="stockChart"></canvas>
        </div>
    </div>
    <!-- 코인 차트 -->
    <div class="coin-chart-wrapper">
        <button id="prevCoinBtn">◀</button>
        <button id="nextCoinBtn">▶</button>
        <button onclick="location.href='${root}coinMain'" style="margin-left: 10px;">바로가기</button>
        <div id="coinNameDisplay"></div>
        <div id="coinChartContainer">
            <canvas id="coinChart"></canvas>
        </div>
    </div>
</div>
	