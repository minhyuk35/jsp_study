<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hatshop.member.MemberDTO, com.hatshop.util.HtmlUtils, com.hatshop.util.Logger,
                 com.hatshop.db.DBConn, java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    if (loginUser == null || !loginUser.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/error/403.jsp"); return;
    }
    String ctx = request.getContextPath();

    int inquiryNo = 0;
    try { inquiryNo = Integer.parseInt(request.getParameter("inquiryNo")); } catch (Exception ignored) {}
    if (inquiryNo <= 0) {
        response.sendRedirect(ctx + "/admin/inquiryList.jsp"); return;
    }

    String flashError = (String) session.getAttribute("flashError");
    session.removeAttribute("flashError");

    String memberId = null, name = null, email = null, title = null, content = null, answer = null, status = null;
    java.sql.Timestamp regDate = null, answerDate = null;
    boolean found = false;

    try {
        Connection conn = DBConn.getConnection();
        String sql = "SELECT member_id, inquiry_name, inquiry_email, inquiry_title, inquiry_content, inquiry_answer, " +
                     "inquiry_status, reg_date, answer_date FROM inquiry WHERE inquiry_no = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, inquiryNo);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    found = true;
                    memberId = rs.getString("member_id");
                    name = rs.getString("inquiry_name");
                    email = rs.getString("inquiry_email");
                    title = rs.getString("inquiry_title");
                    content = rs.getString("inquiry_content");
                    answer = rs.getString("inquiry_answer");
                    status = rs.getString("inquiry_status");
                    regDate = rs.getTimestamp("reg_date");
                    answerDate = rs.getTimestamp("answer_date");
                }
            }
        }
    } catch (Exception e) {
        Logger.error(this.getClass(), "admin/inquiryDetail.jsp 조회 오류: inquiryNo=" + inquiryNo, e);
    }

    if (!found) {
        session.setAttribute("flashError", "존재하지 않는 문의입니다.");
        response.sendRedirect(ctx + "/admin/inquiryList.jsp");
        return;
    }
%>
<%@ include file="/WEB-INF/inc/header.jsp" %>

<style>
.admin-section { max-width: 760px; margin: 0 auto; padding: calc(var(--header-h) + 40px) 16px 60px; }
.admin-breadcrumb { display: flex; align-items: center; gap: 6px; font-size: .82rem; color: var(--ink-soft); margin-bottom: 16px; }
.admin-breadcrumb a:hover { color: var(--accent); }
.page-title { font-size: 1.25rem; font-weight: 700; margin-bottom: 20px; }
.info-card  { background: var(--bg); border: 1px solid var(--line); border-radius: 4px; padding: 22px 26px; margin-bottom: 18px; }
.card-title { font-size: .95rem; font-weight: 700; margin-bottom: 14px; padding-bottom: 10px; border-bottom: 1px solid var(--line); display: flex; justify-content: space-between; align-items: center; }
.info-grid  { display: grid; grid-template-columns: 90px 1fr; gap: 9px 16px; font-size: .88rem; margin-bottom: 16px; }
.info-key   { color: var(--ink-soft); }
.inq-body   { white-space: pre-wrap; word-break: break-word; line-height: 1.6; font-size: .9rem; padding-top: 10px; border-top: 1px solid var(--line); }
.ibadge { display: inline-block; padding: 3px 10px; border-radius: 20px; font-size: .75rem; font-weight: 700; border: 1px solid; }
.ibadge-open     { background: #fffbef; color: #8a6200; border-color: #e8c84a; }
.ibadge-answered { background: #f0faf4; color: var(--green); border-color: #7dcf9e; }
.ibadge-closed   { background: var(--ph-a); color: var(--ink-soft); border-color: var(--line); }
.answer-box { background: #f9f8f6; border: 1px solid var(--line); border-radius: 4px; padding: 16px 20px; white-space: pre-wrap; word-break: break-word; font-size: .89rem; line-height: 1.6; }
textarea#answerContent { width: 100%; background: var(--bg); border: 1px solid var(--line); color: var(--ink); border-radius: 2px; padding: 12px 14px; font-size: .9rem; font-family: inherit; outline: none; resize: vertical; min-height: 140px; box-sizing: border-box; }
textarea#answerContent:focus { border-color: var(--ink); }
.btn-submit-answer { margin-top: 12px; padding: 11px 24px; background: var(--ink); color: #fff; border: none; border-radius: 2px; font-size: .88rem; font-weight: 700; cursor: pointer; font-family: inherit; }
.btn-submit-answer:hover { opacity: .8; }
.back-link { color: var(--ink-soft); text-decoration: none; font-size: .85rem; }
.back-link:hover { color: var(--ink); }
.flash-error { background: #fff5f5; border: 1px solid var(--red); color: var(--red); padding: 11px 16px; border-radius: 4px; margin-bottom: 18px; font-size: .9rem; }
</style>

<main class="admin-section">
  <nav class="admin-breadcrumb">
    <a href="<%= ctx %>/admin/">대시보드</a>
    <span>›</span>
    <a href="<%= ctx %>/admin/inquiryList.jsp">고객센터 문의</a>
    <span>›</span>
    <span>#<%= inquiryNo %></span>
  </nav>

  <h1 class="page-title">문의 상세 #<%= inquiryNo %></h1>

  <% if (flashError != null) { %><div class="flash-error"><%= HtmlUtils.escape(flashError) %></div><% } %>

  <div class="info-card">
    <div class="card-title">
      <span>문의 내용</span>
      <%
        String badgeClass, badgeLabel;
        switch (status) {
            case "ANSWERED": badgeClass = "ibadge-answered"; badgeLabel = "답변완료"; break;
            case "CLOSED":   badgeClass = "ibadge-closed";   badgeLabel = "종료"; break;
            default:         badgeClass = "ibadge-open";     badgeLabel = "대기"; break;
        }
      %>
      <span class="ibadge <%= badgeClass %>"><%= badgeLabel %></span>
    </div>
    <div class="info-grid">
      <span class="info-key">이름</span><span><%= HtmlUtils.escape(name) %></span>
      <span class="info-key">이메일</span><span><%= HtmlUtils.escape(email) %></span>
      <span class="info-key">회원ID</span><span><%= memberId != null ? HtmlUtils.escape(memberId) : "비회원" %></span>
      <span class="info-key">제목</span><span><%= HtmlUtils.escape(title) %></span>
      <span class="info-key">접수일</span><span><%= regDate != null ? regDate.toString().substring(0,16) : "" %></span>
    </div>
    <div class="inq-body"><%= HtmlUtils.escape(content) %></div>
  </div>

  <% if (answer != null) { %>
  <div class="info-card">
    <div class="card-title">
      <span>관리자 답변</span>
      <span style="font-size:.78rem;color:var(--ink-soft);font-weight:400"><%= answerDate != null ? answerDate.toString().substring(0,16) : "" %></span>
    </div>
    <div class="answer-box"><%= HtmlUtils.escape(answer) %></div>
  </div>
  <% } %>

  <div class="info-card">
    <div class="card-title"><span><%= answer != null ? "답변 수정" : "답변 작성" %></span></div>
    <form method="POST" action="<%= ctx %>/admin/inquiryAnswerProc.jsp">
      <input type="hidden" name="inquiryNo" value="<%= inquiryNo %>">
      <textarea id="answerContent" name="answerContent" maxlength="3000" placeholder="답변 내용을 입력하세요."><%= answer != null ? HtmlUtils.escape(answer) : "" %></textarea>
      <div style="display:flex;gap:8px;flex-wrap:wrap">
        <button type="submit" class="btn-submit-answer" onclick="return confirm('답변을 등록하시겠습니까?')"><%= answer != null ? "답변 수정" : "답변 등록" %></button>
        <% if (!"CLOSED".equals(status)) { %>
        <button type="submit" name="closeTicket" value="1" class="btn-submit-answer" style="background:var(--ink-soft)" onclick="return confirm('이 문의를 종료 처리하시겠습니까?')">답변 후 종료 처리</button>
        <% } %>
      </div>
    </form>
  </div>

  <a href="<%= ctx %>/admin/inquiryList.jsp" class="back-link">← 목록으로</a>
</main>

<%@ include file="/WEB-INF/inc/footer.jsp" %>
