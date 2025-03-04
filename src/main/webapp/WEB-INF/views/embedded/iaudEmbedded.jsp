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
		#AUDview{
			position: absolute;
			width: 100%;
			height: 100%;
		}
		.rep_div{
			cursor: pointer;
			font-size: 14px;
			font-weight: bold;
		}	
	</style>

<%@ page import="com.matrix.service.TokenService" %>
<%@ page import="com.matrix.service.AudSessionService" %>
<%@ page import="java.util.*" %>
<%
	response.setHeader("Pragma","no-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setDateHeader("Expires", 0);

	/*********************************************
	 * 사용자 설정 영역
	 * serverUrl: AUD7 플랫폼 matrix 서버 주소 (사이트별로 상이하다)
	 * user_id : 임베디드 시 연동할 유저코드
	 * is_ssl : serverUrl이 https 인 경우에 true로 설정
	 **********************************************/
	String serverUrl = request.getParameter("audServerUrl") ;
	if (serverUrl == null || serverUrl == ""){
		out.print("audServerUrl check .. ");
		return;
	}
	/*********************************************
	 * 사용자 코드에 대한 커스텀 방법
	 * userCode : 사이트에서 userCode를 확인할 수 있는 정보 (ex:암호화된 key 등)
	 * 자체적은 sso 모듈을 통해 전달한 userCode를 복호화 처리 하여 AUD7플랫폼에 등록된 평문 userCode르 설정한다.
	 **********************************************/
	String userCode = request.getParameter("userCode") != null ? request.getParameter("userCode") : "bughunters";

	System.out.println("serverUrl: " + serverUrl);
	
	String rCode = request.getParameter("rCode");
	String showTitle = request.getParameter("sTitle");
    request.setAttribute("aud7_server_url" , serverUrl);
    request.setAttribute("is_ssl" , false);
    request.setAttribute("user_id" , userCode);
	//0. 쿠키에 AUD7 인증 token이 존재하는지 확인한다.

	//1. AUD7 플랫폼용 token을 발생한다.
	String aud7Token = null;
	try{
		aud7Token = new TokenService().execute(request , response);
		System.out.println("aud7Token: " + aud7Token);
	}catch(Exception e){
		out.print(e.getMessage());
		return;
	}
    
	//2. 인증정보에 저장된 path 일부 항목을 조회하여 script를 import 한다.
	request.setAttribute("token" , aud7Token);
    Map<String , String> audSessionInfo = new AudSessionService().execute(request , response);
    String AUD7_FULL_PATH = audSessionInfo.get("AUD7_FULL_PATH") ; 
    String AUD7_SKIN_CSS_PATH = audSessionInfo.get("AUD7_SKIN_CSS_PATH");
    String CUSTOM_PARAM = audSessionInfo.get("CUSTOM_PARAM");
	String PORTAL_THEME_CSS_PATH = audSessionInfo.get("PORTAL_THEME_CSS_PATH");
	
%>
<!-- i-AUD 보고서를 임베디드 할 때 적용시킬 AUD7 플랫폼용 소스 import -->

<script type="text/javascript" src="<%=AUD7_FULL_PATH%>/js/lib/audframework/release/bimatrix.lib.audframework.js"></script>
<script type="text/javascript" src="<%=AUD7_FULL_PATH%>/js/lib/audframework/release/bimatrix.module.audframework.js"></script>
<link rel="stylesheet" type="text/css" href="<%=AUD7_SKIN_CSS_PATH%>/bimatrix.module.audframework.css">

<!-- i-AUD 보고서 버튼 영역을 표현할 때 적용시킬 AUD7 플랫폼용 소스 import -->
<link rel="stylesheet" type="text/css" href="<%=serverUrl%>/portal/css/theme1/theme.css" />
<script type="text/javascript" src="<%=serverUrl%>/portal/js/jquery-3.6.0.min.js" flush="false">
<script type="text/javascript" src="<%=serverUrl%>/portal/js/Base64.js"></script>
<script type="text/javascript" src="<%=serverUrl%>/portal/js/jquery.portal.common.js"></script>
<script type="text/javascript" src="<%=serverUrl%>/portal/js/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=serverUrl%>/portal/js/authorityCheck_em.jsp"></script>
<script type="text/javascript" src="<%=serverUrl%>/portal/js/portal.message.jsp"></script>
<script type="text/javascript" src="<%=serverUrl%>/portal/js/portal.option.data.jsp"></script>
<script type="text/javascript" src="<%=serverUrl%>/portal/js/portal.content.top.js"></script>
<script type="text/javascript" src="<%=serverUrl%>/portal/js/matrix.script.comm.js"></script>
<script type="text/javascript" src="<%=serverUrl%>/portal/js/matrix.script.content.em.js"></script>
<script type="text/javascript" src="<%=serverUrl%>/portal/js/portal.content.bookmark.js"></script>
<script type="text/javascript" src="<%=serverUrl%>/portal/js/portal.content.condition.js"></script>
<!-- 폰트 적용 부분 추가 -->
<script type="text/javascript" src="<%=serverUrl%>/extention/AUD/customscript.jsp"></script>

<!-- i-AUD 보고서를 임베디드 할 때 init 설정 -->
<script type="text/javascript">
    var AUD7_PATH = "<%=AUD7_FULL_PATH%>";

	var AUD7_SETTING_PATH = "<%=AUD7_FULL_PATH%>";
	var globalParam = <%=CUSTOM_PARAM%> ;
	var gvWebRootName = "<%=serverUrl%>";
	var currUserId = "<%=userCode%>";
	var ispopupView = true;
	
	//GFN_AUTHORITY.USER_AUTH_INFO();

	var reportCode = "<%=rCode%>"; // 오픈할 보고서 코드
	var showTitle = false; // title , 버튼 영역 표시 여부
	if ("<%=showTitle%>" == "true")
		showTitle = true;

</script>
	
</head>
<body>
<script>
	$(document).ready(function(){

	});
	
	window.onload = function() {
		//console.log("onload");
		var biAccessToken = "<%=aud7Token%>";
		GFN_AUTHORITY.setCookie("bimatrix_accessToken" , biAccessToken)
		// 인증 자동 연장
		GFN_AUTHORITY.UpdateSession();
		//console.log("===bi:"+gfnGetCookie("bimatrix_accessToken"));
		// 리사이징
		winResizer();
		if (reportCode != "null")
			openReport(reportCode , showTitle);
	}

	var winResizer = function(){
		var win_w = $(window).eq(0).outerWidth();
		var win_h = $(window).eq(0).outerHeight();

		var title_panel_height = $('.titlebg').outerHeight();
		var isHidden = $('.titlebg').css("display") === "none";
		if (isHidden)
			title_panel_height = 0;

		$('.view_panel').css('height', win_h);
		$('.view_panel').css('width', win_w );

		$('#AUDview').css('height', win_h - title_panel_height);
	}
	

	/**
	 * resize 함수 호출 시 i-AUD 보고서를 리사이징 시킬 때 추가해줘야 할 함수
	 **/
	window.addEventListener('resize', function(event){
		winResizer();
		AUD.GetMainViewer().ViewerSizeChanged();
	});

	
	/**
	 * i-AUD 보고서 오픈
	 **/
	var openReport = function(_reportCode , isShow){
		reportCode = _reportCode;
		if (!GFN_AUTHORITY.CheckSession()){
			//alert("AUD7 Platform auth invalid. page refresh....");
			location.reload();
			return ;
		}

		GFN_AUTHORITY.USER_AUTH_INFO();

		if (isShow){
			var btn_type = "";
			if (GFN_OPTION.OP04_VIEW_BTN=='TEXT') btn_type = "text_type";
			else if(GFN_OPTION.OP04_VIEW_BTN=='IMAGE') btn_type = "img_type";

			$('.topbtn_group').option_top('view_btn', {'btn_type': btn_type, 'callbackFn': settingTitle, 'embedded':true});
		}else{
			$('.titlebg').css('display','none');
		}
					
		AUD.Init(AudOpenReport);
		
	}

	/**
	 * i-AUD 보고서 오픈에 필요한 Init용 함수.
	 * AUD.LoadDocument ('div id명' , 보고서코드 , 2) ;
	 **/
	var AudOpenReport = function() {
		AUD.SetFileDialogCallback();
		AUD.LoadDocument('AUDview', reportCode, 2);

		if (globalParam.length > 0)
    		AUD.SetCustomParams(<%=CUSTOM_PARAM%>);
	}

	var settingTitle = function() {
		$('.titlebg').css('display','');
		$('.topbtn_group').option_top('setting_title', {'report_code': reportCode});
	}

	function sendSearchSccParam(statsDe, pdTy, groupbyUnit, emoTy, keyword, keywordTy){
		//console.log("sendSearchSccParam");
		var rtn = window.parent.searchSccDocList(statsDe, pdTy, groupbyUnit, emoTy, keyword, keywordTy);
		//console.log("SCC Result: "+rtn);
	}
	
	function sendSearchEidParam(srchfrmlaNo, keyword, keywordTy, histNo){
		var pdBgnde;
		var pdEndde;
		console.log(histNo, "================", biAccessToken)
		if(histNo!=null){
			$.ajax( {
				url : "${pageContext.request.contextPath}/dashboard/selectPdIssue.json",
				type : "POST",
				async : false,
				header : {'bimatrix_accessToken' : biAccessToken},
				data : {"srchfrmlaNo":srchfrmlaNo,"histNo":histNo},
				success : function(rs) {
					for(var i=0;i<rs.pdIssueList.length;i++){
						pdBgnde=rs.pdIssueList[i].pdBgnde.substring(0,4)+rs.pdIssueList[i].pdBgnde.substring(5,7)+rs.pdIssueList[i].pdBgnde.substring(8,10);
						pdEndde=rs.pdIssueList[i].pdEndde.substring(0,4)+rs.pdIssueList[i].pdEndde.substring(5,7)+rs.pdIssueList[i].pdEndde.substring(8,10);
					}
				},
				error : function(xhr) {
					//console.log("ERROR");
				}
			});
		}
		
		if(keyword!='' && keywordTy!=''){
			if(histNo!=0) var rtn = window.parent.searchEidDocList(srchfrmlaNo, keyword, keywordTy, '1', pdBgnde, pdEndde);
			else var rtn = window.parent.searchEidDocList(srchfrmlaNo, keyword, keywordTy, '1');
			//console.log("EID Result: "+rtn);
		}
	}

</script>
<div class="view_panel">
	<div class="titlebg" id="titlebg_main" style="display:none;">
		<div class="title_area">
			<ul><li><span id="dvReportName"></span></li></ul>
		</div><!-- title_area -->
		<div class="bookmark" id="bookmarkIcon" style="display:none;"></div>
		<!-- 현재 경로표시 영역 -->
		<div class="location" style="display:block;"></div>
		<div class="topbtn_group"></div>
	</div><!--// titlebg -->
	<div id="AUDview" name="AUDview" class="istudio-common-viewer"></div>
</div>
</body>
</html>