<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="root" value='${pageContext.request.contextPath }/' />
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>AI Bot | TMI</title>
<link rel="stylesheet" href="${root}css/aiBot.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
	$(document).ready(function() {
		let isLoading = false; // 요청 중인 상태를 저장하는 변수
		let hasRequested = false; // 요청 여부를 저장하는 변수
		
		$('#toggleBotButton').click(async function() {
			$('#aiBotPanel').fadeToggle();
		
			if ($('#aiBotPanel').is(':visible')) {
				
				if ($(this).text() ==='X') {
						$(this).text('주식 분석 AI'); // 'X'를 클릭하면 원래 텍스트로 변경
						$('#aiBotPanel').fadeOut(); // 패널도 닫기
						// hasRequested는 그대로 유지하여, 다시 요청하지 않도록 함
					return; // 더 이상 진행하지 않음
				}else{
					$(this).text('X');
				}
				
				if (hasRequested) return; // 요청을 하지 않고 종료
				
				
				if (isLoading) return; // 이미 요청 중이면 함수 종료

				isLoading = true; // 요청 시작
				$('#loading').show(); // 로딩 이미지 보여주기
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

					// 데이터 출력
					$('#stockRecommendations').text(reply); // 먼저 텍스트만 설정
					hasRequested = true; // 요청 완료 상태로 변경


				} catch (error) {
					console.error('데이터를 가져오는 데 실패했습니다:', error);
					$('#stockRecommendations').html('에러 발생: ' + error.message).fadeIn();
				} finally {
					$('#loading').hide(); // 요청이 끝나면 로딩 이미지 숨기기
					$('#stockRecommendations').fadeIn(); // 모든 내용이 생성된 후에 나타나게 하기
					isLoading = false; // 요청 완료
				}
			} else {
				$(this).text('주식 분석 AI'); // 다시 닫으면 원래 텍스트로 변경
			}
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
	<!-- 로딩 이미지 -->
	<div id="loading">
		<img src="${root}image/loading.gif" alt="로딩 중..." />
	</div>
	

</body>
</html>
