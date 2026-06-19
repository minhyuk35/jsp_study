<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.hatshop.member.MemberDTO, com.hatshop.util.Logger, com.hatshop.db.DBConn,
                 org.json.JSONObject, java.sql.Connection, java.sql.PreparedStatement" %>
<%
    response.setHeader("Cache-Control", "no-store");
    JSONObject resultJson = new JSONObject();

    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        response.setStatus(405);
        resultJson.put("ok", false);
        resultJson.put("error", "허용되지 않은 요청입니다.");
        resultJson.write(response.getWriter());
        return;
    }

    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String title = request.getParameter("title");
    String content = request.getParameter("content");

    name = name == null ? "" : name.trim();
    email = email == null ? "" : email.trim();
    title = title == null ? "" : title.trim();
    content = content == null ? "" : content.trim();

    if (name.isEmpty() || email.isEmpty() || title.isEmpty() || content.isEmpty()) {
        response.setStatus(400);
        resultJson.put("ok", false);
        resultJson.put("error", "이름, 이메일, 제목, 내용을 모두 입력해주세요.");
        resultJson.write(response.getWriter());
        return;
    }
    if (!email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
        response.setStatus(400);
        resultJson.put("ok", false);
        resultJson.put("error", "이메일 형식이 올바르지 않습니다.");
        resultJson.write(response.getWriter());
        return;
    }
    if (name.length() > 50) name = name.substring(0, 50);
    if (email.length() > 100) email = email.substring(0, 100);
    if (title.length() > 200) title = title.substring(0, 200);
    if (content.length() > 2000) content = content.substring(0, 2000);

    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    String memberId = (loginUser != null) ? loginUser.getMemberId() : null;

    try {
        Connection conn = DBConn.getConnection();
        String sql = "INSERT INTO inquiry (member_id, inquiry_name, inquiry_email, inquiry_title, inquiry_content) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            if (memberId == null) {
                ps.setNull(1, java.sql.Types.VARCHAR);
            } else {
                ps.setString(1, memberId);
            }
            ps.setString(2, name);
            ps.setString(3, email);
            ps.setString(4, title);
            ps.setString(5, content);
            ps.executeUpdate();
        }
        Logger.info(this.getClass(), "고객센터 문의 접수: name=" + name + " email=" + email + " memberId=" + memberId);
        resultJson.put("ok", true);
        resultJson.write(response.getWriter());
    } catch (Exception e) {
        Logger.error(this.getClass(), "고객센터 문의 접수 오류: name=" + name + " email=" + email, e);
        response.setStatus(500);
        resultJson.put("ok", false);
        resultJson.put("error", "문의 접수 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
        resultJson.write(response.getWriter());
    }
%>
