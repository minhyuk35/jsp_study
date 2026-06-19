<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hatshop.hat.HatDTO,
                 com.hatshop.member.MemberDTO,
                 com.hatshop.util.HtmlUtils,
                 java.util.List,
                 java.net.URLEncoder" %>
<%
    HatDTO hat = (HatDTO) request.getAttribute("hat");

    @SuppressWarnings("unchecked")
    List<HatDTO> related = (List<HatDTO>) request.getAttribute("related");

    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

    String  ctx      = request.getContextPath();
    boolean soldOut  = hat.isSoldOut();
    int     stock    = hat.getHatStock();

    /* 플래시 메시지 (장바구니 담기 결과) */
    String flashSuccess = (String) session.getAttribute("flashSuccess");
    String flashError   = (String) session.getAttribute("flashError");
    session.removeAttribute("flashSuccess");
    session.removeAttribute("flashError");

    /* 로그인 후 복귀 URL */
    String backPath   = "/hat/detail?hatNo=" + hat.getHatNo();
    String redirectUrl = URLEncoder.encode(backPath, "UTF-8");
%>
<%@ include file="/WEB-INF/inc/header.jsp" %>
<%@ include file="/WEB-INF/inc/nav.jsp" %>

<style>
/* ── 브레드크럼 ── */
.breadcrumb {
  display: flex; align-items: center; gap: 6px; flex-wrap: wrap;
  font-family: var(--mono); font-size: 10px; letter-spacing: .14em;
  text-transform: uppercase; color: var(--ink-soft); margin-bottom: 36px;
}
.breadcrumb a:hover { color: var(--ink); }
.breadcrumb .sep { color: var(--line); }

/* ── 상세 2컬럼 ── */
.detail-wrap {
  display: grid; grid-template-columns: 1fr 1fr;
  gap: 60px; align-items: start; margin-bottom: 80px;
}

/* ── 이미지 영역 ── */
.detail-img-box {
  background: var(--ph-a); aspect-ratio: 4/5; overflow: hidden;
  position: sticky; top: calc(var(--header-h) + 16px);
}
.detail-img-box img { width: 100%; height: 100%; object-fit: cover; mix-blend-mode: multiply; transition: transform .6s; }
.detail-img-box:hover img { transform: scale(1.04); }
.detail-img-placeholder { display: none; }

/* ── 정보 영역 ── */
.detail-info { display: flex; flex-direction: column; gap: 0; padding-top: 8px; }

.detail-cat-badge {
  font-family: var(--mono); font-size: 10px; font-weight: 700; letter-spacing: .2em;
  text-transform: uppercase; color: var(--ink-soft); margin-bottom: 14px; display: block;
}
.detail-name {
  font-size: clamp(26px, 4vw, 44px); font-weight: 900; line-height: .95;
  letter-spacing: -.03em; text-transform: uppercase; margin-bottom: 22px;
}
.detail-price {
  font-size: clamp(22px, 3vw, 32px); font-weight: 800;
  letter-spacing: -.01em; margin-bottom: 26px;
}
.detail-divider { border: none; border-top: 1px solid var(--line); margin: 24px 0; }

/* 재고 상태 */
.stock-badge {
  display: inline-flex; align-items: center; gap: 6px;
  font-size: 11px; font-weight: 700; letter-spacing: .08em; padding: 6px 12px;
}
.stock-ok   { background: rgba(42,125,79,.08); color: var(--green); }
.stock-low  { background: rgba(200,0,0,.06);   color: #a83200; }
.stock-none { background: rgba(0,0,0,.05);     color: var(--ink-soft); }

/* 수량 선택기 */
.qty-row   { display: flex; align-items: center; gap: 16px; margin: 20px 0; }
.qty-label {
  font-size: 11px; font-weight: 700; letter-spacing: .12em;
  text-transform: uppercase; color: var(--ink-soft); flex-shrink: 0;
}
.qty-ctrl  { display: flex; align-items: center; border: 1.4px solid var(--line); }
.qty-btn   {
  width: 42px; height: 42px; background: transparent; border: none; color: var(--ink);
  font-size: 18px; line-height: 1; cursor: pointer; transition: background .15s; font-family: inherit;
}
.qty-btn:hover:not(:disabled) { background: var(--ph-a); }
.qty-btn:disabled { opacity: .3; cursor: not-allowed; }
.qty-input {
  width: 60px; height: 42px; text-align: center; background: transparent;
  border: none; border-left: 1px solid var(--line); border-right: 1px solid var(--line);
  color: var(--ink); font-size: 14px; font-weight: 800; font-family: inherit;
  -moz-appearance: textfield;
}
.qty-input::-webkit-outer-spin-button,
.qty-input::-webkit-inner-spin-button { -webkit-appearance: none; }
.qty-max { font-size: 11px; color: var(--ink-soft); font-family: var(--mono); }

/* 총 금액 미리보기 */
.total-preview {
  background: var(--ph-a); padding: 14px 18px; margin-top: 8px;
  display: flex; justify-content: space-between; align-items: center;
}
.total-preview span:first-child {
  font-size: 11px; font-weight: 700; letter-spacing: .12em;
  text-transform: uppercase; color: var(--ink-soft);
}
.total-preview .total-amount { font-size: 16px; font-weight: 900; }

/* 액션 버튼 */
.action-btns { display: flex; gap: 10px; margin-top: 8px; }
.action-btns .btn { flex: 1; justify-content: center; }
.btn-cart-add {
  background: transparent; color: var(--ink); border-color: var(--ink);
}
.btn-cart-add:hover { background: var(--ink); color: #fff; }
.btn-buy-now  { background: var(--ink); color: #fff; }
.btn-buy-now:hover { background: var(--btn-hover); }

/* 품절 버튼 */
.btn-soldout {
  flex: 1; padding: 16px; font-size: 12px; font-weight: 800;
  letter-spacing: .12em; text-transform: uppercase;
  background: var(--ph-a); color: var(--ink-soft); border: 1.4px solid var(--line);
  cursor: not-allowed; font-family: inherit;
}

/* ── 상품 설명 ── */
.desc-section {
  border-top: 1px solid var(--line); padding: 48px 0; margin-bottom: 64px;
}
.desc-section h2 {
  font-size: 12px; font-weight: 800; letter-spacing: .2em;
  text-transform: uppercase; color: var(--ink-soft); margin-bottom: 20px;
}
.desc-body { line-height: 1.9; color: #555; white-space: pre-line; font-size: 15px; }
.desc-empty { color: var(--ink-soft); font-style: italic; font-size: 14px; }

/* ── 연관 상품 ── */
.related-section { padding-bottom: 80px; }
.related-section h2 {
  font-size: clamp(22px, 3.5vw, 38px); font-weight: 900;
  letter-spacing: -.025em; text-transform: uppercase;
  line-height: .95; margin-bottom: 28px;
}
.related-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 14px; }
.related-card { position: relative; }
.related-card a { display: block; color: inherit; }
.related-img {
  aspect-ratio: 4/5; overflow: hidden; background: var(--ph-a); margin-bottom: 12px;
}
.related-img img {
  width: 100%; height: 100%; object-fit: cover;
  transition: transform .7s cubic-bezier(.2,.7,.2,1);
}
.related-card:hover .related-img img { transform: scale(1.06); }
.r-fallback { display: none; }
.related-body { padding: 0 2px; }
.related-name  { font-size: 13px; font-weight: 600; margin-bottom: 5px; line-height: 1.3; }
.related-price { font-size: 13px; font-weight: 800; }
.related-sold  { font-size: 11px; color: var(--ink-soft); margin-top: 2px; }

/* ── 반응형 ── */
@media (max-width: 900px) {
  .detail-wrap { grid-template-columns: 1fr; gap: 28px; }
  .detail-img-box { position: static; aspect-ratio: 1/1; }
  .detail-name { font-size: 1.6rem; }
  .detail-price { font-size: 1.4rem; }
  .related-grid { grid-template-columns: repeat(2, 1fr); }
}
@media (max-width: 480px) {
  .action-btns { flex-direction: column; }
  .related-grid { gap: 10px; }
}
</style>

<main class="main-content">
<div class="container">

  <!-- 플래시 메시지 -->
  <% if (flashSuccess != null) { %>
  <div class="alert alert-success" style="margin-bottom:20px"><%= flashSuccess %></div>
  <% } %>
  <% if (flashError != null) { %>
  <div class="alert alert-error" style="margin-bottom:20px"><%= flashError %></div>
  <% } %>

  <!-- ── 브레드크럼 ── -->
  <nav class="breadcrumb">
    <a href="<%= ctx %>/">홈</a>
    <span class="sep">›</span>
    <a href="<%= ctx %>/hat/list">전체</a>
    <span class="sep">›</span>
    <a href="<%= ctx %>/hat/list?category=<%= URLEncoder.encode(hat.getHatCategory(),"UTF-8") %>">
      <%= HtmlUtils.escape(hat.getHatCategory()) %>
    </a>
    <span class="sep">›</span>
    <span><%= HtmlUtils.escape(hat.getHatName()) %></span>
  </nav>

  <!-- ── 메인 상세 ── -->
  <div class="detail-wrap">

    <!-- 이미지 -->
    <div class="detail-img-box">
       <% String imgSrc = hat.getHatImage();
          String noImage = ctx + "/images/no-image.png";
       %>
      <% if (imgSrc != null && !imgSrc.trim().isEmpty()) { %>
      <img src="<%= ctx %>/image?src=<%= URLEncoder.encode(imgSrc, "UTF-8") %>"
         alt="<%= HtmlUtils.escape(hat.getHatName()) %>"
         onerror="this.onerror=null;this.src='<%= noImage %>'">
      <span class="detail-img-placeholder" style="display:none"><svg class="icon-svg" style="width:2.2em;height:2.2em" viewBox="0 0 24 24"><path d="M4 16c0-4.4 3.6-8 8-8s8 3.6 8 8"/><ellipse cx="12" cy="16" rx="10" ry="2.2"/></svg></span>
      <% } else { %>
       <img src="<%= noImage %>" alt="<%= HtmlUtils.escape(hat.getHatName()) %>">
      <% } %>
    </div>

    <!-- 정보 -->
    <div class="detail-info">

      <span class="detail-cat-badge"><%= HtmlUtils.escape(hat.getHatCategory()) %></span>
      <h1 class="detail-name"><%= HtmlUtils.escape(hat.getHatName()) %></h1>
      <p class="detail-price"><%= hat.getFormattedPrice() %>원</p>

      <hr class="detail-divider">

      <!-- 재고 상태 -->
      <div>
        <% if (soldOut) { %>
        <span class="stock-badge stock-none"><svg class="icon-svg" style="width:.9em;height:.9em" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><line x1="4.93" y1="4.93" x2="19.07" y2="19.07"/></svg> 품절</span>
        <% } else if (stock <= 5) { %>
        <span class="stock-badge stock-low"><svg class="icon-svg" style="width:.9em;height:.9em" viewBox="0 0 24 24"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg> 잔여 <%= stock %>개 (품절 임박)</span>
        <% } else { %>
        <span class="stock-badge stock-ok"><svg class="icon-svg" style="width:.9em;height:.9em" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg> 재고 있음 (<%= stock %>개)</span>
        <% } %>
      </div>

      <hr class="detail-divider">

      <!-- 수량 선택 -->
      <div class="qty-row">
        <span class="qty-label">수량</span>
        <div class="qty-ctrl">
          <button type="button" class="qty-btn" id="btnMinus"
                  onclick="changeQty(-1)" <%= soldOut ? "disabled" : "" %>>−</button>
          <input type="number" class="qty-input" id="qtyDisplay"
                 value="1" min="1" max="<%= Math.max(stock, 1) %>"
                 oninput="syncQty(this)" <%= soldOut ? "disabled" : "" %>>
          <button type="button" class="qty-btn" id="btnPlus"
                  onclick="changeQty(1)" <%= soldOut ? "disabled" : "" %>>+</button>
        </div>
        <% if (!soldOut) { %>
        <span class="qty-max">최대 <%= stock %>개</span>
        <% } %>
      </div>

      <!-- 총 금액 미리보기 -->
      <% if (!soldOut) { %>
      <div class="total-preview">
        <span>총 주문금액</span>
        <span class="total-amount" id="totalPreview"><%= hat.getFormattedPrice() %>원</span>
      </div>
      <% } %>

      <!-- 액션 버튼 -->
      <div class="action-btns" style="margin-top:16px">
        <% if (soldOut) { %>
        <button class="btn-soldout" disabled><svg class="icon-svg" style="width:.9em;height:.9em" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><line x1="4.93" y1="4.93" x2="19.07" y2="19.07"/></svg> 품절된 상품입니다</button>
        <% } else { %>
        <button type="button" class="btn btn-cart-add" onclick="submitCart(false)">장바구니 담기</button>
        <button type="button" class="btn btn-buy-now" onclick="submitCart(true)">바로 구매</button>
        <% } %>
      </div>

      <!-- hatNo 참조용 (submitCart에서 사용) -->
      <span id="cartHatNo" data-no="<%= hat.getHatNo() %>" style="display:none"></span>

    </div><!-- /detail-info -->
  </div><!-- /detail-wrap -->

  <!-- ── 상품 설명 ── -->
  <section class="desc-section">
    <h2>상품 설명</h2>
    <div class="desc-body">
      <% String desc = hat.getHatDesc(); %>
      <% if (desc != null && !desc.trim().isEmpty()) { %>
      <%= HtmlUtils.nl2br(desc) %>
      <% } else { %>
      <span class="desc-empty">등록된 상품 설명이 없습니다.</span>
      <% } %>
    </div>
  </section>

  <!-- ── 연관 상품 ── -->
  <% if (related != null && !related.isEmpty()) { %>
  <section class="related-section">
    <h2>같은 카테고리 상품</h2>
    <div class="related-grid">
      <% for (HatDTO r : related) { %>
      <div class="related-card">
        <a href="<%= ctx %>/hat/detail?hatNo=<%= r.getHatNo() %>">
          <div class="related-img">
              <% String riSrc = r.getHatImage(); %>
                <% if (riSrc != null && !riSrc.trim().isEmpty()) { %>
                  <img src="<%= ctx %>/image?src=<%= URLEncoder.encode(riSrc, "UTF-8") %>"
                alt="<%= HtmlUtils.escape(r.getHatName()) %>"
                onerror="this.onerror=null;this.src='<%= ctx %>/images/no-image.png'">
            <span class="r-fallback" style="display:none"><svg class="icon-svg" viewBox="0 0 24 24"><path d="M4 16c0-4.4 3.6-8 8-8s8 3.6 8 8"/><ellipse cx="12" cy="16" rx="10" ry="2.2"/></svg></span>
            <% } else { %>
              <img src="<%= ctx %>/images/no-image.png" alt="<%= HtmlUtils.escape(r.getHatName()) %>">
            <% } %>
          </div>
          <div class="related-body">
            <p class="related-name"><%= HtmlUtils.escape(r.getHatName()) %></p>
            <p class="related-price"><%= r.getFormattedPrice() %>원</p>
            <% if (r.isSoldOut()) { %><p class="related-sold">품절</p><% } %>
          </div>
        </a>
      </div>
      <% } %>
    </div>
  </section>
  <% } %>

</div><!-- /container -->
</main>

<script>
const IS_LOGGED_IN  = <%= loginUser != null ? "true" : "false" %>;
const LOGIN_URL     = '<%= ctx %>/member/login.jsp?redirectURL=<%= redirectUrl %>';
const UNIT_PRICE    = <%= hat.getHatPrice() %>;
const MAX_STOCK     = <%= Math.max(stock, 1) %>;

/* ── 수량 변경 ── */
function changeQty(delta) {
    const input = document.getElementById('qtyDisplay');
    let val = parseInt(input.value || 1) + delta;
    val = Math.max(1, Math.min(val, MAX_STOCK));
    input.value = val;
    onQtyChange(val);
}

function syncQty(input) {
    let val = parseInt(input.value);
    if (isNaN(val) || val < 1) val = 1;
    if (val > MAX_STOCK) val = MAX_STOCK;
    input.value = val;
    onQtyChange(val);
}

function onQtyChange(val) {
    /* 총 금액 미리보기 갱신 */
    const preview = document.getElementById('totalPreview');
    if (preview) {
        preview.textContent = (UNIT_PRICE * val).toLocaleString('ko-KR') + '원';
    }
    /* +/- 버튼 상태 */
    document.getElementById('btnMinus').disabled = (val <= 1);
    document.getElementById('btnPlus').disabled  = (val >= MAX_STOCK);
}

/* ── 장바구니 제출 ── */
function submitCart(buyNow) {
    if (!IS_LOGGED_IN) {
        location.href = LOGIN_URL;
        return;
    }
    var qty   = parseInt(document.getElementById('qtyDisplay').value) || 1;
    var hatNo = document.getElementById('cartHatNo').dataset.no;
    var params = 'hatNo=' + hatNo + '&qty=' + qty + '&buyNow=' + (buyNow ? 'Y' : 'N');

    fetch('<%= ctx %>/cart/add', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: params
    })
    .then(function(r) { return r.json(); })
    .then(function(data) {
        if (data.result === 'ok') {
            if (data.redirect) {
                location.href = data.redirect;
            } else {
                if (typeof incrementCartBadge === 'function') incrementCartBadge();
                alert(data.msg || '장바구니에 담겼습니다.');
            }
        } else {
            alert(data.msg || '오류가 발생했습니다.');
        }
    })
    .catch(function() { alert('오류가 발생했습니다.'); });
}

/* ── 초기화 ── */
onQtyChange(1);
</script>

<%@ include file="/WEB-INF/inc/footer.jsp" %>
