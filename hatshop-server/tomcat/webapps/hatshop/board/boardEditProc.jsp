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
    int boardNo = 0;
    try { boardNo = Integer.parseInt(request.getParameter("boardNo")); }
    catch (Exception ignored) {}

    String title     = request.getParameter("boardTitle");
    String content   = request.getParameter("boardContent");
    String typeParam = request.getParameter("boardType");

    if (boardNo <= 0) {
        response.sendRedirect(request.getContextPath() + "/board/boardList.jsp");
        return;
    }

    /* 서버 유효성 검사 */
    if (title == null || title.trim().isEmpty()) {
        session.setAttribute("flashError", "제목을 입력해주세요.");
        response.sendRedirect(request.getContextPath() + "/board/boardEdit.jsp?boardNo=" + boardNo);
        return;
    }
    if (title.trim().length() > 200) {
        session.setAttribute("flashError", "제목은 200자 이하로 입력해주세요.");
        response.sendRedirect(request.getContextPath() + "/board/boardEdit.jsp?boardNo=" + boardNo);
        return;
    }
    if (content == null || content.trim().isEmpty()) {
        session.setAttribute("flashError", "내용을 입력해주세요.");
        response.sendRedirect(request.getContextPath() + "/board/boardEdit.jsp?boardNo=" + boardNo);
        return;
    }

    /* DB 수정 */
    try {
        BoardDAO  dao      = new BoardDAO();
        BoardDTO  existing = dao.getOne(boardNo);

        if (existing == null) {
            session.setAttribute("flashError", "존재하지 않는 게시글입니다.");
            response.sendRedirect(request.getContextPath() + "/board/boardList.jsp");
            return;
        }

        boolean isAdmin = loginUser.isAdmin();

        /* 권한 2차 체크 */
        if (!isAdmin && !loginUser.getMemberId().equals(existing.getMemberId())) {
            session.setAttribute("flashError", "수정 권한이 없습니다.");
            response.sendRedirect(request.getContextPath() + "/board/boardDetail.jsp?boardNo=" + boardNo);
            return;
        }

        /* 게시글 유형 — ADMIN 만 변경 가능 */
        String boardType = existing.getBoardType();  // 기본값: 기존 타입 유지
        if (isAdmin && ("NORMAL".equals(typeParam) || "NOTICE".equals(typeParam))) {
            boardType = typeParam;
        }

        BoardDTO dto = new BoardDTO();
        dto.setBoardNo     (boardNo);
        dto.setMemberId    (loginUser.getMemberId());
        dto.setBoardTitle  (title.trim());
        dto.setBoardContent(content.trim());
        dto.setBoardType   (boardType);

        dao.update(dto, isAdmin);
        session.setAttribute("flashSuccess", "게시글이 수정되었습니다.");
        response.sendRedirect(request.getContextPath() + "/board/boardDetail.jsp?boardNo=" + boardNo);

    } catch (Exception e) {
        session.setAttribute("flashError", "수정 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
        response.sendRedirect(request.getContextPath() + "/board/boardEdit.jsp?boardNo=" + boardNo);
    }
%>
