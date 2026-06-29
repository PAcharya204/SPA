<%@ include file="db.jsp" %>
<%@ page import="java.sql.*" %>

<%
String t_username = (String)session.getAttribute("t_username");

if(t_username == null)
{
    response.sendRedirect("teach_login.jsp");
    return;
}

String name = "";
try
{
    PreparedStatement ps;
    ResultSet rs;

    ps = con.prepareStatement("select t_name from teacher where t_username=?");
    ps.setString(1, t_username);
    rs = ps.executeQuery();

    if(rs.next())
    {
        name = rs.getString("t_name");
    }

    rs.close();
    ps.close();
}
catch(Exception e)
{
    out.println(e.getMessage());
}

String photo = "../images/princi_pic.jpg";

PreparedStatement ps1 = con.prepareStatement(
    "select t_profile from teacher where t_username=?"
);
ps1.setString(1, t_username);
ResultSet rs1 = ps1.executeQuery();

if(rs1.next())
{
    String dbPhoto = rs1.getString("t_profile");

    if(dbPhoto != null && !dbPhoto.trim().equals(""))
    {
        photo = "../" + dbPhoto;
    }
}

rs1.close();
ps1.close();
%>

<!DOCTYPE html>
<html>
<head>
    <title>View Student</title>

    <style>
 .analytics-btn{
            display:inline-flex;
            align-items:center;
            justify-content:center;
            gap:8px;
            padding:10px 18px;
            background:linear-gradient(135deg,#184C85,#2E6FB2);
            color:#fff;
            text-decoration:none;
            border-radius:10px;
            font-size:14px;
            font-weight:600;
            transition:.3s;
            white-space:nowrap;
        }

        .analytics-btn:hover{
            background:linear-gradient(135deg,#2E6FB2,#184C85);
            transform:translateY(-2px);
            box-shadow:0 8px 18px rgba(24,76,133,.25);
            color:#fff;
        }

        .analytics-btn i{
            font-size:14px;
        }

    </style>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
        <link rel="stylesheet" href="../common.css">
</head>

<body>

    <!-- ================= HEADER ================= -->

    <header>

        <div class="logo-section">
            <img src="../images/logo.png" id="logo">
            <h1>VIEW STUDENT</h1>
        </div>

        <div id="profile-section">
            <img src="<%=photo%>" id="profile-pic">
            <a href="teach_profile.jsp"><%=name%></a>
        </div>

    </header>

    <!-- ================= SIDEBAR ================= -->

    <div id="sidebar">

        <div>
            <a href="teach_dashboard.jsp">
                <i class="fa-solid fa-house"></i> DASHBOARD
            </a>
        </div>

        <div>
            <a href="add_marks.jsp">
                <i class="fa-solid fa-user-plus"></i> ADD MARKS
            </a>
        </div>

        <div>
            <a href="add_attendance.jsp">
                <i class="fa-solid fa-users"></i> ADD ATTENDANCE
            </a>
        </div>

        <div>
            <a href="dept_ana.jsp">
                <i class="fa-solid fa-graduation-cap"></i> DEPARTMENT ANALYTICS
            </a>
        </div>

        <div>
            <a href="view_student.jsp">
                <i class="fa-solid fa-graduation-cap"></i> VIEW STUDENT
            </a>
        </div>

    </div>

    <!-- ================= MAIN ================= -->

    <div id="main">

        <div class="table-container">

            <div class="page-header">
                <h2>Student Management</h2>
                <p>View and manage all registered students.</p>
            </div>

            <div class="search-box">
                <input type="text"
                       id="search"
                       placeholder="Search by name, department or roll no...">
            </div>

            <table>

                <thead>
                    <tr>
                        <th>Photo</th>
                        <th>ID</th>
                        <th>Roll No</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Department</th>
                        <th>Semester</th>
                        <th>Section</th>
                        <th>DOB</th>
                        <th>Phone</th>
                        <th>Gender</th>
                        <th>Address</th>
                        <th>Analytics</th>
                    </tr>
                </thead>

                <tbody>

                <%
                try
                {
                    PreparedStatement ps = con.prepareStatement(
                        "select * from student order by roll_no"
                    );
                    ResultSet rs = ps.executeQuery();
                    boolean found = false;

                    while(rs.next())
                    {
                        found = true;
                %>

                    <tr>

                        <td>
                            <img src="../<%=rs.getString("s_profile")%>"
                                 class="student-photo"
                                 alt="Photo">
                        </td>

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

                        <td>
                            <a href="stu_indivisual_ana.jsp?sid=<%=rs.getString("sid")%>"
                               class="analytics-btn">
                                <i class="fa-solid fa-chart-column"></i> Analytics
                            </a>
                        </td>

                    </tr>

                <%
                    }

                    if(!found)
                    {
                %>
                    <tr>
                        <td colspan="13" class="no-data">
                            <i class="fa-solid fa-circle-info"></i>
                            No students found.
                        </td>
                    </tr>
                <%
                    }

                    rs.close();
                    ps.close();
                }
                catch(Exception e)
                {
                    out.println(e.getMessage());
                }
                %>

                </tbody>

            </table>

        </div>

    </div>

    <!-- ================= SEARCH SCRIPT ================= -->

    <script>

        document.getElementById("search").addEventListener("keyup", function()
        {
            let value = this.value.toLowerCase();

            let rows = document.querySelectorAll("tbody tr");

            rows.forEach(function(row)
            {
                let text = row.innerText.toLowerCase();

                row.style.display = text.includes(value) ? "" : "none";
            });
        });

    </script>

</body>
</html>