<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Date" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <title>Welcome</title>
</head>
<body>
    <%! 
        String greeting = "도서 쇼핑몰에 오신 것을 환영합니다";
        String tagline = "Welcome to Web Market!"; 
    %>

    <div class="container py-4">
        <%@ include file="menu.jsp" %>
	    <div class="p-5 mb-4 bg-light border rounded-3">
	        <div class="container-fluid py-5">
	            <h1 class="display-5 fw-bold"><%= greeting %></h1>
	            <p>BookMarket</p>
	        </div>
	    </div>

	    <div class="row align-items-md-stretch">
			<div class = "col-md-12">
				<div class="h-100 p-5 text-bg-dark rounded-3 text-center">
					<h3><%= tagline %></h3>
					<%
						 Date day=new java.util.Date();
					     String am_pm;
					     int hour=day.getHours();
					     int minute=day.getMinutes();
					     int second=day.getSeconds();
					     if(hour/12 == 0){
					    	 am_pm="AM";
					     }else{
					    	 am_pm="PM";
					     }
					     String CT = hour + ":" + minute + ":" + second + " " + am_pm;
					     out.println("현재 접속 시각: " + CT + "\n");
					%>
				</div>
			</div>
	        <%@ include file="footer.jsp" %>
    	</div>	 
    </div> 
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>