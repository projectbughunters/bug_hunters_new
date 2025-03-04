<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<c:set var="root" value='${pageContext.request.contextPath}/' />
<!DOCTYPE html>
<html lang="ko">
<head>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Take Money Information | TMI</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@400&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${root}css/aiRecommend.css">
</head>
<body>
<c:import url="/WEB-INF/views/include/topMenu.jsp"/>
<div class="primary-container">
    <div class="text-container">
        <div class="inner-text-container">
            <h2>Stock Hunter AI: 시장에서 우위를 차지하기 위한 전략</h2>
            <h4>투자 목표를 달성할 수 있도록 엄선된 최고 수익률의 투자 전략은 검증된 AI 모델을 기반으로 합니다</h4>
            <div class="custom-button1" role="button" tabindex="0" onclick="location.href='${root}embedded/sitePortalAudSample';">
	                     <h5>대시보드</h5>
	                 </div>
        </div>
    </div>
    <!-- 각 테마별 버튼 -->
    <div>
        <div class="bcontainer-container">
            <div class="button-container">
                <div>
                    <!-- onClick 함수를 sendDataToNode에서 displayData로 변경 -->
                    <div class="custom-button" role="button" tabindex="0" onclick="displayData('ESG')">
                        <h2>ESG 주식</h2>
                        <h5>ESG 기준을 고려한 투자는 장기적으로 기업의 안정성과 성장 가능성을 높이는 데 도움을 줄 수 있습니다.</h5>
                        <img src="${root}image/blue_chart.png" style="width: 300px; height: auto; margin-right: 10px;">
                    </div>
                </div>
                <div>
                    <div class="custom-button" role="button" tabindex="0" onclick="displayData('Defensive')">
                        <h2>방어형 주식</h2>
                        <h5>방어형 주식은 경기 침체 시에도 안정적인 수익을 기대할 수 있어, 변동성이 큰 시장에서 위험을 줄이고자 하는 투자자에게 추천합니다.</h5>
                        <img src="${root}image/braun_chart.png" style="width: 300px; height: auto; margin-right: 10px;">
                    </div>
                </div>
                <div>
                    <div class="custom-button" role="button" tabindex="0" onclick="displayData('Tech')">
                        <h2>기술주 주식</h2>
                        <h5>기술주는 일반적으로 높은 성장률을 보이지만, 변동성이 크고 리스크도 높기 때문에 투자 시 주의가 필요합니다.</h5>
                        <img src="${root}image/green_chart.png" style="width: 300px; height: auto; margin-right: 10px;">
                    </div>
                </div>
            </div>
            <div class="button-container">
                <div>
                    <div class="custom-button" role="button" tabindex="0" onclick="displayData('Value')">
                        <h2>가치주 주식</h2>
                        <h5>가치주는 일반적으로 시장 상황에 덜 민감하며, 장기적인 투자 관점에서 안정적인 수익을 추구하는 투자자들에게 인기가 있습니다.</h5>
                        <img src="${root}image/orange_chart.png" style="width: 300px; height: auto; margin-right: 10px;">
                    </div>
                </div>
                <div>
                    <div class="custom-button" role="button" tabindex="0" onclick="displayData('Growth')">
                        <h2>성장주 주식</h2>
                        <h5>높은 리스크를 동반할 수 있지만, 큰 수익을 기대하는 투자자들에게 매력적입니다.</h5>
                        <img src="${root}image/purple_chart.png" style="width: 300px; height: auto; margin-right: 10px;">
                    </div>
                </div>
                <div>
                    <div class="custom-button" role="button" tabindex="0" onclick="displayData('Dividend')">
                        <h2>배당주 주식</h2>
                        <h5>꾸준한 소득을 중시하는 투자자에게 인기가 있으며, 장기적인 투자관점에서 안정적인 수익원을 제공합니다.</h5>
                        <img src="${root}image/yellow_chart.png" style="width: 300px; height: auto; margin-right: 10px;">
                    </div>
                </div>
            </div>
        </div>
        <div>
            <!-- 챗봇 응답을 출력할 영역 -->
            <div id="chatbotResponse">
            <h3 id="response-title"></h3>
                <p id="responseContent">여기에 챗봇의 응답이 표시됩니다.</p>
            </div>
        </div>
    </div>

    <!-- JavaScript: 페이지 로드 시 API 데이터를 미리 로드 -->
    <script>
        // 각 테마별 데이터를 JSP에서 가져옴
        const esgStocks = JSON.parse('${esgStocks}');
        const defensiveStocks = JSON.parse('${defensiveStocks}');
        const techStocks = JSON.parse('${techStocks}');
        const valueStocks = JSON.parse('${valueStocks}');
        const growthStocks = JSON.parse('${growthStocks}');
        const dividendStocks = JSON.parse('${dividendStocks}');

        // API 응답 결과를 저장할 캐시 객체
        const cachedData = {};

        // 페이지 로드 시 각 테마에 대해 API 데이터를 미리 요청하여 캐시에 저장하는 함수
        async function prefetchData() {
            const themes = {
                'ESG': esgStocks,
                'Defensive': defensiveStocks,
                'Tech': techStocks,
                'Value': valueStocks,
                'Growth': growthStocks,
                'Dividend': dividendStocks
            };

            for (const theme in themes) {
                try {
                    const response = await axios.post('http://localhost:3000/aiRecommend', {
                        theme: theme,
                        stocks: themes[theme]
                    });
                    cachedData[theme] = response.data.result;
                } catch (error) {
                    console.error(`${theme} 데이터 전송 중 오류 발생:`, error);
                    cachedData[theme] = `오류 발생: ${error.message}`;
                }
            }
        }

        // 페이지가 로드되면 prefetchData 함수가 실행되어 API 데이터를 미리 불러옵니다.
        window.addEventListener('load', prefetchData);

        // 사용자가 버튼을 클릭하면 미리 캐시된 데이터를 출력합니다.
        function displayData(theme) {
            const result = cachedData[theme];
            if (result) {
            	 // 서버 응답 받아서 div에 출력 
                document.getElementById('response-title').innerText = "📊 Stock Hunter AI의 답변 📈"
                document.getElementById('responseContent').innerText = result;
            } else {
                document.getElementById('responseContent').innerText = '데이터 로딩 중...';
            }
        }
    </script>
</div>
<c:import url="/WEB-INF/views/include/bottom.jsp"/>
</body>
</html>
