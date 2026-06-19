<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String CTX = request.getContextPath();
%>
<%@ include file="/WEB-INF/inc/header.jsp" %>

<style>
  .info-wrap    { max-width: 860px; margin: 0 auto 40px; padding: calc(var(--header-h) + 40px) 16px 60px; }
  .page-title   { font-size: 1.6rem; font-weight: 800; margin-bottom: 8px; }
  .page-sub     { color: var(--ink-soft); font-size: .95rem; margin-bottom: 40px; }

  .section      { margin-bottom: 48px; }
  .section-title { font-size: 1.1rem; font-weight: 700; margin-bottom: 18px; padding-bottom: 10px; border-bottom: 2px solid var(--ink); }

  /* 사이즈 테이블 */
  .size-table   { width: 100%; border-collapse: collapse; font-size: .9rem; }
  .size-table th { background: var(--ink); color: #fff; padding: 11px 14px; text-align: center; font-weight: 600; font-size: .85rem; }
  .size-table td { padding: 11px 14px; text-align: center; border-bottom: 1px solid var(--line); color: var(--ink); }
  .size-table tr:last-child td { border-bottom: none; }
  .size-table tbody tr:hover td { background: #f9f8f6; }
  .size-table .size-name { font-weight: 700; }

  /* 측정 방법 */
  .measure-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap: 16px; }
  .measure-card { background: var(--bg); border: 1px solid var(--line); border-radius: 4px; padding: 20px; }
  .measure-card h3 { font-size: .95rem; font-weight: 700; margin-bottom: 10px; }
  .measure-card p  { font-size: .87rem; color: var(--ink-soft); line-height: 1.6; margin: 0; }

  /* 카테고리 탭 */
  .cat-tabs { display: flex; gap: 8px; flex-wrap: wrap; margin-bottom: 20px; }
  .cat-btn  { padding: 7px 18px; border: 1px solid var(--line); background: transparent; color: var(--ink-soft); border-radius: 2px; cursor: pointer; font-size: .88rem; font-family: inherit; transition: all .15s; }
  .cat-btn.active { background: var(--ink); color: #fff; border-color: var(--ink); }
  .cat-btn:hover:not(.active) { border-color: var(--ink); color: var(--ink); }

  .size-panel { display: none; }
  .size-panel.active { display: block; }

  .notice-box { background: #f9f8f6; border-left: 3px solid var(--ink); padding: 16px 20px; border-radius: 0 4px 4px 0; margin-top: 20px; font-size: .88rem; line-height: 1.7; color: var(--ink-soft); }

  .tab-nav      { display: flex; gap: 0; border-bottom: 2px solid var(--line); margin-bottom: 32px; }
  .tab-link     { padding: 12px 24px; text-decoration: none; font-size: .9rem; font-weight: 600; color: var(--ink-soft); border-bottom: 2px solid transparent; margin-bottom: -2px; transition: color .15s, border-color .15s; }
  .tab-link.active { color: var(--ink); border-bottom-color: var(--ink); }
  .tab-link:hover  { color: var(--ink); }

  @media (max-width: 600px) {
    .size-table th:nth-child(n+4),
    .size-table td:nth-child(n+4) { display: none; }
  }
</style>

<main class="info-wrap">
  <h1 class="page-title">사이즈 가이드</h1>
  <p class="page-sub">정확한 사이즈 선택을 위한 가이드입니다. 주문 전 반드시 확인해 주세요.</p>

  <nav class="tab-nav">
    <a href="<%=CTX%>/info/delivery.jsp"   class="tab-link">배송 안내</a>
    <a href="<%=CTX%>/info/returns.jsp"    class="tab-link">교환 / 반품</a>
    <a href="<%=CTX%>/info/size-guide.jsp" class="tab-link active">사이즈 가이드</a>
  </nav>

  <!-- 두상 측정 방법 -->
  <div class="section">
    <h2 class="section-title">두상 측정 방법</h2>
    <div class="measure-grid">
      <div class="measure-card">
        <h3><svg class="icon-svg" viewBox="0 0 24 24"><rect x="2" y="8" width="20" height="8" rx="1"/><line x1="6" y1="8" x2="6" y2="11"/><line x1="10" y1="8" x2="10" y2="11"/><line x1="14" y1="8" x2="14" y2="11"/><line x1="18" y1="8" x2="18" y2="11"/></svg> 줄자 사용</h3>
        <p>부드러운 줄자를 이마 중앙에서 귀 위를 지나 뒤통수를 한 바퀴 감쌉니다. 줄자가 너무 꽉 조이지 않도록 주의하세요.</p>
      </div>
      <div class="measure-card">
        <h3><svg class="icon-svg" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><circle cx="12" cy="12" r="6"/><circle cx="12" cy="12" r="2"/></svg> 측정 위치</h3>
        <p>눈썹 위 1cm, 귀 상단, 후두부 돌출 부위를 지나는 둘레를 측정합니다. 가장 넓은 부분을 기준으로 합니다.</p>
      </div>
      <div class="measure-card">
        <h3><svg class="icon-svg" viewBox="0 0 24 24"><path d="M9 18h6"/><path d="M10 22h4"/><path d="M12 2a7 7 0 0 0-4 12.7V17h8v-2.3A7 7 0 0 0 12 2z"/></svg> 측정 팁</h3>
        <p>한 번에 정확하게 측정하기 어려우면 2~3회 반복 측정 후 평균값을 사용하세요. 머리카락 위에서 측정합니다.</p>
      </div>
    </div>
  </div>

  <!-- 카테고리별 사이즈표 -->
  <div class="section">
    <h2 class="section-title">카테고리별 사이즈표</h2>

    <div class="cat-tabs">
      <button class="cat-btn active" onclick="showCat('ballcap')">볼캡</button>
      <button class="cat-btn" onclick="showCat('bucket')">버킷햇</button>
      <button class="cat-btn" onclick="showCat('beret')">베레모</button>
      <button class="cat-btn" onclick="showCat('fedora')">페도라</button>
      <button class="cat-btn" onclick="showCat('snapback')">스냅백</button>
    </div>

    <!-- 볼캡 -->
    <div class="size-panel active" id="cat-ballcap">
      <table class="size-table">
        <thead>
          <tr>
            <th>사이즈</th>
            <th>두상 둘레 (cm)</th>
            <th>머리 너비 (cm)</th>
            <th>모자 높이 (cm)</th>
            <th>챙 길이 (cm)</th>
          </tr>
        </thead>
        <tbody>
          <tr><td class="size-name">S</td><td>54 ~ 55</td><td>17.5</td><td>14.0</td><td>7.5</td></tr>
          <tr><td class="size-name">M</td><td>56 ~ 57</td><td>18.0</td><td>14.5</td><td>7.5</td></tr>
          <tr><td class="size-name">L</td><td>58 ~ 59</td><td>18.5</td><td>15.0</td><td>8.0</td></tr>
          <tr><td class="size-name">XL</td><td>60 ~ 61</td><td>19.0</td><td>15.5</td><td>8.0</td></tr>
          <tr><td class="size-name">FREE</td><td>54 ~ 60</td><td colspan="3">벨크로 / 스트랩 조절 가능</td></tr>
        </tbody>
      </table>
    </div>

    <!-- 버킷햇 -->
    <div class="size-panel" id="cat-bucket">
      <table class="size-table">
        <thead>
          <tr>
            <th>사이즈</th>
            <th>두상 둘레 (cm)</th>
            <th>머리 너비 (cm)</th>
            <th>모자 높이 (cm)</th>
            <th>챙 너비 (cm)</th>
          </tr>
        </thead>
        <tbody>
          <tr><td class="size-name">S</td><td>54 ~ 55</td><td>17.5</td><td>12.0</td><td>6.0</td></tr>
          <tr><td class="size-name">M</td><td>56 ~ 57</td><td>18.0</td><td>12.5</td><td>6.5</td></tr>
          <tr><td class="size-name">L</td><td>58 ~ 59</td><td>18.5</td><td>13.0</td><td>6.5</td></tr>
          <tr><td class="size-name">XL</td><td>60 ~ 61</td><td>19.0</td><td>13.5</td><td>7.0</td></tr>
          <tr><td class="size-name">FREE</td><td>54 ~ 60</td><td colspan="3">끈 조절 가능</td></tr>
        </tbody>
      </table>
    </div>

    <!-- 베레모 -->
    <div class="size-panel" id="cat-beret">
      <table class="size-table">
        <thead>
          <tr>
            <th>사이즈</th>
            <th>두상 둘레 (cm)</th>
            <th>지름 (cm)</th>
            <th>높이 (cm)</th>
            <th>소재 신축성</th>
          </tr>
        </thead>
        <tbody>
          <tr><td class="size-name">S/M</td><td>54 ~ 57</td><td>28.0</td><td>10.0</td><td>약간</td></tr>
          <tr><td class="size-name">M/L</td><td>57 ~ 60</td><td>29.5</td><td>10.5</td><td>약간</td></tr>
          <tr><td class="size-name">FREE</td><td>54 ~ 60</td><td colspan="3">신축성 있는 소재</td></tr>
        </tbody>
      </table>
    </div>

    <!-- 페도라 -->
    <div class="size-panel" id="cat-fedora">
      <table class="size-table">
        <thead>
          <tr>
            <th>사이즈</th>
            <th>두상 둘레 (cm)</th>
            <th>머리 너비 (cm)</th>
            <th>크라운 높이 (cm)</th>
            <th>챙 너비 (cm)</th>
          </tr>
        </thead>
        <tbody>
          <tr><td class="size-name">S</td><td>54 ~ 55</td><td>17.5</td><td>10.0</td><td>6.0</td></tr>
          <tr><td class="size-name">M</td><td>56 ~ 57</td><td>18.0</td><td>10.5</td><td>6.5</td></tr>
          <tr><td class="size-name">L</td><td>58 ~ 59</td><td>18.5</td><td>11.0</td><td>7.0</td></tr>
          <tr><td class="size-name">XL</td><td>60 ~ 61</td><td>19.0</td><td>11.5</td><td>7.0</td></tr>
        </tbody>
      </table>
    </div>

    <!-- 스냅백 -->
    <div class="size-panel" id="cat-snapback">
      <table class="size-table">
        <thead>
          <tr>
            <th>사이즈</th>
            <th>두상 둘레 (cm)</th>
            <th>머리 너비 (cm)</th>
            <th>모자 높이 (cm)</th>
            <th>조절 방식</th>
          </tr>
        </thead>
        <tbody>
          <tr><td class="size-name">FREE</td><td>54 ~ 62</td><td>17.5 ~ 19.5</td><td>15.0</td><td>스냅 버튼 (무단계 조절)</td></tr>
        </tbody>
      </table>
    </div>

    <div class="notice-box">
      위 치수는 상품마다 1~2cm 오차가 있을 수 있습니다. 두상 둘레 기준으로 선택하시되, 사이즈 경계에 해당하시면 더 큰 사이즈를 추천드립니다.
    </div>
  </div>

  <!-- 사이즈 선택 팁 -->
  <div class="section">
    <h2 class="section-title">사이즈 선택 팁</h2>
    <div style="background:var(--bg);border:1px solid var(--line);border-radius:4px;padding:24px 28px;">
      <ul style="list-style:none;padding:0;margin:0;">
        <li style="padding:9px 0 9px 16px;position:relative;font-size:.9rem;line-height:1.6;border-bottom:1px solid var(--line);">
          <span style="position:absolute;left:0;color:var(--ink-soft);">—</span>
          <strong>두상 둘레</strong>를 먼저 측정하세요. 모자 사이즈의 가장 기본 기준입니다.
        </li>
        <li style="padding:9px 0 9px 16px;position:relative;font-size:.9rem;line-height:1.6;border-bottom:1px solid var(--line);">
          <span style="position:absolute;left:0;color:var(--ink-soft);">—</span>
          헤어 볼륨이 있거나 머리숱이 많은 경우 <strong>한 사이즈 크게</strong> 선택하시기를 권장합니다.
        </li>
        <li style="padding:9px 0 9px 16px;position:relative;font-size:.9rem;line-height:1.6;border-bottom:1px solid var(--line);">
          <span style="position:absolute;left:0;color:var(--ink-soft);">—</span>
          스냅백·벨크로 제품은 <strong>FREE</strong> 사이즈로 광범위하게 조절 가능합니다.
        </li>
        <li style="padding:9px 0 9px 16px;position:relative;font-size:.9rem;line-height:1.6;">
          <span style="position:absolute;left:0;color:var(--ink-soft);">—</span>
          사이즈 선택이 어려우신 경우 게시판 문의 또는 교환/반품 페이지를 이용해 주세요.
        </li>
      </ul>
    </div>
  </div>
</main>

<script>
function showCat(cat) {
  document.querySelectorAll('.size-panel').forEach(function(p) { p.classList.remove('active'); });
  document.querySelectorAll('.cat-btn').forEach(function(b) { b.classList.remove('active'); });
  document.getElementById('cat-' + cat).classList.add('active');
  event.currentTarget.classList.add('active');
}
</script>

<%@ include file="/WEB-INF/inc/footer.jsp" %>
