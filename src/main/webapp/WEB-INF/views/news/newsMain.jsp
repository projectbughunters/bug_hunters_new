<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<c:set var="root" value='${pageContext.request.contextPath }/' />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${root}css/news.css">
    
    <title>News | TMI</title>
</head>
<body>
  <c:import url="/WEB-INF/views/include/topMenu.jsp" />
  <div class="primary-container">
  
    <div class="container">
    	<div class="row">
	        <!-- 경제 뉴스 섹션 -->
	        <div class="news-section">
	            <h2>경제 뉴스</h2>
	            <div class="content">
	                <div class="image-container">
	                    <img alt="경제 뉴스 이미지" src="${root }image/economy.jpg">
	                </div>
	                <div class="list-container">
	                    <ul id="economyNewsList">
	                        <c:forEach var="economyNews" items="${economyItems}">
	                            <li>
	                                <a href="${economyNews.link}" target="_blank">${economyNews.title}</a>
	                            </li>
	                        </c:forEach>
	                    </ul>
	                    <div class="pagination">
	                        <button id="economyPrevBtn" disabled>←</button>
	                        <button id="economyNextBtn">→</button>
	                    </div>
	                 </div>
	              </div>
         	  </div>
     
            <!-- 유튜브 영상 -->
            <div class="news-section">
            <div class="video-section">
	             <div class="content">
				    <div class="video-container">
				        <iframe
				            src="https://www.youtube.com/embed?listType=playlist&list=PLT6yxVwBEbi0AKJXT8tseRoYHctKpD1Fj&autoplay=1&mute=1&controls=0&loop=1"
				            title="YouTube video player" frameborder="0"
				            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
				            allowfullscreen> 
		         		</iframe>
			    	</div>
			     </div>
			 </div>
			 </div>
        </div>

        <!-- 코인 뉴스와 주식 뉴스 섹션 -->
        <div class="row">
            <!-- 코인 뉴스 -->
            <div class="news-section">
                <h2>코인 뉴스</h2>
                <div class="content">
                    <div class="image-container">
                        <img alt="코인 뉴스 이미지" src="${root }image/coin.jpg">
                    </div>
                    <div class="list-container">
                        <ul id="coinNewsList">
                            <c:forEach var="coinNews" items="${coinItems}">
                                <li>
                                    <a href="${coinNews.link}" target="_blank">${coinNews.title}</a>
                                </li>
                            </c:forEach>
                        </ul>
                        <div class="pagination">
                            <button id="coinPrevBtn" disabled>←</button>
                            <button id="coinNextBtn">→</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 주식 뉴스 -->
            <div class="news-section">
                <h2>주식 뉴스</h2>
                <div class="content">
                    <div class="image-container">
                        <img alt="주식 뉴스 이미지" src="${root }image/stock.jpg">
                    </div>
                    <div class="list-container">
                        <ul id="stockNewsList">
                            <c:forEach var="stockNews" items="${stockItems}">
                                <li>
                                    <a href="${stockNews.link}" target="_blank">${stockNews.title}</a>
                                </li>
                            </c:forEach>
                        </ul>
                        <div class="pagination">
                            <button id="stockPrevBtn" disabled>←</button>
                            <button id="stockNextBtn">→</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    </div>
    <c:import url="/WEB-INF/views/include/bottom.jsp" />

    <script>
        document.addEventListener("DOMContentLoaded", () => {
            const setupPagination = (listId, prevBtnId, nextBtnId, itemsPerPage = 10) => {
                const list = document.getElementById(listId);
                const items = Array.from(list.querySelectorAll("li"));
                const prevBtn = document.getElementById(prevBtnId);
                const nextBtn = document.getElementById(nextBtnId);

                let currentPage = 1;
                const totalPages = Math.ceil(items.length / itemsPerPage);

                const updateList = () => {
                    const start = (currentPage - 1) * itemsPerPage;
                    const end = start + itemsPerPage;

                    items.forEach((item, index) => {
                        item.style.display = index >= start && index < end ? "block" : "none";
                    });

                    prevBtn.disabled = currentPage === 1;
                    nextBtn.disabled = currentPage === totalPages;
                };

                prevBtn.addEventListener("click", () => {
                    if (currentPage > 1) {
                        currentPage--;
                        updateList();
                    }
                });

                nextBtn.addEventListener("click", () => {
                    if (currentPage < totalPages) {
                        currentPage++;
                        updateList();
                    }
                });

                updateList();
            };

            setupPagination("economyNewsList", "economyPrevBtn", "economyNextBtn");
            setupPagination("coinNewsList", "coinPrevBtn", "coinNextBtn");
            setupPagination("stockNewsList", "stockPrevBtn", "stockNextBtn");
        });
    </script>
</body>
</html>
