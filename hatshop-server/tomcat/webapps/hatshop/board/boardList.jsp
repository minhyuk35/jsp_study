<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.hatshop.board.BoardDTO, com.hatshop.board.BoardDAO,
                 com.hatshop.member.MemberDTO, com.hatshop.util.StringUtil,
                 java.util.List" %>
<%
    String CTX = request.getContextPath();
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

    int curPage = 1;
    try { curPage = Integer.parseInt(request.getParameter("page")); }
    catch (Exception ignored) {}
    if (curPage < 1) curPage = 1;

    String keyword = request.getParameter("keyword");
    if (keyword == null) keyword = "";
    keyword = keyword.trim();

    final int PAGE_SIZE  = 10;
    final int BLOCK_SIZE = 5;

    BoardDAO dao = new BoardDAO();
    List<BoardDTO> notices    = dao.getNotices();
    int            totalCount = dao.getCount(keyword);
    int totalPages = (totalCount == 0) ? 1 : (int) Math.ceil((double) totalCount / PAGE_SIZE);
    if (curPage > totalPages) curPage = totalPages;

    List<BoardDTO> list = dao.getList(curPage, PAGE_SIZE, keyword);

    int blockStart = ((curPage - 1) / BLOCK_SIZE) * BLOCK_SIZE + 1;
    int blockEnd   = Math.min(blockStart + BLOCK_SIZE - 1, totalPages);

    String encKeyword = java.net.URLEncoder.encode(keyword, "UTF-8");

    String flashSuccess = (String) session.getAttribute("flashSuccess");
    String flashError   = (String) session.getAttribute("flashError");
    if (flashSuccess != null) session.removeAttribute("flashSuccess");
    if (flashError   != null) session.removeAttribute("flashError");
%>
<%@ include file="/WEB-INF/inc/header.jsp" %>

<style>
  .board-wrap   { max-width: 1000px; margin: 0 auto 40px; padding: calc(var(--header-h) + 40px) 16px 0; }
  .board-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 24px; }
  .page-title   { font-size: 1.6rem; font-weight: 700; color: var(--txt); }

  .search-bar { display: flex; gap: 8px; margin-bottom: 18px; }
  .search-bar input {
    flex: 1; max-width: 340px; background: var(--card);
    border: 1px solid var(--border); color: var(--txt);
    border-radius: var(--r); padding: 9px 14px; font-size: .9rem;
    outline: none; transition: border-color .2s;
  }
  .search-bar input:focus { border-color: var(--accent); }
  .btn-search {
    padding: 9px 20px; background: var(--accent); color: #fff;
    border: none; border-radius: var(--r); font-weight: 600;
    cursor: pointer; font-size: .88rem; transition: opacity .2s;
  }
  .btn-search:hover { opacity: .8; }
  .btn-write {
    padding: 9px 22px; background: transparent;
    border: 1px solid var(--border-dark); color: var(--txt);
    border-radius: var(--r); font-size: .88rem; font-weight: 600;
    text-decoration: none; transition: background .2s, border-color .2s;
  }
  .btn-write:hover { background: var(--bg-sub); border-color: var(--accent); }

  .flash-success {
    background: #f0faf0; border: 1px solid #28a745; color: #1a6b2a;
    padding: 11px 16px; border-radius: var(--r); margin-bottom: 16px; font-size: .9rem;
  }
  .flash-error {
    background: #fff0f0; border: 1px solid #dc3545; color: #a50000;
    padding: 11px 16px; border-radius: var(--r); margin-bottom: 16px; font-size: .9rem;
  }

  .board-table {
    width: 100%; border-collapse: collapse; background: var(--card);
    border-radius: var(--r); overflow: hidden; border: 1px solid var(--border);
  }
  .board-table thead th {
    background: var(--bg-sub); color: var(--txt-3); font-size: .82rem;
    font-weight: 600; padding: 11px 14px; text-align: center;
    border-bottom: 1px solid var(--border);
  }
  .board-table td {
    padding: 12px 14px; border-bottom: 1px solid var(--border);
    vertical-align: middle; font-size: .9rem; color: var(--txt);
  }
  .board-table tr:last-child td { border-bottom: none; }
  .board-table tbody tr:hover td { background: var(--bg-sub); }
  .board-table tbody tr { cursor: pointer; }

  .col-no     { width: 70px;  text-align: center; color: var(--txt-3); white-space: nowrap; }
  .col-type   { width: 60px;  text-align: center; white-space: nowrap; }
  .col-title  { text-align: left; }
  .col-author { width: 100px; text-align: center; color: var(--txt-3); }
  .col-date   { width: 110px; text-align: center; color: var(--txt-3); font-size: .82rem; }
  .col-hit    { width: 60px;  text-align: center; color: var(--txt-3); font-size: .82rem; }

  .notice-row td { background: #fafaf8; }
  .notice-row:hover td { background: #f5f4f0 !important; }

  .badge-notice {
    display: inline-block; padding: 2px 8px;
    background: #111; color: #fff;
    border-radius: 2px; font-size: .72rem; font-weight: 700;
  }

  .title-link { color: var(--txt); text-decoration: none; transition: color .15s; }
  .title-link:hover { color: var(--txt-2); text-decoration: underline; }
  .notice-row .title-link { font-weight: 600; }

  .empty-cell {
    text-align: center; color: var(--txt-3);
    padding: 60px 20px !important; font-size: .9rem;
  }

  .pagination {
    display: flex; justify-content: center; align-items: center;
    gap: 4px; margin-top: 24px; flex-wrap: wrap;
  }
  .page-btn {
    min-width: 36px; height: 36px; display: inline-flex;
    align-items: center; justify-content: center;
    background: var(--card); border: 1px solid var(--border);
    color: var(--txt-2); border-radius: var(--r);
    text-decoration: none; font-size: .85rem;
    transition: all .15s; padding: 0 6px;
  }
  .page-btn:hover  { border-color: var(--accent); color: var(--accent); }
  .page-btn.active { background: var(--accent); border-color: var(--accent); color: #fff; font-weight: 700; }
  .page-btn.nav    { font-size: .8rem; }

  @media (max-width: 640px) {
    .col-author, .col-hit { display: none; }
    .col-no { width: 44px; }
    .col-date { width: 80px; }
  }
</style>

<main class="board-wrap">
  <div class="board-header">
    <h1 class="page-title">게시판</h1>
    <% if (loginUser != null) { %>
    <a href="<%=CTX%>/board/boardWrite.jsp" class="btn-write">글쓰기</a>
    <% } %>
  </div>

  <% if (flashSuccess != null) { %><div class="flash-success"><%=flashSuccess%></div><% } %>
  <% if (flashError   != null) { %><div class="flash-error"><%=flashError%></div><% } %>

  <form method="GET" action="<%=CTX%>/board/boardList.jsp" class="search-bar">
    <input type="text" name="keyword" placeholder="제목 검색..."
           value="<%=StringUtil.escapeHtml(keyword)%>" maxlength="100">
    <button type="submit" class="btn-search">검색</button>
  </form>

  <table class="board-table">
    <thead>
      <tr>
        <th class="col-no">번호</th>
        <th class="col-type">구분</th>
        <th class="col-title">제목</th>
        <th class="col-author">작성자</th>
        <th class="col-date">날짜</th>
        <th class="col-hit">조회</th>
      </tr>
    </thead>
    <tbody>

    <% for (BoardDTO notice : notices) { %>
    <tr class="notice-row" onclick="location.href='<%=CTX%>/board/boardDetail.jsp?boardNo=<%=notice.getBoardNo()%>'">
      <td class="col-no">—</td>
      <td class="col-type"><span class="badge-notice">공지</span></td>
      <td class="col-title">
        <a href="<%=CTX%>/board/boardDetail.jsp?boardNo=<%=notice.getBoardNo()%>" class="title-link" onclick="event.stopPropagation()">
          <%=StringUtil.escapeHtml(notice.getBoardTitle())%>
        </a>
      </td>
      <td class="col-author"><%=StringUtil.escapeHtml(notice.getMemberName() != null ? notice.getMemberName() : notice.getMemberId())%></td>
      <td class="col-date"><%=notice.getShortDate()%></td>
      <td class="col-hit"><%=notice.getBoardHit()%></td>
    </tr>
    <% } %>

    <%
      int rowNum = totalCount - (curPage - 1) * PAGE_SIZE;
      if (list.isEmpty()) {
    %>
    <tr>
      <td colspan="6" class="empty-cell">
        <% if (keyword.isEmpty()) { %>
          등록된 게시글이 없습니다.
        <% } else { %>
          "<strong><%=StringUtil.escapeHtml(keyword)%></strong>" 검색 결과가 없습니다.
        <% } %>
      </td>
    </tr>
    <% } else {
         for (BoardDTO board : list) { %>
    <tr onclick="location.href='<%=CTX%>/board/boardDetail.jsp?boardNo=<%=board.getBoardNo()%>'">
      <td class="col-no"><%=rowNum--%></td>
      <td class="col-type"></td>
      <td class="col-title">
        <a href="<%=CTX%>/board/boardDetail.jsp?boardNo=<%=board.getBoardNo()%>" class="title-link" onclick="event.stopPropagation()">
          <%=StringUtil.escapeHtml(board.getBoardTitle())%>
        </a>
      </td>
      <td class="col-author"><%=StringUtil.escapeHtml(board.getMemberName() != null ? board.getMemberName() : board.getMemberId())%></td>
      <td class="col-date"><%=board.getShortDate()%></td>
      <td class="col-hit"><%=board.getBoardHit()%></td>
    </tr>
    <%   } } %>

    </tbody>
  </table>

  <% if (totalPages > 1) { %>
  <nav class="pagination">
    <% if (blockStart > 1) { %>
    <a href="<%=CTX%>/board/boardList.jsp?page=<%=blockStart-1%>&keyword=<%=encKeyword%>" class="page-btn nav">&#8249; 이전</a>
    <% } %>

    <% for (int i = blockStart; i <= blockEnd; i++) { %>
    <a href="<%=CTX%>/board/boardList.jsp?page=<%=i%>&keyword=<%=encKeyword%>"
       class="page-btn<%=i == curPage ? " active" : ""%>"><%=i%></a>
    <% } %>

    <% if (blockEnd < totalPages) { %>
    <a href="<%=CTX%>/board/boardList.jsp?page=<%=blockEnd+1%>&keyword=<%=encKeyword%>" class="page-btn nav">다음 &#8250;</a>
    <% } %>
  </nav>
  <% } %>

</main>

<%@ include file="/WEB-INF/inc/footer.jsp" %>
