<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<c:set var="root" value='${pageContext.request.contextPath }/' />
<!DOCTYPE html>
<html lang="ko">

<head>
	<!-- Axios CDN 추가 -->
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="${root}image/TMI_YB.png" type="image/png">
    <title>AI Partner | TMI</title>
    <link rel="stylesheet" href="${root}css/ai.css">
</head>
<body>

<c:import url="/WEB-INF/views/include/topMenu.jsp"/>

<div class="container">
    <div class="chat-box" id="chat-box">
    </div>
    <div class="input-container">
        <textarea class="input-area" id="user-input" placeholder="챗봇에게 질문을 입력하세요..." onkeypress="checkEnter(event)"></textarea>
        <button class="send-btn" onclick="sendMessage()">➔</button>
    </div>
</div>

<script>
    function sendMessage() {
        const userInput = document.getElementById('user-input').value; // 사용자 입력 값 가져오기
        if (!userInput.trim()) {
            return; // 입력이 비어있으면 함수 종료
        }

        // 사용자 입력을 채팅 박스에 추가
        const userMessageDiv = document.createElement('div');
        userMessageDiv.textContent = "사용자: " + userInput;
        document.getElementById('chat-box').appendChild(userMessageDiv);

        // Axios를 사용하여 Node.js 서버에 요청 전송
        axios.post('http://localhost:3000/api/chatbot', {
            message: userInput // JSON 형식으로 데이터 전송
        })
            .then(function(response) {
                // 챗봇의 응답을 채팅 박스에 추가
                const botMessageDiv = document.createElement('div');
                botMessageDiv.textContent = "챗봇: " + response.data.reply;
                document.getElementById('chat-box').appendChild(botMessageDiv);

                // 입력 필드 초기화
                document.getElementById('user-input').value = '';
            })
            .catch(function(error) {
                console.error('Error:', error);
                const errorDiv = document.createElement('div');
                errorDiv.textContent = '처리 중 오류 발생';
                document.getElementById('chat-box').appendChild(errorDiv);
            });
    }

    function checkEnter(event) {
        if (event.key === 'Enter') {
            event.preventDefault(); // 기본 Enter키 동작 방지 (줄바꿈 방지)
            sendMessage(); // 메시지 전송
        }
    }
</script>

<c:import url="/WEB-INF/views/include/bottom.jsp"/>
</body>
</html>
