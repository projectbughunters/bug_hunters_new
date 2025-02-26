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
<link rel="stylesheet" href="${root}css/exchange.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(document).ready(function() {
    $('#toggleExchangeButton').click(function() {
    	
        const button = $(this);
        $('#exchangePanel').fadeToggle(300, function() { // fadeToggle() 완료 후 실행
            if ($('#exchangePanel').is(':visible')) {
                button.text('X');
            } else {
                button.text('환율 계산기'); // 패널이 완전히 닫힌 후 변경
            }
        });
        
        $('#fromCurrency').on('input', function() {
            let inputValue = $(this).val();

            // 숫자가 아닌 경우 제거 (실수 가능하도록 . 포함 허용)
            if (!/^\d*\.?\d*$/.test(inputValue)) {
                alert("숫자만 입력 가능합니다.");
                $(this).val(inputValue.replace(/[^0-9.]/g, ''));
            }
        });
            
            const currencyForm = $('#currencyForm');
            const fromCurrency = $('#fromCurrency');
            const toCurrency = $('#toCurrency');
            const resultElement = $('#result');

            if (!currencyForm.length || !fromCurrency.length || !toCurrency.length || !resultElement.length) {
                console.error('필수 요소가 없습니다. HTML 구조를 확인하세요.');
                return;
            }

            // 기존 submit 이벤트 핸들러 제거 후 다시 등록 (중복 방지)
            currencyForm.off('submit').on('submit', function(event) { 
                event.preventDefault();

                let amount = fromCurrency.val().trim();
                let toCurrencyValue = toCurrency.val();

                if (!amount || !toCurrencyValue) {
                    alert("금액과 목표 통화를 모두 입력해주세요.");
                    return;
                }

                // 서버에 POST 요청
                $.ajax({
                    url: 'http://localhost:3000/currency',
                    method: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify({
                        amount: parseFloat(amount).toFixed(2),
                        fromCurrency: 'USD', // 원화
                        toCurrency: toCurrencyValue
                    }),
                    dataType: 'json'
                })
                .done(function(data) {
                    if (data.convertedAmount) {
                        const convertedAmount = parseFloat(data.convertedAmount);
                        if (!isNaN(convertedAmount)) {
                            const resultAmount = convertedAmount.toFixed(2);
                            resultElement.text(amount + "$ = " + resultAmount + " " + toCurrencyValue);
                        } else {
                            resultElement.html("<p>환율 계산에 실패했습니다: 잘못된 결과 값</p>");
                        }
                    } else {
                        resultElement.html("<p>환율 계산에 실패했습니다: " + (data.error || '알 수 없는 오류') + "</p>");
                    }
                })
                .fail(function(jqXHR, textStatus, errorThrown) {
                    console.error('서버 오류:', textStatus, errorThrown);
                    resultElement.text('서버 오류가 발생했습니다. 서버 상태를 확인해주세요.');
                });
            });
        
    });
});

</script>
</head>
<body>

<button id="toggleExchangeButton">환율 계산기</button>

	<!-- 환율 계산기 -->
    <div class="calculator-container" id="exchangePanel">
        <h3>환율 계산기</h3>
        <form id="currencyForm">
            <div class="form-group">
                <label for="fromCurrency">달러($) 금액</label>
                <input type="text" id="fromCurrency" name="fromCurrency" placeholder="$ 금액 입력" required>
            </div>
            <div class="form-group">
                <label for="toCurrency">목표 통화</label>
                <select id="toCurrency" name="toCurrency" required>
                    <option value="KRW">원화 (KRW)</option>
                    <option value="EUR">유로 (EUR)</option>
                    <option value="JPY">일본 엔 (JPY)</option>
                    <option value="GBP">영국 파운드 (GBP)</option>
                </select>
            </div>
            <button type="submit">계산하기</button>
        </form>

        <div class="result" id="result"></div>
    </div>

    
</body>
</html>
