<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.hatshop.order.OrderDTO, com.hatshop.order.OrderDTO.OrderDetailDTO,
                 com.hatshop.util.HtmlUtils, com.hatshop.util.Logger, com.hatshop.db.DBConn,
                 java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet,
                 java.util.List, java.net.URLEncoder" %>
<%
    String CTX = request.getContextPath();
    OrderDTO order = (OrderDTO) request.getAttribute("order");
    if (order == null) {
        response.sendRedirect(CTX + "/order/list");
        return;
    }
    List<OrderDetailDTO> details = order.getDetails();
    String flashSuccess = (String) session.getAttribute("flashSuccess");
    String flashError   = (String) session.getAttribute("flashError");
    if (flashSuccess != null) session.removeAttribute("flashSuccess");
    if (flashError   != null) session.removeAttribute("flashError");
    boolean cancellable = "PENDING".equals(order.getOrderStatus()) || "PAID".equals(order.getOrderStatus());

    boolean refundEligible = "PAID".equals(order.getOrderStatus()) || "SHIPPING".equals(order.getOrderStatus()) || "DONE".equals(order.getOrderStatus());
    String activeRefundStatus = null;
    try {
        Connection conn = DBConn.getConnection();
        String sql = "SELECT refund_status FROM refund WHERE order_no = ? AND refund_status IN ('REQUESTED','APPROVED','COMPLETED') ORDER BY refund_no DESC LIMIT 1";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, order.getOrderNo());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) activeRefundStatus = rs.getString("refund_status");
            }
        }
    } catch (Exception e) {
        Logger.error(this.getClass(), "orderDetail.jsp 환불상태 조회 오류: orderNo=" + order.getOrderNo(), e);
    }
    String refundBadgeLabel = null;
    if ("REQUESTED".equals(activeRefundStatus)) refundBadgeLabel = "환불 신청 중";
    else if ("APPROVED".equals(activeRefundStatus)) refundBadgeLabel = "환불 승인됨";
    else if ("COMPLETED".equals(activeRefundStatus)) refundBadgeLabel = "환불 완료";
%>
<%@ include file="/WEB-INF/inc/header.jsp" %>

<style>
  .detail-wrap { max-width: 800px; margin: 0 auto 40px; padding: calc(var(--header-h) + 40px) 16px 0; }
  .page-header { display: flex; align-items: center; gap: 16px; margin-bottom: 32px; }
  .back-btn    { color: var(--ink-soft); text-decoration: none; font-size: .88rem; transition: color .2s; }
  .back-btn:hover { color: var(--ink); }
  .page-title  { font-size: 1.5rem; font-weight: 800; }

  .info-card  { background: var(--bg); border: 1px solid var(--line); border-radius: 4px; padding: 24px 28px; margin-bottom: 20px; }
  .card-title { font-size: 1rem; font-weight: 700; margin-bottom: 16px; padding-bottom: 12px; border-bottom: 1px solid var(--line); display: flex; align-items: center; justify-content: space-between; }

  .badge { display: inline-block; padding: 4px 12px; border-radius: 2px; font-size: .8rem; font-weight: 600; border: 1px solid; }
  .status-pending  { background: #f5f5f5; color: #555; border-color: #ccc; }
  .status-paid     { background: #eff8ff; color: #1a6fb3; border-color: #96cff5; }
  .status-shipping { background: #fffbef; color: #8a6200; border-color: #e8c84a; }
  .status-done     { background: #f0faf4; color: var(--green); border-color: #7dcf9e; }
  .status-cancel   { background: #fff5f5; color: var(--red); border-color: #f5a0a0; }

  .info-grid { display: grid; grid-template-columns: 90px 1fr; gap: 10px 16px; }
  .info-key  { color: var(--ink-soft); font-size: .88rem; }
  .info-val  { font-size: .88rem; }

  .item-row  { display: flex; align-items: center; gap: 14px; padding: 14px 0; border-bottom: 1px solid var(--line); }
  .item-row:last-child { border-bottom: none; }
  .item-thumb { width: 72px; height: 72px; object-fit: cover; border-radius: 2px; flex-shrink: 0; background: var(--ph-a); }
  .item-info  { flex: 1; }
  .item-name  { font-weight: 600; margin-bottom: 4px; }
  .item-cat   { font-size: .78rem; color: var(--ink-soft); }
  .item-right { text-align: right; white-space: nowrap; }
  .item-price { font-size: .85rem; color: var(--ink-soft); }
  .item-sub   { font-size: 1rem; font-weight: 700; margin-top: 3px; }

  .pay-row { display: flex; justify-content: space-between; padding: 8px 0; }
  .pay-row.total { border-top: 1px solid var(--line); margin-top: 8px; padding-top: 16px; }
  .pay-row.total .pay-label { font-weight: 700; }
  .pay-row.total .pay-val   { font-size: 1.2rem; font-weight: 800; }
  .pay-label { color: var(--ink-soft); font-size: .9rem; }
  .pay-val   { font-size: .9rem; }

  .action-row { display: flex; gap: 12px; margin-top: 24px; flex-wrap: wrap; }
  .btn-ghost   { flex: 1; min-width: 120px; padding: 13px; text-align: center; text-decoration: none; border: 1px solid var(--line); color: var(--ink-soft); border-radius: 2px; font-size: .9rem; transition: border-color .2s, color .2s; }
  .btn-ghost:hover   { border-color: var(--ink); color: var(--ink); }
  .btn-primary { flex: 1; min-width: 120px; padding: 13px; text-align: center; text-decoration: none; background: var(--ink); color: #fff; border-radius: 2px; font-size: .9rem; font-weight: 700; transition: opacity .2s; }
  .btn-primary:hover { opacity: .8; }
  .btn-danger  { flex: 1; min-width: 120px; padding: 13px; text-align: center; background: transparent; border: 1px solid var(--red, #dc3545); color: var(--red, #dc3545); border-radius: 2px; font-size: .9rem; cursor: pointer; font-family: inherit; transition: background .2s, color .2s; }
  .btn-danger:hover  { background: var(--red, #dc3545); color: #fff; }

  .flash-success { background: #f0faf4; border: 1px solid #7dcf9e; color: #1a6b3a; padding: 12px 16px; border-radius: 4px; margin-bottom: 20px; font-size: .9rem; }
  .flash-error   { background: #fff5f5; border: 1px solid var(--red, #dc3545); color: var(--red, #dc3545); padding: 12px 16px; border-radius: 4px; margin-bottom: 20px; font-size: .9rem; }

  @media (max-width: 520px) {
    .info-grid  { grid-template-columns: 72px 1fr; }
    .item-thumb { width: 56px; height: 56px; }
  }
</style>

<main class="detail-wrap">
  <div class="page-header">
    <a href="<%=CTX%>/member/mypage.jsp" class="back-btn">← 마이페이지</a>
    <h1 class="page-title">주문 상세 <span style="font-size:1rem;font-weight:400;color:var(--ink-soft);">#<%=order.getOrderNo()%></span></h1>
  </div>

  <% if (flashSuccess != null) { %><div class="flash-success"><%=HtmlUtils.escape(flashSuccess)%></div><% } %>
  <% if (flashError   != null) { %><div class="flash-error"><%=HtmlUtils.escape(flashError)%></div><% } %>

  <div class="info-card">
    <div class="card-title">
      <span>주문 정보</span>
      <span class="badge <%=order.getStatusClass()%>"><%=order.getStatusLabel()%></span>
    </div>
    <div class="info-grid">
      <span class="info-key">주문 번호</span>
      <span class="info-val">#<%=order.getOrderNo()%></span>

      <span class="info-key">주문 일시</span>
      <span class="info-val"><%=HtmlUtils.escape(order.getOrderDate() != null ? order.getOrderDate() : "")%></span>
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
    </div>
  </div>

  <div class="info-card">
    <h2 class="card-title">주문 상품</h2>

    <% if (details != null && !details.isEmpty()) {
         for (OrderDetailDTO d : details) {
           String rawImg = d.getHatImage();
           String imgSrc = (rawImg != null && !rawImg.trim().isEmpty())
               ? CTX + "/image?src=" + URLEncoder.encode(rawImg, "UTF-8")
               : CTX + "/images/no-image.png";
    %>
    <div class="item-row">
      <img src="<%=imgSrc%>" alt="<%=HtmlUtils.escape(d.getHatName() != null ? d.getHatName() : "")%>" class="item-thumb"
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

    <div style="margin-top:20px;">
      <div class="pay-row">
        <span class="pay-label">상품 금액</span>
        <span class="pay-val"><%=order.getFormattedTotal()%>원</span>
      </div>
      <div class="pay-row">
        <span class="pay-label">배송비</span>
        <span class="pay-val">무료</span>
      </div>
      <div class="pay-row total">
        <span class="pay-label">총 결제 금액</span>
        <span class="pay-val"><%=order.getFormattedTotal()%>원</span>
      </div>
    </div>
  </div>

  <div class="action-row">
    <a href="<%=CTX%>/member/mypage.jsp" class="btn-ghost">마이페이지</a>
    <% if (cancellable) { %>
    <form method="POST" action="<%=CTX%>/order/cancel" id="cancelForm" style="flex:1;min-width:120px;">
      <input type="hidden" name="orderNo" value="<%=order.getOrderNo()%>">
      <button type="button" class="btn-danger" style="width:100%;" onclick="confirmCancel()">주문 취소</button>
    </form>
    <% } %>
    <% if (refundBadgeLabel != null) { %>
    <span class="btn-ghost" style="cursor:default;flex:1;min-width:120px;">
      <%= HtmlUtils.escape(refundBadgeLabel) %>
    </span>
    <% } else if (refundEligible) { %>
    <a href="<%=CTX%>/refund/request.jsp?orderNo=<%=order.getOrderNo()%>" class="btn-ghost" style="flex:1;min-width:120px;">환불 신청</a>
    <% } %>
    <a href="<%=CTX%>/hat/list" class="btn-primary">쇼핑 계속하기</a>
  </div>
</main>

<script>
function confirmCancel() {
  if (confirm('주문을 취소하시겠습니까?\n취소 후에는 되돌릴 수 없습니다.')) {
    document.getElementById('cancelForm').submit();
  }
}
</script>

<%@ include file="/WEB-INF/inc/footer.jsp" %>
