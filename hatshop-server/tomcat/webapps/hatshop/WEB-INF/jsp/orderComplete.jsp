<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.hatshop.order.OrderDTO, com.hatshop.order.OrderDTO.OrderDetailDTO,
                 com.hatshop.util.HtmlUtils, java.util.List, java.net.URLEncoder" %>
<%
    String CTX = request.getContextPath();
    OrderDTO order = (OrderDTO) request.getAttribute("order");
    if (order == null) {
        response.sendRedirect(CTX + "/order/list");
        return;
    }
    List<OrderDetailDTO> details = order.getDetails();
%>
<%@ include file="/WEB-INF/inc/header.jsp" %>

<style>
  .complete-wrap { max-width: 760px; margin: 0 auto 48px; padding: calc(var(--header-h) + 40px) 16px 0; }

  .complete-hero { text-align: center; margin-bottom: 40px; }
  .complete-icon {
    width: 80px; height: 80px; border-radius: 50%;
    background: #f0faf4; border: 2px solid var(--green);
    display: inline-flex; align-items: center; justify-content: center;
    margin-bottom: 20px;
  }
  .complete-icon svg { width: 40px; height: 40px; stroke: var(--green); fill: none; stroke-width: 2.5; stroke-linecap: round; stroke-linejoin: round; }
  .complete-title { font-size: 1.7rem; font-weight: 700; margin-bottom: 8px; }
  .complete-sub   { color: var(--ink-soft); font-size: .95rem; }
  .order-no-chip  { display: inline-block; background: #f5f5f5; border: 1px solid var(--line); border-radius: 20px; padding: 4px 16px; font-size: .85rem; font-weight: 600; margin-top: 12px; }

  .info-card  { background: var(--bg); border: 1px solid var(--line); border-radius: 4px; padding: 24px 28px; margin-bottom: 20px; }
  .card-title { font-size: 1rem; font-weight: 700; margin-bottom: 16px; padding-bottom: 12px; border-bottom: 1px solid var(--line); }

  .info-grid { display: grid; grid-template-columns: 90px 1fr; gap: 10px 16px; }
  .info-key  { color: var(--ink-soft); font-size: .88rem; }
  .info-val  { font-size: .88rem; }

  .item-row  { display: flex; align-items: center; gap: 14px; padding: 12px 0; border-bottom: 1px solid var(--line); }
  .item-row:last-child { border-bottom: none; }
  .item-thumb { width: 64px; height: 64px; object-fit: cover; border-radius: 2px; flex-shrink: 0; background: var(--ph-a); }
  .item-info  { flex: 1; }
  .item-name  { font-weight: 600; margin-bottom: 3px; }
  .item-cat   { font-size: .78rem; color: var(--ink-soft); }
  .item-right { text-align: right; }
  .item-price { color: var(--ink-soft); font-size: .85rem; }
  .item-sub   { font-weight: 700; margin-top: 2px; }

  .pay-row { display: flex; justify-content: space-between; padding: 8px 0; }
  .pay-row.total { border-top: 1px solid var(--line); margin-top: 8px; padding-top: 16px; }
  .pay-row.total .pay-label { font-weight: 700; font-size: 1rem; }
  .pay-row.total .pay-val   { font-size: 1.25rem; font-weight: 800; }
  .pay-label { color: var(--ink-soft); }

  .badge { display: inline-block; padding: 3px 10px; border-radius: 2px; font-size: .78rem; font-weight: 600; border: 1px solid; }
  .status-pending  { background: #f5f5f5; color: #555; border-color: #ccc; }
  .status-paid     { background: #eff8ff; color: #1a6fb3; border-color: #96cff5; }
  .status-shipping { background: #fffbef; color: #8a6200; border-color: #e8c84a; }
  .status-done     { background: #f0faf4; color: var(--green); border-color: #7dcf9e; }
  .status-cancel   { background: #fff5f5; color: var(--red); border-color: #f5a0a0; }

  .action-row { display: flex; gap: 12px; margin-top: 28px; }
  .btn-ghost   { flex: 1; padding: 14px; text-align: center; text-decoration: none; border: 1px solid var(--line); color: var(--ink-soft); border-radius: 2px; font-size: .95rem; transition: border-color .2s, color .2s; }
  .btn-ghost:hover   { border-color: var(--ink); color: var(--ink); }
  .btn-primary { flex: 1; padding: 14px; text-align: center; text-decoration: none; background: var(--ink); color: #fff; border-radius: 2px; font-size: .95rem; font-weight: 700; transition: opacity .2s; }
  .btn-primary:hover { opacity: .8; }
</style>

<main class="complete-wrap">

  <div class="complete-hero">
    <div class="complete-icon">
      <svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>
    </div>
    <h1 class="complete-title">주문이 완료되었습니다</h1>
    <p class="complete-sub">주문이 성공적으로 접수되었습니다. 빠르게 준비하겠습니다.</p>
    <span class="order-no-chip">주문번호 #<%=order.getOrderNo()%></span>
  </div>

  <div class="info-card">
    <h2 class="card-title">주문 상품 (<%=details != null ? details.size() : 0%>건)</h2>
    <% if (details != null) {
         for (OrderDetailDTO d : details) {
           String rawImg = d.getHatImage();
           String imgSrc;
           if (rawImg != null && !rawImg.trim().isEmpty()) {
               imgSrc = CTX + "/image?src=" + URLEncoder.encode(rawImg, "UTF-8");
           } else {
               imgSrc = CTX + "/images/no-image.png";
           }
    %>
    <div class="item-row">
      <img src="<%=imgSrc%>" alt="<%=HtmlUtils.escape(d.getHatName())%>" class="item-thumb"
           onerror="this.onerror=null;this.src='<%=CTX%>/images/no-image.png'">
      <div class="item-info">
        <div class="item-name"><%=HtmlUtils.escape(d.getHatName() != null ? d.getHatName() : "(상품명 없음)")%></div>
        <div class="item-cat"><%=HtmlUtils.escape(d.getHatCategory() != null ? d.getHatCategory() : "")%></div>
      </div>
      <div class="item-right">
        <div class="item-price"><%=d.getFormattedPrice()%>원 × <%=d.getDetailQty()%></div>
        <div class="item-sub"><%=d.getFormattedSubTotal()%>원</div>
      </div>
    </div>
    <% } } %>

    <div style="margin-top:20px; padding-top:4px;">
      <div class="pay-row">
        <span class="pay-label">상품 금액</span>
        <span><%=order.getFormattedTotal()%>원</span>
      </div>
      <div class="pay-row">
        <span class="pay-label">배송비</span>
        <span>무료</span>
      </div>
      <div class="pay-row total">
        <span class="pay-label">총 결제 금액</span>
        <span><%=order.getFormattedTotal()%>원</span>
      </div>
    </div>
  </div>

  <div class="info-card">
    <h2 class="card-title">배송 정보</h2>
    <div class="info-grid">
      <span class="info-key">받는 분</span>
      <span class="info-val"><%=HtmlUtils.escape(order.getRecvName() != null ? order.getRecvName() : "")%></span>

      <span class="info-key">연락처</span>
      <span class="info-val"><%=HtmlUtils.escape(order.getRecvPhone() != null ? order.getRecvPhone() : "")%></span>

      <span class="info-key">배송 주소</span>
      <span class="info-val"><%=HtmlUtils.escape(order.getRecvAddr() != null ? order.getRecvAddr() : "")%></span>

      <span class="info-key">주문 일시</span>
      <span class="info-val"><%=HtmlUtils.escape(order.getOrderDate() != null ? order.getOrderDate() : "")%></span>

      <span class="info-key">주문 상태</span>
      <span class="info-val">
        <span class="badge <%=order.getStatusClass()%>"><%=order.getStatusLabel()%></span>
      </span>
    </div>
  </div>

  <div class="action-row">
    <a href="<%=CTX%>/hat/list" class="btn-ghost">쇼핑 계속하기</a>
    <a href="<%=CTX%>/order/list" class="btn-primary">주문 목록 보기</a>
  </div>

</main>

<%@ include file="/WEB-INF/inc/footer.jsp" %>
