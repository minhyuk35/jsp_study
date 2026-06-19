<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hatshop.member.*" %>
<%
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    if (loginUser == null) {
        response.sendRedirect(request.getContextPath() + "/member/login.jsp");
        return;
    }
    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        response.sendRedirect(request.getContextPath() + "/member/mypage.jsp");
        return;
    }

    String memberPw = request.getParameter("memberPw");

    if (memberPw == null || memberPw.isEmpty()) {
        session.setAttribute("flashError", "비밀번호를 입력하세요.");
        response.sendRedirect("mypage.jsp?tab=delete");
        return;
    }

    try {
        MemberDAO dao = new MemberDAO();
        boolean deleted = dao.delete(loginUser.getMemberId(), memberPw);

        if (deleted) {
            session.invalidate();
            /* 메인 페이지에 탈퇴 완료 메시지 (새 세션에 flash 저장) */
            request.getSession().setAttribute("flashSuccess", "회원 탈퇴가 완료되었습니다. 이용해 주셔서 감사합니다.");
            response.sendRedirect(request.getContextPath() + "/");
        } else {
            session.setAttribute("flashError", "비밀번호가 일치하지 않습니다.");
            response.sendRedirect("mypage.jsp?tab=delete");
        }
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("flashError", "탈퇴 처리 중 오류가 발생했습니다.");
        response.sendRedirect("mypage.jsp?tab=delete");
    }
%>
