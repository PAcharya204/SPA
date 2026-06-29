<%@ page import="java.sql.*" %>

<%
Connection con=null;

try
{
    Class.forName("com.mysql.cj.jdbc.Driver");

    con=DriverManager.getConnection("jdbc:mysql://localhost:3306/saps","root","");
}
catch(Exception e)
{
    out.println(e);
}
%>