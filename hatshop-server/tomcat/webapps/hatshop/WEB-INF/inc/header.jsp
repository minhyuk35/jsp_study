<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hatshop.cart.CartDAO, com.hatshop.member.MemberDTO" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String _ctx = request.getContextPath();
    String _uri = request.getRequestURI();
    String _cat = request.getParameter("category");
    if (_cat == null) _cat = "";
    boolean _onHome  = _uri.endsWith("/") || _uri.endsWith("index.jsp") || _uri.equals(_ctx + "/");
    boolean _onBoard = _uri.contains("/board/");
    boolean _onHat   = _uri.contains("/hat/");

    MemberDTO _hdrUser = (MemberDTO) session.getAttribute("loginUser");
    int _cartCount = 0;
    int _unreadInquiryCount = 0;
    if (_hdrUser != null) {
        try { _cartCount = new CartDAO().getCartCount(_hdrUser.getMemberId()); }
        catch (Exception _e) { /* 배지 카운트 실패 시 0으로 유지 */ }
        try {
            java.sql.Connection _conn = com.hatshop.db.DBConn.getConnection();
            try (java.sql.PreparedStatement _ps = _conn.prepareStatement(
                    "SELECT COUNT(*) FROM inquiry WHERE member_id = ? AND inquiry_status IN ('ANSWERED','CLOSED') AND is_read = 0")) {
                _ps.setString(1, _hdrUser.getMemberId());
                try (java.sql.ResultSet _rs = _ps.executeQuery()) {
                    if (_rs.next()) _unreadInquiryCount = _rs.getInt(1);
                }
            }
        } catch (Exception _e) { /* 알림 카운트 실패 시 0으로 유지 */ }
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HATSHOP — Wear Your Statement</title>
    <link rel="stylesheet" href="<%= _ctx %>/css/style.css?v=5">
    <link rel="stylesheet" href="<%= _ctx %>/css/chatbot.css?v=5">
</head>
<body>

<header class="site-header <%= _onHome ? "" : "scrolled" %>" id="siteHeader" data-home="<%= _onHome %>">

    <a href="<%= _ctx %>/" class="brand">HATSHOP</a>

    <nav class="site-nav-primary" id="primaryNav">
        <a href="<%= _ctx %>/"
           class="<%= _onHome ? "active" : "" %>">Home</a>
        <a href="<%= _ctx %>/hat/list?category=%EB%B3%BC%EC%BA%A1"
           class="<%= "볼캡".equals(_cat) ? "active" : "" %>">볼캡</a>
        <a href="<%= _ctx %>/hat/list?category=%EB%B2%84%ED%82%B7%ED%96%87"
           class="<%= "버킷햇".equals(_cat) ? "active" : "" %>">버킷햇</a>
        <a href="<%= _ctx %>/hat/list?category=%EB%B2%A0%EB%A0%88%EB%AA%A8"
           class="<%= "베레모".equals(_cat) ? "active" : "" %>">베레모</a>
        <a href="<%= _ctx %>/hat/list?category=%ED%8E%98%EB%8F%84%EB%9D%BC"
           class="<%= "페도라".equals(_cat) ? "active" : "" %>">페도라</a>
        <a href="<%= _ctx %>/hat/list?category=%EC%8A%A4%EB%83%85%EB%B0%B1"
           class="<%= "스냅백".equals(_cat) ? "active" : "" %>">스냅백</a>
        <a href="<%= _ctx %>/board/boardList.jsp"
           class="<%= _onBoard ? "active" : "" %>">커뮤니티</a>
    </nav>

    <div class="header-icons">
        <c:choose>
            <c:when test="${empty sessionScope.loginUser}">
                <a href="${pageContext.request.contextPath}/member/login.jsp">로그인</a>
                <a href="${pageContext.request.contextPath}/member/join.jsp">회원가입</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/member/mypage.jsp?tab=inquiries" style="position:relative">마이페이지<%
                    if (_unreadInquiryCount > 0) { %><span class="cart-count"><%= _unreadInquiryCount %></span><% } %></a>
                <c:if test="${sessionScope.loginUser.grade eq 'ADMIN'}">
                    <a href="${pageContext.request.contextPath}/admin/">관리자</a>
                </c:if>
                <a href="${pageContext.request.contextPath}/member/logout.jsp">로그아웃</a>
            </c:otherwise>
        </c:choose>
        <a href="<%= _ctx %>/cart/list" style="position:relative">
            장바구니<span class="cart-count" id="cartBadge"<%= _cartCount > 0 ? "" : " style=\"display:none\"" %>><%= _cartCount > 0 ? _cartCount : 0 %></span>
        </a>
    </div>

</header>

<script>
(function(){
    var h   = document.getElementById('siteHeader');
    var isHome = h && h.getAttribute('data-home') === 'true';
    function upd(){ h.classList.toggle('scrolled', !isHome || window.scrollY > 50); }
    window.addEventListener('scroll', upd, {passive:true});
    upd();
})();
function incrementCartBadge() {
    var b = document.getElementById('cartBadge');
    if (!b) return;
    var n = (parseInt(b.textContent) || 0) + 1;
    b.textContent = n;
    b.style.display = '';
}
</script>
