<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<c:set var="root" value='${pageContext.request.contextPath }/' />
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
</head>
<body>
<c:import url="/WEB-INF/views/include/topMenu.jsp"/>
<h1>AI Recommendations</h1>

<!-- 각 테마별 버튼 -->
<button onclick="sendDataToNode('ESG', esgStocks)">ESG 주식 데이터 전송</button>
<button onclick="sendDataToNode('Defensive', defensiveStocks)">방어형 주식 데이터 전송</button>
<button onclick="sendDataToNode('Tech', techStocks)">기술 주식 데이터 전송</button>
<button onclick="sendDataToNode('Value', valueStocks)">가치주 데이터 전송</button>
<button onclick="sendDataToNode('Growth', growthStocks)">성장주 데이터 전송</button>
<button onclick="sendDataToNode('Dividend', dividendStocks)">배당주 데이터 전송</button>

<!-- 챗봇 응답을 출력할 영역 -->
<div id="chatbotResponse" style="margin-top: 20px; padding: 10px; border: 1px solid #ccc;">
  <h3>챗봇 응답:</h3>
  <p id="responseContent">여기에 챗봇의 응답이 표시됩니다.</p>
</div>

<!-- JavaScript: Node.js로 데이터 전송 -->
<script>
  // 각 테마별 데이터를 JSP에서 가져옴
  const esgStocks = JSON.parse('${esgStocks}');
  const defensiveStocks = JSON.parse('${defensiveStocks}');
  const techStocks = JSON.parse('${techStocks}');
  const valueStocks = JSON.parse('${valueStocks}');
  const growthStocks = JSON.parse('${growthStocks}');
  const dividendStocks = JSON.parse('${dividendStocks}');

  // Node.js 서버로 데이터 전송 함수
  async function sendDataToNode(theme, data) {
    try {
      // Node.js 서버로 POST 요청
      const response = await axios.post('http://localhost:3000/aiRecommend', {
        theme: theme,
        stocks: data
      });

      // 서버 응답 받아서 div에 출력
      document.getElementById('responseContent').innerText = response.data.result;
    } catch (error) {
      console.error(`${theme} 데이터 전송 중 오류 발생:`, error);
      alert(`${theme} 데이터 전송 중 오류가 발생했습니다.`);
    }
  }
</script>

<c:import url="/WEB-INF/views/include/bottom.jsp"/>
</body>
</html>
