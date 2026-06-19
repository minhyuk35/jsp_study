<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.hatshop.member.MemberDTO" %>
<%
    String CTX = request.getContextPath();
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
%>
<%@ include file="/WEB-INF/inc/header.jsp" %>

<style>
  .info-wrap    { max-width: 800px; margin: 0 auto 40px; padding: calc(var(--header-h) + 40px) 16px 60px; }
  .page-title   { font-size: 1.6rem; font-weight: 800; margin-bottom: 8px; }
  .page-sub     { color: var(--ink-soft); font-size: .95rem; margin-bottom: 40px; }

  .section      { margin-bottom: 40px; }
  .section-title { font-size: 1.1rem; font-weight: 700; margin-bottom: 18px; padding-bottom: 10px; border-bottom: 2px solid var(--ink); }

  .info-box     { background: var(--bg); border: 1px solid var(--line); border-radius: 4px; padding: 24px 28px; }

  .grid-2       { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
  .policy-card  { background: var(--bg); border: 1px solid var(--line); border-radius: 4px; padding: 20px 22px; }
  .policy-card h3 { font-size: .95rem; font-weight: 700; margin-bottom: 14px; display: flex; align-items: center; gap: 8px; }
  .tag-ok   { display: inline-block; padding: 2px 8px; background: #f0faf4; color: #1a6b3a; border: 1px solid #7dcf9e; border-radius: 2px; font-size: .72rem; font-weight: 700; }
  .tag-no   { display: inline-block; padding: 2px 8px; background: #fff5f5; color: #a50000; border: 1px solid #f5a0a0; border-radius: 2px; font-size: .72rem; font-weight: 700; }

  .policy-list  { list-style: none; padding: 0; margin: 0; }
  .policy-list li { padding: 6px 0 6px 14px; position: relative; font-size: .88rem; color: var(--ink); line-height: 1.5; }
  .policy-list li::before { content: '·'; position: absolute; left: 4px; color: var(--ink-soft); }

  .notice-list  { list-style: none; padding: 0; margin: 0; }
  .notice-list li { padding: 9px 0 9px 16px; position: relative; font-size: .9rem; color: var(--ink); line-height: 1.6; border-bottom: 1px solid var(--line); }
  .notice-list li:last-child { border-bottom: none; }
  .notice-list li::before { content: '—'; position: absolute; left: 0; color: var(--ink-soft); }

  .step-list    { counter-reset: step; list-style: none; padding: 0; margin: 0; }
  .step-list li { counter-increment: step; display: flex; align-items: flex-start; gap: 14px; padding: 14px 0; border-bottom: 1px solid var(--line); font-size: .92rem; }
  .step-list li:last-child { border-bottom: none; }
  .step-list li::before { content: counter(step); display: inline-flex; width: 26px; height: 26px; background: var(--ink); color: #fff; border-radius: 50%; align-items: center; justify-content: center; font-size: .78rem; font-weight: 700; flex-shrink: 0; margin-top: 1px; }
  .step-body    { flex: 1; }
  .step-title   { font-weight: 600; margin-bottom: 3px; }
  .step-desc    { color: var(--ink-soft); font-size: .87rem; line-height: 1.5; }

  .request-card { background: #f9f8f6; border: 1px solid var(--line); border-radius: 4px; padding: 28px 32px; }
  .form-row     { margin-bottom: 18px; }
  .form-row label { display: block; font-size: 11px; font-weight: 700; letter-spacing: .08em; text-transform: uppercase; color: var(--ink-soft); margin-bottom: 7px; }
  .form-row select,
  .form-row input[type="text"],
  .form-row textarea { width: 100%; background: #fff; border: 1px solid var(--line); color: var(--ink); border-radius: 2px; padding: 10px 14px; font-size: .93rem; font-family: inherit; outline: none; transition: border-color .2s; box-sizing: border-box; }
  .form-row select:focus,
  .form-row input:focus,
  .form-row textarea:focus { border-color: var(--ink); }
  .form-row textarea { resize: vertical; min-height: 100px; line-height: 1.6; }
  .btn-submit   { width: 100%; padding: 13px; background: var(--ink); color: #fff; font-weight: 700; border: none; border-radius: 2px; cursor: pointer; font-size: .95rem; font-family: inherit; transition: opacity .2s; margin-top: 4px; }
  .btn-submit:hover { opacity: .8; }

  .login-prompt { background: #f9f8f6; border: 1px solid var(--line); border-radius: 4px; padding: 32px; text-align: center; color: var(--ink-soft); }
  .login-prompt a { color: var(--ink); font-weight: 700; text-decoration: underline; }

  .tab-nav      { display: flex; gap: 0; border-bottom: 2px solid var(--line); margin-bottom: 32px; }
  .tab-link     { padding: 12px 24px; text-decoration: none; font-size: .9rem; font-weight: 600; color: var(--ink-soft); border-bottom: 2px solid transparent; margin-bottom: -2px; transition: color .15s, border-color .15s; }
  .tab-link.active { color: var(--ink); border-bottom-color: var(--ink); }
  .tab-link:hover  { color: var(--ink); }

  @media (max-width: 580px) { .grid-2 { grid-template-columns: 1fr; } }
</style>

<main class="info-wrap">
  <h1 class="page-title">교환 / 반품</h1>
  <p class="page-sub">교환 및 반품 정책과 신청 방법을 안내해 드립니다.</p>

  <nav class="tab-nav">
    <a href="<%=CTX%>/info/delivery.jsp"   class="tab-link">배송 안내</a>
    <a href="<%=CTX%>/info/returns.jsp"    class="tab-link active">교환 / 반품</a>
    <a href="<%=CTX%>/info/size-guide.jsp" class="tab-link">사이즈 가이드</a>
  </nav>

  <!-- 교환/반품 기간 -->
  <div class="section">
    <h2 class="section-title">교환 · 반품 기간</h2>
    <div class="info-box">
      <ul class="notice-list">
        <li>상품 수령 후 <strong>7일 이내</strong> 교환·반품 신청이 가능합니다.</li>
        <li>단순 변심의 경우 반품 배송비(편도 3,000원)가 고객 부담입니다.</li>
        <li>상품 결함·오배송의 경우 배송비는 HATSHOP 부담입니다.</li>
      </ul>
    </div>
  </div>

  <!-- 가능/불가 사유 -->
  <div class="section">
    <h2 class="section-title">교환 · 반품 가능 / 불가 사유</h2>
    <div class="grid-2">
      <div class="policy-card">
        <h3><span class="tag-ok">가능</span> 교환·반품 가능</h3>
        <ul class="policy-list">
          <li>단순 변심 (수령 후 7일 이내, 미사용)</li>
          <li>사이즈·색상 오주문</li>
          <li>상품 불량 또는 파손</li>
          <li>오배송 (다른 상품 발송)</li>
          <li>상품 설명과 현저히 다른 경우</li>
        </ul>
      </div>
      <div class="policy-card">
        <h3><span class="tag-no">불가</span> 교환·반품 불가</h3>
        <ul class="policy-list">
          <li>착용 또는 세탁 후 반품</li>
          <li>택 제거 후 반품</li>
          <li>분실·훼손된 구성품</li>
          <li>수령 후 7일 초과</li>
          <li>고객 과실로 인한 상품 손상</li>
        </ul>
      </div>
    </div>
  </div>

  <!-- 신청 방법 -->
  <div class="section">
    <h2 class="section-title">교환 · 반품 신청 방법</h2>
    <ul class="step-list">
      <li>
        <div class="step-body">
          <div class="step-title">아래 양식 작성</div>
          <div class="step-desc">주문 번호, 교환·반품 사유를 포함해 아래 신청 양식을 작성해 주세요.</div>
        </div>
      </li>
      <li>
        <div class="step-body">
          <div class="step-title">담당자 확인 및 연락</div>
          <div class="step-desc">접수 후 1~2 영업일 이내에 담당자가 확인 후 연락드립니다.</div>
        </div>
      </li>
      <li>
        <div class="step-body">
          <div class="step-title">상품 반송</div>
          <div class="step-desc">안내받은 주소로 상품을 반송해 주세요. (운송장 번호 별도 안내)</div>
        </div>
      </li>
      <li>
        <div class="step-body">
          <div class="step-title">처리 완료</div>
          <div class="step-desc">상품 수령 확인 후 교환 발송 또는 환불 처리가 완료됩니다. (3~5 영업일)</div>
        </div>
      </li>
    </ul>
  </div>

  <!-- 신청 양식 -->
  <div class="section">
    <h2 class="section-title">교환 · 반품 신청</h2>
    <% if (loginUser != null) { %>
    <div class="request-card">
      <form method="POST" action="<%=CTX%>/board/boardWriteProc.jsp" id="returnForm">
        <input type="hidden" name="boardType" value="NORMAL">

        <div class="form-row">
          <label for="reqType">신청 유형 <span style="color:var(--red)">*</span></label>
          <select id="reqType" name="_reqType">
            <option value="">선택하세요</option>
            <option value="교환">교환</option>
            <option value="반품">반품</option>
          </select>
        </div>

        <div class="form-row">
          <label for="orderNoInput">주문 번호 <span style="color:var(--red)">*</span></label>
          <input type="text" id="orderNoInput" name="_orderNo" placeholder="예: 1234" maxlength="20">
        </div>

        <div class="form-row">
          <label for="returnReason">사유 <span style="color:var(--red)">*</span></label>
          <textarea id="returnReason" name="_reason" placeholder="교환·반품 사유를 상세히 입력해 주세요." maxlength="2000"></textarea>
        </div>

        <input type="hidden" id="boardTitle" name="boardTitle" value="">
        <input type="hidden" id="boardContent" name="boardContent" value="">
        <button type="button" class="btn-submit" onclick="submitReturn()">신청하기</button>
      </form>
    </div>
    <% } else { %>
    <div class="login-prompt">
      <p>교환·반품 신청은 로그인 후 이용하실 수 있습니다.</p>
      <p style="margin-top:12px;"><a href="<%=CTX%>/member/login.jsp">로그인하기 →</a></p>
    </div>
    <% } %>
  </div>
</main>

<script>
function submitReturn() {
  var type   = document.getElementById('reqType').value;
  var orderNo = document.getElementById('orderNoInput').value.trim();
  var reason = document.getElementById('returnReason').value.trim();

  if (!type)    { alert('신청 유형을 선택하세요.'); return; }
  if (!orderNo) { alert('주문 번호를 입력하세요.'); return; }
  if (!reason)  { alert('사유를 입력하세요.'); return; }

  document.getElementById('boardTitle').value   = '[' + type + '] 주문번호 ' + orderNo;
  document.getElementById('boardContent').value = '신청 유형: ' + type + '\n주문 번호: ' + orderNo + '\n\n사유:\n' + reason;
  document.getElementById('returnForm').submit();
}
</script>

<%@ include file="/WEB-INF/inc/footer.jsp" %>
