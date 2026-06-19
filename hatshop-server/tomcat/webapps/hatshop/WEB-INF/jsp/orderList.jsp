<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.hatshop.order.OrderDTO, com.hatshop.order.OrderDTO.OrderDetailDTO,
                 com.hatshop.util.HtmlUtils, java.util.List, java.net.URLEncoder" %>
<%
    String CTX = request.getContextPath();
    List<OrderDTO> orderList = (List<OrderDTO>) request.getAttribute("orderList");
    String flashSuccess = (String) session.getAttribute("flashSuccess");
    String flashError   = (String) session.getAttribute("flashError");
    if (flashSuccess != null) session.removeAttribute("flashSuccess");
    if (flashError   != null) session.removeAttribute("flashError");
%>
<%@ include file="/WEB-INF/inc/header.jsp" %>

<style>
  .list-wrap   { max-width: 860px; margin: 0 auto 40px; padding: calc(var(--header-h) + 40px) 16px 0; }
  .page-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 28px; }
  .page-title  { font-size: 1.6rem; font-weight: 800; }
  .order-count { font-size: .88rem; color: var(--ink-soft); }

  .flash-success { background: #f0faf4; border: 1px solid var(--green); color: var(--green); padding: 12px 18px; border-radius: 4px; margin-bottom: 20px; }
  .flash-error   { background: #fff5f5; border: 1px solid var(--red);   color: var(--red);   padding: 12px 18px; border-radius: 4px; margin-bottom: 20px; }

  .order-card { background: var(--bg); border: 1px solid var(--line); border-radius: 4px; margin-bottom: 16px; overflow: hidden; transition: border-color .2s; }
  .order-card:hover { border-color: var(--ink); }

  .card-header { display: flex; align-items: center; justify-content: space-between; padding: 14px 20px; border-bottom: 1px solid var(--line); background: var(--bg-sub); }
  .order-no    { font-weight: 700; font-size: .95rem; }
  .order-date  { font-size: .82rem; color: var(--ink-soft); margin-left: 12px; }

  .badge { display: inline-block; padding: 3px 10px; border-radius: 2px; font-size: .78rem; font-weight: 600; border: 1px solid; }
  .status-pending  { background: #f5f5f5; color: #555; border-color: #ccc; }
  .status-paid     { background: #eff8ff; color: #1a6fb3; border-color: #96cff5; }
  .status-shipping { background: #fffbef; color: #8a6200; border-color: #e8c84a; }
  .status-done     { background: #f0faf4; color: var(--green); border-color: #7dcf9e; }
  .status-cancel   { background: #fff5f5; color: var(--red); border-color: #f5a0a0; }

  .card-body { padding: 16px 20px; display: flex; align-items: center; justify-content: space-between; gap: 16px; }

  .thumb-group { display: flex; }
  .thumb-group img { width: 56px; height: 56px; object-fit: cover; border-radius: 2px; border: 2px solid var(--bg); background: var(--ph-a); margin-left: -8px; }
  .thumb-group img:first-child { margin-left: 0; }
  .thumb-more { width: 56px; height: 56px; border-radius: 2px; background: var(--bg-sub); border: 1px solid var(--line); display: inline-flex; align-items: center; justify-content: center; font-size: .78rem; color: var(--ink-soft); margin-left: -8px; flex-shrink: 0; }

  .order-summary  { flex: 1; }
  .summary-cnt    { font-size: .88rem; color: var(--ink-soft); margin-bottom: 4px; }
  .summary-total  { font-size: 1.1rem; font-weight: 800; }

  .btn-detail { padding: 8px 20px; background: transparent; border: 1px solid var(--line); border-radius: 2px; font-size: .85rem; text-decoration: none; white-space: nowrap; transition: border-color .2s; }
  .btn-detail:hover { border-color: var(--ink); }

  .empty-state { text-align: center; padding: 80px 20px; }
  .empty-icon  { font-size: 4rem; margin-bottom: 16px; opacity: .3; }
  .empty-title { font-size: 1.1rem; font-weight: 700; margin-bottom: 8px; }
  .empty-sub   { color: var(--ink-soft); font-size: .9rem; margin-bottom: 24px; }
  .btn-shop    { display: inline-block; padding: 12px 32px; background: var(--ink); color: #fff; border-radius: 2px; font-weight: 700; text-decoration: none; transition: opacity .2s; }
  .btn-shop:hover { opacity: .8; }

  @media (max-width: 520px) {
    .card-body { flex-wrap: wrap; }
    .thumb-group { flex-shrink: 0; }
  }
</style>

<main class="list-wrap">
  <div class="page-header">
    <h1 class="page-title">주문 목록</h1>
    <% if (orderList != null && !orderList.isEmpty()) { %>
    <span class="order-count">총 <%=orderList.size()%>건</span>
    <% } %>
  </div>

  <% if (flashSuccess != null) { %><div class="flash-success"><%=HtmlUtils.escape(flashSuccess)%></div><% } %>
  <% if (flashError   != null) { %><div class="flash-error"><%=HtmlUtils.escape(flashError)%></div><% } %>

  <% if (orderList == null || orderList.isEmpty()) { %>
  <div class="empty-state">
    <div class="empty-icon"><svg class="icon-svg" style="width:1em;height:1em" viewBox="0 0 24 24"><path d="M16.5 9.4 7.55 4.24"/><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/><polyline points="3.29 7 12 12 20.71 7"/><line x1="12" y1="22" x2="12" y2="12"/></svg></div>
    <h2 class="empty-title">아직 주문 내역이 없습니다</h2>
    <p class="empty-sub">마음에 드는 모자를 찾아 주문해보세요.</p>
    <a href="<%=CTX%>/hat/list" class="btn-shop">모자 쇼핑하러 가기</a>
  </div>

  <% } else {
       for (OrderDTO order : orderList) {
         List<OrderDetailDTO> details = order.getDetails();
  %>
  <div class="order-card">
    <div class="card-header">
      <div>
        <span class="order-no">주문 #<%=order.getOrderNo()%></span>
        <span class="order-date"><%=order.getOrderDate() != null ? order.getOrderDate().substring(0, Math.min(16, order.getOrderDate().length())) : ""%></span>
      </div>
      <span class="badge <%=order.getStatusClass()%>"><%=order.getStatusLabel()%></span>
    </div>
    <div class="card-body">
      <div class="thumb-group">
        <% if (details != null && !details.isEmpty()) {
             int showCount = Math.min(details.size(), 3);
             for (int i = 0; i < showCount; i++) {
               OrderDetailDTO d = details.get(i);
               String rawImg = d.getHatImage();
               String imgSrc = (rawImg != null && !rawImg.trim().isEmpty())
                   ? CTX + "/image?src=" + URLEncoder.encode(rawImg, "UTF-8")
                   : CTX + "/images/no-image.png";
        %>
        <img src="<%=imgSrc%>" alt="<%=HtmlUtils.escape(d.getHatName() != null ? d.getHatName() : "")%>"
             onerror="this.onerror=null;this.src='<%=CTX%>/images/no-image.png'">
        <% }
           if (details.size() > 3) { %>
        <span class="thumb-more">+<%=details.size()-3%></span>
        <% }
          }
        %>
      </div>

      <div class="order-summary">
        <div class="summary-cnt">상품 <%=order.getItemCount()%>건</div>
        <div class="summary-total"><%=order.getFormattedTotal()%>원</div>
      </div>

      <a href="<%=CTX%>/order/detail?orderNo=<%=order.getOrderNo()%>" class="btn-detail">상세보기</a>
    </div>
  </div>
  <% } } %>

</main>

<%@ include file="/WEB-INF/inc/footer.jsp" %>
