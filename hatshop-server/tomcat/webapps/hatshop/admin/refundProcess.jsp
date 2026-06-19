<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hatshop.member.MemberDTO, com.hatshop.util.Logger, com.hatshop.db.DBConn,
                 java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    if (loginUser == null || !loginUser.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/error/403.jsp"); return;
    }
    String ctx = request.getContextPath();
    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        response.sendRedirect(ctx + "/admin/refundList.jsp"); return;
    }

    int refundNo = 0;
    try { refundNo = Integer.parseInt(request.getParameter("refundNo")); } catch (Exception ignored) {}
    String action = request.getParameter("action");

    if (refundNo <= 0 || action == null ||
        !(action.equals("approve") || action.equals("reject") || action.equals("complete"))) {
        session.setAttribute("flashError", "잘못된 요청입니다.");
        response.sendRedirect(ctx + "/admin/refundList.jsp");
        return;
    }

    Connection conn = DBConn.getConnection();
    boolean origAutoCommit = true;

    try {
        origAutoCommit = conn.getAutoCommit();
        conn.setAutoCommit(false);

        /* 현재 상태 + 주문번호 조회 (락 방지를 위해 단순 조회) */
        int orderNo = 0;
        String curStatus = null;
        String sql0 = "SELECT order_no, refund_status FROM refund WHERE refund_no = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql0)) {
            ps.setInt(1, refundNo);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    orderNo = rs.getInt("order_no");
                    curStatus = rs.getString("refund_status");
                }
            }
        }

        if (curStatus == null) {
            conn.rollback();
            session.setAttribute("flashError", "존재하지 않는 환불 신청입니다.");
            response.sendRedirect(ctx + "/admin/refundList.jsp");
            return;
        }

        if ("approve".equals(action)) {
            if (!"REQUESTED".equals(curStatus)) {
                conn.rollback();
                session.setAttribute("flashError", "신청 상태의 건만 승인할 수 있습니다.");
                response.sendRedirect(ctx + "/admin/refundList.jsp");
                return;
            }
            try (PreparedStatement ps = conn.prepareStatement(
                    "UPDATE refund SET refund_status='APPROVED', processed_date=NOW() WHERE refund_no=?")) {
                ps.setInt(1, refundNo);
                ps.executeUpdate();
            }
            conn.commit();
            Logger.info(this.getClass(), "환불 승인: refundNo=" + refundNo + " orderNo=" + orderNo + " admin=" + loginUser.getMemberId());
            session.setAttribute("flashSuccess", "환불 신청 #" + refundNo + "건을 승인했습니다.");

        } else if ("reject".equals(action)) {
            if (!"REQUESTED".equals(curStatus)) {
                conn.rollback();
                session.setAttribute("flashError", "신청 상태의 건만 거부할 수 있습니다.");
                response.sendRedirect(ctx + "/admin/refundList.jsp");
                return;
            }
            try (PreparedStatement ps = conn.prepareStatement(
                    "UPDATE refund SET refund_status='REJECTED', processed_date=NOW() WHERE refund_no=?")) {
                ps.setInt(1, refundNo);
                ps.executeUpdate();
            }
            conn.commit();
            Logger.info(this.getClass(), "환불 거부: refundNo=" + refundNo + " orderNo=" + orderNo + " admin=" + loginUser.getMemberId());
            session.setAttribute("flashSuccess", "환불 신청 #" + refundNo + "건을 거부했습니다.");

        } else { /* complete */
            if (!"APPROVED".equals(curStatus)) {
                conn.rollback();
                session.setAttribute("flashError", "승인된 건만 완료 처리할 수 있습니다.");
                response.sendRedirect(ctx + "/admin/refundList.jsp");
                return;
            }
            /* 재고 복구 */
            try (PreparedStatement ps = conn.prepareStatement(
                    "UPDATE hat h JOIN order_detail d ON h.hat_no = d.hat_no SET h.hat_stock = h.hat_stock + d.detail_qty WHERE d.order_no = ?")) {
                ps.setInt(1, orderNo);
                ps.executeUpdate();
            }
            /* 주문 상태를 취소로 전환 (환불 완료 = 주문 취소 처리) */
            try (PreparedStatement ps = conn.prepareStatement(
                    "UPDATE orders SET order_status='CANCEL' WHERE order_no=?")) {
                ps.setInt(1, orderNo);
                ps.executeUpdate();
            }
            try (PreparedStatement ps = conn.prepareStatement(
                    "UPDATE refund SET refund_status='COMPLETED', processed_date=NOW() WHERE refund_no=?")) {
                ps.setInt(1, refundNo);
                ps.executeUpdate();
            }
            conn.commit();
            Logger.info(this.getClass(), "환불 완료 처리: refundNo=" + refundNo + " orderNo=" + orderNo + " admin=" + loginUser.getMemberId());
            session.setAttribute("flashSuccess", "환불 신청 #" + refundNo + "건을 완료 처리했습니다. 재고가 복구되고 주문이 취소 처리되었습니다.");
        }

        response.sendRedirect(ctx + "/admin/refundList.jsp");

    } catch (Exception e) {
        try { conn.rollback(); } catch (Exception ignored) {}
        Logger.error(this.getClass(), "환불 처리 오류: refundNo=" + refundNo + " action=" + action, e);
        session.setAttribute("flashError", "환불 처리 중 오류가 발생했습니다.");
        response.sendRedirect(ctx + "/admin/refundList.jsp");
    } finally {
        try { conn.setAutoCommit(origAutoCommit); } catch (Exception ignored) {}
    }
%>
