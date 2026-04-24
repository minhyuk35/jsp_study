<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dto.Book" %>
<%@ page import="dao.BookRepository" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css" rel="stylesheet">
    <title>도서 정보</title>
</head>
<body>
    <div class="container py-4">
        <%@ include file="menu.jsp" %>

        <div class="p-4 mb-4 bg-body-tertiary rounded-3 border">
            <h1 class="display-6 fw-bold">도서 정보</h1>
            <p class="text-muted mb-0">BookInfo</p>
        </div>

        <%
            String id = request.getParameter("id");
            BookRepository dao = BookRepository.getInstance();
            Book book = dao.getBookById(id);
        %>

        <div class="row g-4 align-items-start">
            <div class="col-md-4 text-center">
                <img src="${pageContext.request.contextPath}/resources/images/<%= book.getFilename() %>"
                    class="img-fluid rounded shadow-sm" style="max-height: 420px; object-fit: cover; width: 100%;">
            </div>
            <div class="col-md-8">
                <h3 class="fw-bold mb-2"><%= book.getName() %></h3>
                <p class="text-muted mb-3"><%= book.getDescription() %></p>
                <hr>
                <table class="table table-borderless">
                    <tbody>
                        <tr>
                            <th class="col-3 text-muted fw-normal">도서코드</th>
                            <td><span class="badge bg-danger"><%= book.getBookId() %></span></td>
                        </tr>
                        <tr>
                            <th class="text-muted fw-normal">저자</th>
                            <td><%= book.getAuthor() %></td>
                        </tr>
                        <tr>
                            <th class="text-muted fw-normal">출판사</th>
                            <td><%= book.getPublisher() %></td>
                        </tr>
                        <tr>
                            <th class="text-muted fw-normal">출판일</th>
                            <td><%= book.getReleaseDate() %></td>
                        </tr>
                        <tr>
                            <th class="text-muted fw-normal">분류</th>
                            <td><%= book.getCategory() %></td>
                        </tr>
                        <tr>
                            <th class="text-muted fw-normal">재고수</th>
                            <td><%= book.getUnitsInStock() %></td>
                        </tr>
                    </tbody>
                </table>
                <h4 class="fw-bold mt-2 mb-4"><%= book.getUnitPrice() %>원</h4>
                <a href="#" class="btn btn-dark me-2">도서 주문 &raquo;</a>
                <a href="${pageContext.request.contextPath}/books.jsp" class="btn btn-outline-secondary">도서 목록 &raquo;</a>
            </div>
        </div>

        <jsp:include page="footer.jsp" />
    </div>
</body>
</html>
