<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hatshop.member.*" %>
<%
    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        response.sendRedirect(request.getContextPath() + "/member/login.jsp");
        return;
    }

    String memberId    = request.getParameter("memberId");
    String memberPw    = request.getParameter("memberPw");
    String redirectURL = request.getParameter("redirectURL");

    /* 기본 입력 검사 */
    if (memberId == null || memberId.trim().isEmpty()
     || memberPw == null || memberPw.isEmpty()) {
        session.setAttribute("loginError", "아이디와 비밀번호를 입력하세요.");
        response.sendRedirect("login.jsp");
        return;
    }

    try {
        MemberDAO dao = new MemberDAO();
        MemberDTO dto = dao.login(memberId.trim(), memberPw);

        if (dto == null) {
            session.setAttribute("loginError", "아이디 또는 비밀번호가 일치하지 않습니다.");
            response.sendRedirect("login.jsp");
            return;
        }

        /* 세션 생성 */
        session.setAttribute("loginUser", dto);

        /* 안전한 리다이렉트 — 열린 리다이렉트 방지: 상대 경로만 허용 */
        String target;
        if (redirectURL != null && !redirectURL.trim().isEmpty()
         && redirectURL.startsWith("/") && !redirectURL.startsWith("//")) {
            target = request.getContextPath() + redirectURL;
        } else {
            target = request.getContextPath() + "/";
        }
        response.sendRedirect(target);

    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("loginError", "로그인 중 오류가 발생했습니다.");
        response.sendRedirect("login.jsp");
    }
%>
