<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.hatshop.board.BoardDAO, com.hatshop.board.BoardDTO,
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

    /* 파라미터 파싱 */
    int boardNo = 0;
    try { boardNo = Integer.parseInt(request.getParameter("boardNo")); }
    catch (Exception ignored) {}

    if (boardNo <= 0) {
        response.sendRedirect(request.getContextPath() + "/board/boardList.jsp");
        return;
    }

    /* 삭제 처리 */
    try {
        BoardDAO dao = new BoardDAO();

        /* 권한 체크를 위해 기존 글 조회 */
        BoardDTO existing = dao.getOne(boardNo);
        if (existing == null) {
            session.setAttribute("flashError", "이미 삭제되었거나 존재하지 않는 게시글입니다.");
            response.sendRedirect(request.getContextPath() + "/board/boardList.jsp");
            return;
        }

        boolean isAdmin = loginUser.isAdmin();

        /* 비본인 + 비관리자 → 거부 */
        if (!isAdmin && !loginUser.getMemberId().equals(existing.getMemberId())) {
            session.setAttribute("flashError", "삭제 권한이 없습니다.");
            response.sendRedirect(request.getContextPath() + "/board/boardDetail.jsp?boardNo=" + boardNo);
            return;
        }

        int rows = dao.delete(boardNo, loginUser.getMemberId(), isAdmin);
        if (rows > 0) {
            /* 삭제 성공 시 세션에서 조회 기록도 제거 */
            session.removeAttribute("viewed_board_" + boardNo);
            session.setAttribute("flashSuccess", "게시글이 삭제되었습니다.");
        } else {
            session.setAttribute("flashError", "삭제에 실패했습니다. 잠시 후 다시 시도해주세요.");
        }

    } catch (Exception e) {
        session.setAttribute("flashError", "삭제 중 오류가 발생했습니다.");
    }

    response.sendRedirect(request.getContextPath() + "/board/boardList.jsp");
%>
