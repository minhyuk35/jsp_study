<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Date" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css" rel="stylesheet">
    <title>Welcome</title>
</head>
<body>
    <%!
        String greeting = "도서 쇼핑몰에 오신 것을 환영합니다";
        String tagline = "Welcome to BookMarket!";
    %>

    <div class="container py-4">
        <%@ include file="menu.jsp" %>

        <div class="p-5 mb-4 bg-dark text-white rounded-3">
            <div class="container-fluid py-3">
                <h1 class="display-5 fw-bold"><%= greeting %></h1>
                <p class="fs-5 text-white-50 mb-4">BookMarket</p>
                <a href="${pageContext.request.contextPath}/books.jsp" class="btn btn-outline-light btn-lg">도서 목록 보기 &raquo;</a>
            </div>
        </div>

        <div class="row g-4">
            <div class="col-md-6">
                <div class="card h-100 border-0 shadow-sm">
                    <div class="card-body text-center py-5">
                        <h4 class="card-title fw-bold mb-3"><%= tagline %></h4>
                        <%
                            response.setIntHeader("Refresh", 5);
                            Date day = new java.util.Date();
                            String am_pm;
                            int hour = day.getHours();
                            int minute = day.getMinutes();
                            int second = day.getSeconds();
                            if (hour / 12 == 0) {
                                am_pm = "AM";
                            } else {
                                am_pm = "PM";
                            }
                            String CT = hour + ":" + String.format("%02d", minute) + ":" + String.format("%02d", second) + " " + am_pm;
                        %>
                        <p class="text-muted mb-2">현재 접속 시각</p>
                        <span class="badge bg-dark text-white fs-5 px-4 py-2"><%= CT %></span>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card h-100 border-0 shadow-sm">
                    <div class="card-body text-center py-5">
                        <h4 class="card-title fw-bold mb-4">빠른 메뉴</h4>
                        <div class="d-grid gap-3">
                            <a href="${pageContext.request.contextPath}/books.jsp" class="btn btn-dark btn-lg">도서 목록</a>
                            <a href="${pageContext.request.contextPath}/addBook.jsp" class="btn btn-outline-dark btn-lg">도서 등록</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%@ include file="footer.jsp" %>
    </div>
</body>
</html>
