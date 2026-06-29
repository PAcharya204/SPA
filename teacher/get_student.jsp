<%@ include file="db.jsp" %>
<%@ page import="java.sql.*" %>

<%
String dept=request.getParameter("dept");
String semester=request.getParameter("semester");

PreparedStatement ps=con.prepareStatement(
"SELECT sid,roll_no,s_name FROM student WHERE dept=? AND semester=? ORDER BY s_name");

ps.setString(1,dept);
ps.setInt(2,Integer.parseInt(semester));

ResultSet rs=ps.executeQuery();

out.println("<option value=''>Select Student</option>");

while(rs.next())
{
%>

<option value="<%=rs.getInt("sid")%>">
<%=rs.getString("roll_no")%> - <%=rs.getString("s_name")%>
</option>

<%
}

rs.close();
ps.close();
%>