<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta name="viewport" content="width=device-width, user-scalable=no">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge">

	<style>
		*{
			margin: 0;
		}
		.top_panel{
			position: absolute;
			width: 100%;
			height: 50px;
			background-color: black;
		}
		.left_panel{
			position: absolute;
			width: 250px;
			background-color: darkgrey;
		}
		.HideFrame {
			left: -50000px;
			top: -50000px;
			position: absolute;
		}
		.VisibleFrame {
			float: left;
			position: relative;
			overflow: hidden;
			left: 0px;
			top: 0px;
			width: 100%;
			height: 100%;
		}
	</style>

<%
	response.setHeader("Pragma","no-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setDateHeader("Expires", 0);

	request.setAttribute("aud7_server_url" , "http://192.168.1.1:8087");
    request.setAttribute("is_ssl" , false);
    request.setAttribute("user_id" , "bughunters");

%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	
</head>
<body>
<script>
	
	window.onload = function() {
		console.log("onload");
		winResizer();
	}
	
	window.addEventListener('resize', function(event){
		winResizer();
	});

	var winResizer = function(){
		console.log('winResizer===');
		var win_w = $(window).eq(0).outerWidth();
		var win_h = $(window).eq(0).outerHeight();

		var top_panel_height = $('.top_panel').outerHeight();
		var left_panel_width = $('.left_panel').outerWidth();

		$('.left_panel').css('height', win_h - top_panel_height);
		$('.left_panel').css('top', top_panel_height);

		$('.main_group').css('height', win_h - top_panel_height);
		$('.main_group').css('top', top_panel_height);
		$('.main_group').css('left', left_panel_width);
		$('.main_group').css('width', win_w - left_panel_width);
		

	}

	var openReport = function(code , isTileShow , iframeId){
		$("#" + iframeId)[0].contentWindow.openReport(code , isTileShow);	
	
		$('.main_group').removeClass('SiteHideFrame').addClass('SiteVisibleFrame');
	}

	function openPopReport(reportCode){
		var winWidth = $( window ).width() - 100;
        var winHeight = $( window ).height() - 100;
		
        //window.open("http://192.168.11.45:9090/examples/embedded/iaudEmbedded.jsp?rCode="+reportCode+"&sTitle=true&audServerUrl=http://192.168.0.83:8083", "reportPop", "width="+winWidth+",height="+ winHeight+",resizable=yes");
		//window.open("http://192.168.0.83:8083/portal/Content.jsp" , "reportPop", "width="+winWidth+",height="+ winHeight+",resizable=yes")
		window.open("http://192.168.1.1:8087/extention/portal/SimpleSSO.jsp?reportCode="+reportCode, "reportPop", "width="+winWidth+",height="+ winHeight+",resizable=yes");
   }

</script>

<div class="top_panel">
</div>

<div class="left_panel">
	<ul>
		<li>
			<div class='rep_div' onclick='openReport("REP4463E55E07C047729CAD7F4143840DC6", true , "REPORT_VIEW")'>희민팀 보고서</div>
		</li>
		<li>
			<div class='rep_div' onclick='openReport("REP5F50B17A5AC4427EA64888D7F444FB03", true,  "REPORT_VIEW")'>[AUD7] Event Test5_List-Grid</div>
		</li>
		<li>
			<div class='rep_div' onclick='openReport("REP78288DEF77384F459384F18FEA72E617", false ,  "REPORT_VIEW")'>[AUD7] Event Test8_MX-Grid</div>
		</li>
		<li>
			<div class='rep_div' onclick='openReport("REPE8A1A0CC379A4467A62E58BE74CEEF90", true ,  "REPORT_VIEW")'>[AUD7] Event Test6_OlapGrid</div>
		</li>
		<li>
			<div class='rep_div' onclick='openReport("REP6CDB152C8EDB425BA448524855F3DE23", true ,  "REPORT_VIEW")'>커피_매출정보</div>
		</li>
		<li>
			<div class='rep_div' onclick='openPopReport("REP7D3F179423564C0CACA0A3411279CBDF" , true ,  "REPORT_VIEW")'>[MX-GRID] 달력 . 팝업으로 열기</div>
		</li>
		<li>
			<div class='rep_div' onclick='openReport("REP89CAE7FA188744C685AF8C589138E031" , true ,  "REPORT_VIEW")'>(i-Meta Viewer)커피 매출 정보2</div>
		</li>
		<li>
			<div class='rep_div' onclick='openReport("REPD538CE402E6E458BABE5A0EFFA199286" , true ,  "REPORT_VIEW")'>HyperLink</div>
		</li>
		<li>
			<div class='rep_div' onclick='openReport("REP992967AD96B74AE5B417E870B861A603" , true ,  "REPORT_VIEW")'>HAN TEST</div>
		</li>	
		<li>
			<div class='rep_div' onclick='openReport("REP4463E55E07C047729CAD7F4143840DC6" , true ,  "REPORT_VIEW")'>D3 차트</div>
		</li>		
	</ul>
</div>

<div class="main_group VisibleFrame">
	<iframe id="REPORT_VIEW" name="REPORT_VIEW"  width="100%" height="100%" frameborder="0"  src="http://localhost:9088/bugHunters_TMI/embedded/iaudEmbedded?audServerUrl=http://192.168.1.1:8087"></iframe>
</div>

</body>
</html>