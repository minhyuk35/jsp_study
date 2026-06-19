<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.hatshop.board.BoardDTO, com.hatshop.board.BoardDAO,
                 com.hatshop.member.MemberDTO, com.hatshop.util.StringUtil" %>
<%
    String CTX = request.getContextPath();
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

    int boardNo = 0;
    try { boardNo = Integer.parseInt(request.getParameter("boardNo")); }
    catch (Exception ignored) {}

    if (boardNo <= 0) {
        response.sendRedirect(CTX + "/board/boardList.jsp");
        return;
    }

    BoardDAO dao = new BoardDAO();

    String sessionKey = "viewed_board_" + boardNo;
    if (session.getAttribute(sessionKey) == null) {
        dao.increaseHit(boardNo);
        session.setAttribute(sessionKey, Boolean.TRUE);
    }

    BoardDTO board = dao.getOne(boardNo);
    if (board == null) {
        session.setAttribute("flashError", "존재하지 않는 게시글입니다.");
        response.sendRedirect(CTX + "/board/boardList.jsp");
        return;
    }

    boolean canEdit = loginUser != null &&
        (loginUser.isAdmin() || loginUser.getMemberId().equals(board.getMemberId()));

    String flashSuccess = (String) session.getAttribute("flashSuccess");
    String flashError   = (String) session.getAttribute("flashError");
    if (flashSuccess != null) session.removeAttribute("flashSuccess");
    if (flashError   != null) session.removeAttribute("flashError");

    String safeContent = StringUtil.nl2br(StringUtil.escapeHtml(board.getBoardContent()));
%>
<%@ include file="/WEB-INF/inc/header.jsp" %>

<style>
  .detail-wrap { max-width: 860px; margin: 0 auto 40px; padding: calc(var(--header-h) + 40px) 16px 0; }

  .nav-bar { display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px; }
  .back-link { color: var(--ink-soft); text-decoration: none; font-size: .88rem; transition: color .15s; }
  .back-link:hover { color: var(--ink); }
  .btn-group { display: flex; gap: 8px; }

  .flash-success { background: #f0faf4; border: 1px solid var(--green); color: var(--green); padding: 11px 16px; border-radius: 4px; margin-bottom: 16px; font-size: .9rem; }
  .flash-error   { background: #fff5f5; border: 1px solid var(--red);   color: var(--red);   padding: 11px 16px; border-radius: 4px; margin-bottom: 16px; font-size: .9rem; }

  .post-card { background: var(--bg); border: 1px solid var(--line); border-radius: 4px; overflow: hidden; }

  .post-header { padding: 24px 28px 20px; border-bottom: 1px solid var(--line); }
  .post-type-badge { display: inline-block; padding: 2px 10px; background: #111; color: #fff; border-radius: 2px; font-size: .75rem; font-weight: 700; margin-bottom: 10px; }
  .post-title { font-size: 1.35rem; font-weight: 700; margin-bottom: 12px; line-height: 1.4; }
  .post-meta  { display: flex; gap: 20px; flex-wrap: wrap; }
  .meta-item  { font-size: .82rem; color: var(--ink-soft); }
  .meta-item strong { color: var(--ink-soft); }

  .post-body  { padding: 28px; min-height: 220px; font-size: .95rem; line-height: 1.8; word-break: break-word; }

  .post-footer { padding: 16px 28px; border-top: 1px solid var(--line); display: flex; justify-content: flex-end; gap: 8px; }

  .btn-edit   { padding: 8px 20px; background: transparent; border: 1px solid var(--line); color: var(--ink-soft); border-radius: 2px; text-decoration: none; font-size: .85rem; transition: all .15s; }
  .btn-edit:hover { border-color: var(--ink); color: var(--ink); }
  .btn-delete { padding: 8px 20px; background: transparent; border: 1px solid var(--red); color: var(--red); border-radius: 2px; cursor: pointer; font-size: .85rem; font-family: inherit; transition: background .15s; }
  .btn-delete:hover { background: #fff5f5; }
  .btn-list   { padding: 8px 20px; background: var(--ink); color: #fff; border: none; border-radius: 2px; text-decoration: none; font-size: .85rem; font-weight: 600; transition: opacity .15s; }
  .btn-list:hover { opacity: .8; }
</style>

<main class="detail-wrap">
  <div class="nav-bar">
    <a href="<%=CTX%>/board/boardList.jsp" class="back-link">← 게시판 목록</a>
  </div>

  <% if (flashSuccess != null) { %><div class="flash-success"><%=flashSuccess%></div><% } %>
  <% if (flashError   != null) { %><div class="flash-error"><%=flashError%></div><% } %>

  <div class="post-card">
    <div class="post-header">
      <% if (board.isNotice()) { %>
      <span class="post-type-badge">공지</span>
      <% } %>
      <h1 class="post-title"><%=StringUtil.escapeHtml(board.getBoardTitle())%></h1>
      <div class="post-meta">
        <span class="meta-item">작성자 <strong><%=StringUtil.escapeHtml(board.getMemberName() != null ? board.getMemberName() : board.getMemberId())%></strong></span>
        <span class="meta-item">작성일 <strong><%=board.getShortDate()%></strong></span>
        <span class="meta-item">조회 <strong><%=board.getBoardHit()%></strong></span>
      </div>
    </div>

    <div class="post-body"><%=safeContent%></div>

    <div class="post-footer">
      <% if (canEdit) { %>
      <a href="<%=CTX%>/board/boardEdit.jsp?boardNo=<%=boardNo%>" class="btn-edit">수정</a>
      <form method="POST" action="<%=CTX%>/board/boardDeleteProc.jsp" id="deleteForm" style="display:inline;">
        <input type="hidden" name="boardNo" value="<%=boardNo%>">
        <button type="button" class="btn-delete" onclick="confirmDelete()">삭제</button>
      </form>
      <% } %>
      <a href="<%=CTX%>/board/boardList.jsp" class="btn-list">목록</a>
    </div>
  </div>
</main>

<%@ include file="/WEB-INF/inc/footer.jsp" %>

<script>
function confirmDelete() {
  if (confirm('정말 삭제하시겠습니까? 삭제 후 복구할 수 없습니다.')) {
    document.getElementById('deleteForm').submit();
  }
}
</script>
