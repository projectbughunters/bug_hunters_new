<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<c:set var="root" value='${pageContext.request.contextPath }/' />
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<div class="news-section">
   <h2 style="border-bottom: solid 2px #d9d9d9; padding-bottom: 15px;">실시간 뉴스</h2>

   <!-- 슬라이드를 감싸는 래퍼 -->
   <div class="news-slider-wrapper">
      
      <!-- newsList를 4개씩 끊어서 .news-slide 로 감싸기 -->
      <c:forEach var="news" items="${newsList}" varStatus="status">

         <!-- 4개 단위의 첫 번째 아이템에서 news-slide 시작 -->
         <c:if test="${status.index % 4 == 0}">
            <div class="news-slide">
         </c:if>

               <!-- 단일 뉴스 아이템 -->
               <div class="news-item">
                  <c:if test="${not empty news.image}">
                     <a href="https://n.news.naver.com/mnews/article/${news.officeId}/${news.articleId}"
                     target="_blank"><img class="news-image" src="${news.image}" alt="${news.title}"/></a>
                  </c:if>
                  <a href="https://n.news.naver.com/mnews/article/${news.officeId}/${news.articleId}"
                     target="_blank">${news.title}</a>
               </div>

         <!-- 4개 단위의 마지막 아이템에서 news-slide 닫기 (또는 전체 마지막 news에도 닫기) -->
         <c:if test="${(status.index + 1) % 4 == 0 or status.last}">
            </div><!-- /.news-slide -->
         </c:if>

      </c:forEach>
      
      
      
   </div><!-- /.news-slider-wrapper -->

   <div class="pagination-controls">
      <button id="newsPrevBtn">&#10094;</button>
      <button id="newsNextBtn">&#10095;</button>
   </div>
</div>



<script>
document.addEventListener("DOMContentLoaded", () => {
	const slides = document.querySelectorAll('.news-slide');
    const totalSlides = slides.length;
    let currentIndex = 0;

    // 초기에 모든 슬라이드 숨기고, 첫 번째만 표시
    function showSlide(index) {
    slides.forEach((slide, i) => {
        // 활성화 여부에 따라 active 클래스를 부여/제거
        if (i === index) {
            slide.classList.add('active');
        } else {
            slide.classList.remove('active');
        }
    });
}
    showSlide(currentIndex);

    // 다음 슬라이드
    function nextSlide() {
        currentIndex = (currentIndex + 1) % totalSlides;
        showSlide(currentIndex);
    }

    // 이전 슬라이드
    function prevSlide() {
        // 음수가 되지 않도록 전체 슬라이드 개수를 더해서 나머지 연산
        currentIndex = (currentIndex - 1 + totalSlides) % totalSlides;
        showSlide(currentIndex);
    }

    // 버튼 이벤트 연결
    document.getElementById('newsNextBtn').addEventListener('click', nextSlide);
    document.getElementById('newsPrevBtn').addEventListener('click', prevSlide);

    // 3초마다 자동으로 다음 슬라이드 이동
    setInterval(nextSlide, 10000);
});
</script>
