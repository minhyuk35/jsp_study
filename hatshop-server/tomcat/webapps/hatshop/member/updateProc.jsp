<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hatshop.member.*" %>
<%
    /* 세션 확인 */
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    if (loginUser == null) {
        response.sendRedirect(request.getContextPath() + "/member/login.jsp?redirectURL=/member/mypage.jsp");
        return;
    }
    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        response.sendRedirect(request.getContextPath() + "/member/mypage.jsp");
        return;
    }

    String type = request.getParameter("type");

    try {
        MemberDAO dao = new MemberDAO();

        /* ── 정보 수정 ── */
        if ("info".equals(type)) {
            String memberName = request.getParameter("memberName");
            String email      = request.getParameter("email");
            String phone      = request.getParameter("phone");
            String addr       = request.getParameter("addr");

            /* 서버 유효성 검사 */
            if (memberName == null || memberName.trim().isEmpty()) {
                session.setAttribute("flashError", "이름을 입력하세요.");
                response.sendRedirect("mypage.jsp?tab=account");
                return;
            }
            if (email == null || !email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
                session.setAttribute("flashError", "이메일 형식이 올바르지 않습니다.");
                response.sendRedirect("mypage.jsp?tab=account");
                return;
            }

            MemberDTO dto = new MemberDTO();
            dto.setMemberId(loginUser.getMemberId());
            dto.setMemberName(memberName.trim());
            dto.setEmail(email.trim());
            dto.setPhone(phone == null ? "" : phone.trim());
            dto.setAddr(addr   == null ? "" : addr.trim());

            dao.update(dto);

            /* 세션의 loginUser 도 갱신 */
            MemberDTO updated = dao.getOne(loginUser.getMemberId());
            if (updated != null) session.setAttribute("loginUser", updated);

            session.setAttribute("flashSuccess", "회원정보가 수정되었습니다.");
            response.sendRedirect("mypage.jsp?tab=account");

        /* ── 비밀번호 변경 ── */
        } else if ("pw".equals(type)) {
            String curPw  = request.getParameter("curPw");
            String newPw  = request.getParameter("newPw");
            String newPw2 = request.getParameter("newPw2");

            if (curPw == null || curPw.isEmpty()) {
                session.setAttribute("flashError", "현재 비밀번호를 입력하세요.");
                response.sendRedirect("mypage.jsp?tab=account");
                return;
            }
            if (newPw == null || newPw.length() < 8) {
                session.setAttribute("flashError", "새 비밀번호는 8자 이상 입력하세요.");
                response.sendRedirect("mypage.jsp?tab=account");
                return;
            }
            if (!newPw.equals(newPw2)) {
                session.setAttribute("flashError", "새 비밀번호가 일치하지 않습니다.");
                response.sendRedirect("mypage.jsp?tab=account");
                return;
            }

            boolean ok = dao.updatePw(loginUser.getMemberId(), curPw, newPw);
            if (ok) {
                session.setAttribute("flashSuccess", "비밀번호가 변경되었습니다.");
                response.sendRedirect("mypage.jsp?tab=account");
            } else {
                session.setAttribute("flashError", "현재 비밀번호가 일치하지 않습니다.");
                response.sendRedirect("mypage.jsp?tab=account");
            }

        } else {
            response.sendRedirect("mypage.jsp");
        }

    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("flashError", "처리 중 오류가 발생했습니다: " + e.getMessage());
        response.sendRedirect("mypage.jsp");
    }
%>
