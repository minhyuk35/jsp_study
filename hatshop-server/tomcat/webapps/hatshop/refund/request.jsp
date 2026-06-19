<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.hatshop.member.MemberDTO, com.hatshop.order.OrderDAO, com.hatshop.order.OrderDTO,
                 com.hatshop.order.OrderDTO.OrderDetailDTO, com.hatshop.util.HtmlUtils, com.hatshop.util.Logger,
                 com.hatshop.db.DBConn, java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet,
                 java.net.URLEncoder, java.util.List" %>
<%
    String CTX = request.getContextPath();
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    if (loginUser == null) {
        response.sendRedirect(CTX + "/member/login.jsp?redirectURL=" +
            URLEncoder.encode("/refund/request.jsp?orderNo=" + HtmlUtils.safe(request.getParameter("orderNo")), "UTF-8"));
        return;
    }

    int orderNo = 0;
    try { orderNo = Integer.parseInt(request.getParameter("orderNo")); } catch (Exception ignored) {}
    if (orderNo <= 0) {
        session.setAttribute("flashError", "잘못된 주문번호입니다.");
        response.sendRedirect(CTX + "/member/mypage.jsp");
        return;
    }

    OrderDTO order = null;
    boolean hasActiveRefund = false;
    try {
        order = new OrderDAO().getOrderDetail(orderNo, loginUser.getMemberId());
    } catch (Exception e) {
        Logger.error(this.getClass(), "refund/request.jsp 주문 조회 오류: orderNo=" + orderNo, e);
        session.setAttribute("flashError", "주문 정보를 불러오는 중 오류가 발생했습니다.");
        response.sendRedirect(CTX + "/member/mypage.jsp");
        return;
    }

    if (order == null) {
        session.setAttribute("flashError", "본인 주문만 환불 신청이 가능합니다.");
        response.sendRedirect(CTX + "/member/mypage.jsp");
        return;
    }

    String status = order.getOrderStatus();
    boolean eligible = "PAID".equals(status) || "SHIPPING".equals(status) || "DONE".equals(status);
    if (!eligible) {
        session.setAttribute("flashError", "결제 대기 중이거나 이미 취소된 주문은 환불 신청이 불가합니다.");
        response.sendRedirect(CTX + "/member/mypage.jsp");
        return;
    }

    try {
        Connection conn = DBConn.getConnection();
        String sql = "SELECT COUNT(*) FROM refund WHERE order_no = ? AND refund_status IN ('REQUESTED','APPROVED','COMPLETED')";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderNo);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) hasActiveRefund = true;
            }
        }
    } catch (Exception e) {
        Logger.error(this.getClass(), "refund/request.jsp 중복확인 오류: orderNo=" + orderNo, e);
        session.setAttribute("flashError", "환불 신청 가능 여부 확인 중 오류가 발생했습니다.");
        response.sendRedirect(CTX + "/member/mypage.jsp");
        return;
    }

    if (hasActiveRefund) {
        session.setAttribute("flashError", "이미 환불 신청이 진행 중인 주문입니다.");
        response.sendRedirect(CTX + "/member/mypage.jsp");
        return;
    }

    List<OrderDetailDTO> details = order.getDetails();
    String flashError = (String) session.getAttribute("flashError");
    session.removeAttribute("flashError");
%>
<%@ include file="/WEB-INF/inc/header.jsp" %>

<style>
  .refund-wrap { max-width: 720px; margin: 0 auto 40px; padding: calc(var(--header-h) + 40px) 16px 0; }
  .page-header { display: flex; align-items: center; gap: 16px; margin-bottom: 28px; }
  .back-link { color: var(--ink-soft); text-decoration: none; font-size: .88rem; transition: color .15s; }
  .back-link:hover { color: var(--ink); }
  .page-title { font-size: 1.5rem; font-weight: 800; }

  .info-card  { background: var(--bg); border: 1px solid var(--line); border-radius: 4px; padding: 22px 26px; margin-bottom: 20px; }
  .card-title { font-size: .95rem; font-weight: 700; margin-bottom: 14px; padding-bottom: 10px; border-bottom: 1px solid var(--line); }
  .item-row  { display: flex; align-items: center; gap: 14px; padding: 10px 0; border-bottom: 1px solid var(--line); }
  .item-row:last-child { border-bottom: none; }
  .item-thumb { width: 56px; height: 56px; object-fit: cover; border-radius: 2px; flex-shrink: 0; background: var(--ph-a); }
  .item-info  { flex: 1; font-size: .88rem; }
  .item-name  { font-weight: 600; margin-bottom: 2px; }
  .item-cat   { font-size: .78rem; color: var(--ink-soft); }
  .order-total-line { display: flex; justify-content: space-between; margin-top: 14px; padding-top: 14px; border-top: 1px solid var(--line); font-weight: 700; }

  .reason-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-bottom: 18px; }
  .reason-opt { position: relative; }
  .reason-opt input { position: absolute; opacity: 0; }
  .reason-opt label { display: block; padding: 13px 16px; border: 1px solid var(--line); border-radius: 4px;
                       cursor: pointer; font-size: .9rem; text-align: center; transition: all .15s; }
  .reason-opt input:checked + label { border-color: var(--ink); background: var(--ink); color: #fff; font-weight: 700; }
  .reason-opt label:hover { border-color: var(--ink); }

  .form-row  { margin-bottom: 18px; }
  .form-row label.field-label { display: block; font-size: 11px; font-weight: 700; letter-spacing: .08em;
                       text-transform: uppercase; color: var(--ink-soft); margin-bottom: 7px; }
  textarea#reasonDetail { width: 100%; background: var(--bg); border: 1px solid var(--line); color: var(--ink);
                       border-radius: 2px; padding: 10px 14px; font-size: .93rem; font-family: inherit;
                       outline: none; resize: vertical; min-height: 110px; box-sizing: border-box; }
  textarea#reasonDetail:focus { border-color: var(--ink); }

  .notice-box { background: #fffbef; border: 1px solid #e8c84a; color: #6b5500; padding: 12px 16px;
                       border-radius: 4px; font-size: .85rem; margin-bottom: 20px; }
  .btn-submit-refund { width: 100%; padding: 14px; background: var(--ink); color: #fff; font-weight: 700;
                       border: none; border-radius: 2px; cursor: pointer; font-size: .95rem; font-family: inherit;
                       transition: opacity .2s; }
  .btn-submit-refund:hover { opacity: .8; }
  .flash-error { background: #fff5f5; border: 1px solid var(--red); color: var(--red); padding: 11px 16px;
                       border-radius: 4px; margin-bottom: 20px; font-size: .9rem; }
</style>

<main class="refund-wrap">
  <div class="page-header">
    <a href="<%= CTX %>/member/mypage.jsp" class="back-link">← 마이페이지</a>
    <h1 class="page-title">환불 신청</h1>
  </div>

  <% if (flashError != null) { %>
  <div class="flash-error"><%= HtmlUtils.escape(flashError) %></div>
  <% } %>

  <div class="info-card">
    <div class="card-title">주문 #<%= order.getOrderNo() %> 정보</div>
    <% if (details != null) {
         for (OrderDetailDTO d : details) {
           String rawImg = d.getHatImage();
           String imgSrc = (rawImg != null && !rawImg.trim().isEmpty())
               ? CTX + "/image?src=" + URLEncoder.encode(rawImg, "UTF-8")
               : CTX + "/images/no-image.png";
    %>
    <div class="item-row">
      <img src="<%= imgSrc %>" alt="<%= HtmlUtils.escape(d.getHatName() != null ? d.getHatName() : "") %>" class="item-thumb"
           onerror="this.onerror=null;this.src='<%= CTX %>/images/no-image.png'">
      <div class="item-info">
        <div class="item-name"><%= HtmlUtils.escape(d.getHatName() != null ? d.getHatName() : "(상품명 없음)") %></div>
        <div class="item-cat"><%= HtmlUtils.escape(d.getHatCategory() != null ? d.getHatCategory() : "") %> · <%= d.getDetailQty() %>개</div>
      </div>
    </div>
    <% } } %>
    <div class="order-total-line">
      <span>총 결제 금액</span>
      <span><%= order.getFormattedTotal() %>원</span>
    </div>
  </div>

  <div class="notice-box">
    환불 신청 후 영업일 기준 3~5일 내(회사 사정에 따라 변동될 수 있음) 처리됩니다. 신청 후에는 마이페이지 &gt; 주문 내역에서 진행 상태를 확인할 수 있습니다.
  </div>

  <div class="info-card">
    <form method="POST" action="<%= CTX %>/refund/requestProc.jsp" id="refundForm">
      <input type="hidden" name="orderNo" value="<%= order.getOrderNo() %>">

      <div class="form-row">
        <label class="field-label">환불 사유 <span style="color:var(--red)">*</span></label>
        <div class="reason-grid">
          <div class="reason-opt">
            <input type="radio" name="reasonCode" id="r1" value="CHANGE_MIND">
            <label for="r1">단순 변심</label>
          </div>
          <div class="reason-opt">
            <input type="radio" name="reasonCode" id="r2" value="DEFECTIVE">
            <label for="r2">상품 불량 / 하자</label>
          </div>
          <div class="reason-opt">
            <input type="radio" name="reasonCode" id="r3" value="WRONG_ITEM">
            <label for="r3">오배송 (다른 상품 수령)</label>
          </div>
          <div class="reason-opt">
            <input type="radio" name="reasonCode" id="r4" value="SIZE_COLOR">
            <label for="r4">사이즈 / 색상 불일치</label>
          </div>
          <div class="reason-opt">
            <input type="radio" name="reasonCode" id="r5" value="LATE_DELIVERY">
            <label for="r5">배송 지연</label>
          </div>
          <div class="reason-opt">
            <input type="radio" name="reasonCode" id="r6" value="OTHER">
            <label for="r6">기타</label>
          </div>
        </div>
      </div>

      <div class="form-row">
        <label class="field-label" for="reasonDetail">상세 설명 (선택)</label>
        <textarea id="reasonDetail" name="reasonDetail" maxlength="1000" placeholder="환불 사유를 자세히 입력해주시면 빠른 처리에 도움이 됩니다."></textarea>
      </div>

      <button type="submit" class="btn-submit-refund" onclick="return validateRefundForm()">환불 신청하기</button>
    </form>
  </div>
</main>

<script>
function validateRefundForm() {
  var checked = document.querySelector('input[name="reasonCode"]:checked');
  if (!checked) { alert('환불 사유를 선택해주세요.'); return false; }
  if (checked.value === 'OTHER') {
    var detail = document.getElementById('reasonDetail').value.trim();
    if (!detail) { alert('기타 사유 선택 시 상세 설명을 입력해주세요.'); return false; }
  }
  return confirm('환불을 신청하시겠습니까?');
}
</script>

<%@ include file="/WEB-INF/inc/footer.jsp" %>
