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
<link rel="icon" href="${root}image/TMI_YB.png" type="image/png">
<title>Notice | TMI</title>
<link rel="stylesheet" href="${root }css/boardMain.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<c:import url="/WEB-INF/views/include/topMenu.jsp" />
<div class="primary-container">
    <div class="container">
        <div class="filter-section">
            <select id="boardType">
                <option value="all">전체게시글</option>
                <option value="공지게시판">공지게시판</option>
                <option value="자유게시판">자유게시판</option>
                <option value="고객센터">고객센터 접수</option>
            </select>
            <div class="searchKeyword">
                <input type="text" id="searchKeyword" placeholder="제목 입력" />
                <!-- 검색 버튼은 검색 전용 함수 호출 -->
                <button type="submit" onclick="fetchSearchedBoardList(1)">검색</button>
            </div>
        </div>
        
        <!-- 게시글 테이블 -->
        <table class="board-table">
            <thead>
                <tr>
                    <th>번호</th>
                    <th style="width:10%;">카테고리</th>
                    <th style="width:38%;">제목</th>
                    <th>작성자</th>
                    <th>작성일</th>
                    <th>조회수</th>
                    <th>추천수</th>
                </tr>
            </thead>
            <!-- 공지사항 영역: 서버에서 렌더링하여 항상 상단에 표시 -->
            <tbody id="noticeTbody">
                <c:forEach var="board" items="${noticeList}" varStatus="status">
                    <tr style="background-color: #d0d0d0;">
                        <td style="color: red;">공지</td>
                        <td>${board.type}</td>
                        <td><a href="${root}board/boardRead?board_idx=${board.board_idx}">${board.title}</a></td>
                        <td>관리자</td>
                        <td>${board.write_date}</td>
                        <td>${board.view_count}</td>
                        <td>${board.like_count}</td>
                    </tr>
                </c:forEach>
            </tbody>
            <!-- 일반 게시글 영역: AJAX로 동적으로 업데이트 -->
            <tbody id="boardTbody">
                <!-- AJAX에서 가져온 데이터가 여기에 삽입됩니다. -->
            </tbody>
        </table>
        
        <!-- 페이징 네비게이션 -->
        <div id="pagination" class="pagination"></div>
          
        <button id="writeButton" onclick="location.href='${root}board/boardWrite'" class="write-btn">글쓰기</button>
    </div>
 </div>
    <c:import url="/WEB-INF/views/include/bottom.jsp" />

    <!-- AJAX 및 페이징 처리 스크립트 -->
    <script type="text/javascript">
    $(document).ready(function() {
        var currentPage = 1;
        var pageSize = 10; // 페이지당 항목 수 (필요에 따라 조정)

        // 필터(게시판 타입) 기준 게시글 목록을 가져오는 함수 (전역 노출)
        window.fetchFilteredBoardList = function(page) {
            currentPage = page || 1;
            var boardType = $('#boardType').val();
            $.ajax({
                url: '${root}board/getBoardInfoByType',
                type: 'GET',
                data: { currentPage: currentPage, pageSize: pageSize, type: boardType },
                success: function(response) {
                    updateBoardList(response.list);
                    updatePagination(response.pageBean);
                },
                error: function(xhr, status, error) {
                    console.error("필터 기준 게시글 정보를 가져오는 데 실패했습니다:", error);
                }
            });
        };

        // 검색 기준 게시글 목록을 가져오는 함수 (전역 노출)
        window.fetchSearchedBoardList = function(page) {
            currentPage = page || 1;
            var keyword = $('#searchKeyword').val().trim();
            var boardType = $('#boardType').val();
            $.ajax({
                url: '${root}board/searchBoard',
                type: 'GET',
                data: { currentPage: currentPage, pageSize: pageSize, keyword: keyword, type: boardType },
                success: function(response) {
                    updateBoardList(response.list);
                    updatePagination(response.pageBean);
                },
                error: function(xhr, status, error) {
                    console.error("검색 기준 게시글 정보를 가져오는 데 실패했습니다:", error);
                }
            });
        };

        // 일반 게시글 목록 업데이트 함수 (boardTbody 영역)
        function updateBoardList(list) {
            var rows = '';
            $.each(list, function(index, board) {
                rows += '<tr>';
                // 전체 목록 번호 = (현재페이지-1)*페이지당개수 + index + 1
                rows += '<td>' + ((currentPage - 1) * pageSize + index + 1) + '</td>';
                rows += '<td>' + board.type + '</td>';
                rows += '<td><a href="${root}board/boardRead?board_idx=' + board.board_idx + '">' + board.title + '</a></td>';
                rows += '<td>' + board.member_id + '</td>';
                rows += '<td>' + board.write_date + '</td>';
                rows += '<td>' + board.view_count + '</td>';
                rows += '<td>' + board.like_count + '</td>';
                rows += '</tr>';
            });
            $('#boardTbody').html(rows);
        }

        // 페이징 네비게이션 업데이트 함수
        function updatePagination(pageBean) {
            var paginationHTML = '';
            if(pageBean.currentPage > 1) {
                paginationHTML += '<a href="javascript:void(0);" class="page-link" data-page="' + (pageBean.currentPage - 1) + '">이전</a> ';
            }
            paginationHTML += ' 페이지 ' + pageBean.currentPage + ' / ' + pageBean.totalPage + ' ';
            if(pageBean.currentPage < pageBean.totalPage) {
                paginationHTML += '<a href="javascript:void(0);" class="page-link" data-page="' + (pageBean.currentPage + 1) + '">다음</a>';
            }
            $('#pagination').html(paginationHTML);
        }

        // 페이지 링크 클릭 이벤트 처리
        $('#pagination').on('click', '.page-link', function() {
            var page = $(this).data('page');
            // 검색어가 입력되어 있다면 검색 기준, 없으면 필터 기준 조회
            if($('#searchKeyword').val().trim() !== '') {
                fetchSearchedBoardList(page);
            } else {
                fetchFilteredBoardList(page);
            }
        });

        // 게시판 타입 변경 시: 검색어를 초기화하고 필터 기준 조회 실행
        $('#boardType').on('change', function() {
            $('#searchKeyword').val('');
            fetchFilteredBoardList(1);
        });

        // 검색어 입력 시 Enter 키 처리 (검색 기준 조회)
        $('#searchKeyword').on('keypress', function(e) {
            if (e.which === 13) {
                fetchSearchedBoardList(1);
            }
        });

        // 초기 로딩 시 필터 기준 게시글 목록 조회 (검색어 없음)
        fetchFilteredBoardList(1);
    });

    </script>
</body>
</html>
