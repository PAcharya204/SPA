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

int totalTeachers=0;
int totalStudents=0;

int mcaTeachers=0;
int mscTeachers=0;
int maTeachers=0;
int mtechTeachers=0;

int mcaStudents=0;
int mscStudents=0;
int maStudents=0;
int mtechStudents=0;

try
{
    PreparedStatement ps;
    ResultSet rs;

    ps=con.prepareStatement("select count(*) from teacher");
    rs=ps.executeQuery();
    if(rs.next())
    {
        totalTeachers=rs.getInt(1);
    }
    rs.close();
    ps.close();

    ps=con.prepareStatement("select count(*) from teacher where dept='MCA'");
    rs=ps.executeQuery();
    if(rs.next())
    {
        mcaTeachers=rs.getInt(1);
    }
    rs.close();
    ps.close();

    ps=con.prepareStatement("select count(*) from teacher where dept='MSC'");
    rs=ps.executeQuery();
    if(rs.next())
    {
        mscTeachers=rs.getInt(1);
    }
    rs.close();
    ps.close();

    ps=con.prepareStatement("select count(*) from teacher where dept='MA'");
    rs=ps.executeQuery();
    if(rs.next())
    {
        maTeachers=rs.getInt(1);
    }
    rs.close();
    ps.close();

    ps=con.prepareStatement("select count(*) from teacher where dept='MTECH'");
    rs=ps.executeQuery();
    if(rs.next())
    {
        mtechTeachers=rs.getInt(1);
    }
    rs.close();
    ps.close();

    ps=con.prepareStatement("select count(*) from student");
    rs=ps.executeQuery();

    if(rs.next())
    {
        totalStudents=rs.getInt(1);
    }

    rs.close();
    ps.close();


    ps=con.prepareStatement(
    "select count(*) from student where dept='MCA'");

    rs=ps.executeQuery();

    if(rs.next())
    {
        mcaStudents=rs.getInt(1);
    }

    rs.close();
    ps.close();


    ps=con.prepareStatement(
    "select count(*) from student where dept='MSC'");

    rs=ps.executeQuery();

    if(rs.next())
    {
        mscStudents=rs.getInt(1);
    }

    rs.close();
    ps.close();


    ps=con.prepareStatement(
    "select count(*) from student where dept='MA'");

    rs=ps.executeQuery();

    if(rs.next())
    {
        maStudents=rs.getInt(1);
    }

    rs.close();
    ps.close();


    ps=con.prepareStatement(
    "select count(*) from student where dept='MTECH'");

    rs=ps.executeQuery();

    if(rs.next())
    {
        mtechStudents=rs.getInt(1);
    }

    rs.close();
    ps.close();
}
catch(Exception e)
{
    out.println(e.getMessage());
}

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

    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="../common.css">

    <link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
    <style>
    /*======================================================
                    ADMIN DASHBOARD ONLY
    ======================================================*/

    /* Welcome Section */

    #welcome{
        margin-bottom:30px;
    }

    /* Dashboard Cards */

    .dashboard-grid{
        display:grid;
        grid-template-columns:repeat(auto-fit,minmax(230px,1fr));
        gap:25px;
    }

    /* Card Top Colors */

    .teachers::before{
        background:#1b63b5;
    }

    .students::before{
        background:#3ca374;
    }

    .mca::before{
        background:#4d88c6;
    }

    .msc::before{
        background:#7a8fe8;
    }

    .ma::before{
        background:#18a085;
    }

    .mtech::before{
        background:#24599a;
    }

    /* Responsive */

    @media(max-width:768px){

        .dashboard-grid{
            grid-template-columns:1fr;
        }

    }
    </style>
</head>

<body>

    <header>
        <div class="logo-section">
            <img src="../images/logo.png" id="logo">
            <h1>ADMIN DASHBOARD</h1>
        </div>

        <div id="profile-section">
            <img src="<%=photo%>" id="profile-pic">
            <a href="ad_profile.jsp"><%=name%></a>
        </div>

    </header>
    <hr>
    <div id="sidebar">

        <div><a href="ad_dashboard.jsp"><i class="fa-solid fa-house"></i>&nbsp;&nbsp;DASHBOARD</a></div>

        <div><a href="add_teacher.jsp"><i class="fa-solid fa-user-plus"></i>&nbsp;&nbsp;ADD TEACHER</a></div>

        <div><a href="view_teacher.jsp"><i class="fa-solid fa-users"></i>&nbsp;&nbsp;VIEW TEACHERS</a></div>

        <div><a href="add_student.jsp"><i class="fa-solid fa-graduation-cap"></i>&nbsp;&nbsp;ADD STUDENT</a></div>

        <div><a href="view_student.jsp"><i class="fa-solid fa-user-graduate"></i>&nbsp;&nbsp;VIEW STUDENTS</a></div>

    </div>

    <div id="main">

        <div id="welcome">
            <h2>Welcome, <%=name%></h2>
            <p>Administrator Dashboard Overview</p>
        </div>
        <div class="dashboard-grid">

            <div class="card teachers">
                <h3>Total Teachers</h3>
                <h1><%=totalTeachers%></h1>
            </div>

            <div class="card mca">
                <h3>MCA Teachers</h3>
                <h1><%=mcaTeachers%></h1>
            </div>

            <div class="card msc">
                <h3>MSC Teachers</h3>
                <h1><%=mscTeachers%></h1>
            </div>

            <div class="card ma">
                <h3>MA Teachers</h3>
                <h1><%=maTeachers%></h1>
            </div>

            <div class="card mtech">
                <h3>MTECH Teachers</h3>
                <h1><%=mtechTeachers%></h1>
            </div>

            <div class="card students">
                <h3>Total Students</h3>
                <h1><%=totalStudents%></h1>
            </div>

            <div class="card mca">
                <h3>MCA Students</h3>
                <h1><%=mcaStudents%></h1>
            </div>

            <div class="card msc">
                <h3>MSC Students</h3>
                <h1><%=mscStudents%></h1>
            </div>

            <div class="card ma">
                <h3>MA Students</h3>
                <h1><%=maStudents%></h1>
            </div>

            <div class="card mtech">
                <h3>MTECH Students</h3>
                <h1><%=mtechStudents%></h1>
            </div>

        </div>
    </div>

</body>
</html>