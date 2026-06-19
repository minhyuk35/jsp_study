<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hatshop.cart.*,com.hatshop.member.MemberDTO,java.util.*" %>
<%
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    if (loginUser == null) {
        response.sendRedirect(request.getContextPath() + "/member/login.jsp");
        return;
    }
    CartDAO dao = new CartDAO();
    List<CartDTO> list = dao.getList(loginUser.getMemberId());
    int total = list.stream().mapToInt(CartDTO::getSubtotal).sum();
    String ctx = request.getContextPath();
%>
<%@ include file="/WEB-INF/inc/header.jsp" %>
<%@ include file="/WEB-INF/inc/nav.jsp" %>
<main class="main-content">
    <div class="container">
        <h2 style="margin-bottom:24px">장바구니</h2>
        <% if (list.isEmpty()) { %>
            <p style="text-align:center;color:#888;padding:60px 0">장바구니가 비어 있습니다.</p>
        <% } else { %>
        <table class="table">
            <thead><tr><th>상품</th><th>단가</th><th>수량</th><th>소계</th><th>삭제</th></tr></thead>
            <tbody>
            <% for (CartDTO c : list) { %>
            <tr>
                <td>
                    <a href="<%= ctx %>/hat/detail.jsp?hatId=<%= c.getHatId() %>">
                        <% if (c.getHatImage() != null && !c.getHatImage().isEmpty()) { %>
                                        <img src="<%= ctx %>/image?src=<%= java.net.URLEncoder.encode(c.getHatImage(), "UTF-8") %>" style="width:48px;height:48px;object-fit:cover;border-radius:4px;vertical-align:middle;margin-right:8px" onerror="this.onerror=null;this.src='<%= ctx %>/images/no-image.png'">
                                    <% } else { %>
                                        <img src="<%= ctx %>/images/no-image.png" style="width:48px;height:48px;object-fit:cover;border-radius:4px;vertical-align:middle;margin-right:8px" alt="<%= HtmlUtils.escape(c.getHatName()) %>">
                                    <% } %>
                        <%= c.getHatName() %>
                    </a>
                </td>
                <td><%= String.format("%,d", c.getPrice()) %>원</td>
                <td><%= c.getQuantity() %></td>
                <td><strong><%= String.format("%,d", c.getSubtotal()) %>원</strong></td>
                <td>
                    <a href="<%= ctx %>/cart/deleteAction.jsp?cartId=<%= c.getCartId() %>"
                       class="btn btn-danger btn-sm"
                       onclick="return confirmDelete()">삭제</a>
                </td>
            </tr>
            <% } %>
            </tbody>
            <tfoot>
                <tr><td colspan="3" style="text-align:right;font-weight:700">합계</td>
                <td colspan="2"><strong style="color:#e94560;font-size:1.1rem"><%= String.format("%,d", total) %>원</strong></td></tr>
            </tfoot>
        </table>
        <div style="text-align:right;margin-top:16px">
            <a href="<%= ctx %>/order/orderForm.jsp" class="btn btn-primary">주문하기</a>
        </div>
        <% } %>
    </div>
</main>
<%@ include file="/WEB-INF/inc/footer.jsp" %>
