<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/inc/header.jsp" %>
<main class="main-content">
    <div class="container error-page">
        <div class="error-code">403</div>
        <h2>접근 권한이 없습니다</h2>
        <p>이 페이지에 접근할 수 있는 권한이 없습니다.</p>
        <a href="${pageContext.request.contextPath}/" class="btn btn-primary">홈으로 돌아가기</a>
    </div>
</main>
<%@ include file="/WEB-INF/inc/footer.jsp" %>
