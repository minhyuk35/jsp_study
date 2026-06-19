<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hatshop.order.*,com.hatshop.member.MemberDTO,java.util.*" %>
<%
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    if (loginUser == null) {
        response.sendRedirect(request.getContextPath() + "/member/login.jsp");
        return;
    }
    OrderDAO dao = new OrderDAO();
    List<OrderDTO> list = dao.getListByMember(loginUser.getMemberId());
    String ctx = request.getContextPath();
%>
<%@ include file="/WEB-INF/inc/header.jsp" %>
<%@ include file="/WEB-INF/inc/nav.jsp" %>
<main class="main-content">
    <div class="container">
        <h2 style="margin-bottom:24px">주문 내역</h2>
        <% if (list.isEmpty()) { %>
            <p style="text-align:center;color:#888;padding:60px 0">주문 내역이 없습니다.</p>
        <% } else { %>
        <table class="table">
            <thead><tr><th>주문번호</th><th>상품</th><th>수량</th><th>금액</th><th>상태</th><th>주문일</th></tr></thead>
            <tbody>
            <% for (OrderDTO o : list) { %>
            <tr>
                <td>#<%= o.getOrderId() %></td>
                <td><%= o.getHatName() %></td>
                <td><%= o.getQuantity() %></td>
                <td><%= String.format("%,d", o.getTotalPrice()) %>원</td>
                <td><span class="badge"><%= o.getStatus() %></span></td>
                <td><%= o.getOrderDate() %></td>
            </tr>
            <% } %>
            </tbody>
        </table>
        <% } %>
    </div>
</main>
<%@ include file="/WEB-INF/inc/footer.jsp" %>
