<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.hatshop.member.MemberDTO, com.hatshop.order.OrderDAO, com.hatshop.order.OrderDTO,
                 com.hatshop.util.Logger, com.hatshop.db.DBConn,
                 java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%
    String CTX = request.getContextPath();
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    if (loginUser == null) {
        response.sendRedirect(CTX + "/member/login.jsp");
        return;
    }
    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        response.sendRedirect(CTX + "/member/mypage.jsp");
        return;
    }

    int orderNo = 0;
    try { orderNo = Integer.parseInt(request.getParameter("orderNo")); } catch (Exception ignored) {}
    String reasonCode = request.getParameter("reasonCode");
    String reasonDetail = request.getParameter("reasonDetail");
    if (reasonDetail != null) reasonDetail = reasonDetail.trim();

    java.util.Set<String> validCodes = new java.util.HashSet<>(java.util.Arrays.asList(
        "CHANGE_MIND", "DEFECTIVE", "WRONG_ITEM", "SIZE_COLOR", "LATE_DELIVERY", "OTHER"));

    if (orderNo <= 0) {
        session.setAttribute("flashError", "잘못된 주문번호입니다.");
        response.sendRedirect(CTX + "/member/mypage.jsp");
        return;
    }
    if (reasonCode == null || !validCodes.contains(reasonCode)) {
        session.setAttribute("flashError", "환불 사유를 선택해주세요.");
        response.sendRedirect(CTX + "/refund/request.jsp?orderNo=" + orderNo);
        return;
    }
    if ("OTHER".equals(reasonCode) && (reasonDetail == null || reasonDetail.isEmpty())) {
        session.setAttribute("flashError", "기타 사유 선택 시 상세 설명을 입력해주세요.");
        response.sendRedirect(CTX + "/refund/request.jsp?orderNo=" + orderNo);
        return;
    }
    if (reasonDetail != null && reasonDetail.length() > 1000) {
        reasonDetail = reasonDetail.substring(0, 1000);
    }

    try {
        OrderDTO order = new OrderDAO().getOrderDetail(orderNo, loginUser.getMemberId());
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

        Connection conn = DBConn.getConnection();

        String dupSql = "SELECT COUNT(*) FROM refund WHERE order_no = ? AND refund_status IN ('REQUESTED','APPROVED','COMPLETED')";
        try (PreparedStatement ps = conn.prepareStatement(dupSql)) {
            ps.setInt(1, orderNo);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    session.setAttribute("flashError", "이미 환불 신청이 진행 중인 주문입니다.");
                    response.sendRedirect(CTX + "/member/mypage.jsp");
                    return;
                }
            }
        }

        String insertSql = "INSERT INTO refund (order_no, member_id, reason_code, reason_detail) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
            ps.setInt(1, orderNo);
            ps.setString(2, loginUser.getMemberId());
            ps.setString(3, reasonCode);
            if (reasonDetail == null || reasonDetail.isEmpty()) {
                ps.setNull(4, java.sql.Types.VARCHAR);
            } else {
                ps.setString(4, reasonDetail);
            }
            ps.executeUpdate();
        }

        Logger.info(this.getClass(), "환불 신청 완료: orderNo=" + orderNo + " memberId=" + loginUser.getMemberId() + " reason=" + reasonCode);
        session.setAttribute("flashSuccess", "환불 신청이 완료되었습니다. 영업일 기준 3~5일 내(회사 사정에 따라 변동될 수 있음)로 환불 처리됩니다.");
        response.sendRedirect(CTX + "/member/mypage.jsp");

    } catch (Exception e) {
        Logger.error(this.getClass(), "환불 신청 처리 오류: orderNo=" + orderNo, e);
        session.setAttribute("flashError", "환불 신청 처리 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
        response.sendRedirect(CTX + "/member/mypage.jsp");
    }
%>
