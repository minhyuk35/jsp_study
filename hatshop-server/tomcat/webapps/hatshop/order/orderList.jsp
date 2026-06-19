<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.hatshop.order.OrderDTO, java.util.List" %>
<%
    String CTX = request.getContextPath();
    List<OrderDTO> orderList = (List<OrderDTO>) request.getAttribute("orderList");
    String flashSuccess = (String) session.getAttribute("flashSuccess");
    String flashError   = (String) session.getAttribute("flashError");
    if (flashSuccess != null) session.removeAttribute("flashSuccess");
    if (flashError   != null) session.removeAttribute("flashError");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>??주문 목록 - HatShop</title>
<link rel="stylesheet" href="<%=CTX%>/css/style.css">
<style>
  .list-wrap   { max-width: 860px; margin: 0 auto 40px; padding: calc(var(--header-h) + 40px) 16px 0; }
  .page-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 28px; }
  .page-title  { font-size: 1.6rem; font-weight: 700; color: var(--accent); }
  .order-count { font-size: .88rem; color: var(--text-muted); }

  /* ?�래??메시지 */
  .flash-success { background: rgba(40,167,69,.15); border: 1px solid #28a745; color: #5dd879; padding: 12px 18px; border-radius: 8px; margin-bottom: 20px; }
  .flash-error   { background: rgba(220,53,69,.15);  border: 1px solid #dc3545; color: #ff6b6b; padding: 12px 18px; border-radius: 8px; margin-bottom: 20px; }

  /* 주문 카드 */
  .order-card { background: var(--bg-card); border: 1px solid var(--border); border-radius: 10px; margin-bottom: 16px; overflow: hidden; transition: border-color .2s; }
  .order-card:hover { border-color: var(--accent); }

  .card-header { display: flex; align-items: center; justify-content: space-between; padding: 14px 20px; border-bottom: 1px solid var(--border); background: var(--bg-hover); }
  .order-no   { font-weight: 700; color: var(--text-primary); font-size: .95rem; }
  .order-date { font-size: .82rem; color: var(--text-muted); margin-left: 12px; }

  /* ?�태 배�? */
  .badge             { display: inline-block; padding: 3px 10px; border-radius: 20px; font-size: .78rem; font-weight: 600; }
  .status-pending    { background: rgba(108,117,125,.2); color: #adb5bd; }
  .status-paid       { background: rgba(0,123,255,.18); color: #69b3ff; }
  .status-shipping   { background: rgba(255,193,7,.18); color: #ffc107; }
  .status-done       { background: rgba(40,167,69,.18); color: #5dd879; }
  .status-cancel     { background: rgba(220,53,69,.18); color: #ff6b6b; }

  .card-body { padding: 16px 20px; display: flex; align-items: center; justify-content: space-between; gap: 16px; }

  /* ?�네??묶음 */
  .thumb-group { display: flex; gap: -8px; }
  .thumb-group img { width: 56px; height: 56px; object-fit: cover; border-radius: 6px; border: 2px solid var(--bg-card); background: var(--bg-hover); margin-left: -8px; }
  .thumb-group img:first-child { margin-left: 0; }
  .thumb-more { width: 56px; height: 56px; border-radius: 6px; background: var(--bg-hover); border: 2px solid var(--border); display: inline-flex; align-items: center; justify-content: center; font-size: .78rem; color: var(--text-muted); margin-left: -8px; flex-shrink: 0; }

  /* 주문 ?�약 */
  .order-summary { flex: 1; }
  .summary-cnt   { font-size: .88rem; color: var(--text-muted); margin-bottom: 4px; }
  .summary-total { font-size: 1.1rem; font-weight: 700; color: var(--accent); }

  .btn-detail { padding: 8px 20px; background: transparent; border: 1px solid var(--accent); color: var(--accent); border-radius: 6px; font-size: .85rem; text-decoration: none; white-space: nowrap; transition: background .2s; }
  .btn-detail:hover { background: rgba(229,185,78,.15); }

  /* �??�태 */
  .empty-state { text-align: center; padding: 80px 20px; }
  .empty-icon  { font-size: 4rem; margin-bottom: 16px; opacity: .3; }
  .empty-title { font-size: 1.1rem; font-weight: 600; color: var(--text-primary); margin-bottom: 8px; }
  .empty-sub   { color: var(--text-muted); font-size: .9rem; margin-bottom: 24px; }
  .btn-shop    { display: inline-block; padding: 12px 32px; background: var(--accent); color: #1a1a1a; border-radius: 8px; font-weight: 700; text-decoration: none; transition: opacity .2s; }
  .btn-shop:hover { opacity: .88; }

  @media (max-width: 520px) {
    .card-body { flex-wrap: wrap; }
    .thumb-group { flex-shrink: 0; }
  }
</style>
</head>
<body>
<%@ include file="/WEB-INF/inc/header.jsp" %>

<main class="list-wrap">
  <div class="page-header">
    <h1 class="page-title">??주문 목록</h1>
    <% if (orderList != null && !orderList.isEmpty()) { %>
    <span class="order-count">�?<%=orderList.size()%>�?/span>
    <% } %>
  </div>

  <% if (flashSuccess != null) { %>
  <div class="flash-success"><%=flashSuccess%></div>
  <% } %>
  <% if (flashError != null) { %>
  <div class="flash-error"><%=flashError%></div>
  <% } %>

  <% if (orderList == null || orderList.isEmpty()) { %>
  <!-- �??�태 -->
  <div class="empty-state">
    <div class="empty-icon">?��</div>
    <h2 class="empty-title">?�직 주문 ?�역???�습?�다</h2>
    <p class="empty-sub">마음???�는 모자�?찾아 주문?�보?�요.</p>
    <a href="<%=CTX%>/hat/list" class="btn-shop">모자 ?�핑?�러 가�?/a>
  </div>

  <% } else {
       for (OrderDTO order : orderList) {
         java.util.List<com.hatshop.order.OrderDTO.OrderDetailDTO> details = order.getDetails();
  %>
  <!-- 주문 카드 -->
  <div class="order-card">
    <div class="card-header">
      <div>
        <span class="order-no">주문 #<%=order.getOrderNo()%></span>
        <span class="order-date"><%=order.getOrderDate() != null ? order.getOrderDate().substring(0,16) : ""%></span>
      </div>
      <span class="badge <%=order.getStatusClass()%>"><%=order.getStatusLabel()%></span>
    </div>
    <div class="card-body">
      <!-- ?�네??그룹 (최�? 3�??�시) -->
      <div class="thumb-group">
        <%
          if (details != null && !details.isEmpty()) {
            int showCount = Math.min(details.size(), 3);
            for (int i = 0; i < showCount; i++) {
              com.hatshop.order.OrderDTO.OrderDetailDTO d = details.get(i);
              String imgSrc = (d.getHatImage() != null && !d.getHatImage().isEmpty())
                  ? CTX + "/uploads/" + d.getHatImage()
                  : CTX + "/images/no-image.png";
        %>
        <img src="<%=imgSrc%>" alt="<%=d.getHatName() != null ? d.getHatName() : ""%>"
             onerror="this.src='<%=CTX%>/images/no-image.png'">
        <% }
           if (details.size() > 3) { %>
        <span class="thumb-more">+<%=details.size()-3%></span>
        <% }
          }
        %>
      </div>

      <!-- ?�약 -->
      <div class="order-summary">
        <div class="summary-cnt">
          ?�품 <%=order.getItemCount()%>�?        </div>
        <div class="summary-total"><%=order.getFormattedTotal()%>??/div>
      </div>

      <!-- ?�세보기 버튼 -->
      <a href="<%=CTX%>/order/detail?orderNo=<%=order.getOrderNo()%>" class="btn-detail">
        ?�세보기
      </a>
    </div>
  </div>
  <% } } %>

</main>

<%@ include file="/WEB-INF/inc/footer.jsp" %>
</body>
</html>
