<%@ include file="db.jsp" %>
<%@ page import="java.sql.*" %>

<%
String t_username = (String)session.getAttribute("t_username");

if(t_username == null)
{
    response.sendRedirect("teach_login.jsp");
    return;
}

String subid = request.getParameter("subid");
String totalClasses = request.getParameter("total_classes");

String sid[] = request.getParameterValues("sid");
String attended[] = request.getParameterValues("attended");
String remarks[] = request.getParameterValues("remarks");

try
{
    if(sid != null)
    {
        for(int i=0; i<sid.length; i++)
        {
            int studentId = Integer.parseInt(sid[i]);
            int subjectId = Integer.parseInt(subid);

            int total = Integer.parseInt(totalClasses);
            int attendedClasses = Integer.parseInt(attended[i]);

            double percent = 0;

            if(total > 0)
            {
                percent = (attendedClasses * 100.0) / total;
            }

            PreparedStatement check = con.prepareStatement(

                "SELECT attendance_id " +
                "FROM attendance " +
                "WHERE sid=? " +
                "AND subid=?"

            );

            check.setInt(1, studentId);
            check.setInt(2, subjectId);

            ResultSet rs = check.executeQuery();

            if(rs.next())
            {
                PreparedStatement update = con.prepareStatement(

                    "UPDATE attendance SET " +
                    "total_classes=?," +
                    "attended_classes=?," +
                    "attendance_percent=?," +
                    "remarks=? " +
                    "WHERE sid=? " +
                    "AND subid=?"

                );

                update.setInt(1, total);
                update.setInt(2, attendedClasses);
                update.setDouble(3, percent);
                update.setString(4, remarks[i]);
                update.setInt(5, studentId);
                update.setInt(6, subjectId);

                update.executeUpdate();
                update.close();
            }
            else
            {
                PreparedStatement insert = con.prepareStatement(

                    "INSERT INTO attendance(" +
                    "sid," +
                    "subid," +
                    "total_classes," +
                    "attended_classes," +
                    "attendance_percent," +
                    "remarks" +
                    ") VALUES(?,?,?,?,?,?)"

                );

                insert.setInt(1, studentId);
                insert.setInt(2, subjectId);
                insert.setInt(3, total);
                insert.setInt(4, attendedClasses);
                insert.setDouble(5, percent);
                insert.setString(6, remarks[i]);

                insert.executeUpdate();
                insert.close();
            }

            rs.close();
            check.close();
        }
    }

    %>

    <script>

    alert("Attendance Saved Successfully.");

    window.location="add_attendance.jsp";

    </script>

<%

return;
}
catch(Exception e)
{
    out.println("<h3>Error : " + e.getMessage() + "</h3>");
}
%>