<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hatshop.member.MemberDTO, com.hatshop.hat.HatDAO, com.hatshop.hat.HatDTO,
                 com.hatshop.util.HtmlUtils, java.util.List, java.net.URLEncoder" %>
<%
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    if (loginUser == null || !loginUser.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/error/403.jsp"); return;
    }
    String ctx = request.getContextPath();

    /* 플래시 메시지 */
    String flashError   = (String) session.getAttribute("flashError");
    String flashSuccess = (String) session.getAttribute("flashSuccess");
    session.removeAttribute("flashError");
    session.removeAttribute("flashSuccess");

    /* 검색 파라미터 */
    String category = request.getParameter("category");
    String keyword  = request.getParameter("keyword");
    if (category != null && category.trim().isEmpty()) category = null;
    if (keyword  != null && keyword.trim().isEmpty())  keyword  = null;

    int pageSize = 10;
    int curPage  = 1;
    try { curPage = Integer.parseInt(request.getParameter("page")); } catch (Exception e) {}
    if (curPage < 1) curPage = 1;

    HatDAO hatDAO = new HatDAO();
    int totalCount = hatDAO.getTotalCount(category, keyword);
    int totalPages = Math.max(1, (int) Math.ceil((double) totalCount / pageSize));
    if (curPage > totalPages) curPage = totalPages;

    List<HatDTO> hatList = hatDAO.getHatList(category, keyword, curPage, pageSize);

    String encKw  = keyword  != null ? URLEncoder.encode(keyword, "UTF-8")  : "";
    String encCat = category != null ? URLEncoder.encode(category, "UTF-8") : "";
%>
<%@ include file="/WEB-INF/inc/header.jsp" %>

<style>
.admin-section   { max-width: 1100px; margin: 0 auto; }
.admin-page-head { display: flex; align-items: center; justify-content: space-between;
                   margin-bottom: 20px; flex-wrap: wrap; gap: 12px; }
.admin-page-head h1 { font-size: 1.25rem; font-weight: 700; }
.admin-toolbar   { display: flex; align-items: center; gap: 10px; flex-wrap: wrap; margin-bottom: 16px; }
.admin-toolbar select, .admin-toolbar input { padding: 8px 12px; background: var(--bg-card);
    border: 1px solid var(--border); border-radius: var(--radius); color: var(--text-primary);
    font-size: .85rem; }
.admin-toolbar select:focus, .admin-toolbar input:focus { outline: none; border-color: var(--accent); }
.admin-toolbar input { width: 220px; }
.data-table      { width: 100%; border-collapse: collapse; font-size: .88rem; }
.data-table th   { text-align: left; padding: 11px 14px; background: var(--bg-card);
                   color: var(--text-muted); font-weight: 600; border-bottom: 1px solid var(--border);
                   white-space: nowrap; }
.data-table td   { padding: 11px 14px; border-bottom: 1px solid rgba(255,255,255,.04);
                   vertical-align: middle; }
.data-table tr:hover td { background: rgba(255,255,255,.03); }
.thumb-cell img  { width: 44px; height: 44px; object-fit: cover; border-radius: 6px;
                   border: 1px solid var(--border); background: var(--bg-card); }
.thumb-cell .no-img { width: 44px; height: 44px; border-radius: 6px; background: var(--bg-card);
                      border: 1px solid var(--border); display: flex; align-items: center;
                      justify-content: center; font-size: 1.2rem; color: var(--text-muted); }
.badge-category  { display: inline-block; padding: 2px 8px; border-radius: 20px; font-size: .75rem;
                   background: rgba(229,185,78,.12); color: var(--accent); border: 1px solid rgba(229,185,78,.25); }
.badge-out       { background: rgba(224,82,82,.12); color: var(--danger); border-color: rgba(224,82,82,.25); }
.badge-in        { background: rgba(34,197,94,.12); color: var(--success); border: 1px solid rgba(34,197,94,.30);
                   display: inline-block; padding: 2px 8px; border-radius: 20px; font-size: .75rem;
                   white-space: nowrap; }
.badge-out       { white-space: nowrap; }
.stock-warn      { color: var(--danger); font-weight: 600; }
.action-btns     { display: flex; gap: 6px; }
.btn-xs          { padding: 4px 10px; font-size: .78rem; border-radius: 4px; }
.table-card      { background: var(--bg-secondary); border: 1px solid var(--border);
                   border-radius: 12px; overflow: hidden; }
.table-summary   { padding: 10px 16px; background: var(--bg-card);
                   border-top: 1px solid var(--border); font-size: .82rem; color: var(--text-muted); }
.admin-breadcrumb{ display: flex; align-items: center; gap: 6px;
                   font-size: .82rem; color: var(--text-muted); margin-bottom: 16px; }
.admin-breadcrumb a:hover { color: var(--accent); }
.keyword-tag     { display: inline-flex; align-items: center; gap: 6px;
                   padding: 4px 10px; background: rgba(229,185,78,.1);
                   border: 1px solid rgba(229,185,78,.3); border-radius: 20px; font-size: .8rem; }
.keyword-tag a   { color: var(--text-muted); text-decoration: none; font-size: .9rem; }
.keyword-tag a:hover { color: var(--danger); }
</style>

<main class="main-content">
<div class="container">
<div class="admin-section">

  <!-- 브레드크럼 -->
  <nav class="admin-breadcrumb">
    <a href="<%= ctx %>/admin/">대시보드</a>
    <span>›</span>
    <span>상품 관리</span>
  </nav>

  <!-- 헤더 -->
  <div class="admin-page-head">
    <h1><svg class="icon-svg" viewBox="0 0 24 24"><path d="M4 16c0-4.4 3.6-8 8-8s8 3.6 8 8"/><ellipse cx="12" cy="16" rx="10" ry="2.2"/></svg> 상품 관리
      <% if (totalCount > 0) { %><span style="font-size:.85rem;color:var(--text-muted);font-weight:400"> (총 <%= totalCount %>개)</span><% } %>
    </h1>
    <a href="<%= ctx %>/admin/hat/regist" class="btn btn-primary">+ 상품 등록</a>
  </div>

  <!-- 플래시 메시지 -->
  <% if (flashError   != null) { %><div class="alert alert-error"  ><%= HtmlUtils.escape(flashError)   %></div><% } %>
  <% if (flashSuccess != null) { %><div class="alert alert-success"><%= HtmlUtils.escape(flashSuccess) %></div><% } %>

  <!-- 검색 툴바 -->
  <form method="get" action="<%= ctx %>/admin/hatList.jsp" class="admin-toolbar">
    <select name="category" onchange="this.form.submit()">
      <option value="">전체 카테고리</option>
      <%
          String[] cats = {"볼캡","버킷햇","베레모","페도라","니트햇"};
          for (String c : cats) {
              String sel = c.equals(category) ? " selected" : "";
      %>
      <option value="<%= HtmlUtils.escape(c) %>"<%= sel %>><%= HtmlUtils.escape(c) %></option>
      <% } %>
    </select>
    <input type="text" name="keyword" placeholder="상품명 검색..."
           value="<%= keyword != null ? HtmlUtils.escape(keyword) : "" %>">
    <button type="submit" class="btn btn-secondary btn-xs" style="padding:8px 16px">검색</button>
    <% if (keyword != null || category != null) { %>
    <a href="<%= ctx %>/admin/hatList.jsp" class="btn btn-secondary btn-xs"
       style="padding:8px 12px;color:var(--text-muted)">초기화</a>
    <% } %>
  </form>

  <!-- 키워드 태그 -->
  <% if (keyword != null) { %>
  <div style="margin-bottom:12px">
    <span class="keyword-tag">
      "<%= HtmlUtils.escape(keyword) %>"
      <a href="<%= ctx %>/admin/hatList.jsp<%= encCat.isEmpty() ? "" : "?category=" + encCat %>">✕</a>
    </span>
  </div>
  <% } %>

  <!-- 테이블 -->
  <div class="table-card">
    <% if (hatList == null || hatList.isEmpty()) { %>
    <div style="text-align:center;padding:60px 20px;color:var(--text-muted)">
      <div style="font-size:2.5rem;margin-bottom:12px"><svg class="icon-svg" style="width:1em;height:1em" viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg></div>
      <p>조건에 맞는 상품이 없습니다.</p>
      <a href="<%= ctx %>/admin/hatList.jsp" style="color:var(--accent);font-size:.85rem">전체 목록 보기</a>
    </div>
    <% } else { %>
    <table class="data-table">
      <thead>
        <tr>
          <th style="width:50px">No.</th>
          <th style="width:56px">이미지</th>
          <th>상품명</th>
          <th style="width:90px">카테고리</th>
          <th style="width:100px;text-align:right">가격</th>
          <th style="width:70px;text-align:center">재고</th>
          <th style="width:90px;text-align:center;white-space:nowrap">상태</th>
          <th style="width:110px">관리</th>
        </tr>
      </thead>
      <tbody>
        <% for (HatDTO h : hatList) { %>
        <tr>
          <td style="color:var(--text-muted)"><%= h.getHatNo() %></td>
          <td class="thumb-cell">
              <% if (h.getHatImage() != null && !h.getHatImage().isEmpty()) { %>
                <img src="<%= ctx %>/image?src=<%= java.net.URLEncoder.encode(h.getHatImage(), "UTF-8") %>"
                alt="<%= HtmlUtils.escape(h.getHatName()) %>"
                onerror="this.onerror=null;this.src='<%= ctx %>/images/no-image.png'">
              <% } else { %>
              <img class="no-img"
                src="<%= ctx %>/images/no-image.png"
                alt="<%= HtmlUtils.escape(h.getHatName()) %>">
              <% } %>
          </td>
          <td>
            <a href="<%= ctx %>/hat/detail?hatNo=<%= h.getHatNo() %>"
               target="_blank"
               style="color:var(--text-primary);text-decoration:none"
               title="상품 페이지 새 탭으로 보기">
              <%= HtmlUtils.escape(h.getHatName()) %>
            </a>
          </td>
          <td><span class="badge-category"><%= HtmlUtils.escape(h.getHatCategory()) %></span></td>
          <td style="text-align:right"><%= h.getFormattedPrice() %>원</td>
          <td style="text-align:center">
            <% if (h.getHatStock() == 0) { %>
            <span class="stock-warn">0</span>
            <% } else { %>
            <%= h.getHatStock() %>
            <% } %>
          </td>
          <td style="text-align:center;white-space:nowrap">
            <% if (h.isSoldOut()) { %>
            <span class="badge-category badge-out">품절</span>
            <% } else { %>
            <span class="badge-in">판매중</span>
            <% } %>
          </td>
          <td>
            <div class="action-btns">
              <a href="<%= ctx %>/admin/hat/edit?hatNo=<%= h.getHatNo() %>"
                 class="btn btn-secondary btn-xs">수정</a>
            </div>
          </td>
        </tr>
        <% } %>
      </tbody>
    </table>

    <div class="table-summary">
      <%= (curPage - 1) * pageSize + 1 %> – <%= Math.min(curPage * pageSize, totalCount) %> / 전체 <%= totalCount %>개
    </div>
    <% } %>
  </div><!-- /table-card -->

  <!-- 페이지네이션 -->
  <% if (totalPages > 1) {
      int startPage = Math.max(1, curPage - 2);
      int endPage   = Math.min(totalPages, startPage + 4);
      if (endPage - startPage < 4) startPage = Math.max(1, endPage - 4);
      String baseUrl = ctx + "/admin/hatList.jsp?page=";
      String suffix  = (encCat.isEmpty() ? "" : "&category=" + encCat)
                     + (encKw.isEmpty()  ? "" : "&keyword="  + encKw);
  %>
  <nav class="pagination" style="margin-top:20px">
    <% if (curPage > 1) { %>
    <a href="<%= baseUrl %>1<%= suffix %>" class="page-item">«</a>
    <a href="<%= baseUrl %><%= curPage - 1 %><%= suffix %>" class="page-item">‹</a>
    <% } %>
    <% if (startPage > 1) { %><span class="page-item" style="cursor:default">…</span><% } %>
    <% for (int p = startPage; p <= endPage; p++) { %>
    <a href="<%= baseUrl %><%= p %><%= suffix %>"
       class="page-item<%= p == curPage ? " active" : "" %>"><%= p %></a>
    <% } %>
    <% if (endPage < totalPages) { %><span class="page-item" style="cursor:default">…</span><% } %>
    <% if (curPage < totalPages) { %>
    <a href="<%= baseUrl %><%= curPage + 1 %><%= suffix %>" class="page-item">›</a>
    <a href="<%= baseUrl %><%= totalPages %><%= suffix %>" class="page-item">»</a>
    <% } %>
  </nav>
  <% } %>

</div>
</div>
</main>

<%@ include file="/WEB-INF/inc/footer.jsp" %>
