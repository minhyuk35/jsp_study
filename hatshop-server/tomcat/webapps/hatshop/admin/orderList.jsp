<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hatshop.member.MemberDTO, com.hatshop.order.OrderDAO, com.hatshop.order.OrderDTO,
                 com.hatshop.util.HtmlUtils, java.util.List" %>
<%
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    if (loginUser == null || !loginUser.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/error/403.jsp"); return;
    }
    String ctx = request.getContextPath();

    String flashSuccess = (String) session.getAttribute("flashSuccess");
    String flashError   = (String) session.getAttribute("flashError");
    session.removeAttribute("flashSuccess");
    session.removeAttribute("flashError");

    List<OrderDTO> orders = new OrderDAO().getAllOrders();
%>
<%@ include file="/WEB-INF/inc/header.jsp" %>

<style>
.admin-section { max-width: 1200px; margin: 40px auto; padding: 0 16px 60px; }
.admin-page-head { display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px; }
.admin-page-head h1 { font-size: 1.25rem; font-weight: 700; }
.admin-breadcrumb { display: flex; align-items: center; gap: 6px; font-size: .82rem; color: var(--ink-soft); margin-bottom: 16px; }
.admin-breadcrumb a:hover { color: var(--accent); }
.data-table { width: 100%; border-collapse: collapse; font-size: .88rem; }
.data-table th { text-align: left; padding: 11px 14px; background: var(--ph-a); color: var(--ink-soft); font-weight: 600; border-bottom: 1px solid var(--line); font-size: .82rem; }
.data-table td { padding: 10px 14px; border-bottom: 1px solid var(--line); vertical-align: middle; }
.data-table tr:last-child td { border-bottom: none; }
.data-table tbody tr:hover td { background: var(--bg-sub); }
.table-card { border: 1px solid var(--line); border-radius: 4px; overflow: hidden; }
.table-summary { padding: 10px 16px; background: var(--bg-sub); border-top: 1px solid var(--line); font-size: .82rem; color: var(--ink-soft); }

.badge { display: inline-block; padding: 3px 9px; border-radius: 2px; font-size: .75rem; font-weight: 600; border: 1px solid; }
.status-pending  { background: #f5f5f5; color: #555; border-color: #ccc; }
.status-paid     { background: #eff8ff; color: #1a6fb3; border-color: #96cff5; }
.status-shipping { background: #fffbef; color: #8a6200; border-color: #e8c84a; }
.status-done     { background: #f0faf4; color: var(--green); border-color: #7dcf9e; }
.status-cancel   { background: #fff5f5; color: var(--red); border-color: #f5a0a0; }

.status-form select { padding: 5px 8px; border: 1px solid var(--line); border-radius: 2px; font-size: .82rem; color: var(--ink); background: var(--bg); cursor: pointer; }
.status-form button { padding: 5px 10px; background: var(--ink); color: #fff; border: none; border-radius: 2px; font-size: .78rem; cursor: pointer; margin-left: 4px; }
.status-form button:hover { opacity: .8; }
</style>

<main class="main-content">
<div class="container">
<div class="admin-section">

  <nav class="admin-breadcrumb">
    <a href="<%= ctx %>/admin/">대시보드</a>
    <span>›</span>
    <span>주문 관리</span>
  </nav>

  <div class="admin-page-head">
    <h1><svg class="icon-svg" viewBox="0 0 24 24"><path d="M16.5 9.4 7.55 4.24"/><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/><polyline points="3.29 7 12 12 20.71 7"/><line x1="12" y1="22" x2="12" y2="12"/></svg> 주문 관리
      <span style="font-size:.85rem;color:var(--ink-soft);font-weight:400"> (총 <%= orders.size() %>건)</span>
    </h1>
  </div>

  <% if (flashSuccess != null) { %><div class="alert alert-success" style="margin-bottom:16px"><%= HtmlUtils.escape(flashSuccess) %></div><% } %>
  <% if (flashError   != null) { %><div class="alert alert-error"   style="margin-bottom:16px"><%= HtmlUtils.escape(flashError)   %></div><% } %>

  <div class="table-card">
    <% if (orders.isEmpty()) { %>
    <div style="text-align:center;padding:60px 20px;color:var(--ink-soft)">주문 내역이 없습니다.</div>
    <% } else { %>
    <table class="data-table">
      <thead>
        <tr>
          <th style="width:70px">주문번호</th>
          <th style="width:100px">회원 ID</th>
          <th style="width:140px">주문일시</th>
          <th style="width:90px">상품 수</th>
          <th style="width:120px;text-align:right">결제 금액</th>
          <th style="width:90px">받는 분</th>
          <th style="width:100px;text-align:center">상태</th>
          <th style="width:220px">상태 변경</th>
        </tr>
      </thead>
      <tbody>
        <% for (OrderDTO o : orders) { %>
        <tr>
          <td style="font-weight:600">#<%= o.getOrderNo() %></td>
          <td style="color:var(--ink-soft)"><%= HtmlUtils.escape(o.getMemberId() != null ? o.getMemberId() : "") %></td>
          <td style="font-size:.82rem;color:var(--ink-soft)"><%= o.getOrderDate() != null ? o.getOrderDate().substring(0,16) : "" %></td>
          <td style="color:var(--ink-soft)"><%= o.getItemCount() %>건</td>
          <td style="text-align:right;font-weight:600"><%= o.getFormattedTotal() %>원</td>
          <td><%= HtmlUtils.escape(o.getRecvName() != null ? o.getRecvName() : "") %></td>
          <td style="text-align:center">
            <span class="badge <%= o.getStatusClass() %>"><%= o.getStatusLabel() %></span>
          </td>
          <td>
            <form class="status-form" action="<%= ctx %>/admin/orderStatus" method="post"
                  onsubmit="return confirm('상태를 변경하시겠습니까?')">
              <input type="hidden" name="orderNo" value="<%= o.getOrderNo() %>">
              <select name="status">
                <option value="PENDING"  <%= "PENDING" .equals(o.getOrderStatus()) ? "selected" : "" %>>주문 대기</option>
                <option value="PAID"     <%= "PAID"    .equals(o.getOrderStatus()) ? "selected" : "" %>>결제 완료</option>
                <option value="SHIPPING" <%= "SHIPPING".equals(o.getOrderStatus()) ? "selected" : "" %>>배송 중</option>
                <option value="DONE"     <%= "DONE"    .equals(o.getOrderStatus()) ? "selected" : "" %>>배송 완료</option>
                <option value="CANCEL"   <%= "CANCEL"  .equals(o.getOrderStatus()) ? "selected" : "" %>>취소됨</option>
              </select>
              <button type="submit">변경</button>
            </form>
          </td>
        </tr>
        <% } %>
      </tbody>
    </table>
    <div class="table-summary">전체 <%= orders.size() %>건</div>
    <% } %>
  </div>

</div>
</div>
</main>

<%@ include file="/WEB-INF/inc/footer.jsp" %>
