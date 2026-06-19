<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    /* 구 URL(/hat/detail.jsp?hatNo=X 또는 ?hatId=X)을 서블릿으로 리다이렉트 */
    String hatNo = request.getParameter("hatNo");
    if (hatNo == null || hatNo.isEmpty()) hatNo = request.getParameter("hatId");

    if (hatNo == null || hatNo.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/hat/list");
    } else {
        response.sendRedirect(request.getContextPath() + "/hat/detail?hatNo=" + hatNo);
    }
%>
