<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hatshop.member.MemberDTO, com.hatshop.util.HtmlUtils, com.hatshop.util.Logger,
                 com.hatshop.order.OrderDAO, com.hatshop.order.OrderDTO,
                 com.hatshop.order.OrderDTO.OrderDetailDTO, com.hatshop.db.DBConn,
                 java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet,
                 java.util.List, java.util.Map, java.util.HashMap, java.net.URLEncoder" %>
<%
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    if (loginUser == null) {
        response.sendRedirect(request.getContextPath() + "/member/login.jsp?redirectURL=/member/mypage.jsp");
        return;
    }

    String flashSuccess = (String) session.getAttribute("flashSuccess");
    String flashError   = (String) session.getAttribute("flashError");
    session.removeAttribute("flashSuccess");
    session.removeAttribute("flashError");

    String tab = request.getParameter("tab");
    if (tab == null) tab = "orders";

    /* 주문 목록 로드 (+ 각 주문의 품목 상세를 채워 썸네일 표시) */
    List<OrderDTO> orderList = null;
    try {
        OrderDAO orderDAO = new OrderDAO();
        orderList = orderDAO.getOrderList(loginUser.getMemberId());
        for (OrderDTO o : orderList) {
            try {
                OrderDTO full = orderDAO.getOrderDetail(o.getOrderNo(), loginUser.getMemberId());
                if (full != null) o.setDetails(full.getDetails());
            } catch (Exception inner) {
                Logger.error(this.getClass(), "mypage.jsp 주문 상세 보강 오류: orderNo=" + o.getOrderNo(), inner);
            }
        }
    } catch (Exception e) {
        Logger.error(this.getClass(), "mypage.jsp 주문목록 조회 오류: memberId=" + loginUser.getMemberId(), e);
        orderList = new java.util.ArrayList<>();
    }

    /* 주문별 환불 상태 (활성 신청만) 맵 로드 */
    Map<Integer, String> refundStatusMap = new HashMap<>();
    try {
        Connection conn = DBConn.getConnection();
        String sql = "SELECT order_no, refund_status FROM refund WHERE member_id = ? AND refund_status IN ('REQUESTED','APPROVED','COMPLETED')";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, loginUser.getMemberId());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    refundStatusMap.put(rs.getInt("order_no"), rs.getString("refund_status"));
                }
            }
        }
    } catch (Exception e) {
        Logger.error(this.getClass(), "mypage.jsp 환불상태 조회 오류: memberId=" + loginUser.getMemberId(), e);
    }

    /* 내 문의 내역 로드 */
    List<Object[]> myInquiries = new java.util.ArrayList<>();
    try {
        Connection conn = DBConn.getConnection();
        String sql = "SELECT inquiry_no, inquiry_title, inquiry_content, inquiry_answer, inquiry_status, reg_date, answer_date " +
                     "FROM inquiry WHERE member_id = ? ORDER BY inquiry_no DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, loginUser.getMemberId());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    myInquiries.add(new Object[]{
                        rs.getInt("inquiry_no"), rs.getString("inquiry_title"), rs.getString("inquiry_content"),
                        rs.getString("inquiry_answer"), rs.getString("inquiry_status"),
                        rs.getTimestamp("reg_date"), rs.getTimestamp("answer_date")
                    });
                }
            }
        }
        /* 문의 탭을 열람하면 미확인 답변을 읽음 처리 */
        if ("inquiries".equals(tab)) {
            try (PreparedStatement ps = conn.prepareStatement(
                    "UPDATE inquiry SET is_read = 1 WHERE member_id = ? AND is_read = 0")) {
                ps.setString(1, loginUser.getMemberId());
                ps.executeUpdate();
            }
        }
    } catch (Exception e) {
        Logger.error(this.getClass(), "mypage.jsp 문의내역 조회 오류: memberId=" + loginUser.getMemberId(), e);
    }

    String CTX = request.getContextPath();
%>
<%@ include file="/WEB-INF/inc/header.jsp" %>
<%@ include file="/WEB-INF/inc/nav.jsp" %>

<style>
.mypage-layout { display: grid; grid-template-columns: 240px 1fr; gap: 28px; align-items: start;
                 max-width: 1100px; margin: 0 auto; padding: calc(var(--header-h) + 40px) 24px 60px; }

/* ── 프로필 카드 ── */
.profile-card { background: var(--bg); border: 1px solid var(--line);
                padding: 28px 20px; text-align: center; position: sticky; top: calc(var(--header-h) + 20px); }
.profile-avatar { width: 72px; height: 72px; border-radius: 50%; background: var(--ink);
                  display: flex; align-items: center; justify-content: center;
                  font-size: 1.8rem; color: #fff; margin: 0 auto 14px; font-weight: 700; }
.profile-name  { font-weight: 700; font-size: 1rem; margin-bottom: 4px; }
.profile-id    { font-size: .82rem; color: var(--ink-soft); margin-bottom: 8px; }
.profile-grade { display: inline-block; padding: 2px 10px;
                 font-size: .72rem; font-weight: 700; letter-spacing: .08em;
                 text-transform: uppercase; margin-bottom: 8px; border: 1px solid; }
.grade-normal  { background: var(--bg-sub); color: var(--ink-soft); border-color: var(--line); }
.grade-admin   { background: #fff5f5; color: var(--red); border-color: rgba(200,16,46,.3); }
.profile-date  { font-size: .78rem; color: var(--ink-soft); margin-bottom: 20px; }
.profile-sep   { border: none; border-top: 1px solid var(--line); margin: 16px 0; }
.profile-nav   { display: flex; flex-direction: column; gap: 4px; }
.profile-nav-btn {
    display: block; width: 100%; padding: 10px 14px; text-align: left;
    background: none; border: none; border-radius: 2px; cursor: pointer;
    font-size: .88rem; font-family: inherit; color: var(--ink-soft);
    transition: background .15s, color .15s; text-decoration: none;
}
.profile-nav-btn:hover { background: var(--bg-sub); color: var(--ink); }
.profile-nav-btn.active { background: var(--ink); color: #fff; font-weight: 600; }
.profile-nav-btn.logout-btn { color: var(--ink-soft); margin-top: 4px; }
.profile-nav-btn.logout-btn:hover { background: #fff5f5; color: var(--red); }

/* ── 탭 패널 ── */
.tab-panel { display: none; }
.tab-panel.active { display: block; }

/* ── 주문 내역 ── */
.section-heading { font-size: 1.1rem; font-weight: 800; letter-spacing: -.01em;
                   margin-bottom: 20px; display: flex; align-items: center; justify-content: space-between; }
.order-card { background: var(--bg); border: 1px solid var(--line); margin-bottom: 12px;
              transition: border-color .2s; }
.order-card:hover { border-color: var(--ink); }
.order-card-head { display: flex; align-items: center; justify-content: space-between;
                   padding: 12px 18px; border-bottom: 1px solid var(--line); background: var(--bg-sub); }
.order-no-txt { font-weight: 700; font-size: .92rem; }
.order-date-txt { font-size: .8rem; color: var(--ink-soft); margin-left: 10px; }
.order-card-body { display: flex; align-items: center; gap: 14px; padding: 14px 18px; }
.thumb-row { display: flex; }
.thumb-row img { width: 52px; height: 52px; object-fit: cover; border-radius: 2px;
                 border: 2px solid #fff; margin-left: -8px; background: var(--ph-a); }
.thumb-row img:first-child { margin-left: 0; }
.thumb-more-badge { width: 52px; height: 52px; background: var(--bg-sub);
                    border: 1px solid var(--line); display: inline-flex; align-items: center;
                    justify-content: center; font-size: .75rem; color: var(--ink-soft);
                    margin-left: -8px; flex-shrink: 0; }
.order-summary-block { flex: 1; }
.order-item-cnt { font-size: .85rem; color: var(--ink-soft); margin-bottom: 3px; }
.order-total-price { font-size: 1.05rem; font-weight: 800; }
.btn-order-detail { padding: 7px 18px; background: transparent; border: 1px solid var(--line);
                    color: var(--ink-soft); font-size: .82rem; text-decoration: none;
                    white-space: nowrap; transition: all .15s; }
.btn-order-detail:hover { border-color: var(--ink); color: var(--ink); }
.empty-orders { text-align: center; padding: 60px 20px; color: var(--ink-soft); border: 1px solid var(--line); }
.empty-orders .icon { font-size: 3rem; margin-bottom: 14px; opacity: .4; }
.empty-orders p { margin-bottom: 16px; font-size: .9rem; }

/* 주문 상태 배지 */
.obadge { display: inline-block; padding: 2px 8px; font-size: .75rem; font-weight: 600; border: 1px solid; }
.status-pending  { background: #f5f5f5; color: #555; border-color: #ccc; }
.status-paid     { background: #eff8ff; color: #1a6fb3; border-color: #96cff5; }
.status-shipping { background: #fffbef; color: #8a6200; border-color: #e8c84a; }
.status-done     { background: #f0faf4; color: var(--green); border-color: #7dcf9e; }
.status-cancel   { background: #fff5f5; color: var(--red); border-color: #f5a0a0; }

/* ── 계정 설정 ── */
.settings-section { border: 1px solid var(--line); margin-bottom: 20px; overflow: hidden; }
.settings-section-head { display: flex; align-items: center; gap: 12px; padding: 18px 24px;
                          border-bottom: 1px solid var(--line); background: var(--bg-sub); }
.settings-section-head .sec-icon { font-size: 1.1rem; }
.settings-section-head h3 { font-size: .95rem; font-weight: 700; }
.settings-section-head p  { font-size: .8rem; color: var(--ink-soft); margin-top: 2px; }
.settings-section-body { padding: 24px; }
.pw-strength { display: flex; gap: 4px; margin-top: 8px; }
.pw-strength span { height: 3px; flex: 1; background: var(--line); border-radius: 2px; transition: background .3s; }
.pw-strength.weak   span:nth-child(1) { background: var(--red); }
.pw-strength.fair   span:nth-child(1), .pw-strength.fair   span:nth-child(2) { background: #f5a623; }
.pw-strength.strong span:nth-child(1), .pw-strength.strong span:nth-child(2),
.pw-strength.strong span:nth-child(3) { background: var(--green); }
.pw-hint { font-size: .78rem; color: var(--ink-soft); margin-top: 6px; }
.danger-zone { border-color: rgba(200,16,46,.35) !important; }
.danger-zone .settings-section-head { background: #fff5f5; }
.danger-zone h3 { color: var(--red); }

@media (max-width: 768px) {
    .mypage-layout { grid-template-columns: 1fr; padding-top: calc(var(--header-h) + 20px); }
    .profile-card { position: static; }
}
</style>

<main>
<div class="mypage-layout">

  <!-- ── 프로필 사이드바 ── -->
  <aside class="profile-card">
    <div class="profile-avatar">
      <%= HtmlUtils.escape(loginUser.getMemberName()).substring(0, 1) %>
    </div>
    <p class="profile-name"><%= HtmlUtils.escape(loginUser.getMemberName()) %></p>
    <p class="profile-id"><%= HtmlUtils.escape(loginUser.getMemberId()) %></p>
    <span class="profile-grade <%= loginUser.isAdmin() ? "grade-admin" : "grade-normal" %>">
      <%= loginUser.isAdmin() ? "ADMIN" : "MEMBER" %>
    </span>
    <p class="profile-date">가입 <%= HtmlUtils.escape(loginUser.getRegDate()) %></p>
    <hr class="profile-sep">
    <nav class="profile-nav">
      <button class="profile-nav-btn <%= "orders".equals(tab) ? "active" : "" %>"
              onclick="switchTab('orders')">주문 내역</button>
      <button class="profile-nav-btn <%= "inquiries".equals(tab) ? "active" : "" %>"
              onclick="switchTab('inquiries')">문의 내역</button>
      <button class="profile-nav-btn <%= "account".equals(tab) ? "active" : "" %>"
              onclick="switchTab('account')">계정 설정</button>
      <a href="<%= CTX %>/member/logout.jsp" class="profile-nav-btn logout-btn">로그아웃</a>
    </nav>
  </aside>

  <!-- ── 탭 패널 영역 ── -->
  <div>

    <% if (flashSuccess != null) { %>
    <div class="alert alert-success" style="margin-bottom:20px"><%= flashSuccess %></div>
    <% } %>
    <% if (flashError != null) { %>
    <div class="alert alert-error" style="margin-bottom:20px"><%= flashError %></div>
    <% } %>

    <!-- ═══ 주문 내역 탭 ═══ -->
    <div id="panel-orders" class="tab-panel">
      <div class="section-heading">
        <span>주문 내역</span>
        <% if (orderList != null && !orderList.isEmpty()) { %>
        <span style="font-size:.82rem;color:var(--ink-soft);font-weight:400">총 <%= orderList.size() %>건</span>
        <% } %>
      </div>

      <% if (orderList == null || orderList.isEmpty()) { %>
      <div class="empty-orders">
        <div class="icon"><svg class="icon-svg" style="width:2.4em;height:2.4em" viewBox="0 0 24 24"><path d="M16.5 9.4 7.55 4.24"/><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/><polyline points="3.29 7 12 12 20.71 7"/><line x1="12" y1="22" x2="12" y2="12"/></svg></div>
        <p>아직 주문 내역이 없습니다.</p>
        <a href="<%= CTX %>/hat/list" style="display:inline-block;padding:8px 24px;background:var(--ink);color:#fff;font-size:.85rem;font-weight:700;text-decoration:none;">모자 쇼핑하러 가기</a>
      </div>
      <% } else {
           for (OrderDTO order : orderList) {
             List<OrderDetailDTO> details = order.getDetails();
             String refundStatus = refundStatusMap.get(order.getOrderNo());
             String refundBadgeText = null;
             if ("REQUESTED".equals(refundStatus)) refundBadgeText = "환불 신청 중";
             else if ("APPROVED".equals(refundStatus)) refundBadgeText = "환불 승인됨";
             else if ("COMPLETED".equals(refundStatus)) refundBadgeText = "환불 완료";
      %>
      <div class="order-card">
        <div class="order-card-head">
          <div>
            <span class="order-no-txt">주문 #<%= order.getOrderNo() %></span>
            <span class="order-date-txt"><%= order.getOrderDate() != null ? order.getOrderDate().substring(0, Math.min(16, order.getOrderDate().length())) : "" %></span>
          </div>
          <span style="display:flex;gap:6px;align-items:center">
            <% if (refundBadgeText != null) { %>
            <span class="obadge status-pending"><%= refundBadgeText %></span>
            <% } %>
            <span class="obadge <%= order.getStatusClass() %>"><%= order.getStatusLabel() %></span>
          </span>
        </div>
        <div class="order-card-body">
          <div class="thumb-row">
            <% if (details != null && !details.isEmpty()) {
                 int showCnt = Math.min(details.size(), 3);
                 for (int i = 0; i < showCnt; i++) {
                   OrderDetailDTO d = details.get(i);
                   String rawImg = d.getHatImage();
                   String imgSrc = (rawImg != null && !rawImg.trim().isEmpty())
                       ? CTX + "/image?src=" + URLEncoder.encode(rawImg, "UTF-8")
                       : CTX + "/images/no-image.png";
            %>
            <img src="<%= imgSrc %>" alt="<%= HtmlUtils.escape(d.getHatName() != null ? d.getHatName() : "") %>"
                 onerror="this.onerror=null;this.src='<%= CTX %>/images/no-image.png'">
            <% }
               if (details.size() > 3) { %>
            <span class="thumb-more-badge">+<%= details.size()-3 %></span>
            <% }
              }
            %>
          </div>
          <div class="order-summary-block">
            <div class="order-item-cnt">상품 <%= order.getItemCount() %>건</div>
            <div class="order-total-price"><%= order.getFormattedTotal() %>원</div>
          </div>
          <div style="display:flex;gap:8px">
            <% boolean refundEligible = refundBadgeText == null &&
                   ("PAID".equals(order.getOrderStatus()) || "SHIPPING".equals(order.getOrderStatus()) || "DONE".equals(order.getOrderStatus()));
               if (refundEligible) { %>
            <a href="<%= CTX %>/refund/request.jsp?orderNo=<%= order.getOrderNo() %>" class="btn-order-detail">환불 신청</a>
            <% } %>
            <a href="<%= CTX %>/order/detail?orderNo=<%= order.getOrderNo() %>" class="btn-order-detail">상세보기</a>
          </div>
        </div>
      </div>
      <% } } %>
    </div><!-- /panel-orders -->

    <!-- ═══ 문의 내역 탭 ═══ -->
    <div id="panel-inquiries" class="tab-panel">
      <div class="section-heading">
        <span>문의 내역</span>
        <% if (!myInquiries.isEmpty()) { %>
        <span style="font-size:.82rem;color:var(--ink-soft);font-weight:400">총 <%= myInquiries.size() %>건</span>
        <% } %>
      </div>

      <% if (myInquiries.isEmpty()) { %>
      <div class="empty-orders">
        <div class="icon"><svg class="icon-svg" style="width:1em;height:1em" viewBox="0 0 24 24"><path d="M3 18v-6a9 9 0 0 1 18 0v6"/><path d="M21 19a2 2 0 0 1-2 2h-1a2 2 0 0 1-2-2v-3a2 2 0 0 1 2-2h3zM3 19a2 2 0 0 0 2 2h1a2 2 0 0 0 2-2v-3a2 2 0 0 0-2-2H3z"/></svg></div>
        <p>아직 문의한 내역이 없습니다.</p>
      </div>
      <% } else {
           for (Object[] iq : myInquiries) {
             int iqNo = (Integer) iq[0];
             String iqTitle = (String) iq[1];
             String iqContent = (String) iq[2];
             String iqAnswer = (String) iq[3];
             String iqStatus = (String) iq[4];
             java.sql.Timestamp iqReg = (java.sql.Timestamp) iq[5];
             java.sql.Timestamp iqAnsDate = (java.sql.Timestamp) iq[6];
             String iqBadgeClass, iqBadgeLabel;
             switch (iqStatus) {
                 case "ANSWERED": iqBadgeClass = "status-done";    iqBadgeLabel = "답변완료"; break;
                 case "CLOSED":   iqBadgeClass = "status-cancel";  iqBadgeLabel = "종료"; break;
                 default:         iqBadgeClass = "status-pending"; iqBadgeLabel = "답변대기"; break;
             }
      %>
      <div class="order-card">
        <div class="order-card-head">
          <div>
            <span class="order-no-txt"><%= HtmlUtils.escape(iqTitle) %></span>
            <span class="order-date-txt"><%= iqReg != null ? iqReg.toString().substring(0,16) : "" %></span>
          </div>
          <span class="obadge <%= iqBadgeClass %>"><%= iqBadgeLabel %></span>
        </div>
        <div class="order-card-body" style="flex-direction:column;align-items:stretch;gap:10px">
          <div style="font-size:.88rem;color:var(--ink-soft);white-space:pre-wrap;word-break:break-word"><%= HtmlUtils.escape(iqContent) %></div>
          <% if (iqAnswer != null) { %>
          <div style="background:var(--bg-sub);border-radius:4px;padding:12px 14px;font-size:.86rem;white-space:pre-wrap;word-break:break-word">
            <div style="font-weight:700;margin-bottom:4px;font-size:.78rem;color:var(--ink-soft)">관리자 답변 <%= iqAnsDate != null ? "· " + iqAnsDate.toString().substring(0,16) : "" %></div>
            <%= HtmlUtils.escape(iqAnswer) %>
          </div>
          <% } %>
        </div>
      </div>
      <% } } %>
    </div><!-- /panel-inquiries -->

    <!-- ═══ 계정 설정 탭 ═══ -->
    <div id="panel-account" class="tab-panel">
      <div class="section-heading">계정 설정</div>

      <!-- 회원정보 수정 -->
      <div class="settings-section">
        <div class="settings-section-head">
          <span class="sec-icon"><svg class="icon-svg" viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg></span>
          <div>
            <h3>기본 정보</h3>
            <p>이름, 이메일, 전화번호, 주소를 수정합니다</p>
          </div>
        </div>
        <div class="settings-section-body">
          <form action="<%= CTX %>/member/updateProc.jsp" method="post">
            <input type="hidden" name="type" value="info">
            <div class="form-group">
              <label>아이디</label>
              <input type="text" class="form-control"
                     value="<%= HtmlUtils.escape(loginUser.getMemberId()) %>" disabled
                     style="opacity:.4;cursor:not-allowed">
            </div>
            <div class="form-group">
              <label for="memberName">이름 <span style="color:var(--red)">*</span></label>
              <input type="text" id="memberName" name="memberName" class="form-control"
                     value="<%= HtmlUtils.escape(loginUser.getMemberName()) %>" maxlength="30">
            </div>
            <div class="form-group">
              <label for="email">이메일 <span style="color:var(--red)">*</span></label>
              <input type="email" id="email" name="email" class="form-control"
                     value="<%= HtmlUtils.escape(loginUser.getEmail()) %>" maxlength="100">
            </div>
            <div class="form-group">
              <label for="phone">전화번호</label>
              <input type="tel" id="phone" name="phone" class="form-control"
                     value="<%= HtmlUtils.escape(loginUser.getPhone() == null ? "" : loginUser.getPhone()) %>"
                     maxlength="20">
            </div>
            <div class="form-group">
              <label for="addr">주소</label>
              <input type="text" id="addr" name="addr" class="form-control"
                     value="<%= HtmlUtils.escape(loginUser.getAddr() == null ? "" : loginUser.getAddr()) %>"
                     maxlength="200">
            </div>
            <button type="submit" class="btn btn-primary btn-sm"
                    onclick="return validateInfoForm(this.form)">저장</button>
          </form>
        </div>
      </div>

      <!-- 비밀번호 변경 -->
      <div class="settings-section">
        <div class="settings-section-head">
          <span class="sec-icon"><svg class="icon-svg" viewBox="0 0 24 24"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg></span>
          <div>
            <h3>비밀번호 변경</h3>
            <p>정기적인 비밀번호 변경으로 계정을 안전하게 보호하세요</p>
          </div>
        </div>
        <div class="settings-section-body">
          <form action="<%= CTX %>/member/updateProc.jsp" method="post"
                onsubmit="return validatePwForm(this)">
            <input type="hidden" name="type" value="pw">
            <div class="form-group">
              <label for="curPw">현재 비밀번호 <span style="color:var(--red)">*</span></label>
              <input type="password" id="curPw" name="curPw" class="form-control"
                     placeholder="현재 비밀번호 입력" autocomplete="current-password">
            </div>
            <div class="form-group">
              <label for="newPw">새 비밀번호 <span style="color:var(--red)">*</span></label>
              <input type="password" id="newPw" name="newPw" class="form-control"
                     placeholder="영문·숫자 조합 8자 이상" autocomplete="new-password"
                     oninput="checkPwStrength(this.value)">
              <div class="pw-strength" id="pwStrength">
                <span></span><span></span><span></span>
              </div>
              <div class="pw-hint" id="pwHint">8자 이상 입력해주세요</div>
            </div>
            <div class="form-group">
              <label for="newPw2">새 비밀번호 확인 <span style="color:var(--red)">*</span></label>
              <input type="password" id="newPw2" name="newPw2" class="form-control"
                     placeholder="새 비밀번호 재입력" autocomplete="new-password">
            </div>
            <button type="submit" class="btn btn-primary btn-sm">비밀번호 변경</button>
          </form>
        </div>
      </div>

      <!-- 회원 탈퇴 -->
      <div class="settings-section danger-zone">
        <div class="settings-section-head">
          <span class="sec-icon"><svg class="icon-svg" viewBox="0 0 24 24"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg></span>
          <div>
            <h3>회원 탈퇴</h3>
            <p>탈퇴 후 모든 데이터는 삭제되며 복구할 수 없습니다</p>
          </div>
        </div>
        <div class="settings-section-body">
          <div class="alert alert-error" style="margin-bottom:20px;font-size:.85rem">
            탈퇴 시 장바구니, 주문 내역 등 모든 데이터가 즉시 삭제됩니다.
          </div>
          <form action="<%= CTX %>/member/deleteProc.jsp" method="post"
                onsubmit="return confirmDelete()">
            <div class="form-group">
              <label for="delPw">비밀번호 확인 <span style="color:var(--red)">*</span></label>
              <input type="password" id="delPw" name="memberPw" class="form-control"
                     placeholder="비밀번호를 입력하여 탈퇴를 확인하세요">
            </div>
            <button type="submit" class="btn btn-danger btn-sm">회원 탈퇴</button>
          </form>
        </div>
      </div>

    </div><!-- /panel-account -->

  </div><!-- /tab panels -->
</div><!-- /mypage-layout -->
</main>

<script>
const INIT_TAB = '<%= tab %>';

function switchTab(name) {
    ['orders','inquiries','account'].forEach(t => {
        document.getElementById('panel-' + t).classList.toggle('active', t === name);
    });
    document.querySelectorAll('.profile-nav-btn[onclick]').forEach(btn => {
        btn.classList.toggle('active', btn.getAttribute('onclick') === "switchTab('" + name + "')");
    });
}

function validateInfoForm(form) {
    if (!form.memberName.value.trim()) {
        alert('이름을 입력하세요.'); form.memberName.focus(); return false;
    }
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(form.email.value.trim())) {
        alert('이메일 형식이 올바르지 않습니다.'); form.email.focus(); return false;
    }
    return true;
}

function validatePwForm(form) {
    if (!form.curPw.value) {
        alert('현재 비밀번호를 입력하세요.'); form.curPw.focus(); return false;
    }
    if (form.newPw.value.length < 8) {
        alert('새 비밀번호는 8자 이상 입력하세요.'); form.newPw.focus(); return false;
    }
    if (form.newPw.value !== form.newPw2.value) {
        alert('새 비밀번호가 일치하지 않습니다.'); form.newPw2.focus(); return false;
    }
    return true;
}

function checkPwStrength(val) {
    var el = document.getElementById('pwStrength');
    var hint = document.getElementById('pwHint');
    if (!el) return;
    el.className = 'pw-strength';
    if (val.length === 0) { hint.textContent = '8자 이상 입력해주세요'; return; }
    var score = 0;
    if (val.length >= 8) score++;
    if (/[A-Za-z]/.test(val) && /[0-9]/.test(val)) score++;
    if (/[^A-Za-z0-9]/.test(val)) score++;
    var levels = ['', 'weak', 'fair', 'strong'];
    var msgs = ['', '보안 수준: 낮음', '보안 수준: 보통', '보안 수준: 높음'];
    el.className = 'pw-strength ' + (levels[score] || '');
    hint.textContent = msgs[score] || '';
}

function confirmDelete() {
    var pw = document.getElementById('delPw').value;
    if (!pw) { alert('비밀번호를 입력하세요.'); return false; }
    return confirm('정말 탈퇴하시겠습니까?\n이 작업은 되돌릴 수 없습니다.');
}

switchTab(INIT_TAB);
</script>

<%@ include file="/WEB-INF/inc/footer.jsp" %>
