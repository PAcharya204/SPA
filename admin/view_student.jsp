<%@ include file="db.jsp" %>
<%@ page import="java.sql.*" %>

<%
String admin_username=(String)session.getAttribute("admin_username");

if(admin_username==null)
{
    response.sendRedirect("ad_log.jsp");
}


/*------------------------Admin Name------------------------*/
String name="";
try
{
    PreparedStatement ps;
    ResultSet rs;

    ps=con.prepareStatement("select name from admin where username=?");
    ps.setString(1,admin_username);
    rs=ps.executeQuery();
    if(rs.next())
    {
        name=rs.getString("name");
    }
    rs.close();
    ps.close();
}
catch(Exception e)
{
    out.println(e.getMessage());
}

/*----------------------------------------------------------------*/

/* ----------------Profile image----------------------- */
String photo="../images/default_ad.jpg";

PreparedStatement ps1=con.prepareStatement("select profile from admin where username=?");

ps1.setString(1,admin_username);

ResultSet rs1=ps1.executeQuery();

if(rs1.next())
{
    String dbPhoto=rs1.getString("profile");

    if(dbPhoto!=null && !dbPhoto.trim().equals(""))
    {
        photo="../" +dbPhoto;
    }
}

rs1.close();
ps1.close();
/* ---------------------------------------- */

%>

<!DOCTYPE html>
<html>
<head>
    <title>View Student</title>
    <link rel="stylesheet" href="../common.css">
<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
    <style>
        
.table-photo{
    width:50px;
    height:50px;
    border-radius:50%;
    object-fit:cover;
    border:2px solid #2E6FB2;
}
    </style>
    

</head>
<body>
    <header>

        <div class="logo-section">
            <img src="../images/logo.png" id="logo">
            <h1>VIEW STUDENT</h1>
        </div>

        <div id="profile-section">
            <img src="<%=photo%>" id="profile-pic">
            <a href="ad_profile.jsp"><%=name%></a>
        </div>

    </header>
    <div id="sidebar">

        <div><a href="ad_dashboard.jsp"><i class="fa-solid fa-house"></i>&nbsp;&nbsp;DASHBOARD</a></div>

        <div><a href="add_teacher.jsp"><i class="fa-solid fa-user-plus"></i>&nbsp;&nbsp;ADD TEACHER</a></div>

        <div><a href="view_teacher.jsp"><i class="fa-solid fa-users"></i>&nbsp;&nbsp;VIEW TEACHERS</a></div>

        <div><a href="add_student.jsp"><i class="fa-solid fa-graduation-cap"></i>&nbsp;&nbsp;ADD STUDENT</a></div>

        <div><a href="view_student.jsp"><i class="fa-solid fa-user-graduate"></i>&nbsp;&nbsp;VIEW STUDENTS</a></div>

    </div>

    <div id="main">
        <div class="table-container">
            <div class="page-header">
                <h2>Student Management</h2>
                <p>View, edit and manage all registered students.</p>
            </div>
            <div class="search-box">

                <input type="text" id="search" placeholder="Search by Roll No, Name, Department, Semester or Username...">

            </div>
            <table class="analytics-table">

                <tr>
                    <th>Photo</th>
                    <th>ID</th>
                    <th>Roll No</th>
                    <th>Name</th>
                    <th>Username</th>
                    <th>Department</th>
                    <th>Semester</th>
                    <th>Section</th>
                    <th>DOB</th>
                    <th>Phone</th>
                    <th>Gender</th>
                    <th>Address</th>
                    <th>Edit</th>
                    <th>Delete</th>
                </tr>
                <%
                try
                {
                    PreparedStatement ps=
                    con.prepareStatement("select * from student");

                    ResultSet rs=
                    ps.executeQuery();
                    boolean found=false;
                    while(rs.next())
                    {
                        found=true;
                %>
                <tr>
                    <td> <img src="../<%=rs.getString("s_profile")%>" class="table-photo"></td>
                    <td><%=rs.getInt("sid")%></td>
                    <td><%=rs.getString("roll_no")%></td>
                    <td><%=rs.getString("s_name")%></td>
                    <td><%=rs.getString("s_username")%></td>
                    <td><%=rs.getString("dept")%></td>
                    <td><%=rs.getInt("semester")%></td>
                    <td><%=rs.getString("section")%></td>
                    <td><%=rs.getString("s_dob")%></td>
                    <td><%=rs.getString("s_phone")%></td>
                    <td><%=rs.getString("s_gender")%></td>
                    <td><%=rs.getString("s_addr")%></td>
                    <td><a class="edit-btn"href="s_edit.jsp?id=<%=rs.getInt("sid")%>">EDIT</a></td>
                    <td><a class="delete-btn" href="s_delete.jsp?id=<%=rs.getInt("sid")%>" onclick="return confirm('Are you sure you want to delete this student?')">DELETE</a></td>
                </tr>
                <%
                    }
                    if(!found)
                    {
                        %>
                        <tr>
                            <td colspan="14" class="no-data">No Students Found</td>
                        </tr>
                        <%
                    }

                    rs.close();
                    ps.close();
                    con.close();
                }
                catch(Exception e)
                {
                    out.println(e.getMessage());
                }
                %>
            </table>
        </div>
    </div>
    <script>
        document.getElementById("search").onkeyup=function(){

        let value=this.value.toLowerCase();

        let rows=document.querySelectorAll("table tbody tr");

        rows.forEach(function(row){

        row.style.display=row.innerText.toLowerCase().includes(value)
        ?"":"none";

        });

        }
    </script>
    </body>
</html>