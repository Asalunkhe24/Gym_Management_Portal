```jsp
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
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
String[] plans = {"Basic", "Platinum", "Premium"};
String[] durations = {"Monthly", "Quarterly", "Half Yearly", "Yearly"};
%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>Gym Fees Structure</title>

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
    margin-bottom: 30px;
}

table {
    width: 100%;
    border-collapse: collapse;
    background-color: white;
}

th, td {
    border: 1px solid #ddd;
    padding: 15px;
    text-align: center;
}

th {
    background-color: #222;
    color: white;
}

td:first-child {
    font-weight: bold;
}

.plan-title {
    font-size: 18px;
}

.price {
    font-size: 18px;
    font-weight: bold;
}

.facilities-section {
    margin-top: 40px;
}

.facility-table {
    margin-top: 15px;
}

.facility-list {
    text-align: left;
    padding-left: 25px;
}

.facility-list li {
    margin-bottom: 8px;
}

.no-facility {
    color: #888;
}

</style>

</head>

<body>

<div class="container">

<h1>Gym Fees Structure</h1>

<table>

<thead>

<tr>

    <th>Duration</th>

    <%
    for(String plan : plans) {
    %>

        <th class="plan-title">
            <%= plan %>
        </th>

    <%
    }
    %>

</tr>

</thead>

<tbody>

<%
for(String duration : durations) {
%>

<tr>

    <td>
        <%= duration %>
    </td>

    <%
    for(String plan : plans) {

        String price = "N/A";

        PreparedStatement psmt = null;
        ResultSet rs = null;

        try {

            psmt = conn.prepareStatement(
                "SELECT price FROM fee_structure " +
                "WHERE plan_name = ? AND duration = ?"
            );

            psmt.setString(1, plan);
            psmt.setString(2, duration);

            rs = psmt.executeQuery();

            if(rs.next()) {
                price = rs.getString("price");
            }

        } catch(Exception e) {
            e.printStackTrace();
        } finally {

            try {
                if(rs != null) rs.close();
                if(psmt != null) psmt.close();
            } catch(Exception e) {
                e.printStackTrace();
            }

        }
    %>

        <td class="price">
            ₹ <%= price %>
        </td>

    <%
    }
    %>

</tr>

<%
}
%>

</tbody>

</table>


<!-- FACILITIES SECTION -->

<div class="facilities-section">

<h1>Plan Facilities</h1>

<table class="facility-table">

<thead>

<tr>

    <th>Basic</th>
    <th>Platinum</th>
    <th>Premium</th>

</tr>

</thead>

<tbody>

<tr>

<%
for(String plan : plans) {
%>

<td>

<ul class="facility-list">

<%

PreparedStatement facilityPsmt = null;
ResultSet facilityRs = null;

try {

    facilityPsmt = conn.prepareStatement(
        "SELECT facility_name FROM plan_facilities " +
        "WHERE plan_name = ?"
    );

    facilityPsmt.setString(1, plan);

    facilityRs = facilityPsmt.executeQuery();

    boolean hasFacility = false;

    while(facilityRs.next()) {

        hasFacility = true;

%>

        <li>
            <%= facilityRs.getString("facility_name") %>
        </li>

<%
    }

    if(!hasFacility) {
%>

        <li class="no-facility">
            No facilities available
        </li>

<%
    }

} catch(Exception e) {

    e.printStackTrace();

%>

    <li class="no-facility">
        Unable to load facilities
    </li>

<%

} finally {

    try {
        if(facilityRs != null) facilityRs.close();
        if(facilityPsmt != null) facilityPsmt.close();
    } catch(Exception e) {
        e.printStackTrace();
    }

}

%>

</ul>

</td>

<%
}
%>

</tr>

</tbody>

</table>

</div>

</div>

</body>

</html>
```
