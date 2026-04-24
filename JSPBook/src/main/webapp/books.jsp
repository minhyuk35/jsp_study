<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="dto.Book" %>
<%@ page import="dao.BookRepository" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css" rel="stylesheet">
    <title>도서 목록</title>
</head>
<body>
    <div class="container py-4">
        <%@ include file="menu.jsp" %>

        <div class="p-4 mb-4 bg-body-tertiary rounded-3 border">
            <h1 class="display-6 fw-bold">도서 목록</h1>
            <p class="text-muted mb-0">BookList</p>
        </div>

        <%
            BookRepository dao = BookRepository.getInstance();
            ArrayList<Book> listOfBooks = dao.getAllBooks();
        %>

        <div class="row row-cols-1 row-cols-md-3 g-4">
            <%
                for (int i = 0; i < listOfBooks.size(); i++) {
                    Book book = listOfBooks.get(i);
            %>
            <div class="col">
                <div class="card h-100 shadow-sm">
                    <img src="${pageContext.request.contextPath}/resources/images/<%= book.getFilename() %>"
                        class="card-img-top" style="height: 280px; object-fit: cover;">
                    <div class="card-body">
                        <h5 class="card-title fw-bold"><%= book.getName() %></h5>
                        <p class="card-text text-muted small"><%= book.getAuthor() %> | <%= book.getPublisher() %> | <%= book.getReleaseDate() %></p>
                        <p class="card-text small"><%= book.getDescription().substring(0, 60) %>...</p>
                    </div>
                    <div class="card-footer d-flex justify-content-between align-items-center bg-white border-top-0 pb-3">
                        <span class="fw-bold fs-6"><%= book.getUnitPrice() %>원</span>
                        <a href="${pageContext.request.contextPath}/book.jsp?id=<%= book.getBookId() %>"
                            class="btn btn-dark btn-sm">상세 정보 &raquo;</a>
                    </div>
                </div>
            </div>
            <%
                }
            %>
        </div>

        <%@ include file="footer.jsp" %>
    </div>
</body>
</html>
