<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<c:set var="root" value='${pageContext.request.contextPath }/' />
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com">
<link
   href="https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@400&display=swap"
   rel="stylesheet">

<div class="stock-section">
   <h2>
      주식
      <button onclick="location.href='${root}stock/stockMain'"
         style="margin-left: 10px;">바로가기</button>
   </h2>

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
                     <td><img
                        src="https://financialmodelingprep.com/image-stock/${stock.symbol}.png"
                        style="width: 30px; height: 30px; margin-right: 10px;" /></td>
                     <td class="clickable"
                        onclick="location.href='${root}stock/info/${stock.symbol}'">
                        ${stock.symbol}</td>
                     <td class="light-bg">${stock.name}</td>
                     <td class="light-bg">${stock.currency}</td>
                     <td class="light-bg"><script>
                        var trailingPE = parseFloat(
                              '${stock.trailingPE}').toFixed(2);
                        trailingPE = trailingPE.slice(0, -1) + 'x';
                        document.write(trailingPE);
                     </script></td>
                     <td class="align-right light-bg">$<c:out
                           value="${stock.marketPrice}" /></td>
                     <td
                        class="align-right light-bg ${stock.marketChange > 0 ? 'positive-change' : 'negative-change'}">
                        <script>
                           var marketChange = $
                           {
                              stock.marketChange
                           };
                           document.write(marketChange.toFixed(2)
                                 + "%");
                        </script>
                     </td>
                     <td class="align-right light-bg"><script>
                        var marketCap = '${stock.marketCap}';
                        document.write(formatEBITDA(marketCap));
                     </script></td>
                  </tr>
               </c:forEach>
            </tbody>
         </table>
      </div>
      <div class="stock-chart-wrapper">

         <button id="prevStockBtn">◀</button>
         <button id="nextStockBtn">▶</button>
         <div id="stockNameDisplay"></div>
         <div id="stockChartContainer">
            <canvas id="stockChart"></canvas>
         </div>
      </div>
   </div>
</div>