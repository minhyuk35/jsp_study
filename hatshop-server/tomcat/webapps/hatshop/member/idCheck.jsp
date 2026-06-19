<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hatshop.member.MemberDAO" %>
<%
    /* AJAX 아이디 중복 확인 — JSON 응답 */
    response.setHeader("Cache-Control", "no-store");

    String memberId = request.getParameter("memberId");

    boolean available = false;
    String  message   = "";

    if (memberId == null || memberId.trim().isEmpty()) {
        message = "아이디를 입력하세요.";
    } else if (!memberId.matches("[a-zA-Z0-9]{4,20}")) {
        message = "4~20자 영문·숫자만 사용 가능합니다.";
    } else {
        try {
            MemberDAO dao = new MemberDAO();
            if (dao.idExists(memberId.trim())) {
                message = "이미 사용 중인 아이디입니다.";
            } else {
                available = true;
                message = "사용 가능한 아이디입니다.";
            }
        } catch (Exception e) {
            message = "서버 오류가 발생했습니다.";
        }
    }
%>
{"available":<%= available %>,"message":"<%= message.replace("\"","\\\"") %>"}
