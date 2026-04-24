<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark rounded-3 mb-4">
	<div class="container-fluid">
		<a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/welcome.jsp">BookMarket</a>
		<button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarMain"
			aria-controls="navbarMain" aria-expanded="false" aria-label="Toggle navigation">
			<span class="navbar-toggler-icon"></span>
		</button>
		<div class="collapse navbar-collapse" id="navbarMain">
			<ul class="navbar-nav ms-auto">
				<li class="nav-item">
					<a class="nav-link" href="${pageContext.request.contextPath}/books.jsp">도서 목록</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="${pageContext.request.contextPath}/addBook.jsp">도서 등록</a>
				</li>
			</ul>
		</div>
	</div>
</nav>
