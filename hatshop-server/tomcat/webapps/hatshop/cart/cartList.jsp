<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hatshop.member.MemberDTO, com.hatshop.cart.CartDTO,
                 com.hatshop.util.HtmlUtils, java.util.List" %>
<%
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    if (loginUser == null) {
        response.sendRedirect(request.getContextPath() + "/member/login.jsp"); return;
    }

    String ctx  = request.getContextPath();
    List<CartDTO> cartList   = (List<CartDTO>) request.getAttribute("cartList");
    int           totalPrice = (Integer)       request.getAttribute("totalPrice");
    boolean       isEmpty    = cartList == null || cartList.isEmpty();

    String flashSuccess = (String) session.getAttribute("flashSuccess");
    session.removeAttribute("flashSuccess");
%>
<%@ include file="/WEB-INF/inc/header.jsp" %>

<style>
/* ── 레이아웃 ─────────────────────────────────── */
.cart-wrap      { max-width: 1000px; margin: 0 auto; }
.cart-page-head { display: flex; align-items: center; justify-content: space-between;
                  margin-bottom: 20px; flex-wrap: wrap; gap: 10px; }
.cart-page-head h1 { font-size: 1.25rem; font-weight: 700; }

/* ── 테이블 ────────────────────────────────────── */
.cart-card      { background: var(--bg-secondary); border: 1px solid var(--border);
                  border-radius: 12px; overflow: hidden; }
.cart-table     { width: 100%; border-collapse: collapse; font-size: .9rem; }
.cart-table th  { padding: 13px 14px; background: var(--bg-card);
                  color: var(--text-muted); font-weight: 600; text-align: center;
                  border-bottom: 1px solid var(--border); }
.cart-table td  { padding: 14px; border-bottom: 1px solid rgba(255,255,255,.04);
                  vertical-align: middle; text-align: center; }
.cart-table tr:last-child td { border-bottom: none; }
.cart-table tbody tr:hover td { background: rgba(255,255,255,.03); }

/* ── 상품 셀 ─────────────────────────────────── */
.cart-prod      { display: flex; align-items: center; gap: 12px; text-align: left; }
.cart-thumb     { width: 60px; height: 60px; border-radius: 8px; object-fit: cover;
                  border: 1px solid var(--border); background: var(--bg-card); flex-shrink: 0; }
.cart-thumb-empty { display: flex; align-items: center; justify-content: center;
                    font-size: 1.5rem; background: var(--bg-card);
                    border: 1px solid var(--border); }
.cart-name      { font-weight: 600; color: var(--text-primary); }
.cart-category  { font-size: .78rem; color: var(--text-muted); margin-top: 2px; }

/* ── 수량 컨트롤 ───────────────────────────────── */
.qty-ctrl       { display: inline-flex; align-items: center;
                  border: 1px solid var(--border); border-radius: 8px; overflow: hidden; }
.qty-btn        { width: 32px; height: 32px; background: var(--bg-card); border: none;
                  color: var(--text-primary); font-size: 1rem; cursor: pointer;
                  display: flex; align-items: center; justify-content: center;
                  transition: background .15s; }
.qty-btn:hover  { background: var(--accent); color: #111; }
.qty-btn:disabled { opacity: .35; cursor: default; }
.qty-num        { min-width: 36px; text-align: center; font-weight: 600; padding: 0 4px; }

/* ── 소계 ────────────────────────────────────── */
.subtotal       { font-weight: 700; color: var(--accent); white-space: nowrap; }

/* ── 삭제 버튼 ───────────────────────────────── */
.btn-del        { width: 28px; height: 28px; border-radius: 50%; background: transparent;
                  border: 1px solid var(--border); color: var(--text-muted);
                  cursor: pointer; font-size: .85rem; display: inline-flex;
                  align-items: center; justify-content: center; transition: .15s; }
.btn-del:hover  { border-color: var(--danger); color: var(--danger); background: rgba(224,82,82,.1); }

/* ── 체크박스 ────────────────────────────────── */
.cart-check     { width: 17px; height: 17px; accent-color: var(--accent); cursor: pointer; }

/* ── 하단 요약 ───────────────────────────────── */
.cart-footer    { padding: 20px 24px; background: var(--bg-card);
                  border-top: 1px solid var(--border);
                  display: flex; align-items: center; justify-content: space-between;
                  flex-wrap: wrap; gap: 14px; }
.total-info     { display: flex; align-items: center; gap: 24px; flex-wrap: wrap; }
.total-item     { font-size: .85rem; color: var(--text-muted); }
.total-item strong { color: var(--text-primary); font-weight: 700; }
.total-main     { font-size: 1.05rem; font-weight: 700; }
.total-main strong { color: var(--accent); font-size: 1.2rem; }
.cart-actions   { display: flex; gap: 10px; flex-wrap: wrap; }

/* ── 툴바 ────────────────────────────────────── */
.cart-toolbar   { display: flex; align-items: center; gap: 10px; margin-bottom: 12px;
                  flex-wrap: wrap; }

/* ── 빈 장바구니 ────────────────────────────── */
.cart-empty     { text-align: center; padding: 80px 20px;
                  color: var(--text-muted); }
.cart-empty .icon   { font-size: 4rem; margin-bottom: 16px; opacity: .5; }
.cart-empty p       { font-size: 1rem; margin-bottom: 20px; }

/* ── 품절 표시 ───────────────────────────────── */
.out-of-stock   { color: var(--danger); font-size: .76rem; margin-top: 3px; }

/* ── 반응형 ────────────────────────────────── */
@media (max-width: 700px) {
    .cart-table th:nth-child(4),
    .cart-table td:nth-child(4),
    .cart-table th:nth-child(2),
    .cart-table td:nth-child(2) { display: none; }
    .cart-footer { flex-direction: column; align-items: flex-start; }
}

/* ── 토스트 ────────────────────────────────── */
#cart-toast { position: fixed; bottom: 28px; left: 50%; transform: translateX(-50%) translateY(60px);
              background: var(--bg-card); border: 1px solid var(--border); border-radius: 8px;
              padding: 12px 22px; font-size: .88rem; color: var(--text-primary);
              box-shadow: 0 4px 20px rgba(0,0,0,.4); transition: transform .3s ease, opacity .3s ease;
              opacity: 0; z-index: 9999; white-space: nowrap; }
#cart-toast.show { transform: translateX(-50%) translateY(0); opacity: 1; }
</style>

<main class="main-content">
<div class="container">
<div class="cart-wrap">

  <div class="cart-page-head">
    <h1><svg class="icon-svg" viewBox="0 0 24 24"><circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/></svg> 장바구니
      <% if (!isEmpty) { %>
      <span style="font-size:.85rem;color:var(--text-muted);font-weight:400">
        (<span id="item-count"><%= cartList.size() %></span>개)
      </span>
      <% } %>
    </h1>
    <a href="<%= ctx %>/hat/list" class="btn btn-secondary" style="font-size:.85rem">쇼핑 계속하기</a>
  </div>

  <% if (flashSuccess != null) { %>
  <div class="alert alert-success"><%= HtmlUtils.escape(flashSuccess) %></div>
  <% } %>

  <% if (isEmpty) { %>
  <!-- ── 빈 장바구니 ── -->
  <div class="cart-card">
    <div class="cart-empty">
      <div class="icon"><svg class="icon-svg" style="width:1em;height:1em" viewBox="0 0 24 24"><circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/></svg></div>
      <p>장바구니가 비어 있습니다.</p>
      <a href="<%= ctx %>/hat/list" class="btn btn-primary">모자 쇼핑하러 가기</a>
    </div>
  </div>

  <% } else { %>
  <!-- ── 툴바: 선택 삭제 / 전체 선택 ── -->
  <div class="cart-toolbar">
    <label style="display:flex;align-items:center;gap:7px;cursor:pointer;font-size:.88rem">
      <input type="checkbox" id="checkAll" class="cart-check" onchange="toggleAll(this)">
      전체 선택
    </label>
    <button class="btn btn-secondary" style="font-size:.82rem;padding:6px 12px"
            onclick="deleteSelected()">선택 삭제</button>
  </div>

  <!-- ── 장바구니 테이블 ── -->
  <div class="cart-card">
    <table class="cart-table">
      <thead>
        <tr>
          <th style="width:40px"></th>
          <th style="width:70px">이미지</th>
          <th style="text-align:left">상품명</th>
          <th style="width:100px">단가</th>
          <th style="width:130px">수량</th>
          <th style="width:110px">소계</th>
          <th style="width:44px"></th>
        </tr>
      </thead>
      <tbody id="cartBody">
      <%
        String noImage = ctx + "/images/no-image.png";
        for (CartDTO item : cartList) {
            String imgSrc = item.getHatImage();
            String proxySrc = (imgSrc != null && !imgSrc.trim().isEmpty())
              ? ctx + "/image?src=" + java.net.URLEncoder.encode(imgSrc, "UTF-8")
              : noImage;
            if (imgSrc == null || imgSrc.trim().isEmpty()) {
              imgSrc = noImage;
          }
      %>
        <tr id="row-<%= item.getCartNo() %>" class="cart-row">

          <!-- 체크박스 -->
          <td>
            <input type="checkbox"
                   class="cart-check item-check"
                   value="<%= item.getCartNo() %>"
                   data-price="<%= item.getHatPrice() %>"
                   onchange="updateSelectedTotal()">
          </td>

          <!-- 이미지 -->
          <td>
                <% if (imgSrc != null) { %>
            <img class="cart-thumb"
                  src="<%= proxySrc %>"
                alt="<%= HtmlUtils.escape(item.getHatName()) %>"
                onerror="this.onerror=null;this.src='<%= noImage %>'">
            <% } else { %>
              <img class="cart-thumb cart-thumb-empty"
                src="<%= noImage %>"
                alt="<%= HtmlUtils.escape(item.getHatName()) %>">
            <% } %>
          </td>

          <!-- 상품명 -->
          <td>
            <div class="cart-prod">
              <div>
                <div class="cart-name">
                  <a href="<%= ctx %>/hat/detail?hatNo=<%= item.getHatNo() %>"
                     style="color:inherit;text-decoration:none">
                    <%= HtmlUtils.escape(item.getHatName()) %>
                  </a>
                </div>
                <div class="cart-category"><%= HtmlUtils.escape(item.getHatCategory()) %></div>
                <% if (item.isOverStock()) { %>
                <div class="out-of-stock"><svg class="icon-svg" style="width:.85em;height:.85em" viewBox="0 0 24 24"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg> 재고 부족 (현재 재고 <%= item.getHatStock() %>개)</div>
                <% } else if (item.isSoldOut()) { %>
                <div class="out-of-stock">품절</div>
                <% } %>
              </div>
            </div>
          </td>

          <!-- 단가 -->
          <td><%= item.getFormattedPrice() %>원</td>

          <!-- 수량 컨트롤 -->
          <td>
            <div class="qty-ctrl">
              <button class="qty-btn"
                      onclick="updateQty(<%= item.getCartNo() %>, -1)"
                      id="btn-minus-<%= item.getCartNo() %>"
                      <%= item.getCartQty() <= 1 ? "disabled" : "" %>
                      title="수량 감소">−</button>
              <span class="qty-num" id="qty-<%= item.getCartNo() %>"><%= item.getCartQty() %></span>
              <button class="qty-btn"
                      onclick="updateQty(<%= item.getCartNo() %>, 1)"
                      id="btn-plus-<%= item.getCartNo() %>"
                      <%= item.getCartQty() >= item.getHatStock() ? "disabled" : "" %>
                      title="수량 증가">+</button>
            </div>
          </td>

          <!-- 소계 -->
          <td>
            <span class="subtotal" id="sub-<%= item.getCartNo() %>">
              <%= item.getFormattedSubTotal() %>원
            </span>
          </td>

          <!-- 삭제 -->
          <td>
            <button class="btn-del" onclick="deleteItem(<%= item.getCartNo() %>)" title="삭제">✕</button>
          </td>
        </tr>
      <% } %>
      </tbody>
    </table>

    <!-- ── 하단 요약 + 버튼 ── -->
    <div class="cart-footer">
      <div class="total-info">
        <div class="total-item">
          선택 합계:
          <strong id="selected-total">0원</strong>
        </div>
        <div class="total-main">
          전체 합계:
          <strong id="total-price"><%= formatPrice(totalPrice) %>원</strong>
        </div>
      </div>
      <div class="cart-actions">
        <button class="btn btn-secondary" onclick="deleteSelected()">선택 삭제</button>
        <button class="btn btn-primary"   onclick="orderSelected()"  id="btn-order">
          선택 상품 주문
        </button>
      </div>
    </div>
  </div><!-- /cart-card -->
  <% } %>

</div>
</div>
</main>

<div id="cart-toast"></div>

<script>
const CTX = '<%= ctx %>';

/* ── 가격 포맷 ─────────────────────────────── */
function formatPrice(n) {
    return Number(n).toLocaleString('ko-KR');
}

/* ── 선택 합계 갱신 ─────────────────────────── */
function updateSelectedTotal() {
    let total = 0;
    document.querySelectorAll('.item-check:checked').forEach(cb => {
        const row  = document.getElementById('row-' + cb.value);
        const qtyEl = document.getElementById('qty-' + cb.value);
        const price = parseInt(cb.dataset.price) || 0;
        const qty   = parseInt(qtyEl ? qtyEl.textContent : 1);
        total += price * qty;
    });
    document.getElementById('selected-total').textContent = formatPrice(total) + '원';

    // 전체 선택 체크박스 동기화
    const all     = document.querySelectorAll('.item-check');
    const checked = document.querySelectorAll('.item-check:checked');
    const checkAllEl = document.getElementById('checkAll');
    if (checkAllEl) {
        checkAllEl.checked       = checked.length === all.length && all.length > 0;
        checkAllEl.indeterminate = checked.length > 0 && checked.length < all.length;
    }
}

/* ── 전체 선택 / 해제 ───────────────────────── */
function toggleAll(cb) {
    document.querySelectorAll('.item-check').forEach(el => el.checked = cb.checked);
    updateSelectedTotal();
}

/* ── 수량 변경 AJAX ─────────────────────────── */
async function updateQty(cartNo, delta) {
    const qtyEl    = document.getElementById('qty-'       + cartNo);
    const minusBtn = document.getElementById('btn-minus-' + cartNo);
    const plusBtn  = document.getElementById('btn-plus-'  + cartNo);
    if (!qtyEl) return;

    const newQty = parseInt(qtyEl.textContent) + delta;
    if (newQty < 1) return;

    // 버튼 잠금
    if (minusBtn) minusBtn.disabled = true;
    if (plusBtn)  plusBtn.disabled  = true;

    try {
        const res  = await fetch(CTX + '/cart/update', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'cartNo=' + cartNo + '&qty=' + newQty
        });
        const data = await res.json();

        if (data.result === 'ok') {
            const actualQty = data.qty || newQty;
            qtyEl.textContent = actualQty;

            // 소계 갱신
            const subEl = document.getElementById('sub-' + cartNo);
            if (subEl) subEl.textContent = formatPrice(data.subTotal) + '원';

            // 전체 합계 갱신
            const totalEl = document.getElementById('total-price');
            if (totalEl) totalEl.textContent = formatPrice(data.totalPrice) + '원';

            // 선택 합계 갱신
            updateSelectedTotal();

            // 버튼 상태 복원
            if (minusBtn) minusBtn.disabled = (actualQty <= 1);
            // stock 정보가 없으면 plus는 항상 활성화 (서버에서 재고 체크)
            if (plusBtn)  plusBtn.disabled  = false;

        } else {
            showToast(data.msg || '수정에 실패했습니다.', 'error');
            // 버튼 복원
            if (minusBtn) minusBtn.disabled = (parseInt(qtyEl.textContent) <= 1);
            if (plusBtn)  plusBtn.disabled  = false;
        }
    } catch (e) {
        showToast('서버 오류가 발생했습니다.', 'error');
        if (minusBtn) minusBtn.disabled = false;
        if (plusBtn)  plusBtn.disabled  = false;
    }
}

/* ── 단건 삭제 AJAX ─────────────────────────── */
async function deleteItem(cartNo) {
    if (!confirm('이 상품을 장바구니에서 삭제하시겠습니까?')) return;

    try {
        const res  = await fetch(CTX + '/cart/delete', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'cartNo=' + cartNo
        });
        const data = await res.json();

        if (data.result === 'ok') {
            const row = document.getElementById('row-' + cartNo);
            if (row) row.remove();

            // 합계 갱신
            const totalEl = document.getElementById('total-price');
            if (totalEl) totalEl.textContent = formatPrice(data.totalPrice) + '원';

            // 아이템 수 갱신
            const countEl = document.getElementById('item-count');
            const rows    = document.querySelectorAll('.cart-row');
            if (countEl) countEl.textContent = rows.length;

            updateSelectedTotal();
            showToast('상품이 삭제되었습니다.');

            // 빈 장바구니 → 페이지 리로드
            if (rows.length === 0) setTimeout(() => location.reload(), 600);

        } else {
            showToast(data.msg || '삭제에 실패했습니다.', 'error');
        }
    } catch (e) {
        showToast('서버 오류가 발생했습니다.', 'error');
    }
}

/* ── 선택 삭제 AJAX ─────────────────────────── */
async function deleteSelected() {
    const checked = document.querySelectorAll('.item-check:checked');
    if (checked.length === 0) { showToast('삭제할 상품을 선택하세요.'); return; }
    if (!confirm(checked.length + '개 상품을 장바구니에서 삭제하시겠습니까?')) return;

    const cartNos = Array.from(checked).map(cb => cb.value).join(',');

    try {
        const res  = await fetch(CTX + '/cart/delete', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'cartNos=' + encodeURIComponent(cartNos)
        });
        const data = await res.json();

        if (data.result === 'ok') {
            checked.forEach(cb => {
                const row = document.getElementById('row-' + cb.value);
                if (row) row.remove();
            });

            const totalEl = document.getElementById('total-price');
            if (totalEl) totalEl.textContent = formatPrice(data.totalPrice) + '원';

            const rows    = document.querySelectorAll('.cart-row');
            const countEl = document.getElementById('item-count');
            if (countEl) countEl.textContent = rows.length;

            // 전체 선택 해제
            const checkAllEl = document.getElementById('checkAll');
            if (checkAllEl) { checkAllEl.checked = false; checkAllEl.indeterminate = false; }

            updateSelectedTotal();
            showToast(checked.length + '개 상품이 삭제되었습니다.');

            if (rows.length === 0) setTimeout(() => location.reload(), 600);

        } else {
            showToast(data.msg || '삭제에 실패했습니다.', 'error');
        }
    } catch (e) {
        showToast('서버 오류가 발생했습니다.', 'error');
    }
}

/* ── 선택 상품 주문 ─────────────────────────── */
function orderSelected() {
    const checked = document.querySelectorAll('.item-check:checked');
    if (checked.length === 0) { showToast('주문할 상품을 선택하세요.'); return; }

    const cartNos = Array.from(checked).map(cb => cb.value).join(',');
    location.href = CTX + '/order/checkout?cartNos=' + encodeURIComponent(cartNos);
}

/* ── 토스트 알림 ─────────────────────────────── */
function showToast(msg, type) {
    const el = document.getElementById('cart-toast');
    el.textContent = msg;
    el.style.borderColor = type === 'error' ? 'var(--danger)' : 'var(--border)';
    el.classList.add('show');
    clearTimeout(el._timer);
    el._timer = setTimeout(() => el.classList.remove('show'), 2400);
}

/* ── 초기화 ──────────────────────────────────── */
document.addEventListener('DOMContentLoaded', function () {
    updateSelectedTotal();
});
</script>

<%-- 서버 측 포맷 헬퍼 (선언 위치: 페이지 하단) --%>
<%!
private String formatPrice(int price) {
    return java.text.NumberFormat.getNumberInstance(java.util.Locale.KOREA).format(price);
}
%>

<%@ include file="/WEB-INF/inc/footer.jsp" %>
