<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/inc/header.jsp" %>
<main class="main-content">
    <div class="container error-page">
        <div class="error-code">404</div>
        <h2>페이지를 찾을 수 없습니다</h2>
        <p>요청하신 페이지가 존재하지 않거나 이동되었습니다.</p>
        <a href="${pageContext.request.contextPath}/" class="btn btn-primary">홈으로 돌아가기</a>
    </div>
</main>
<%@ include file="/WEB-INF/inc/footer.jsp" %>
