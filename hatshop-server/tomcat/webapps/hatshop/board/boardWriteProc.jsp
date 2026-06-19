<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.hatshop.board.BoardDTO, com.hatshop.board.BoardDAO,
                 com.hatshop.member.MemberDTO" %>
<%
    /* POST 전용 처리 페이지 */
    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        response.sendRedirect(request.getContextPath() + "/board/boardList.jsp");
        return;
    }

    /* 로그인 체크 */
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    if (loginUser == null) {
        session.setAttribute("flashError", "로그인이 필요합니다.");
        response.sendRedirect(request.getContextPath() + "/member/login.jsp");
        return;
    }

    /* 파라미터 수집 */
    String title   = request.getParameter("boardTitle");
    String content = request.getParameter("boardContent");
    String typeParam = request.getParameter("boardType");

    /* 게시글 유형 — ADMIN 만 공지 설정 가능 */
    String boardType = "NORMAL";
    if (loginUser.isAdmin() && "NOTICE".equals(typeParam)) {
        boardType = "NOTICE";
    }

    /* 서버 유효성 검사 */
    if (title == null || title.trim().isEmpty()) {
        session.setAttribute("flashError", "제목을 입력해주세요.");
        response.sendRedirect(request.getContextPath() + "/board/boardWrite.jsp");
        return;
    }
    if (title.trim().length() > 200) {
        session.setAttribute("flashError", "제목은 200자 이하로 입력해주세요.");
        response.sendRedirect(request.getContextPath() + "/board/boardWrite.jsp");
        return;
    }
    if (content == null || content.trim().isEmpty()) {
        session.setAttribute("flashError", "내용을 입력해주세요.");
        response.sendRedirect(request.getContextPath() + "/board/boardWrite.jsp");
        return;
    }

    /* DB 저장 */
    try {
        BoardDTO dto = new BoardDTO();
        dto.setMemberId   (loginUser.getMemberId());
        dto.setBoardTitle (title.trim());
        dto.setBoardContent(content.trim());
        dto.setBoardType  (boardType);

        int boardNo = new BoardDAO().insert(dto);
        session.setAttribute("flashSuccess", "게시글이 등록되었습니다.");
        response.sendRedirect(request.getContextPath() + "/board/boardDetail.jsp?boardNo=" + boardNo);

    } catch (Exception e) {
        session.setAttribute("flashError", "게시글 등록 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
        response.sendRedirect(request.getContextPath() + "/board/boardWrite.jsp");
    }
%>
