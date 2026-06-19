<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.hatshop.member.MemberDTO" %>
<%
    String CTX = request.getContextPath();
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

    if (loginUser == null) {
        session.setAttribute("flashError", "로그인이 필요합니다.");
        response.sendRedirect(CTX + "/member/login.jsp?redirectURL=" +
            java.net.URLEncoder.encode("/board/boardWrite.jsp", "UTF-8"));
        return;
    }

    String flashError = (String) session.getAttribute("flashError");
    if (flashError != null) session.removeAttribute("flashError");
%>
<%@ include file="/WEB-INF/inc/header.jsp" %>

<style>
  .write-wrap { max-width: 800px; margin: 0 auto 40px; padding: calc(var(--header-h) + 40px) 16px 0; }
  .page-header { display: flex; align-items: center; gap: 16px; margin-bottom: 28px; }
  .back-link { color: var(--ink-soft); text-decoration: none; font-size: .88rem; transition: color .15s; }
  .back-link:hover { color: var(--ink); }
  .page-title { font-size: 1.5rem; font-weight: 800; }

  .write-card { background: var(--bg); border: 1px solid var(--line); border-radius: 4px; padding: 28px 32px; }

  .form-row  { margin-bottom: 20px; }
  .form-row label { display: block; font-size: 11px; font-weight: 700; letter-spacing: .1em; text-transform: uppercase; color: var(--ink-soft); margin-bottom: 7px; }
  .form-row label span.req { color: var(--red); margin-left: 3px; }
  .form-row input[type="text"],
  .form-row select,
  .form-row textarea {
    width: 100%; background: var(--bg); border: 1px solid var(--line);
    color: var(--ink); border-radius: 2px; padding: 10px 14px;
    font-size: .95rem; font-family: inherit; outline: none; transition: border-color .2s; box-sizing: border-box;
  }
  .form-row input:focus, .form-row select:focus, .form-row textarea:focus { border-color: var(--ink); }
  .form-row textarea { resize: vertical; min-height: 300px; line-height: 1.6; }
  .field-error { display: block; color: var(--red); font-size: .8rem; margin-top: 5px; }

  .char-count { font-size: .78rem; color: var(--ink-soft); float: right; margin-top: 4px; }

  .btn-row { display: flex; gap: 10px; margin-top: 24px; }
  .btn-submit { flex: 1; padding: 13px; background: var(--ink); color: #fff; font-weight: 700; border: none; border-radius: 2px; cursor: pointer; font-size: .95rem; font-family: inherit; transition: opacity .2s; }
  .btn-submit:hover { opacity: .8; }
  .btn-cancel { flex: 0 0 120px; padding: 13px; background: transparent; border: 1px solid var(--line); color: var(--ink-soft); border-radius: 2px; text-align: center; text-decoration: none; font-size: .9rem; transition: border-color .2s, color .2s; }
  .btn-cancel:hover { border-color: var(--ink); color: var(--ink); }

  .flash-error { background: #fff5f5; border: 1px solid var(--red); color: var(--red); padding: 11px 16px; border-radius: 4px; margin-bottom: 20px; font-size: .9rem; }
</style>

<main class="write-wrap">
  <div class="page-header">
    <a href="<%=CTX%>/board/boardList.jsp" class="back-link">← 게시판</a>
    <h1 class="page-title">글쓰기</h1>
  </div>

  <% if (flashError != null) { %>
  <div class="flash-error"><%=flashError%></div>
  <% } %>

  <div class="write-card">
    <form method="POST" action="<%=CTX%>/board/boardWriteProc.jsp" id="writeForm">

      <% if (loginUser.isAdmin()) { %>
      <div class="form-row">
        <label for="boardType">게시글 유형 <span style="color:var(--ink-soft);font-size:.78rem;">(관리자)</span></label>
        <select id="boardType" name="boardType">
          <option value="NORMAL">일반</option>
          <option value="NOTICE">공지</option>
        </select>
      </div>
      <% } %>

      <div class="form-row">
        <label for="boardTitle">제목 <span class="req">*</span></label>
        <input type="text" id="boardTitle" name="boardTitle" maxlength="200"
               placeholder="제목을 입력하세요" autocomplete="off">
        <span class="field-error" id="err-title"></span>
      </div>

      <div class="form-row">
        <label for="boardContent">내용 <span class="req">*</span></label>
        <textarea id="boardContent" name="boardContent" maxlength="10000"
                  placeholder="내용을 입력하세요"></textarea>
        <span class="char-count" id="charCount">0 / 10,000</span>
        <span class="field-error" id="err-content"></span>
      </div>

      <div class="btn-row">
        <a href="<%=CTX%>/board/boardList.jsp" class="btn-cancel">취소</a>
        <button type="submit" class="btn-submit">등록하기</button>
      </div>
    </form>
  </div>
</main>

<%@ include file="/WEB-INF/inc/footer.jsp" %>

<script>
(function () {
  var titleInput  = document.getElementById('boardTitle');
  var contentArea = document.getElementById('boardContent');
  var charCountEl = document.getElementById('charCount');

  contentArea.addEventListener('input', function () {
    var len = this.value.length;
    charCountEl.textContent = len.toLocaleString() + ' / 10,000';
    charCountEl.style.color = len > 9000 ? 'var(--red)' : '';
  });

  document.getElementById('writeForm').addEventListener('submit', function (e) {
    var ok = true;
    function err(id, msg) { document.getElementById(id).textContent = msg; ok = false; }
    function clr(id)      { document.getElementById(id).textContent = ''; }

    clr('err-title'); clr('err-content');

    var title   = titleInput.value.trim();
    var content = contentArea.value.trim();

    if (!title)              err('err-title',   '제목을 입력해주세요.');
    else if (title.length > 200) err('err-title', '제목은 200자 이하로 입력해주세요.');
    if (!content)            err('err-content', '내용을 입력해주세요.');

    if (!ok) e.preventDefault();
  });
})();
</script>
