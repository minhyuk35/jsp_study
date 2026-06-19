<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.hatshop.cart.CartDTO, com.hatshop.member.MemberDTO, java.util.List" %>
<%
    String CTX = request.getContextPath();
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    List<CartDTO> orderItems = (List<CartDTO>) request.getAttribute("orderItems");
    Integer orderTotal = (Integer) request.getAttribute("orderTotal");
    String cartNosParam = (String) request.getAttribute("cartNosParam");
    String flashError = (String) session.getAttribute("flashError");
    if (flashError != null) session.removeAttribute("flashError");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>주문?�기 - HatShop</title>
<link rel="stylesheet" href="<%=CTX%>/css/style.css">
<style>
  .order-wrap { max-width: 900px; margin: 0 auto 40px; padding: calc(var(--header-h) + 40px) 16px 0; }
  .page-title { font-size: 1.6rem; font-weight: 700; color: var(--accent); margin-bottom: 32px; }

  /* ?�션 카드 */
  .order-card { background: var(--bg-card); border: 1px solid var(--border); border-radius: 10px; padding: 28px; margin-bottom: 24px; }
  .card-title  { font-size: 1.05rem; font-weight: 600; color: var(--text-primary); border-bottom: 1px solid var(--border); padding-bottom: 12px; margin-bottom: 20px; }

  /* 주문 ?�품 ?�이�?*/
  .item-table { width: 100%; border-collapse: collapse; }
  .item-table th { font-size: .82rem; color: var(--text-muted); font-weight: 500; padding: 8px 12px; border-bottom: 1px solid var(--border); text-align: left; }
  .item-table td { padding: 12px; border-bottom: 1px solid rgba(255,255,255,.05); vertical-align: middle; }
  .item-table tr:last-child td { border-bottom: none; }
  .item-thumb { width: 64px; height: 64px; object-fit: cover; border-radius: 6px; background: var(--bg-hover); }
  .item-name  { font-weight: 600; color: var(--text-primary); }
  .item-cat   { font-size: .78rem; color: var(--text-muted); margin-top: 3px; }
  .item-price { color: var(--text-muted); }
  .item-qty   { color: var(--text-primary); font-weight: 600; }
  .item-sub   { color: var(--accent); font-weight: 700; }

  /* 총액 ??*/
  .total-row   { display: flex; justify-content: space-between; align-items: center; padding: 16px 0 0; border-top: 1px solid var(--border); margin-top: 8px; }
  .total-label { color: var(--text-muted); }
  .total-amount{ font-size: 1.3rem; font-weight: 700; color: var(--accent); }

  /* 배송 ??*/
  .form-row { margin-bottom: 18px; }
  .form-row label { display: block; font-size: .85rem; color: var(--text-muted); margin-bottom: 6px; }
  .form-row label span.req { color: var(--accent); margin-left: 3px; }
  .form-row input[type="text"],
  .form-row textarea { width: 100%; background: var(--bg-hover); border: 1px solid var(--border); color: var(--text-primary); border-radius: 6px; padding: 10px 14px; font-size: .95rem; outline: none; transition: border-color .2s; box-sizing: border-box; }
  .form-row input:focus,
  .form-row textarea:focus { border-color: var(--accent); }
  .form-row textarea { resize: vertical; min-height: 80px; }

  /* ???�보?� ?�일 버튼 */
  .btn-same { background: transparent; border: 1px solid var(--accent); color: var(--accent); padding: 6px 14px; border-radius: 20px; cursor: pointer; font-size: .82rem; transition: background .2s; }
  .btn-same:hover { background: rgba(229,185,78,.15); }

  /* 주문 버튼 */
  .btn-order { display: block; width: 100%; padding: 16px; background: var(--accent); color: #1a1a1a; font-size: 1.1rem; font-weight: 700; border: none; border-radius: 8px; cursor: pointer; transition: opacity .2s; margin-top: 8px; }
  .btn-order:hover { opacity: .88; }

  /* ?�래???�러 */
  .flash-error { background: rgba(220,53,69,.15); border: 1px solid #dc3545; color: #ff6b6b; padding: 12px 18px; border-radius: 8px; margin-bottom: 24px; }

  .form-row-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 6px; }
  .form-row-header label { margin-bottom: 0; }

  @media (max-width: 640px) {
    .item-table thead { display: none; }
    .item-table td { display: block; }
    .item-table td::before { content: attr(data-label); font-size: .78rem; color: var(--text-muted); margin-right: 8px; }
  }
</style>
</head>
<body>
<%@ include file="/WEB-INF/inc/header.jsp" %>

<main class="order-wrap">
  <h1 class="page-title">주문?�기</h1>

  <% if (flashError != null) { %>
  <div class="flash-error"><%=flashError%></div>
  <% } %>

  <form method="POST" action="<%=CTX%>/order/process" id="orderForm">
    <input type="hidden" name="cartNos" value="<%=cartNosParam != null ? cartNosParam : ""%>">

    <!-- 주문 ?�품 -->
    <div class="order-card">
      <h2 class="card-title">주문 ?�품</h2>
      <table class="item-table">
        <thead>
          <tr>
            <th style="width:76px">?��?지</th>
            <th>?�품�?/th>
            <th style="width:110px">?��?</th>
            <th style="width:60px">?�량</th>
            <th style="width:120px">?�계</th>
          </tr>
        </thead>
        <tbody>
        <% if (orderItems != null) {
             for (CartDTO item : orderItems) {
               String imgSrc = (item.getHatImage() != null && !item.getHatImage().isEmpty())
                   ? CTX + "/uploads/" + item.getHatImage()
                   : CTX + "/images/no-image.png";
        %>
          <tr>
            <td data-label="?��?지">
              <img src="<%=imgSrc%>" alt="<%=item.getHatName()%>" class="item-thumb"
                   onerror="this.src='<%=CTX%>/images/no-image.png'">
            </td>
            <td data-label="?�품�?>
              <div class="item-name"><%=item.getHatName() != null ? item.getHatName() : ""%></div>
              <div class="item-cat"><%=item.getHatCategory() != null ? item.getHatCategory() : ""%></div>
            </td>
            <td data-label="?��?" class="item-price">
              <%=item.getFormattedPrice()%>??            </td>
            <td data-label="?�량" class="item-qty"><%=item.getCartQty()%></td>
            <td data-label="?�계" class="item-sub"><%=item.getFormattedSubTotal()%>??/td>
          </tr>
        <% } } %>
        </tbody>
      </table>
      <div class="total-row">
        <span class="total-label">�?결제 금액</span>
        <span class="total-amount" id="orderTotalDisplay">
          <%
            java.text.NumberFormat nf = java.text.NumberFormat.getNumberInstance(java.util.Locale.KOREA);
            out.print(nf.format(orderTotal != null ? orderTotal : 0));
          %>??        </span>
      </div>
    </div>

    <!-- 배송 ?�보 -->
    <div class="order-card">
      <div style="display:flex;align-items:center;justify-content:space-between;border-bottom:1px solid var(--border);padding-bottom:12px;margin-bottom:20px;">
        <h2 style="font-size:1.05rem;font-weight:600;color:var(--text-primary);">배송 ?�보</h2>
        <button type="button" class="btn-same" id="btnSameAsMe"
          data-name="<%=loginUser != null ? loginUser.getMemberName() : ""%>"
          data-phone="<%=loginUser != null && loginUser.getMemberPhone() != null ? loginUser.getMemberPhone() : ""%>"
          data-addr="<%=loginUser != null && loginUser.getMemberAddr() != null ? loginUser.getMemberAddr() : ""%>">
          ???�보?� ?�일
        </button>
      </div>

      <div class="form-row">
        <label for="recvName">받는 �?<span class="req">*</span></label>
        <input type="text" id="recvName" name="recvName" maxlength="50" placeholder="받는 �??�름"
               value="<%=request.getParameter("recvName") != null ? request.getParameter("recvName") : ""%>">
        <span class="field-error" id="err-recvName"></span>
      </div>

      <div class="form-row">
        <label for="recvPhone">?�락�?<span class="req">*</span></label>
        <input type="text" id="recvPhone" name="recvPhone" maxlength="20" placeholder="010-0000-0000"
               value="<%=request.getParameter("recvPhone") != null ? request.getParameter("recvPhone") : ""%>">
        <span class="field-error" id="err-recvPhone"></span>
      </div>

      <div class="form-row">
        <label for="recvAddr">배송 주소 <span class="req">*</span></label>
        <textarea id="recvAddr" name="recvAddr" maxlength="200" placeholder="배송 받으??주소�??�력?�세??><%=request.getParameter("recvAddr") != null ? request.getParameter("recvAddr") : ""%></textarea>
        <span class="field-error" id="err-recvAddr"></span>
      </div>
    </div>

    <button type="submit" class="btn-order" id="btnOrder">주문?�기</button>
  </form>
</main>

<%@ include file="/WEB-INF/inc/footer.jsp" %>

<script>
(function() {
  /* ???�보?� ?�일 버튼 */
  var btnSame = document.getElementById('btnSameAsMe');
  if (btnSame) {
    btnSame.addEventListener('click', function() {
      document.getElementById('recvName').value  = this.dataset.name  || '';
      document.getElementById('recvPhone').value = this.dataset.phone || '';
      document.getElementById('recvAddr').value  = this.dataset.addr  || '';
    });
  }

  /* ?�화번호 ?�동 ?�이??*/
  var phoneInput = document.getElementById('recvPhone');
  if (phoneInput) {
    phoneInput.addEventListener('input', function() {
      var v = this.value.replace(/\D/g, '');
      if (v.length <= 3)       this.value = v;
      else if (v.length <= 7)  this.value = v.slice(0,3) + '-' + v.slice(3);
      else if (v.length <= 11) this.value = v.slice(0,3) + '-' + v.slice(3,7) + '-' + v.slice(7);
      else                     this.value = v.slice(0,3) + '-' + v.slice(3,7) + '-' + v.slice(7,11);
    });
  }

  /* ?�라?�언???�효??검??*/
  document.getElementById('orderForm').addEventListener('submit', function(e) {
    var ok = true;

    function setErr(id, msg) {
      var el = document.getElementById('err-' + id);
      if (el) el.textContent = msg;
      ok = false;
    }
    function clrErr(id) {
      var el = document.getElementById('err-' + id);
      if (el) el.textContent = '';
    }

    var name  = document.getElementById('recvName').value.trim();
    var phone = document.getElementById('recvPhone').value.trim();
    var addr  = document.getElementById('recvAddr').value.trim();

    clrErr('recvName'); clrErr('recvPhone'); clrErr('recvAddr');

    if (!name)  setErr('recvName',  '받는 �??�름???�력?�세??');
    if (!phone) setErr('recvPhone', '?�락처�? ?�력?�세??');
    else if (!/^010-\d{4}-\d{4}$/.test(phone)) setErr('recvPhone', '010-0000-0000 ?�식?�로 ?�력?�세??');
    if (!addr)  setErr('recvAddr',  '배송 주소�??�력?�세??');

    if (!ok) { e.preventDefault(); return; }

    /* 중복 ?�출 방�? */
    var btn = document.getElementById('btnOrder');
    btn.disabled = true;
    btn.textContent = '처리 �?..';
  });
})();
</script>
</body>
</html>
