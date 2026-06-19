<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.hatshop.order.OrderDTO, com.hatshop.order.OrderDTO.OrderDetailDTO, java.util.List" %>
<%
    String CTX = request.getContextPath();
    OrderDTO order = (OrderDTO) request.getAttribute("order");
    if (order == null) {
        response.sendRedirect(CTX + "/order/list");
        return;
    }
    List<OrderDetailDTO> details = order.getDetails();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>주문 ?�세 - HatShop</title>
<link rel="stylesheet" href="<%=CTX%>/css/style.css">
<style>
  .detail-wrap { max-width: 800px; margin: 0 auto 40px; padding: calc(var(--header-h) + 40px) 16px 0; }
  .page-header { display: flex; align-items: center; gap: 16px; margin-bottom: 32px; }
  .back-btn { color: var(--text-muted); text-decoration: none; font-size: .88rem; display: flex; align-items: center; gap: 4px; transition: color .2s; }
  .back-btn:hover { color: var(--accent); }
  .page-title { font-size: 1.5rem; font-weight: 700; color: var(--accent); }

  .info-card { background: var(--bg-card); border: 1px solid var(--border); border-radius: 10px; padding: 24px 28px; margin-bottom: 20px; }
  .card-title { font-size: 1rem; font-weight: 600; color: var(--text-primary); margin-bottom: 16px; padding-bottom: 12px; border-bottom: 1px solid var(--border); display: flex; align-items: center; justify-content: space-between; }

  /* ?�태 배�? */
  .badge             { display: inline-block; padding: 4px 12px; border-radius: 20px; font-size: .8rem; font-weight: 600; }
  .status-pending    { background: rgba(108,117,125,.2); color: #adb5bd; }
  .status-paid       { background: rgba(0,123,255,.18); color: #69b3ff; }
  .status-shipping   { background: rgba(255,193,7,.18); color: #ffc107; }
  .status-done       { background: rgba(40,167,69,.18); color: #5dd879; }
  .status-cancel     { background: rgba(220,53,69,.18); color: #ff6b6b; }

  /* 배송 ?�보 그리??*/
  .info-grid { display: grid; grid-template-columns: 100px 1fr; gap: 10px 16px; }
  .info-key  { color: var(--text-muted); font-size: .88rem; }
  .info-val  { color: var(--text-primary); font-size: .88rem; }

  /* ?�품 ??*/
  .item-row  { display: flex; align-items: center; gap: 14px; padding: 14px 0; border-bottom: 1px solid rgba(255,255,255,.05); }
  .item-row:last-child { border-bottom: none; }
  .item-thumb { width: 72px; height: 72px; object-fit: cover; border-radius: 8px; flex-shrink: 0; background: var(--bg-hover); }
  .item-info  { flex: 1; }
  .item-name  { font-weight: 600; color: var(--text-primary); margin-bottom: 4px; }
  .item-cat   { font-size: .78rem; color: var(--text-muted); }
  .item-right { text-align: right; white-space: nowrap; }
  .item-price { font-size: .85rem; color: var(--text-muted); }
  .item-sub   { font-size: 1rem; font-weight: 700; color: var(--accent); margin-top: 3px; }

  /* 결제 ?�약 */
  .pay-row { display: flex; justify-content: space-between; padding: 8px 0; }
  .pay-row.total { border-top: 1px solid var(--border); margin-top: 8px; padding-top: 16px; }
  .pay-row.total .pay-label { font-weight: 600; color: var(--text-primary); }
  .pay-row.total .pay-val   { font-size: 1.2rem; font-weight: 700; color: var(--accent); }
  .pay-label { color: var(--text-muted); font-size: .9rem; }
  .pay-val   { color: var(--text-primary); font-size: .9rem; }

  /* ?�단 버튼 */
  .action-row { display: flex; gap: 12px; margin-top: 24px; }
  .btn-ghost   { flex: 1; padding: 13px; background: transparent; border: 1px solid var(--border); color: var(--text-secondary); border-radius: 8px; font-size: .9rem; text-align: center; text-decoration: none; transition: border-color .2s, color .2s; }
  .btn-ghost:hover { border-color: var(--accent); color: var(--accent); }
  .btn-primary { flex: 1; padding: 13px; background: var(--accent); border: none; color: #1a1a1a; border-radius: 8px; font-size: .9rem; font-weight: 700; text-align: center; text-decoration: none; transition: opacity .2s; }
  .btn-primary:hover { opacity: .88; }

  @media (max-width: 520px) {
    .info-grid { grid-template-columns: 80px 1fr; }
    .item-thumb { width: 56px; height: 56px; }
  }
</style>
</head>
<body>
<%@ include file="/WEB-INF/inc/header.jsp" %>

<main class="detail-wrap">
  <div class="page-header">
    <a href="<%=CTX%>/member/mypage.jsp" class="back-btn">
      &#8592; 마이페이지
    </a>
    <h1 class="page-title">주문 ?�세 <span style="font-size:1rem;font-weight:400;color:var(--text-muted);">#<%=order.getOrderNo()%></span></h1>
  </div>

  <!-- 주문 ?�태 + ?�시 -->
  <div class="info-card">
    <div class="card-title">
      <span>주문 ?�보</span>
      <span class="badge <%=order.getStatusClass()%>"><%=order.getStatusLabel()%></span>
    </div>
    <div class="info-grid">
      <span class="info-key">주문 번호</span>
      <span class="info-val">#<%=order.getOrderNo()%></span>

      <span class="info-key">주문 ?�시</span>
      <span class="info-val"><%=order.getOrderDate() != null ? order.getOrderDate() : ""%></span>
    </div>
  </div>

  <!-- 배송 ?�보 -->
  <div class="info-card">
    <h2 class="card-title">배송 ?�보</h2>
    <div class="info-grid">
      <span class="info-key">받는 �?/span>
      <span class="info-val"><%=order.getRecvName() != null ? order.getRecvName() : ""%></span>

      <span class="info-key">?�락�?/span>
      <span class="info-val"><%=order.getRecvPhone() != null ? order.getRecvPhone() : ""%></span>

      <span class="info-key">배송 주소</span>
      <span class="info-val"><%=order.getRecvAddr() != null ? order.getRecvAddr() : ""%></span>
    </div>
  </div>

  <!-- 주문 ?�품 -->
  <div class="info-card">
    <h2 class="card-title">주문 ?�품</h2>

    <% if (details != null && !details.isEmpty()) {
         for (OrderDetailDTO d : details) {
           String imgSrc = (d.getHatImage() != null && !d.getHatImage().isEmpty())
               ? CTX + "/uploads/" + d.getHatImage()
               : CTX + "/images/no-image.png";
    %>
    <div class="item-row">
      <img src="<%=imgSrc%>" alt="<%=d.getHatName() != null ? d.getHatName() : ""%>" class="item-thumb"
           onerror="this.src='<%=CTX%>/images/no-image.png'">
      <div class="item-info">
        <div class="item-name"><%=d.getHatName() != null ? d.getHatName() : "(?�품�??�음)"%></div>
        <div class="item-cat"><%=d.getHatCategory() != null ? d.getHatCategory() : ""%></div>
      </div>
      <div class="item-right">
        <div class="item-price"><%=d.getFormattedPrice()%>??× <%=d.getDetailQty()%></div>
        <div class="item-sub"><%=d.getFormattedSubTotal()%>??/div>
      </div>
    </div>
    <% } } %>

    <!-- 결제 ?�약 -->
    <div style="margin-top: 20px;">
      <div class="pay-row">
        <span class="pay-label">?�품 금액</span>
        <span class="pay-val"><%=order.getFormattedTotal()%>??/span>
      </div>
      <div class="pay-row">
        <span class="pay-label">배송�?/span>
        <span class="pay-val">무료</span>
      </div>
      <div class="pay-row total">
        <span class="pay-label">�?결제 금액</span>
        <span class="pay-val"><%=order.getFormattedTotal()%>??/span>
      </div>
    </div>
  </div>

  <!-- 버튼 -->
  <div class="action-row">
    <a href="<%=CTX%>/member/mypage.jsp" class="btn-ghost">마이페이지</a>
    <a href="<%=CTX%>/hat/list"    class="btn-primary">?�핑 계속?�기</a>
  </div>
</main>

<%@ include file="/WEB-INF/inc/footer.jsp" %>
</body>
</html>
