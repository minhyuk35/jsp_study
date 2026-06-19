<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    /* 이미 로그인된 사용자는 메인으로 */
    if (session.getAttribute("loginUser") != null) {
        response.sendRedirect(request.getContextPath() + "/");
        return;
    }

    /* 플래시 메시지 읽기 (1회 표시 후 제거) */
    String flashError   = (String) session.getAttribute("loginError");
    String flashSuccess = (String) session.getAttribute("flashSuccess");
    session.removeAttribute("loginError");
    session.removeAttribute("flashSuccess");

    /* 로그인 후 돌아갈 URL */
    String redirectURL = request.getParameter("redirectURL");
    if (redirectURL == null) redirectURL = "";
%>
<%@ include file="/WEB-INF/inc/header.jsp" %>
<%@ include file="/WEB-INF/inc/nav.jsp" %>

<main class="main-content">
<div class="container">
<div class="form-box" style="max-width:420px">

  <div style="text-align:center;margin-bottom:28px">
    <div style="margin-bottom:8px"><svg class="icon-svg" style="width:2.2em;height:2.2em" viewBox="0 0 24 24"><path d="M4 16c0-4.4 3.6-8 8-8s8 3.6 8 8"/><ellipse cx="12" cy="16" rx="10" ry="2.2"/></svg></div>
    <h2 style="font-size:1.4rem">로그인</h2>
  </div>

  <% if (flashSuccess != null) { %>
  <div class="alert alert-success"><%= flashSuccess %></div>
  <% } %>
  <% if (flashError != null) { %>
  <div class="alert alert-error"><%= flashError %></div>
  <% } %>

  <form action="<%= request.getContextPath() %>/member/loginProc.jsp" method="post"
        onsubmit="return validateLoginForm(this)">

    <input type="hidden" name="redirectURL" value="<%= redirectURL %>">

    <div class="form-group">
      <label for="memberId">아이디</label>
      <input type="text" id="memberId" name="memberId" class="form-control"
             placeholder="아이디 입력" maxlength="20" autocomplete="username" autofocus>
    </div>

    <div class="form-group">
      <label for="memberPw">비밀번호</label>
      <input type="password" id="memberPw" name="memberPw" class="form-control"
             placeholder="비밀번호 입력" autocomplete="current-password">
    </div>

    <button type="submit" class="btn btn-primary" style="width:100%;margin-top:4px">
      로그인
    </button>
  </form>

  <div style="text-align:center;margin-top:20px;font-size:.88rem;color:var(--text-secondary)">
    계정이 없으신가요?
    <a href="<%= request.getContextPath() %>/member/join.jsp"
       style="color:var(--accent)">회원가입</a>
  </div>

</div>
</div>
</main>

<script>
function validateLoginForm(form) {
    if (!form.memberId.value.trim()) {
        alert('아이디를 입력하세요.'); form.memberId.focus(); return false;
    }
    if (!form.memberPw.value) {
        alert('비밀번호를 입력하세요.'); form.memberPw.focus(); return false;
    }
    return true;
}
</script>

<%@ include file="/WEB-INF/inc/footer.jsp" %>
