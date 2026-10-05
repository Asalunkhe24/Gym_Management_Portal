<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Universal Fitness Club</title>
<style>
	
</style>
</head>
<body>

	<%
		String msg = request.getParameter("msg");
		if(msg != null && !msg.trim().isEmpty()){
	%>
		<div class="alert-msg">
			<%= msg %>
		</div>
		
	<%
		}
	%>

	<div style="margin:20px; border:2px solid; padding: 5px">
		<h1>🏋️‍♀️ Universal Fitness - Management Portal</h1>
		<button><a href="register.jsp">Register</a></button>
		<button><a href="Details.jsp">Show Details</a></button>
		<button><a href= "feeStructure.jsp">Fee Structure</a></button>
	</div>
</body>
</html>