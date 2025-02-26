<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<c:set var="root" value='${pageContext.request.contextPath }/' />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${root}css/portfolio.css">
    <title>포트폴리오 | TMI</title>
   
</head>
<body>

    <div class="section">
        <div class="text" id="text1">Welcome to TMI PortFolio!</div>
    </div>
    <div class="section">
        <div class="text" id="text2">${loginUserBean.member_name}'s PortFolio</div>
    </div>
    <div class="section">
        <div class="text right" id="text3">START</div>
    </div>
    <div class="section">
        <div class="text" id="text4">당신의 성향은 ${profileBean.personal_tendency_code } 입니다.</div>
    </div>
    <div class="section">
        <div class="text" id="text5">위험자산 VS 안전자산 </div>
    </div>
    <div class="section">
    	<c:if test="${tendencyCode == '중립형'}">
        <div class="text right" id="ratio"> 50 : 50 </div>
        </c:if>
    	<c:if test="${tendencyCode == '보수형'}">
        <div class="text right" id="ratio"> 30 : 70 </div>
        </c:if>
    	<c:if test="${tendencyCode == '공격형'}">
        <div class="text right" id="ratio"> 70 : 30 </div>
        </c:if>
    </div>
    <div class="section">
    <div class="text" id="text7">위험자산 List
        <ul>
            <li><span>알트코인</span></li>
            <li><span>이더리움</span></li>
            <li><span>솔라나</span></li>
        </ul>
    </div>
</div>
<div class="section">
    <div class="text" id="text8">안전자산 List
        <ul>
            <li><span>삼성</span></li>
            <li><span>테슬라</span></li>
            <li><span>인텔</span></li>
        </ul>
    </div>
</div>
    

    <div class="portfolio-container" id="portfolio-container">
        <div class="portfolio-summary" id="portfolio-summary">
            <h2>당신의 포트폴리오 요약</h2>
            <div class="performance-metrics">
                <div class="metric-card">
                    <div class="metric-value">₩15,000,000</div>
                    <div class="metric-label">총 자산</div>
                </div>
                <div class="metric-card">
                    <div class="metric-value">+12.5%</div>
                    <div class="metric-label">전체 수익률</div>
                </div>
                <div class="metric-card">
                    <div class="metric-value">+₩1,650,000</div>
                    <div class="metric-label">총 수익금</div>
                </div>
            </div>

            <div class="asset-distribution">
                <div class="distribution-item">
                    <div class="distribution-value">45%</div>
                    <div class="distribution-label">주식</div>
                </div>
                <div class="distribution-item">
                    <div class="distribution-value">30%</div>
                    <div class="distribution-label">암호화폐</div>
                </div>
                <div class="distribution-item">
                    <div class="distribution-value">25%</div>
                    <div class="distribution-label">현금성 자산</div>
                </div>
            </div>
        </div>

        <div class="portfolio-chart" id="portfolio-chart">
            <h2>포트폴리오 차트</h2>
            <!-- 차트를 위한 공간 -->
        </div>

        <div class="portfolio-holdings" id="portfolio-holdings">
            <h2>보유 자산 현황</h2>
            <table class="holdings-table">
                <thead>
                    <tr>
                        <th>자산명</th>
                        <th>보유수량</th>
                        <th>현재가</th>
                        <th>평가금액</th>
                        <th>수익률</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>삼성전자</td>
                        <td>100</td>
                        <td>₩72,000</td>
                        <td>₩7,200,000</td>
                        <td style="color: #2ecc71">+15.2%</td>
                    </tr>
                    <tr>
                        <td>비트코인</td>
                        <td>0.5</td>
                        <td>₩80,000,000</td>
                        <td>₩4,000,000</td>
                        <td style="color: #e74c3c">-5.8%</td>
                    </tr>
                    <tr>
                        <td>현금성 자산</td>
                        <td>-</td>
                        <td>-</td>
                        <td>₩3,800,000</td>
                        <td>0.0%</td>
                    </tr>
                </tbody>
            </table>
        </div>

       
    </div>

<script>
    document.addEventListener("DOMContentLoaded", () => {
        const texts = document.querySelectorAll('.text');
        const portfolioSummary = document.getElementById('portfolio-summary');
        const portfolioChart = document.getElementById('portfolio-chart');
        const portfolioHoldings = document.getElementById('portfolio-holdings');
        
        window.addEventListener('scroll', () => {
            texts.forEach((el) => {
                const rect = el.getBoundingClientRect();
                if (rect.top < window.innerHeight * 0.8) {
                    el.classList.add('visible');
                } else {
                    el.classList.remove('visible');
                }
            });

         // 포트폴리오 섹션을 차례로 표시
            if (portfolioSummary && portfolioSummary.getBoundingClientRect().top < window.innerHeight * 0.8) {
                portfolioSummary.classList.add('visible');
            } else {
                portfolioSummary.classList.remove('visible');
            }

            if (portfolioChart && portfolioChart.getBoundingClientRect().top < window.innerHeight * 0.8) {
                portfolioChart.classList.add('visible');
            } else {
                portfolioChart.classList.remove('visible');
            }

            if (portfolioHoldings && portfolioHoldings.getBoundingClientRect().top < window.innerHeight * 0.8) {
                portfolioHoldings.classList.add('visible');
            } else {
                portfolioHoldings.classList.remove('visible');
            }
        });
    });
    
    
    document.addEventListener("DOMContentLoaded", () => {
        const riskItems = document.querySelectorAll('#text7 ul li span');
        const safeItems = document.querySelectorAll('#text8 ul li span');

        // 위험자산 List의 각 항목에 대해 애니메이션 적용
        riskItems.forEach((item, index) => {
            setTimeout(() => {
                item.classList.add('visible'); // visible 클래스 추가
            }, index * 800); // 800ms 간격으로 지연
        });

        // 안전자산 List의 각 항목에 대해 애니메이션 적용
        safeItems.forEach((item, index) => {
            setTimeout(() => {
                item.classList.add('visible'); // visible 클래스 추가
            }, index * 800); // 800ms 간격으로 지연
        });
    });

    document.addEventListener("DOMContentLoaded", () => {
        let isScrolling = true; // 자동 스크롤 상태를 나타내는 변수

        const scrollPage = () => {
            if (isScrolling) { // isScrolling이 true일 때만 스크롤
                window.scrollBy(0, 6); // 아래로 6픽셀 스크롤
                if (window.scrollY + window.innerHeight < document.body.scrollHeight) {
                    requestAnimationFrame(scrollPage);
                }
            }
        };

        // 자동 스크롤 시작
        scrollPage();

        // 사용자가 스크롤을 할 경우 자동 스크롤 중지
        window.addEventListener('scroll', () => {
            isScrolling = false; // 자동 스크롤을 멈춤
        });
    });
   
    </script>

</body>
</html>
