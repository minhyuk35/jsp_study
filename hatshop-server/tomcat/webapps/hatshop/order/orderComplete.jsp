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
<title>주문 ?�료 - HatShop</title>
<link rel="stylesheet" href="<%=CTX%>/css/style.css">
<style>
  .complete-wrap { max-width: 760px; margin: 0 auto 48px; padding: calc(var(--header-h) + 40px) 16px 0; }

  /* ?�료 ?�이�?+ ?�?��? */
  .complete-hero { text-align: center; margin-bottom: 40px; }
  .complete-icon {
    width: 80px; height: 80px; border-radius: 50%;
    background: rgba(229,185,78,.15); border: 2px solid var(--accent);
    display: inline-flex; align-items: center; justify-content: center;
    margin-bottom: 20px;
  }
  .complete-icon svg { width: 40px; height: 40px; stroke: var(--accent); fill: none; stroke-width: 2.5; stroke-linecap: round; stroke-linejoin: round; }
  .complete-title { font-size: 1.7rem; font-weight: 700; color: var(--text-primary); margin-bottom: 8px; }
  .complete-sub   { color: var(--text-muted); font-size: .95rem; }
  .order-no-chip  { display: inline-block; background: rgba(229,185,78,.12); border: 1px solid var(--accent); color: var(--accent); border-radius: 20px; padding: 4px 16px; font-size: .85rem; font-weight: 600; margin-top: 12px; }

  /* 카드 */
  .info-card { background: var(--bg-card); border: 1px solid var(--border); border-radius: 10px; padding: 24px 28px; margin-bottom: 20px; }
  .card-title { font-size: 1rem; font-weight: 600; color: var(--text-primary); margin-bottom: 16px; padding-bottom: 12px; border-bottom: 1px solid var(--border); }

  /* 배송 ?�보 그리??*/
  .info-grid { display: grid; grid-template-columns: 100px 1fr; gap: 10px 16px; }
  .info-key  { color: var(--text-muted); font-size: .88rem; }
  .info-val  { color: var(--text-primary); font-size: .88rem; }

  /* ?�품 목록 */
  .item-row  { display: flex; align-items: center; gap: 14px; padding: 12px 0; border-bottom: 1px solid rgba(255,255,255,.05); }
  .item-row:last-child { border-bottom: none; }
  .item-thumb { width: 64px; height: 64px; object-fit: cover; border-radius: 6px; flex-shrink: 0; background: var(--bg-hover); }
  .item-info  { flex: 1; }
  .item-name  { font-weight: 600; color: var(--text-primary); margin-bottom: 3px; }
  .item-cat   { font-size: .78rem; color: var(--text-muted); }
  .item-right { text-align: right; }
  .item-price { color: var(--text-muted); font-size: .85rem; }
  .item-sub   { color: var(--accent); font-weight: 700; margin-top: 2px; }

  /* 결제 금액 ?�약 */
  .pay-row { display: flex; justify-content: space-between; padding: 8px 0; }
  .pay-row.total { border-top: 1px solid var(--border); margin-top: 8px; padding-top: 16px; }
  .pay-row.total .pay-label { font-weight: 600; color: var(--text-primary); font-size: 1rem; }
  .pay-row.total .pay-val   { font-size: 1.25rem; font-weight: 700; color: var(--accent); }
  .pay-label { color: var(--text-muted); }
  .pay-val   { color: var(--text-primary); }

  /* ?�션 버튼 */
  .action-row { display: flex; gap: 12px; margin-top: 28px; }
  .btn-ghost { flex: 1; padding: 14px; background: transparent; border: 1px solid var(--border); color: var(--text-secondary); border-radius: 8px; font-size: .95rem; cursor: pointer; text-align: center; text-decoration: none; transition: border-color .2s, color .2s; }
  .btn-ghost:hover { border-color: var(--accent); color: var(--accent); }
  .btn-primary { flex: 1; padding: 14px; background: var(--accent); border: none; color: #1a1a1a; border-radius: 8px; font-size: .95rem; font-weight: 700; cursor: pointer; text-align: center; text-decoration: none; transition: opacity .2s; }
  .btn-primary:hover { opacity: .88; }
</style>
</head>
<body>
<%@ include file="/WEB-INF/inc/header.jsp" %>

<main class="complete-wrap">

  <!-- ?�료 ?�더 -->
  <div class="complete-hero">
    <div class="complete-icon">
      <svg viewBox="0 0 24 24">
        <polyline points="20 6 9 17 4 12"/>
      </svg>
    </div>
    <h1 class="complete-title">주문???�료?�었?�니??</h1>
    <p class="complete-sub">주문???�공?�으�??�수?�었?�니?? 빠르�?준비하겠습?�다.</p>
    <span class="order-no-chip">주문번호 #<%=order.getOrderNo()%></span>
  </div>

  <!-- 주문 ?�품 -->
  <div class="info-card">
    <h2 class="card-title">주문 ?�품 (<%=details != null ? details.size() : 0%>�?</h2>
    <% if (details != null) {
         for (OrderDetailDTO d : details) {
           String imgSrc = (d.getHatImage() != null && !d.getHatImage().isEmpty())
               ? CTX + "/uploads/" + d.getHatImage()
               : CTX + "/images/no-image.png";
    %>
    <div class="item-row">
      <img src="<%=imgSrc%>" alt="<%=d.getHatName()%>" class="item-thumb"
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

    <!-- 결제 금액 ?�약 -->
    <div style="margin-top:20px; padding-top:4px;">
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

      <span class="info-key">주문 ?�시</span>
      <span class="info-val"><%=order.getOrderDate() != null ? order.getOrderDate() : ""%></span>

      <span class="info-key">주문 ?�태</span>
      <span class="info-val">
        <span class="badge <%=order.getStatusClass()%>"><%=order.getStatusLabel()%></span>
      </span>
    </div>
  </div>

  <!-- ?�션 버튼 -->
  <div class="action-row">
    <a href="<%=CTX%>/hat/list" class="btn-ghost">?�핑 계속?�기</a>
    <a href="<%=CTX%>/order/list" class="btn-primary">주문 목록 보기</a>
  </div>

</main>

<%@ include file="/WEB-INF/inc/footer.jsp" %>
</body>
</html>
