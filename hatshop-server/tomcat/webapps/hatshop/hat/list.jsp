<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hatshop.hat.*,java.util.*" %>
<%
    String category = request.getParameter("category");
    if (category == null) category = "";
    int page = 1;
    try { page = Integer.parseInt(request.getParameter("page")); } catch (Exception e) {}
    int pageSize = 12;

    HatDAO dao = new HatDAO();
    List<HatDTO> list = dao.getList(category, page, pageSize);
    int total = dao.getCount(category);
    int totalPage = (int) Math.ceil((double) total / pageSize);
    String ctx = request.getContextPath();
%>
<%@ include file="/WEB-INF/inc/header.jsp" %>
<%@ include file="/WEB-INF/inc/nav.jsp" %>
<main class="main-content">
    <div class="container">
        <h2 style="margin-bottom:24px">모자 목록 <small style="font-size:.7em;color:#888">(총 <%= total %>개)</small></h2>
        <% if (list.isEmpty()) { %>
            <p style="text-align:center;color:#888;padding:60px 0">등록된 상품이 없습니다.</p>
        <% } else { %>
        <div class="product-grid">
            <% for (HatDTO hat : list) { %>
            <div class="product-card">
                <a href="<%= ctx %>/hat/detail.jsp?hatId=<%= hat.getHatId() %>">
                    <div class="img-wrap">
                        <% if (hat.getHatImage() != null && !hat.getHatImage().isEmpty()) { %>
                            <img src="<%= ctx %>/image?src=<%= java.net.URLEncoder.encode(hat.getHatImage(), "UTF-8") %>" alt="<%= hat.getHatName() %>" onerror="this.onerror=null;this.src='<%= ctx %>/images/no-image.png'">
                        <% } else { %>
                            <img src="<%= ctx %>/images/no-image.png" alt="<%= hat.getHatName() %>">
                        <% } %>
                    </div>
                    <div class="card-body">
                        <p class="hat-category"><%= hat.getCategory() %></p>
                        <p class="hat-name"><%= hat.getHatName() %></p>
                        <p class="hat-price"><%= String.format("%,d", hat.getPrice()) %>원</p>
                    </div>
                </a>
            </div>
            <% } %>
        </div>
        <!-- 페이지네이션 -->
        <div class="pagination">
            <% for (int i = 1; i <= totalPage; i++) { %>
                <a href="?category=<%= category %>&page=<%= i %>"
                   class="<%= (i == page) ? "active" : "" %>"><%= i %></a>
            <% } %>
        </div>
        <% } %>
    </div>
</main>
<%@ include file="/WEB-INF/inc/footer.jsp" %>
