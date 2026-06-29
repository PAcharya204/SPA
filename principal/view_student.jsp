<%@ include file="db.jsp" %>
<%@ page import="java.sql.*" %>

<%
String p_username=(String)session.getAttribute("p_username");

if(p_username==null)
{
    response.sendRedirect("p_login.jsp");
}

/*------------------------Principal Name------------------------*/
String name="";
try
{
    PreparedStatement ps;
    ResultSet rs;

    ps=con.prepareStatement("select p_name from principal where p_username=?");
    ps.setString(1,p_username);
    rs=ps.executeQuery();
    if(rs.next())
    {
        name=rs.getString("p_name");
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
String photo="../images/princi_pic.jpg";

PreparedStatement ps1=con.prepareStatement("select p_profile from principal where p_username=?");

ps1.setString(1,p_username);

ResultSet rs1=ps1.executeQuery();

if(rs1.next())
{
    String dbPhoto=rs1.getString("p_profile");

    if(dbPhoto!=null && !dbPhoto.trim().equals(""))
    {
        photo="../" +dbPhoto;
    }
}

rs1.close();
ps1.close();
/* ---------------------------------------- */
%>
<%
int totalStudents = 0;

int mcaStudents = 0;
int mscStudents = 0;
int maStudents = 0;
int mtechStudents = 0;

try
{
    PreparedStatement ps = con.prepareStatement(
        "SELECT COUNT(*) FROM student"
    );

    ResultSet rs = ps.executeQuery();

    if(rs.next())
    {
        totalStudents = rs.getInt(1);
    }

    rs.close();
    ps.close();

    ps = con.prepareStatement(
        "SELECT dept, COUNT(*) total FROM student GROUP BY dept"
    );

    rs = ps.executeQuery();

    while(rs.next())
    {
        String dept = rs.getString("dept");
        int count = rs.getInt("total");

        if(dept.equalsIgnoreCase("MCA"))
            mcaStudents = count;

        else if(dept.equalsIgnoreCase("MSC"))
            mscStudents = count;

        else if(dept.equalsIgnoreCase("MA"))
            maStudents = count;

        else if(dept.equalsIgnoreCase("MTECH"))
            mtechStudents = count;
    }

    rs.close();
    ps.close();
}
catch(Exception e)
{
    out.println(e.getMessage());
}
%>
<!DOCTYPE html>
<html>
<head>
    <title>View Student</title>

    <link rel="stylesheet" href="../common.css">
<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
    <style>

        

        /*==========================
                ANALYTICS BUTTON
        ==========================*/

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

    
</head>

<body>

    <!-- ================= HEADER ================= -->

    <header>

        <div class="logo-section">
            <img src="../images/logo.png" id="logo">
            <h1>STUDENT DETAILS</h1>
        </div>

        <div id="profile-section">
            <img src="<%=photo%>" id="profile-pic">
            <a href="princi_profile.jsp"><%=name%></a>
        </div>

    </header>

    <!-- ================= SIDEBAR ================= -->

    <div id="sidebar">

        <div><a href="princi_dashboard.jsp"><i class="fa-solid fa-house"></i>&nbsp;&nbsp;DASHBOARD</a></div>
        <div><a href="view_student.jsp"><i class="fa-solid fa-user-plus"></i>&nbsp;&nbsp;STUDENT DETAILS</a></div>
        <div><a href="tea_ana.jsp"><i class="fa-solid fa-users"></i>&nbsp;&nbsp;TEACHER DETAILS</a></div>
        <div><a href="dept_ana.jsp"><i class="fa-solid fa-graduation-cap"></i>&nbsp;&nbsp;DEPARTMENT DETAILS</a></div>

    </div>

    <!-- ================= MAIN ================= -->

    <div id="main">

        

            <div class="page-header">
                <h2>Student Management</h2>
                <p>View and manage all registered students.</p>
            </div>

            <div class="cards">

            <div class="card">
                <h3>Total Students</h3>
                <h1><%=totalStudents%></h1>
                <p>Registered Students</p>
            </div>

            <div class="card">
                <h3>MCA</h3>
                <h1><%=mcaStudents%></h1>
                <p>MCA Students</p>
            </div>

            <div class="card">
                <h3>MSC</h3>
                <h1><%=mscStudents%></h1>
                <p>MSC Students</p>
            </div>

            <div class="card">
                <h3>MA</h3>
                <h1><%=maStudents%></h1>
                <p>MA Students</p>
            </div>

            <div class="card">
                <h3>MTECH</h3>
                <h1><%=mtechStudents%></h1>
                <p>MTECH Students</p>
            </div>

        </div>

            <div class="table-container">

                <div class="search-box">
                    <input type="text" id="searchTeacher" placeholder="Search by name, department or username...">
                    <select id="deptFilter">
                        <option value="">All Departments</option>
                        <option value="MCA">MCA</option>
                        <option value="MSC">MSC</option>
                        <option value="MA">MA</option>
                        <option value="MTECH">MTECH</option>
                    </select>
                </div>

            <table class="analytics-table" id="teacherTable">

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
                                 class="table-photo"
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
                            <a href="stu_ana.jsp?sid=<%=rs.getString("sid")%>"
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