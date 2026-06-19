<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hatshop.board.*,com.hatshop.member.MemberDTO,java.util.*" %>
<%
    int curPage = 1;
    try { curPage = Integer.parseInt(request.getParameter("page")); } catch (Exception e) {}
    int pageSize = 15;
    BoardDAO dao = new BoardDAO();
    List<BoardDTO> list = dao.getList(curPage, pageSize);
    int total = dao.getCount();
    int totalPage = (int) Math.ceil((double) total / pageSize);
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    String ctx = request.getContextPath();
%>
<%@ include file="/WEB-INF/inc/header.jsp" %>
<%@ include file="/WEB-INF/inc/nav.jsp" %>
<main class="main-content">
    <div class="container">
        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px">
            <h2>자유게시판 <small style="font-size:.7em;color:#888">(총 <%= total %>개)</small></h2>
            <% if (loginUser != null) { %>
            <a href="<%= ctx %>/board/write.jsp" class="btn btn-primary btn-sm">글쓰기</a>
            <% } %>
        </div>
        <table class="table">
            <thead><tr><th style="width:60px">번호</th><th>제목</th><th style="width:120px">작성자</th><th style="width:90px">조회</th><th style="width:120px">날짜</th></tr></thead>
            <tbody>
            <% if (list.isEmpty()) { %>
            <tr><td colspan="5" style="text-align:center;padding:40px;color:#888">게시글이 없습니다.</td></tr>
            <% } else {
                for (BoardDTO b : list) { %>
            <tr>
                <td><%= b.getBoardId() %></td>
                <td><a href="<%= ctx %>/board/detail.jsp?boardId=<%= b.getBoardId() %>"><%= b.getTitle() %></a></td>
                <td><%= b.getMemberId() %></td>
                <td><%= b.getViewCount() %></td>
                <td><%= b.getRegDate() %></td>
            </tr>
            <% } } %>
            </tbody>
        </table>
        <div class="pagination">
            <% for (int i = 1; i <= totalPage; i++) { %>
                <a href="?page=<%= i %>" class="<%= (i == curPage) ? "active" : "" %>"><%= i %></a>
            <% } %>
        </div>
    </div>
</main>
<%@ include file="/WEB-INF/inc/footer.jsp" %>
