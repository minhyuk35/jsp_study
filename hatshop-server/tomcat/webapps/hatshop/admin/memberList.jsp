<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hatshop.member.MemberDTO, com.hatshop.member.MemberDAO,
                 com.hatshop.util.HtmlUtils, java.util.List" %>
<%
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    if (loginUser == null || !loginUser.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/error/403.jsp"); return;
    }
    String ctx = request.getContextPath();
    List<MemberDTO> members = new MemberDAO().getAll();
%>
<%@ include file="/WEB-INF/inc/header.jsp" %>

<style>
.admin-section { max-width: 1100px; margin: 40px auto; padding: 0 16px 60px; }
.admin-page-head { display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px; }
.admin-page-head h1 { font-size: 1.25rem; font-weight: 700; }
.admin-breadcrumb { display: flex; align-items: center; gap: 6px; font-size: .82rem; color: var(--ink-soft); margin-bottom: 16px; }
.admin-breadcrumb a:hover { color: var(--accent); }
.data-table { width: 100%; border-collapse: collapse; font-size: .88rem; }
.data-table th { text-align: left; padding: 11px 14px; background: var(--ph-a); color: var(--ink-soft); font-weight: 600; border-bottom: 1px solid var(--line); font-size: .82rem; }
.data-table td { padding: 11px 14px; border-bottom: 1px solid var(--line); vertical-align: middle; }
.data-table tr:last-child td { border-bottom: none; }
.data-table tbody tr:hover td { background: var(--bg-sub); }
.table-card { border: 1px solid var(--line); border-radius: 4px; overflow: hidden; }
.table-summary { padding: 10px 16px; background: var(--bg-sub); border-top: 1px solid var(--line); font-size: .82rem; color: var(--ink-soft); }
.badge-admin  { display: inline-block; padding: 2px 8px; background: var(--ink); color: #fff; border-radius: 2px; font-size: .72rem; font-weight: 700; white-space: nowrap; }
.badge-normal { display: inline-block; padding: 2px 8px; background: var(--ph-a); color: var(--ink-soft); border-radius: 2px; font-size: .72rem; white-space: nowrap; }
</style>

<main class="main-content">
<div class="container">
<div class="admin-section">

  <nav class="admin-breadcrumb">
    <a href="<%= ctx %>/admin/">대시보드</a>
    <span>›</span>
    <span>회원 관리</span>
  </nav>

  <div class="admin-page-head">
    <h1><svg class="icon-svg" viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg> 회원 관리
      <span style="font-size:.85rem;color:var(--ink-soft);font-weight:400"> (총 <%= members.size() %>명)</span>
    </h1>
  </div>

  <div class="table-card">
    <% if (members.isEmpty()) { %>
    <div style="text-align:center;padding:60px 20px;color:var(--ink-soft)">등록된 회원이 없습니다.</div>
    <% } else { %>
    <table class="data-table">
      <thead>
        <tr>
          <th style="width:110px">아이디</th>
          <th style="width:90px">이름</th>
          <th>이메일</th>
          <th style="width:130px">전화번호</th>
          <th style="width:80px;text-align:center">등급</th>
          <th style="width:140px">가입일</th>
        </tr>
      </thead>
      <tbody>
        <% for (MemberDTO m : members) { %>
        <tr>
          <td style="font-weight:600"><%= HtmlUtils.escape(m.getMemberId()) %></td>
          <td><%= HtmlUtils.escape(m.getMemberName() != null ? m.getMemberName() : "") %></td>
          <td style="color:var(--ink-soft)"><%= HtmlUtils.escape(m.getEmail() != null ? m.getEmail() : "") %></td>
          <td style="color:var(--ink-soft)"><%= HtmlUtils.escape(m.getPhone() != null ? m.getPhone() : "-") %></td>
          <td style="text-align:center">
            <% if ("ADMIN".equals(m.getGrade())) { %>
            <span class="badge-admin">관리자</span>
            <% } else { %>
            <span class="badge-normal">일반</span>
            <% } %>
          </td>
          <td style="color:var(--ink-soft);font-size:.82rem">
            <%= m.getRegDate() != null ? m.getRegDate().substring(0, 10) : "" %>
          </td>
        </tr>
        <% } %>
      </tbody>
    </table>
    <div class="table-summary">전체 <%= members.size() %>명</div>
    <% } %>
  </div>

</div>
</div>
</main>

<%@ include file="/WEB-INF/inc/footer.jsp" %>
