<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<c:set var="root" value='${pageContext.request.contextPath }/' />
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

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
         <table>
            <thead>
               <tr>
                  <th colspan="2">심볼</th>
                  <th>종목</th>
                  <th>통화</th>
                  <th>주가수익비율</th>
                  <th>현재 가격</th>
                  <th>24시간 변동</th>
                  <th>시가총액</th>
               </tr>
            </thead>
            <tbody>
               <c:forEach var="stock" items="${pageBeanForStocks.list}">
                  <tr>
                     <td style="background: rgba(105, 105, 105, 0.2);"><img src="https://financialmodelingprep.com/image-stock/${stock.symbol}.png"
                              style="width: 30px; height: 30px; margin-right: 10px; "/></td>
                     <td class="clickable" onclick="location.href='${root}stock/info/${stock.symbol}'">
                        ${stock.symbol}</td>
                     <td class="light-bg">${stock.name}</td>
                     <td class="light-bg">${stock.currency}</td>
                     <td class="light-bg">
                        <script>
                           var trailingPE = parseFloat('${stock.trailingPE}').toFixed(2);
                           trailingPE = trailingPE.slice(0, -1) + 'x';
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
