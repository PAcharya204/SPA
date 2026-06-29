<%@ include file="db.jsp" %>
<%@ page import="java.sql.*" %>

<%
String p_username = (String)session.getAttribute("p_username");

if(p_username == null)
{
    response.sendRedirect("princi_login.jsp");
    return;
}

/*==================================================
            PRINCIPAL DETAILS
==================================================*/

String pname = "";
String photo = "../images/principal.png";

try
{
    PreparedStatement ps = con.prepareStatement(
        "SELECT * FROM principal WHERE p_username=?"
    );

    ps.setString(1, p_username);

    ResultSet rs = ps.executeQuery();

    if(rs.next())
    {
        pname = rs.getString("p_name");

        String dbPhoto = rs.getString("p_profile");

        if(dbPhoto != null && !dbPhoto.trim().equals(""))
        {
            photo = "../" + dbPhoto;
        }
    }

    rs.close();
    ps.close();
}
catch(Exception e)
{
    out.println(e.getMessage());
}

/*==================================================
            TEACHER COUNTS
==================================================*/

int totalTeachers = 0;

int mcaTeachers = 0;
int mscTeachers = 0;
int maTeachers = 0;
int mtechTeachers = 0;

try
{
    PreparedStatement ps = con.prepareStatement(
        "SELECT COUNT(*) FROM teacher"
    );

    ResultSet rs = ps.executeQuery();

    if(rs.next())
    {
        totalTeachers = rs.getInt(1);
    }

    rs.close();
    ps.close();


    ps = con.prepareStatement(
        "SELECT dept, COUNT(*) total FROM teacher GROUP BY dept"
    );

    rs = ps.executeQuery();

    while(rs.next())
    {
        String dept = rs.getString("dept");
        int count = rs.getInt("total");

        if(dept.equalsIgnoreCase("MCA"))
        {
            mcaTeachers = count;
        }
        else if(dept.equalsIgnoreCase("MSC"))
        {
            mscTeachers = count;
        }
        else if(dept.equalsIgnoreCase("MA"))
        {
            maTeachers = count;
        }
        else if(dept.equalsIgnoreCase("MTECH"))
        {
            mtechTeachers = count;
        }
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

    <title>Teacher Details</title>

    <link rel="stylesheet" href="../common.css">
    <link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
    <style>

    </style>

</head>

<body>

    <header>

        <div class="logo-section">
            <img src="../images/logo.png" id="logo">
            <h1>TEACHER DETAILS</h1>
        </div>

        <div id="profile-section">
            <img src="<%=photo%>" id="profile-pic">
            <a href="princi_profile.jsp"><%=pname%></a>
        </div>

    </header>


    <div id="sidebar">

        <div><a href="princi_dashboard.jsp"><i class="fa-solid fa-house"></i>&nbsp;&nbsp;DASHBOARD</a></div>
        <div><a href="view_student.jsp"><i class="fa-solid fa-user-plus"></i>&nbsp;&nbsp;STUDENT DETAILS</a></div>
        <div><a href="tea_ana.jsp"><i class="fa-solid fa-users"></i>&nbsp;&nbsp;TEACHER DETAILS</a></div>
        <div><a href="dept_ana.jsp"><i class="fa-solid fa-graduation-cap"></i>&nbsp;&nbsp;DEPARTMENT DETAILS</a></div>

    </div>

    <div id="main">

        
            <div class="page-header">

                <h2>Teacher Details</h2>

                <p>View faculty information department-wise.</p>

            </div>


            <!-- SUMMARY CARDS -->

            <div class="cards">

                <div class="card">
                    <h3>Total Teachers</h3>
                    <h1><%=totalTeachers%></h1>
                    <p>Registered Faculty</p>
                </div>

                <div class="card">
                    <h3>MCA</h3>
                    <h1><%=mcaTeachers%></h1>
                    <p>MCA Teachers</p>
                </div>

                <div class="card">
                    <h3>MSC</h3>
                    <h1><%=mscTeachers%></h1>
                    <p>MSC Teachers</p>
                </div>

                <div class="card">
                    <h3>MA</h3>
                    <h1><%=maTeachers%></h1>
                    <p>MA Teachers</p>
                </div>

                <div class="card">
                    <h3>MTECH</h3>
                    <h1><%=mtechTeachers%></h1>
                    <p>MTECH Teachers</p>
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
                            <th>Teacher ID</th>
                            <th>Teacher Name</th>
                            <th>Department</th>
                            <th>Gender</th>
                            <th>Phone</th>
                            <th>Username</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>

                    <%

                    PreparedStatement ps = con.prepareStatement(

                        "SELECT * FROM teacher ORDER BY dept,t_name"

                    );

                    ResultSet rs = ps.executeQuery();

                    while(rs.next())
                    {

                        String teacherPhoto = "../images/princi_pic.jpg";

                        String dbPhoto = rs.getString("t_profile");

                        if(dbPhoto != null && !dbPhoto.trim().equals(""))
                        {
                            teacherPhoto = "../" + dbPhoto;
                        }

                    %>

                        <tr>
                            <td>
                                <img src="<%=teacherPhoto%>" class="table-photo">
                            </td>
                            <td>T<%=String.format("%03d",rs.getInt("tid"))%></td>
                            <td> <%=rs.getString("t_name")%></td>
                            <td><%=rs.getString("dept")%></td>
                            <td><%=rs.getString("t_gender")%></td>
                            <td><%=rs.getString("t_phone")%></td>
                            <td><%=rs.getString("t_username")%></td>
                            <td><span class="status-active">Active </span></td>
                        </tr>
                        <%

                        }

                        rs.close();
                        ps.close();

                        %>

                    </tbody>
                </table>

            </div>
                <div class="footer">
                <p>Faculty Information Dashboard</p>
            </div>
        </div>
     
    <script>

    const searchTeacher = document.getElementById("searchTeacher");

    const deptFilter = document.getElementById("deptFilter");

    const table = document.getElementById("teacherTable");

    const rows = document.querySelectorAll("#teacherTable tbody tr");


    function filterTeachers()
    {

        let search = searchTeacher.value.toLowerCase();

        let dept = deptFilter.value.toLowerCase();


        for(let i=1;i<rows.length;i++)
        {

            let cells = rows[i].getElementsByTagName("td");

            if(cells.length==0)
            {
                continue;
            }

            let teacherName = cells[2].innerText.toLowerCase();

            let teacherDept = cells[3].innerText.toLowerCase();

            let teacherPhone = cells[5].innerText.toLowerCase();

            let teacherUsername = cells[6].innerText.toLowerCase();


            let searchMatch =

                teacherName.includes(search) ||

                teacherDept.includes(search) ||

                teacherPhone.includes(search) ||

                teacherUsername.includes(search);


            let deptMatch =

                dept=="" ||

                teacherDept==dept;


            if(searchMatch && deptMatch)
            {
                rows[i].style.display="";
            }
            else
            {
                rows[i].style.display="none";
            }

        }

    }


    searchTeacher.onkeyup = filterTeachers;

    deptFilter.onchange = filterTeachers;

    </script>

</body>

</html>