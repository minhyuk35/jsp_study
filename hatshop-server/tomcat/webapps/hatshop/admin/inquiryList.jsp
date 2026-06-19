<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hatshop.member.MemberDTO, com.hatshop.util.HtmlUtils, com.hatshop.util.Logger,
                 com.hatshop.db.DBConn, java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet,
                 java.util.List, java.util.ArrayList" %>
<%
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    if (loginUser == null || !loginUser.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/error/403.jsp"); return;
    }
    String ctx = request.getContextPath();

    String flashSuccess = (String) session.getAttribute("flashSuccess");
    session.removeAttribute("flashSuccess");

    String filter = request.getParameter("status");
    if (filter == null) filter = "";

    List<Object[]> inquiries = new ArrayList<>();
    try {
        Connection conn = DBConn.getConnection();
        StringBuilder sql = new StringBuilder(
            "SELECT inquiry_no, member_id, inquiry_name, inquiry_email, inquiry_title, inquiry_content, inquiry_status, reg_date " +
            "FROM inquiry ");
        if (!filter.isEmpty()) sql.append("WHERE inquiry_status = ? ");
        sql.append("ORDER BY inquiry_no DESC");

        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            if (!filter.isEmpty()) ps.setString(1, filter);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    inquiries.add(new Object[]{
                        rs.getInt("inquiry_no"), rs.getString("member_id"), rs.getString("inquiry_name"),
                        rs.getString("inquiry_email"), rs.getString("inquiry_title"), rs.getString("inquiry_content"),
                        rs.getString("inquiry_status"), rs.getTimestamp("reg_date")
                    });
                }
            }
        }
    } catch (Exception e) {
        Logger.error(this.getClass(), "admin/inquiryList.jsp 조회 오류", e);
    }
%>
<%@ include file="/WEB-INF/inc/header.jsp" %>

<style>
.admin-section { max-width: 1100px; margin: 0 auto; padding: calc(var(--header-h) + 40px) 16px 60px; }
.admin-page-head { display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px; }
.admin-page-head h1 { font-size: 1.25rem; font-weight: 700; }
.admin-breadcrumb { display: flex; align-items: center; gap: 6px; font-size: .82rem; color: var(--ink-soft); margin-bottom: 16px; }
.admin-breadcrumb a:hover { color: var(--accent); }
.filter-tabs { display: flex; gap: 6px; margin-bottom: 18px; flex-wrap: wrap; }
.filter-tab { padding: 7px 16px; border: 1px solid var(--line); border-radius: 20px; font-size: .82rem; text-decoration: none; color: var(--ink-soft); transition: all .15s; }
.filter-tab:hover { border-color: var(--ink); color: var(--ink); }
.filter-tab.active { background: var(--ink); border-color: var(--ink); color: #fff; font-weight: 700; }
.data-table { width: 100%; border-collapse: collapse; font-size: .88rem; }
.data-table th { text-align: left; padding: 11px 14px; background: var(--ph-a); color: var(--ink-soft); font-weight: 600; border-bottom: 1px solid var(--line); font-size: .82rem; white-space: nowrap; }
.data-table td { padding: 11px 14px; border-bottom: 1px solid var(--line); vertical-align: top; }
.data-table tr:last-child td { border-bottom: none; }
.data-table tbody tr:hover td { background: var(--bg-sub); }
.table-card { border: 1px solid var(--line); border-radius: 4px; overflow: hidden; }
.table-summary { padding: 10px 16px; background: var(--bg-sub); border-top: 1px solid var(--line); font-size: .82rem; color: var(--ink-soft); }
.ibadge { display: inline-block; padding: 2px 10px; border-radius: 20px; font-size: .72rem; font-weight: 700; white-space: nowrap; border: 1px solid; }
.ibadge-open     { background: #fffbef; color: #8a6200; border-color: #e8c84a; }
.ibadge-answered { background: #f0faf4; color: var(--green); border-color: #7dcf9e; }
.ibadge-closed   { background: var(--ph-a); color: var(--ink-soft); border-color: var(--line); }
.inq-content    { max-width: 280px; white-space: pre-wrap; word-break: break-word; color: var(--ink-soft); font-size: .85rem; }
.flash-success  { background: #f0faf4; border: 1px solid #7dcf9e; color: #1a6b3a; padding: 11px 16px; border-radius: 4px; margin-bottom: 18px; font-size: .9rem; }
.btn-answer { padding: 6px 14px; background: var(--ink); color: #fff; border: none; border-radius: 2px; font-size: .78rem; text-decoration: none; white-space: nowrap; }
.btn-answer:hover { opacity: .8; }
</style>

<main class="admin-section">

  <nav class="admin-breadcrumb">
    <a href="<%= ctx %>/admin/">대시보드</a>
    <span>›</span>
    <span>고객센터 문의</span>
  </nav>

  <div class="admin-page-head">
    <h1><svg class="icon-svg" viewBox="0 0 24 24"><path d="M3 18v-6a9 9 0 0 1 18 0v6"/><path d="M21 19a2 2 0 0 1-2 2h-1a2 2 0 0 1-2-2v-3a2 2 0 0 1 2-2h3zM3 19a2 2 0 0 0 2 2h1a2 2 0 0 0 2-2v-3a2 2 0 0 0-2-2H3z"/></svg> 고객센터 문의
      <span style="font-size:.85rem;color:var(--ink-soft);font-weight:400"> (총 <%= inquiries.size() %>건)</span>
    </h1>
  </div>

  <% if (flashSuccess != null) { %>
  <div class="flash-success"><%= HtmlUtils.escape(flashSuccess) %></div>
  <% } %>

  <nav class="filter-tabs">
    <a href="<%= ctx %>/admin/inquiryList.jsp" class="filter-tab <%= filter.isEmpty() ? "active" : "" %>">전체</a>
    <a href="<%= ctx %>/admin/inquiryList.jsp?status=OPEN"     class="filter-tab <%= "OPEN".equals(filter) ? "active" : "" %>">대기</a>
    <a href="<%= ctx %>/admin/inquiryList.jsp?status=ANSWERED" class="filter-tab <%= "ANSWERED".equals(filter) ? "active" : "" %>">답변완료</a>
    <a href="<%= ctx %>/admin/inquiryList.jsp?status=CLOSED"   class="filter-tab <%= "CLOSED".equals(filter) ? "active" : "" %>">종료</a>
  </nav>

  <div class="table-card">
    <% if (inquiries.isEmpty()) { %>
    <div style="text-align:center;padding:60px 20px;color:var(--ink-soft)">접수된 문의가 없습니다.</div>
    <% } else { %>
    <table class="data-table">
      <thead>
        <tr>
          <th style="width:50px">No.</th>
          <th style="width:90px">이름</th>
          <th style="width:150px">이메일</th>
          <th style="width:150px">제목</th>
          <th>내용</th>
          <th style="width:90px;text-align:center">상태</th>
          <th style="width:130px">접수일</th>
          <th style="width:80px">관리</th>
        </tr>
      </thead>
      <tbody>
        <% for (Object[] row : inquiries) {
             int inquiryNo = (Integer) row[0];
             String status = (String) row[6];
             String badgeClass, badgeLabel;
             switch (status) {
                 case "ANSWERED": badgeClass = "ibadge-answered"; badgeLabel = "답변완료"; break;
                 case "CLOSED":   badgeClass = "ibadge-closed";   badgeLabel = "종료"; break;
                 default:         badgeClass = "ibadge-open";     badgeLabel = "대기"; break;
             }
        %>
        <tr>
          <td style="color:var(--ink-soft)"><%= inquiryNo %></td>
          <td style="font-weight:600"><%= HtmlUtils.escape((String) row[2]) %></td>
          <td style="color:var(--ink-soft);font-size:.82rem"><%= HtmlUtils.escape((String) row[3]) %></td>
          <td><%= HtmlUtils.escape((String) row[4]) %></td>
          <td class="inq-content"><%= HtmlUtils.escape((String) row[5]) %></td>
          <td style="text-align:center"><span class="ibadge <%= badgeClass %>"><%= badgeLabel %></span></td>
          <td style="color:var(--ink-soft);font-size:.82rem"><%= row[7] != null ? row[7].toString().substring(0, 16) : "" %></td>
          <td><a href="<%= ctx %>/admin/inquiryDetail.jsp?inquiryNo=<%= inquiryNo %>" class="btn-answer"><%= "OPEN".equals(status) ? "답변" : "보기" %></a></td>
        </tr>
        <% } %>
      </tbody>
    </table>
    <div class="table-summary">전체 <%= inquiries.size() %>건</div>
    <% } %>
  </div>

</main>

<%@ include file="/WEB-INF/inc/footer.jsp" %>
