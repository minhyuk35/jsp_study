<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hatshop.member.MemberDTO, com.hatshop.util.Logger, com.hatshop.db.DBConn,
                 java.sql.Connection, java.sql.PreparedStatement" %>
<%
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    if (loginUser == null || !loginUser.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/error/403.jsp"); return;
    }
    String ctx = request.getContextPath();
    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        response.sendRedirect(ctx + "/admin/inquiryList.jsp"); return;
    }

    int inquiryNo = 0;
    try { inquiryNo = Integer.parseInt(request.getParameter("inquiryNo")); } catch (Exception ignored) {}
    String answerContent = request.getParameter("answerContent");
    boolean closeTicket = "1".equals(request.getParameter("closeTicket"));

    if (inquiryNo <= 0) {
        session.setAttribute("flashError", "잘못된 요청입니다.");
        response.sendRedirect(ctx + "/admin/inquiryList.jsp");
        return;
    }
    if (answerContent == null || answerContent.trim().isEmpty()) {
        session.setAttribute("flashError", "답변 내용을 입력해주세요.");
        response.sendRedirect(ctx + "/admin/inquiryDetail.jsp?inquiryNo=" + inquiryNo);
        return;
    }
    answerContent = answerContent.trim();
    if (answerContent.length() > 3000) answerContent = answerContent.substring(0, 3000);

    String newStatus = closeTicket ? "CLOSED" : "ANSWERED";

    try {
        Connection conn = DBConn.getConnection();
        String sql = "UPDATE inquiry SET inquiry_answer = ?, inquiry_status = ?, answer_date = NOW(), is_read = 0 WHERE inquiry_no = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, answerContent);
            ps.setString(2, newStatus);
            ps.setInt(3, inquiryNo);
            ps.executeUpdate();
        }
        Logger.info(this.getClass(), "문의 답변 등록: inquiryNo=" + inquiryNo + " status=" + newStatus + " admin=" + loginUser.getMemberId());
        session.setAttribute("flashSuccess", "문의 #" + inquiryNo + "건에 답변을 등록했습니다.");
        response.sendRedirect(ctx + "/admin/inquiryList.jsp");
    } catch (Exception e) {
        Logger.error(this.getClass(), "문의 답변 등록 오류: inquiryNo=" + inquiryNo, e);
        session.setAttribute("flashError", "답변 등록 중 오류가 발생했습니다.");
        response.sendRedirect(ctx + "/admin/inquiryDetail.jsp?inquiryNo=" + inquiryNo);
    }
%>
