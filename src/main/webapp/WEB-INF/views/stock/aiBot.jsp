<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="root" value='${pageContext.request.contextPath }/' />
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Take Money Information | TMI</title>
<link rel="stylesheet" href="${root}css/aiBot.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
	$(document).ready(function() {
		$('#toggleBotButton').click(async function() {
			const toggleButton = $(this);
			$('#aiBotPanel').fadeToggle(300, function() {
			if ($('#aiBotPanel').is(':visible')) {
				toggleButton.text('X');
				try {
					const symbol = "${symbol}";
					// Node.js API 호출 (POST 요청)
					const response = await fetch('http://localhost:3000/stock/aiChatbot', {
						method: 'POST',
						headers: {
							'Content-Type': 'application/json'
						},
						body: JSON.stringify({ sentimentData: symbol })
					});

					const data = await response.json();
					console.log('받은 데이터:', data); // 확인용 로그
					let reply = data.reply; // GPT의 응답 데이터

					//데이터 출력
					$('#stockRecommendations').text(reply).fadeIn();

				} catch (error) {
					console.error('데이터를 가져오는 데 실패했습니다:', error);
					$('#stockRecommendations').html('에러 발생: ' + error.message).fadeIn();
				}
			}else{
				toggleButton.text('주식 분석 AI');//다시 닫으면 원래 텍스트로 변경
			}
			});
		});
	});
</script>
</head>
<body>

	<button id="toggleBotButton">주식 분석 AI 박스</button>

	<div id="aiBotPanel">
		<h2>주식 뉴스감성분석 AI</h2>
		<p>AI가 분석한 주식의 감성분석결과를 알려드립니다!</p>
		<div id="stockRecommendations"></div>
	</div>

</body>
</html>
