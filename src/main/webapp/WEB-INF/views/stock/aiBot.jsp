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
      let preloadedReply = null; // 백그라운드에서 미리 받아온 데이터를 저장할 변수
      let dataLoaded = false; // 데이터가 로드되었는지 여부를 확인하는 변수
      const symbol = "${symbol}";

      // 페이지 렌더링 시 API 요청을 백그라운드에서 수행
      fetch('http://localhost:3000/stock/aiChatbot', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ sentimentData: symbol })
      })
              .then(response => response.json())
              .then(data => {
                preloadedReply = data.reply; // 응답 데이터를 변수에 저장
                dataLoaded = true; // 데이터 로드 완료 상태로 변경
                console.log('백그라운드에서 받은 데이터:', preloadedReply);
                $('#loading').hide(); // 로딩 이미지를 숨김
              })
              .catch(error => {
                console.error('데이터 수신 실패:', error);
                preloadedReply = '에러 발생: ' + error.message; // 에러 메시지 저장
                dataLoaded = true;
                $('#loading').hide();
              });

      // 패널과 로딩 이미지는 기본적으로 숨김 처리
      $('#aiBotPanel').hide();

      $('#toggleBotButton').click(function() {
        const $button = $(this); // 현재 버튼 요소 참조

        $('#aiBotPanel').fadeToggle(function() {
          // 패널 상태에 따라 버튼 텍스트를 업데이트
          if ($('#aiBotPanel').is(':visible')) {
            $button.text('X'); // 패널이 보이면 "X"로 변경
            if (dataLoaded) {
              $('#stockRecommendations').text(preloadedReply).fadeIn();
            } else {
              $('#stockRecommendations').text('로딩 중...').fadeIn();
            }
          } else {
            $button.text('주식 분석 AI 박스'); // 패널이 숨겨지면 원래 텍스트로 복원
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

<!-- 로딩 이미지 (기본적으로 숨김 처리) -->
<div id="loading">
  <img src="${root}image/loading.gif" alt="로딩 중..." />
</div>

</body>
</html>
