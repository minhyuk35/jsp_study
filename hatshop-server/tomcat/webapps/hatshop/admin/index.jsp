<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hatshop.member.MemberDTO" %>
<%
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    if (loginUser == null || !"ADMIN".equals(loginUser.getGrade())) {
        response.sendRedirect(request.getContextPath() + "/error/403.jsp");
        return;
    }
    String ctx = request.getContextPath();
%>
<%@ include file="/WEB-INF/inc/header.jsp" %>
<%@ include file="/WEB-INF/inc/nav.jsp" %>
<main class="main-content">
    <div class="container">
        <h2 style="margin-bottom:24px">관리자 대시보드</h2>
        <div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(200px,1fr));gap:16px">
            <a href="<%= ctx %>/admin/hatList.jsp" style="background:#fff;border-radius:8px;padding:24px;text-align:center;box-shadow:0 2px 8px rgba(0,0,0,.07);display:block">
                <div style="font-size:2.5rem"><svg class="icon-svg" style="width:1em;height:1em" viewBox="0 0 24 24"><path d="M4 16c0-4.4 3.6-8 8-8s8 3.6 8 8"/><ellipse cx="12" cy="16" rx="10" ry="2.2"/></svg></div>
                <p style="margin-top:12px;font-weight:600">상품 관리</p>
            </a>
            <a href="<%= ctx %>/admin/memberList.jsp" style="background:#fff;border-radius:8px;padding:24px;text-align:center;box-shadow:0 2px 8px rgba(0,0,0,.07);display:block">
                <div style="font-size:2.5rem"><svg class="icon-svg" style="width:1em;height:1em" viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg></div>
                <p style="margin-top:12px;font-weight:600">회원 관리</p>
            </a>
            <a href="<%= ctx %>/admin/orderList.jsp" style="background:#fff;border-radius:8px;padding:24px;text-align:center;box-shadow:0 2px 8px rgba(0,0,0,.07);display:block">
                <div style="font-size:2.5rem"><svg class="icon-svg" style="width:1em;height:1em" viewBox="0 0 24 24"><path d="M16.5 9.4 7.55 4.24"/><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/><polyline points="3.29 7 12 12 20.71 7"/><line x1="12" y1="22" x2="12" y2="12"/></svg></div>
                <p style="margin-top:12px;font-weight:600">주문 관리</p>
            </a>
            <a href="<%= ctx %>/admin/inquiryList.jsp" style="background:#fff;border-radius:8px;padding:24px;text-align:center;box-shadow:0 2px 8px rgba(0,0,0,.07);display:block">
                <div style="font-size:2.5rem"><svg class="icon-svg" style="width:1em;height:1em" viewBox="0 0 24 24"><path d="M3 18v-6a9 9 0 0 1 18 0v6"/><path d="M21 19a2 2 0 0 1-2 2h-1a2 2 0 0 1-2-2v-3a2 2 0 0 1 2-2h3zM3 19a2 2 0 0 0 2 2h1a2 2 0 0 0 2-2v-3a2 2 0 0 0-2-2H3z"/></svg></div>
                <p style="margin-top:12px;font-weight:600">고객센터 문의</p>
            </a>
            <a href="<%= ctx %>/admin/refundList.jsp" style="background:#fff;border-radius:8px;padding:24px;text-align:center;box-shadow:0 2px 8px rgba(0,0,0,.07);display:block">
                <div style="font-size:2.5rem"><svg class="icon-svg" style="width:1em;height:1em" viewBox="0 0 24 24"><polyline points="9 14 4 9 9 4"/><path d="M20 20v-7a4 4 0 0 0-4-4H4"/></svg></div>
                <p style="margin-top:12px;font-weight:600">환불 관리</p>
            </a>
        </div>
    </div>
</main>
<%@ include file="/WEB-INF/inc/footer.jsp" %>
