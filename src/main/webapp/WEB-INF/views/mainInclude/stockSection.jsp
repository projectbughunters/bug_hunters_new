<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<c:set var="root" value='${pageContext.request.contextPath }/' />
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="${root}css/stockSection.css"> 

<div class="stock-section">
<div class="stock-title">
   <div class="title-container">
   <h2>주식</h2>
   </div>
   <div class="button-container">
      <button class="navigate-button" onclick="location.href='${root}stock/stockMain'">&#10095;</button>
   </div>
</div>
	   <div class="stock-content">
	      <div class="stock-table">
	    Loading stocks...
	  </div>
      <div class="stock-chart-wrapper">
         <div id="stockNameDisplay" class="stock-name-display"></div>
         <div id="stockChartContainer" class="chart-container">
            <canvas id="stockChart"></canvas>
            <div class="arrow-btn">
	            <button id="prevStockBtn" class="chart-button">◀</button>
	            <button id="nextStockBtn" class="chart-button">▶</button>
            </div>
         </div>
      </div>
   </div>
</div>
