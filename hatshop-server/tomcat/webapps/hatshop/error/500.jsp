<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/inc/header.jsp" %>
<main class="main-content">
    <div class="container error-page">
        <div class="error-code">500</div>
        <h2>서버 오류가 발생했습니다</h2>
        <p>일시적인 오류입니다. 잠시 후 다시 시도해 주세요.</p>
        <a href="${pageContext.request.contextPath}/" class="btn btn-primary">홈으로 돌아가기</a>
    </div>
</main>
<%@ include file="/WEB-INF/inc/footer.jsp" %>
