<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hatshop.member.*" %>
<%
    /* POST 요청만 허용 */
    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        response.sendRedirect(request.getContextPath() + "/member/join.jsp");
        return;
    }

    String memberId   = request.getParameter("memberId");
    String memberPw   = request.getParameter("memberPw");
    String memberPw2  = request.getParameter("memberPw2");
    String memberName = request.getParameter("memberName");
    String email      = request.getParameter("email");
    String phone      = request.getParameter("phone");
    String addr       = request.getParameter("addr");

    /* ── 서버 유효성 검사 (2차 방어) ── */
    String err = null;

    if (memberId == null || !memberId.matches("[a-zA-Z0-9]{4,20}")) {
        err = "아이디는 4~20자 영문·숫자로 입력하세요.";
    } else if (memberPw == null || memberPw.length() < 8) {
        err = "비밀번호는 8자 이상 입력하세요.";
    } else if (!memberPw.equals(memberPw2)) {
        err = "비밀번호가 일치하지 않습니다.";
    } else if (memberName == null || memberName.trim().isEmpty()) {
        err = "이름을 입력하세요.";
    } else if (email == null || !email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
        err = "이메일 형식이 올바르지 않습니다.";
    } else if (addr == null || addr.trim().isEmpty()) {
        err = "주소를 입력해주세요.";
    }

    if (err != null) {
        session.setAttribute("joinError", err);
        session.setAttribute("joinPrefill", memberId);
        response.sendRedirect("join.jsp");
        return;
    }

    /* ── DB 처리 ── */
    MemberDTO dto = new MemberDTO();
    dto.setMemberId(memberId.trim());
    dto.setMemberPw(memberPw);                           // DAO에서 BCrypt 해시
    dto.setMemberName(memberName.trim());
    dto.setEmail(email.trim());
    dto.setPhone(phone == null ? "" : phone.trim());
    dto.setAddr(addr   == null ? "" : addr.trim());

    try {
        MemberDAO dao = new MemberDAO();
        int result = dao.join(dto);

        if (result == -1) {
            session.setAttribute("joinError", "이미 사용 중인 아이디입니다.");
            session.setAttribute("joinPrefill", memberId);
            response.sendRedirect("join.jsp");
        } else if (result > 0) {
            session.setAttribute("flashSuccess", "회원가입이 완료되었습니다. 로그인해 주세요.");
            response.sendRedirect("login.jsp");
        } else {
            session.setAttribute("joinError", "회원가입 중 오류가 발생했습니다. 다시 시도해주세요.");
            response.sendRedirect("join.jsp");
        }
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("joinError", "서버 오류가 발생했습니다: " + e.getMessage());
        response.sendRedirect("join.jsp");
    }
%>
