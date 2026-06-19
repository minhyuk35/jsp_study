<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String CTX = request.getContextPath();
%>
<%@ include file="/WEB-INF/inc/header.jsp" %>

<style>
  .info-wrap    { max-width: 800px; margin: 0 auto 40px; padding: calc(var(--header-h) + 40px) 16px 60px; }
  .page-title   { font-size: 1.6rem; font-weight: 800; margin-bottom: 8px; }
  .page-sub     { color: var(--ink-soft); font-size: .95rem; margin-bottom: 40px; }

  .section      { margin-bottom: 40px; }
  .section-title { font-size: 1.1rem; font-weight: 700; margin-bottom: 18px; padding-bottom: 10px; border-bottom: 2px solid var(--ink); }

  .info-box     { background: var(--bg); border: 1px solid var(--line); border-radius: 4px; padding: 24px 28px; }
  .info-row     { display: flex; gap: 0; padding: 13px 0; border-bottom: 1px solid var(--line); font-size: .92rem; }
  .info-row:last-child { border-bottom: none; }
  .info-key     { width: 130px; flex-shrink: 0; color: var(--ink-soft); font-weight: 500; }
  .info-val     { flex: 1; color: var(--ink); line-height: 1.6; }

  .highlight-box { background: #f9f8f6; border-left: 3px solid var(--ink); padding: 16px 20px; border-radius: 0 4px 4px 0; margin-top: 16px; font-size: .9rem; line-height: 1.7; }

  .step-list    { counter-reset: step; list-style: none; padding: 0; margin: 0; }
  .step-list li { counter-increment: step; display: flex; align-items: flex-start; gap: 14px; padding: 14px 0; border-bottom: 1px solid var(--line); font-size: .92rem; }
  .step-list li:last-child { border-bottom: none; }
  .step-list li::before { content: counter(step); display: inline-flex; width: 26px; height: 26px; background: var(--ink); color: #fff; border-radius: 50%; align-items: center; justify-content: center; font-size: .78rem; font-weight: 700; flex-shrink: 0; margin-top: 1px; }
  .step-body    { flex: 1; }
  .step-title   { font-weight: 600; margin-bottom: 3px; }
  .step-desc    { color: var(--ink-soft); font-size: .87rem; line-height: 1.5; }

  .notice-list  { list-style: none; padding: 0; margin: 0; }
  .notice-list li { padding: 8px 0 8px 16px; position: relative; font-size: .9rem; color: var(--ink); line-height: 1.6; border-bottom: 1px solid var(--line); }
  .notice-list li:last-child { border-bottom: none; }
  .notice-list li::before { content: '—'; position: absolute; left: 0; color: var(--ink-soft); }

  .tab-nav      { display: flex; gap: 0; border-bottom: 2px solid var(--line); margin-bottom: 32px; }
  .tab-link     { padding: 12px 24px; text-decoration: none; font-size: .9rem; font-weight: 600; color: var(--ink-soft); border-bottom: 2px solid transparent; margin-bottom: -2px; transition: color .15s, border-color .15s; }
  .tab-link.active { color: var(--ink); border-bottom-color: var(--ink); }
  .tab-link:hover  { color: var(--ink); }
</style>

<main class="info-wrap">
  <h1 class="page-title">배송 안내</h1>
  <p class="page-sub">HATSHOP의 배송 정책을 안내해 드립니다.</p>

  <nav class="tab-nav">
    <a href="<%=CTX%>/info/delivery.jsp" class="tab-link active">배송 안내</a>
    <a href="<%=CTX%>/info/returns.jsp"  class="tab-link">교환 / 반품</a>
    <a href="<%=CTX%>/info/size-guide.jsp" class="tab-link">사이즈 가이드</a>
  </nav>

  <!-- 배송 기본 정보 -->
  <div class="section">
    <h2 class="section-title">기본 배송 정보</h2>
    <div class="info-box">
      <div class="info-row">
        <span class="info-key">배송사</span>
        <span class="info-val">CJ 대한통운</span>
      </div>
      <div class="info-row">
        <span class="info-key">배송비</span>
        <span class="info-val"><strong>무료배송</strong> (전 상품 무료)</span>
      </div>
      <div class="info-row">
        <span class="info-key">배송 기간</span>
        <span class="info-val">결제 완료 후 <strong>1~3 영업일</strong> 이내 발송</span>
      </div>
      <div class="info-row">
        <span class="info-key">배송 지역</span>
        <span class="info-val">대한민국 전 지역 (도서산간 제외)</span>
      </div>
      <div class="info-row">
        <span class="info-key">영업일</span>
        <span class="info-val">월~금 (토·일·공휴일 제외)</span>
      </div>
    </div>
    <div class="highlight-box">
      오후 2시 이전 결제 완료 시 당일 출고됩니다. 주문량 증가 및 물류 상황에 따라 다소 지연될 수 있습니다.
    </div>
  </div>

  <!-- 배송 조회 방법 -->
  <div class="section">
    <h2 class="section-title">배송 조회 방법</h2>
    <ul class="step-list">
      <li>
        <div class="step-body">
          <div class="step-title">주문 내역 확인</div>
          <div class="step-desc">로그인 후 마이페이지 → 주문 내역에서 주문 상세를 확인하세요.</div>
        </div>
      </li>
      <li>
        <div class="step-body">
          <div class="step-title">운송장 번호 확인</div>
          <div class="step-desc">상품 발송 후 주문 상세 페이지에 운송장 번호가 업데이트됩니다.</div>
        </div>
      </li>
      <li>
        <div class="step-body">
          <div class="step-title">배송 추적</div>
          <div class="step-desc">CJ 대한통운 홈페이지 또는 앱에서 운송장 번호로 실시간 위치를 확인할 수 있습니다.</div>
        </div>
      </li>
    </ul>
  </div>

  <!-- 도서산간 지역 -->
  <div class="section">
    <h2 class="section-title">도서산간 지역 안내</h2>
    <div class="info-box">
      <ul class="notice-list">
        <li>제주도, 울릉도, 독도 및 기타 도서산간 지역은 추가 배송비가 발생합니다.</li>
        <li>추가 배송비: 제주도 3,000원 / 기타 도서산간 5,000원</li>
        <li>주문 확인 후 별도 안내 드리며, 배송 기간이 1~2일 추가될 수 있습니다.</li>
      </ul>
    </div>
  </div>

  <!-- 배송 관련 주의사항 -->
  <div class="section">
    <h2 class="section-title">주의사항</h2>
    <div class="info-box">
      <ul class="notice-list">
        <li>주문 후 주소 변경이 필요한 경우 배송 출발 전에 고객센터로 연락 바랍니다.</li>
        <li>부재 시 문 앞, 경비실 등에 보관되며 안전하게 수령 가능한 장소를 요청할 수 있습니다.</li>
        <li>반송된 상품은 재발송 시 배송비가 발생할 수 있습니다.</li>
        <li>천재지변, 명절 연휴 등 특수 기간에는 배송이 지연될 수 있습니다.</li>
      </ul>
    </div>
  </div>
</main>

<%@ include file="/WEB-INF/inc/footer.jsp" %>
