<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hatshop.member.MemberDTO, com.hatshop.util.HtmlUtils, com.hatshop.util.Logger,
                 com.hatshop.db.DBConn, java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet,
                 java.util.List, java.util.ArrayList" %>
<%
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    if (loginUser == null || !loginUser.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/error/403.jsp"); return;
    }
    String ctx = request.getContextPath();

    String flashSuccess = (String) session.getAttribute("flashSuccess");
    String flashError   = (String) session.getAttribute("flashError");
    session.removeAttribute("flashSuccess");
    session.removeAttribute("flashError");

    String filter = request.getParameter("status");
    if (filter == null) filter = "";

    java.util.Map<String,String> reasonLabels = new java.util.HashMap<>();
    reasonLabels.put("CHANGE_MIND", "단순 변심");
    reasonLabels.put("DEFECTIVE", "상품 불량/하자");
    reasonLabels.put("WRONG_ITEM", "오배송");
    reasonLabels.put("SIZE_COLOR", "사이즈/색상 불일치");
    reasonLabels.put("LATE_DELIVERY", "배송 지연");
    reasonLabels.put("OTHER", "기타");

    List<Object[]> refunds = new ArrayList<>();
    try {
        Connection conn = DBConn.getConnection();
        StringBuilder sql = new StringBuilder(
            "SELECT r.refund_no, r.order_no, r.member_id, r.reason_code, r.reason_detail, r.refund_status, " +
            "r.request_date, r.processed_date, o.order_total, o.order_status " +
            "FROM refund r JOIN orders o ON r.order_no = o.order_no ");
        if (!filter.isEmpty()) sql.append("WHERE r.refund_status = ? ");
        sql.append("ORDER BY r.refund_no DESC");

        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            if (!filter.isEmpty()) ps.setString(1, filter);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    refunds.add(new Object[]{
                        rs.getInt("refund_no"), rs.getInt("order_no"), rs.getString("member_id"),
                        rs.getString("reason_code"), rs.getString("reason_detail"), rs.getString("refund_status"),
                        rs.getTimestamp("request_date"), rs.getTimestamp("processed_date"),
                        rs.getInt("order_total"), rs.getString("order_status")
                    });
                }
            }
        }
    } catch (Exception e) {
        Logger.error(this.getClass(), "admin/refundList.jsp 조회 오류", e);
    }
%>
<%@ include file="/WEB-INF/inc/header.jsp" %>

<style>
.admin-section { max-width: 1200px; margin: 0 auto; padding: calc(var(--header-h) + 40px) 16px 60px; }
.admin-page-head { display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px; flex-wrap: wrap; gap: 12px; }
.admin-page-head h1 { font-size: 1.25rem; font-weight: 700; display: flex; align-items: center; gap: 8px; }
.admin-breadcrumb { display: flex; align-items: center; gap: 6px; font-size: .82rem; color: var(--ink-soft); margin-bottom: 16px; }
.admin-breadcrumb a:hover { color: var(--accent); }
.filter-tabs { display: flex; gap: 6px; margin-bottom: 18px; flex-wrap: wrap; }
.filter-tab { padding: 7px 16px; border: 1px solid var(--line); border-radius: 20px; font-size: .82rem; text-decoration: none; color: var(--ink-soft); transition: all .15s; }
.filter-tab:hover { border-color: var(--ink); color: var(--ink); }
.filter-tab.active { background: var(--ink); border-color: var(--ink); color: #fff; font-weight: 700; }

.data-table { width: 100%; border-collapse: collapse; font-size: .87rem; }
.data-table th { text-align: left; padding: 11px 14px; background: var(--ph-a); color: var(--ink-soft); font-weight: 600; border-bottom: 1px solid var(--line); font-size: .8rem; white-space: nowrap; }
.data-table td { padding: 11px 14px; border-bottom: 1px solid var(--line); vertical-align: top; }
.data-table tr:last-child td { border-bottom: none; }
.data-table tbody tr:hover td { background: var(--bg-sub); }
.table-card { border: 1px solid var(--line); border-radius: 4px; overflow: hidden; }
.table-summary { padding: 10px 16px; background: var(--bg-sub); border-top: 1px solid var(--line); font-size: .82rem; color: var(--ink-soft); }
.reason-detail-txt { max-width: 240px; white-space: pre-wrap; word-break: break-word; color: var(--ink-soft); font-size: .82rem; }

.rbadge { display: inline-block; padding: 3px 10px; border-radius: 20px; font-size: .75rem; font-weight: 700; border: 1px solid; white-space: nowrap; }
.rbadge-requested { background: #fffbef; color: #8a6200; border-color: #e8c84a; }
.rbadge-approved  { background: #eff8ff; color: #1a6fb3; border-color: #96cff5; }
.rbadge-rejected  { background: #fff5f5; color: var(--red); border-color: #f5a0a0; }
.rbadge-completed { background: #f0faf4; color: var(--green); border-color: #7dcf9e; }

.refund-actions { display: flex; gap: 6px; flex-wrap: wrap; }
.refund-actions form { display: inline; }
.btn-approve { padding: 6px 12px; background: var(--ink); color: #fff; border: none; border-radius: 2px; font-size: .78rem; cursor: pointer; font-family: inherit; }
.btn-approve:hover { opacity: .8; }
.btn-reject { padding: 6px 12px; background: transparent; color: var(--red); border: 1px solid var(--red); border-radius: 2px; font-size: .78rem; cursor: pointer; font-family: inherit; }
.btn-reject:hover { background: #fff5f5; }
.btn-complete { padding: 6px 12px; background: var(--green); color: #fff; border: none; border-radius: 2px; font-size: .78rem; cursor: pointer; font-family: inherit; }
.btn-complete:hover { opacity: .8; }
</style>

<main class="admin-section">

  <nav class="admin-breadcrumb">
    <a href="<%= ctx %>/admin/">대시보드</a>
    <span>›</span>
    <span>환불 관리</span>
  </nav>

  <div class="admin-page-head">
    <h1>
      <svg class="icon-svg" viewBox="0 0 24 24"><polyline points="9 14 4 9 9 4"/><path d="M20 20v-7a4 4 0 0 0-4-4H4"/></svg>
      환불 관리
      <span style="font-size:.85rem;color:var(--ink-soft);font-weight:400"> (총 <%= refunds.size() %>건)</span>
    </h1>
  </div>

  <% if (flashSuccess != null) { %><div class="alert alert-success" style="margin-bottom:16px"><%= HtmlUtils.escape(flashSuccess) %></div><% } %>
  <% if (flashError   != null) { %><div class="alert alert-error"   style="margin-bottom:16px"><%= HtmlUtils.escape(flashError)   %></div><% } %>

  <nav class="filter-tabs">
    <a href="<%= ctx %>/admin/refundList.jsp" class="filter-tab <%= filter.isEmpty() ? "active" : "" %>">전체</a>
    <a href="<%= ctx %>/admin/refundList.jsp?status=REQUESTED" class="filter-tab <%= "REQUESTED".equals(filter) ? "active" : "" %>">신청됨</a>
    <a href="<%= ctx %>/admin/refundList.jsp?status=APPROVED"  class="filter-tab <%= "APPROVED".equals(filter)  ? "active" : "" %>">승인됨</a>
    <a href="<%= ctx %>/admin/refundList.jsp?status=COMPLETED" class="filter-tab <%= "COMPLETED".equals(filter) ? "active" : "" %>">완료됨</a>
    <a href="<%= ctx %>/admin/refundList.jsp?status=REJECTED"  class="filter-tab <%= "REJECTED".equals(filter)  ? "active" : "" %>">거부됨</a>
  </nav>

  <div class="table-card">
    <% if (refunds.isEmpty()) { %>
    <div style="text-align:center;padding:60px 20px;color:var(--ink-soft)">환불 신청 내역이 없습니다.</div>
    <% } else { %>
    <table class="data-table">
      <thead>
        <tr>
          <th style="width:50px">No.</th>
          <th style="width:70px">주문번호</th>
          <th style="width:90px">회원ID</th>
          <th style="width:110px">사유</th>
          <th>상세 설명</th>
          <th style="width:100px;text-align:right">결제금액</th>
          <th style="width:130px">신청일</th>
          <th style="width:90px;text-align:center">상태</th>
          <th style="width:160px">처리</th>
        </tr>
      </thead>
      <tbody>
        <% for (Object[] r : refunds) {
             int refundNo = (Integer) r[0];
             int orderNo  = (Integer) r[1];
             String memberId = (String) r[2];
             String reasonCode = (String) r[3];
             String reasonDetail = (String) r[4];
             String status = (String) r[5];
             java.sql.Timestamp reqDate = (java.sql.Timestamp) r[6];
             int orderTotal = (Integer) r[8];

             String statusLabel, statusClass;
             switch (status) {
                 case "APPROVED":  statusLabel = "승인됨"; statusClass = "rbadge-approved"; break;
                 case "REJECTED":  statusLabel = "거부됨"; statusClass = "rbadge-rejected"; break;
                 case "COMPLETED": statusLabel = "완료됨"; statusClass = "rbadge-completed"; break;
                 default:          statusLabel = "신청됨"; statusClass = "rbadge-requested"; break;
             }
        %>
        <tr>
          <td style="color:var(--ink-soft)"><%= refundNo %></td>
          <td style="font-weight:600">
            <a href="<%= ctx %>/order/detail?orderNo=<%= orderNo %>" target="_blank" style="color:inherit">#<%= orderNo %></a>
          </td>
          <td><%= HtmlUtils.escape(memberId) %></td>
          <td><%= HtmlUtils.escape(reasonLabels.getOrDefault(reasonCode, reasonCode)) %></td>
          <td class="reason-detail-txt"><%= reasonDetail != null ? HtmlUtils.escape(reasonDetail) : "-" %></td>
          <td style="text-align:right"><%= String.format("%,d", orderTotal) %>원</td>
          <td style="font-size:.8rem;color:var(--ink-soft)"><%= reqDate != null ? reqDate.toString().substring(0,16) : "" %></td>
          <td style="text-align:center"><span class="rbadge <%= statusClass %>"><%= statusLabel %></span></td>
          <td>
            <div class="refund-actions">
              <% if ("REQUESTED".equals(status)) { %>
              <form method="POST" action="<%= ctx %>/admin/refundProcess.jsp" onsubmit="return confirm('이 환불 신청을 승인하시겠습니까?')">
                <input type="hidden" name="refundNo" value="<%= refundNo %>">
                <input type="hidden" name="action" value="approve">
                <button type="submit" class="btn-approve">승인</button>
              </form>
              <form method="POST" action="<%= ctx %>/admin/refundProcess.jsp" onsubmit="return confirm('이 환불 신청을 거부하시겠습니까?')">
                <input type="hidden" name="refundNo" value="<%= refundNo %>">
                <input type="hidden" name="action" value="reject">
                <button type="submit" class="btn-reject">거부</button>
              </form>
              <% } else if ("APPROVED".equals(status)) { %>
              <form method="POST" action="<%= ctx %>/admin/refundProcess.jsp" onsubmit="return confirm('환불금 지급을 완료 처리하시겠습니까?\n재고가 복구되고 주문이 취소 처리됩니다.')">
                <input type="hidden" name="refundNo" value="<%= refundNo %>">
                <input type="hidden" name="action" value="complete">
                <button type="submit" class="btn-complete">완료 처리</button>
              </form>
              <% } else { %>
              <span style="color:var(--ink-soft);font-size:.8rem">-</span>
              <% } %>
            </div>
          </td>
        </tr>
        <% } %>
      </tbody>
    </table>
    <div class="table-summary">전체 <%= refunds.size() %>건</div>
    <% } %>
  </div>

</main>

<%@ include file="/WEB-INF/inc/footer.jsp" %>
