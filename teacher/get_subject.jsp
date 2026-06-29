<%@ include file="db.jsp" %>
<%@ page import="java.sql.*" %>

<%
String dept = request.getParameter("dept");
String semester = request.getParameter("semester");

out.println("<option value=''>Select Subject</option>");

if(dept != null && semester != null &&
   !dept.trim().equals("") &&
   !semester.trim().equals(""))
{
    try
    {
        PreparedStatement ps = con.prepareStatement(
            "SELECT subid, subject_name FROM subject WHERE department=? AND semester=? ORDER BY subject_name"
        );

        ps.setString(1, dept);
        ps.setInt(2, Integer.parseInt(semester));

        ResultSet rs = ps.executeQuery();

        while(rs.next())
        {
%>

<option value="<%=rs.getInt("subid")%>">
    <%=rs.getString("subject_name")%>
</option>

<%
        }

        rs.close();
        ps.close();
    }
    catch(Exception e)
    {
        out.println("<option>Error : " + e.getMessage() + "</option>");
    }
}
%>