<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%!
    private Connection conn;

    public void jspInit() {

        String user = "root";
        String pass = "root";
        String url = "jdbc:mysql://127.0.0.1:3306/gym_management_system";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            conn = DriverManager.getConnection(url, user, pass);

            System.out.println("Database Connected Successfully");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void jspDestroy() {

        try {
            if (conn != null) {
                conn.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>

<%

	//1st implicit Object => Stores total registrations throughtout application.
	if(application.getAttribute("totalRegistrations")== null){
		application.setAttribute("totalRegistrations", 0);
	}
	
	//2nd implecit Object =? Stores the logged in user info
	if(session.getAttribute("user")== null){
		session.setAttribute("user", "ADMIN");
	}
	
	PreparedStatement psmt = conn.prepareStatement("insert into gym_member" + 
			"(member_name, mobile_number, plan_type, fees_paid)VALUES(?,?,?,?)");
	
	//3rd implecit Object => Reads data from the form
	try{
	String memberName = request.getParameter("mname");
	String planType = request.getParameter("planType");
	Long number = 000000L;
	Integer fees = 0;
	if(memberName != null && planType != null){
		number = Long.parseLong(request.getParameter("mnumber"));
		fees = Integer.parseInt(request.getParameter("fees"));
		
	
	psmt.setString(1, memberName);
	psmt.setLong(2, number);
	psmt.setString(3, planType);
	psmt.setInt(4, fees);
	int row = psmt.executeUpdate();
	
	if(row>0){
		int registrations = (int)application.getAttribute("totalRegistrations");
		application.setAttribute("totalRegistrations", registrations+1);
		
		response.sendRedirect("gym_portal.jsp?msg=Member+Registered+successfull");
	}
	}
	}
	finally{
		psmt.close();
	}
	
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Universal Fitness Club Registration</title>
</head>
<body>

		<%
			out.println("<div><p>Logged In User : <strong> "+session.getAttribute("user")+"</strong></p>");
			out.println("<p>Total Registrations" + application.getAttribute("totalRegistrations")+"</p>");
			out.println("</div>");
		%>

		<h1>Registration form</h1>
		<form action="register.jsp" method="post">
			
			<label for="mname">Member Name:</label>
			<input type="text" name="mname"><br><br>
			
			<label for="mnumber">Mobile Number:</label>
			<input type="number" name="mnumber"><br><br>
			
			<label>Membership Plan</label>
			<select name="planType">
				<option value="Monthly Plan">Monthly Plan</option>
				<option value="Annual Plan">Annual Plan</option>
				<option value="Personal Training">VIP Personal Training</option>
			</select><br><br>
			
			<label for="fees">Fees Paid</label>
			<input type="number" name="fees"><br><br>
			
			<button type="submit">Submit</button>
			
		</form>
</body>
</html>