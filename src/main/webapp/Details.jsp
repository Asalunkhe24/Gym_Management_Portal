```jsp
<%@page import="java.sql.ResultSet"%>
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

/* =========================
   DELETE MEMBER
   ========================= */

String deleteId = request.getParameter("deleteId");

if(deleteId != null && !deleteId.isEmpty()) {

    try {

        PreparedStatement deletePsmt = conn.prepareStatement(
            "DELETE FROM gym_member WHERE id = ?"
        );

        deletePsmt.setInt(1, Integer.parseInt(deleteId));

        int result = deletePsmt.executeUpdate();

        if(result > 0) {
%>

            <script>
                alert("Member deleted successfully!");
            </script>

<%
        } else {
%>

            <script>
                alert("Member ID not found!");
            </script>

<%
        }

        deletePsmt.close();

    } catch(Exception e) {
        e.printStackTrace();
%>

        <script>
            alert("Error while deleting member!");
        </script>

<%
    }
}


/* =========================
   UPDATE MEMBER
   ========================= */

String updateId = request.getParameter("updateId");

if(updateId != null && !updateId.isEmpty()) {

    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");

    try {

        PreparedStatement updatePsmt = conn.prepareStatement(
            "UPDATE gym_member SET name = ?, email = ?, phone = ? WHERE id = ?"
        );

        updatePsmt.setString(1, name);
        updatePsmt.setString(2, email);
        updatePsmt.setString(3, phone);
        updatePsmt.setInt(4, Integer.parseInt(updateId));

        int result = updatePsmt.executeUpdate();

        if(result > 0) {
%>

            <script>
                alert("Member updated successfully!");
            </script>

<%
        } else {
%>

            <script>
                alert("Member ID not found!");
            </script>

<%
        }

        updatePsmt.close();

    } catch(Exception e) {
        e.printStackTrace();
%>

        <script>
            alert("Error while updating member!");
        </script>

<%
    }
}


/* =========================
   DISPLAY MEMBERS
   ========================= */

PreparedStatement psmt = conn.prepareStatement(
    "SELECT * FROM gym_member"
);

ResultSet rs = psmt.executeQuery();

%>


<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>Gym Members</title>

<style>

body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f4;
    margin: 0;
    padding: 30px;
}

.container {
    width: 90%;
    margin: auto;
}

h1 {
    text-align: center;
}

table {
    width: 100%;
    border-collapse: collapse;
    background-color: white;
    margin-bottom: 40px;
}

th, td {
    border: 1px solid #ccc;
    padding: 12px;
    text-align: center;
}

th {
    background-color: #222;
    color: white;
}


/* =========================
   FORM BLOCKS
   ========================= */

.form-container {
    display: flex;
    gap: 30px;
    margin-top: 30px;
}

.form-box {
    width: 50%;
    background-color: white;
    padding: 25px;
    border-radius: 8px;
    box-shadow: 0 2px 8px #ccc;
}

.form-box h2 {
    margin-top: 0;
}

.form-box label {
    display: block;
    margin-top: 12px;
    margin-bottom: 5px;
    font-weight: bold;
}

.form-box input {
    width: 95%;
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 5px;
}

.update-btn {
    margin-top: 20px;
    padding: 10px 20px;
    background-color: green;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

.delete-btn {
    margin-top: 20px;
    padding: 10px 20px;
    background-color: red;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

</style>

</head>


<body>

<div class="container">

<h1>Gym Members</h1>


<!-- =========================
     MEMBER LIST
     ========================= -->

<table>

<tr>

<%
    /*
     * Automatically display column names
     * from the database.
     */
%>

<%
    java.sql.ResultSetMetaData metaData = rs.getMetaData();

    int columnCount = metaData.getColumnCount();

    for(int i = 1; i <= columnCount; i++) {
%>

        <th>
            <%= metaData.getColumnName(i) %>
        </th>

<%
    }
%>

</tr>


<%

while(rs.next()) {

%>

<tr>

<%

    for(int i = 1; i <= columnCount; i++) {

%>

        <td>
            <%= rs.getString(i) %>
        </td>

<%
    }

%>

</tr>

<%
}
%>

</table>


<!-- =========================
     UPDATE AND DELETE BLOCKS
     ========================= -->

<div class="form-container">


<!-- =========================
     UPDATE MEMBER
     ========================= -->

<div class="form-box">

<h2>Update Member</h2>

<form method="post">

<label>Member ID</label>

<input type="number"
       name="updateId"
       placeholder="Enter Member ID"
       required>


<label>Member Name</label>

<input type="text"
       name="name"
       placeholder="Enter Member Name"
       required>


<label>Email</label>

<input type="email"
       name="email"
       placeholder="Enter Email"
       required>


<label>Phone</label>

<input type="text"
       name="phone"
       placeholder="Enter Phone Number"
       required>


<button type="submit" class="update-btn">

Update Member

</button>

</form>

</div>


<!-- =========================
     DELETE MEMBER
     ========================= -->

<div class="form-box">

<h2>Delete Member</h2>

<form method="post">

<label>Member ID</label>

<input type="number"
       name="deleteId"
       placeholder="Enter Member ID"
       required>

<br>

<button type="submit"
        class="delete-btn"
        onclick="return confirm('Are you sure you want to delete this member?');">

Delete Member

</button>

</form>

</div>

</div>

</div>

</body>

</html>

<%

rs.close();
psmt.close();

%>
```
