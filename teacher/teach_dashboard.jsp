<%@ include file="db.jsp" %>
<%@ page import="java.sql.*" %>

<%
String t_username=(String)session.getAttribute("t_username");

if(t_username==null)
{
    response.sendRedirect("teach_login.jsp");
}

/*------------------------Principal Name------------------------*/
String name="";
try
{
    PreparedStatement ps;
    ResultSet rs;

    ps=con.prepareStatement("select t_name from teacher where t_username=?");
    ps.setString(1,t_username);
    rs=ps.executeQuery();
    if(rs.next())
    {
        name=rs.getString("t_name");
    }
    rs.close();
    ps.close();
}
catch(Exception e)
{
    out.println(e.getMessage());
}

/*----------------------------------------------------------------*/

int totalStudents=0;

int mcaStudents=0;
int mscStudents=0;
int maStudents=0;
int mtechStudents=0;

try
{
    PreparedStatement ps;
    ResultSet rs;

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
String photo="../images/princi_pic.jpg";

PreparedStatement ps1=con.prepareStatement("select t_profile from teacher where t_username=?");

ps1.setString(1,t_username);

ResultSet rs1=ps1.executeQuery();

if(rs1.next())
{
    String dbPhoto=rs1.getString("t_profile");

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

    <title>Teacher Dashboard</title>
       <link rel="stylesheet" href="../common.css">

    <link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
    <style>
    /*======================================================
                    PRINCIPAL DASHBOARD ONLY
    ======================================================*/

    /* Dashboard Cards */

    .dashboard-grid{
        display:grid;
        grid-template-columns:repeat(auto-fit,minmax(230px,1fr));
        gap:25px;
        margin-bottom:35px;
    }

    /* Charts */

    .charts-grid{
        display:grid;
        grid-template-columns:repeat(2,minmax(0,1fr));
        gap:25px;
        margin-top:30px;
    }

    .chart-box canvas{
        width:100% !important;
        height:320px !important;
    }

    /* Card Top Border Colors */

    .teachers::before{
        background:#1B63B5;
    }

    .students::before{
        background:#3CA374;
    }

    .mca::before{
        background:#4D88C6;
    }

    .msc::before{
        background:#7A8FE8;
    }

    .ma::before{
        background:#18A085;
    }

    .mtech::before{
        background:#24599A;
    }

    /* Responsive */

    @media(max-width:992px){

        .charts-grid{
            grid-template-columns:1fr;
        }

    }

    @media(max-width:768px){

        .dashboard-grid{
            grid-template-columns:1fr;
        }

        .chart-box canvas{
            height:260px !important;
        }

    }
    </style>

</head>

<body>

<header>
    <div class="logo-section">
        <img src="../images/logo.png" id="logo">
        <h1>TEACHER DASHBOARD</h1>
    </div>

    <div id="profile-section">
        <img src="<%=photo%>" id="profile-pic">
        <a href="teach_profile.jsp"><%=name%></a>
    </div>

</header>

<div id="sidebar">

    <div><a href="teach_dashboard.jsp"><i class="fa-solid fa-house"></i>&nbsp;&nbsp;DASHBOARD</a></div>

        <div><a href="add_marks.jsp"><i class="fa-solid fa-user-plus"></i>&nbsp;&nbsp;ADD MARKS</a></div>

        <div><a href="add_attendance.jsp"><i class="fa-solid fa-users"></i>&nbsp;&nbsp;ADD ATTENDANCE</a></div>

        <div><a href="dept_ana.jsp"><i class="fa-solid fa-graduation-cap"></i>&nbsp;&nbsp;DEPARTMENT ANALYTICS</a></div>

        <div><a href="view_student.jsp"><i class="fa-solid fa-graduation-cap"></i>&nbsp;&nbsp;VIEW STUDENT</a></div>

</div>

<%
/* ===== TEACHER DEPT INFO ===== */
String teacherDept = "";
int deptStudents = 0;
int subjectCount = 0;
int lowAttendanceCount = 0;

try
{
    PreparedStatement psTD = con.prepareStatement(
        "SELECT dept FROM teacher WHERE t_username=?"
    );
    psTD.setString(1, t_username);
    ResultSet rsTD = psTD.executeQuery();
    if(rsTD.next())
    {
        teacherDept = rsTD.getString("dept");
    }
    rsTD.close();
    psTD.close();

    PreparedStatement psDS = con.prepareStatement(
        "SELECT COUNT(*) FROM student WHERE dept=?"
    );
    psDS.setString(1, teacherDept);
    ResultSet rsDS = psDS.executeQuery();
    if(rsDS.next())
    {
        deptStudents = rsDS.getInt(1);
    }
    rsDS.close();
    psDS.close();

    PreparedStatement psSC = con.prepareStatement(
        "SELECT COUNT(*) FROM subject WHERE department=?"
    );
    psSC.setString(1, teacherDept);
    ResultSet rsSC = psSC.executeQuery();
    if(rsSC.next())
    {
        subjectCount = rsSC.getInt(1);
    }
    rsSC.close();
    psSC.close();

    PreparedStatement psLA = con.prepareStatement(
        "SELECT COUNT(DISTINCT a.sid) " +
        "FROM attendance a " +
        "INNER JOIN student s ON a.sid = s.sid " +
        "WHERE s.dept = ? AND a.attendance_percent < 75"
    );
    psLA.setString(1, teacherDept);
    ResultSet rsLA = psLA.executeQuery();
    if(rsLA.next())
    {
        lowAttendanceCount = rsLA.getInt(1);
    }
    rsLA.close();
    psLA.close();
}
catch(Exception e)
{
    out.println(e.getMessage());
}

/* ===== AVG MARKS PER DEPARTMENT ===== */
java.util.LinkedHashMap<String, Double> deptAvgMap = new java.util.LinkedHashMap<>();
String[] depts = {"MCA", "MSC", "MA", "MTECH"};

try
{
    for(String d : depts)
    {
        PreparedStatement psAvg = con.prepareStatement(
            "SELECT AVG(m.total_marks) " +
            "FROM marks m " +
            "INNER JOIN student s ON m.sid = s.sid " +
            "WHERE s.dept = ?"
        );
        psAvg.setString(1, d);
        ResultSet rsAvg = psAvg.executeQuery();
        double avg = 0;
        if(rsAvg.next())
        {
            avg = rsAvg.getDouble(1);
        }
        deptAvgMap.put(d, avg);
        rsAvg.close();
        psAvg.close();
    }
}
catch(Exception e)
{
    out.println(e.getMessage());
}

/* ===== PENDING MARKS ALERT ===== */
int pendingMarks = 0;
String pendingSubject = "";

try
{
    PreparedStatement psPM = con.prepareStatement(
        "SELECT subject_name FROM subject " +
        "WHERE department = ? " +
        "AND subid NOT IN (SELECT DISTINCT subid FROM marks) " +
        "LIMIT 1"
    );
    psPM.setString(1, teacherDept);
    ResultSet rsPM = psPM.executeQuery();
    if(rsPM.next())
    {
        pendingMarks  = 1;
        pendingSubject = rsPM.getString("subject_name");
    }
    rsPM.close();
    psPM.close();
}
catch(Exception e)
{
    out.println(e.getMessage());
}
%>


<div id="main">

    <!-- ===== WELCOME BANNER ===== -->
    <div id="welcome">
        <h2>Welcome, <%=name%></h2>
        <p>Welcome to the Teacher Dashboard</p>
    </div>

    <!-- ===== STUDENT COUNT CARDS ===== -->
    <div class="dashboard-grid">

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

    <!-- ===== YOUR DEPARTMENT AT A GLANCE ===== -->
    <div class="dashboard-section">

        <h3> Your Department at a Glance</h3>

        <div class="info-grid"> 

            <!-- Department Name -->
            <div class="info-card">
                <div class="icon-box icon-blue">
                    <i class="fa-solid fa-building-columns" style="color:white; font-size:18px;"></i>
                </div>
                <div>
                    <div class="info-label">Your Department</div>
                    <div class="info-value">
                        <%=teacherDept%>
                    </div>
                </div>
            </div>

            <!-- Students in Dept -->
            <div class="info-card">
                <div class="icon-box icon-blue">
                    <i class="fa-solid fa-users" style="color:white; font-size:18px;"></i>
                </div>
                <div>
                    <div class="info-label">Students in Dept</div>
                    <div class="info-value">
                        <%=deptStudents%>
                    </div>
                </div>
            </div>

            <!-- Subjects -->
            <div class="info-card">
                <div class="icon-box icon-blue">
                            
                    <i class="fa-solid fa-book" style="color:white; font-size:18px;"></i>
                </div>
                <div>
                    <div class="info-label">Subjects Assigned</div>
                   <div class="info-value">
                        <%=subjectCount%>
                    </div>
                </div>
            </div>

            <!-- Low Attendance -->
            <div class="info-card danger">
                <div class="icon-box icon-blue">
                           
                    <i class="fa-solid fa-triangle-exclamation" style="color:white; font-size:18px;"></i>
                </div>
                <div>
                    <div class="info-label">Low Attendance</div>
                    <div class="info-value danger">
                        <%=lowAttendanceCount%> students
                    </div>
                </div>
            </div>

        </div>
    </div>


    <!-- ===== ALERTS & NOTICES ===== -->
    <div class="dashboard-section">

        <h3> Alerts &amp; Notices </h3>

        <!-- Red alert — low attendance -->
        <% if(lowAttendanceCount > 0) { %>
        <div class="alert-box alert-red">
            <i class="fa-solid fa-circle-exclamation" style="color:#e74c3c; font-size:20px;"></i>
            <div>
                <div class="alert-title">
                    <%=lowAttendanceCount%> student(s) below 75% attendance
                    in <%=teacherDept%>
                </div>
                <div class="alert-subtitle">
                    Review attendance records and notify if needed.
                </div>
            </div>
        </div>
        <% } %>

        <!-- Amber alert — pending marks -->
        <% if(pendingMarks > 0) { %>
        <div class="alert-box alert-yellow">
            <i class="fa-solid fa-clock" style="color:#f39c12; font-size:20px;"></i>
            <div>
               <div class="alert-title">
                    Marks not entered for: <%=pendingSubject%>
                </div>
                <div class="alert-subtitle">
                    Department: <%=teacherDept%>
                </div>
            </div>
        </div>
        <% } %>

        <!-- Green — all clear -->
        <% if(lowAttendanceCount == 0 && pendingMarks == 0) { %>
        <div class="alert-box alert-green">
            <i class="fa-solid fa-circle-check" style="color:#2ecc71; font-size:20px;"></i>
            <div class="alert-title">
                All clear - no pending alerts.
            </div>
        </div>
        <% } %>

    </div>


    <!-- ===== DEPARTMENT PERFORMANCE BARS ===== -->
    <div class="dashboard-section">

        <h3>Department Performance (Avg Marks)</h3>

        <%
        String[] barColors = {"#184C85", "#2E6FB2", "#3ca374", "#e67e22"};
        int ci = 0;

        for(java.util.Map.Entry<String, Double> entry : deptAvgMap.entrySet())
        {
            double pct   = entry.getValue();
            String color = barColors[ci % barColors.length];
            ci++;
        %>

        <div class="progress-item">

           <div class="progress-header">
                <span><%=entry.getKey()%></span>
                <span><%=String.format("%.1f", pct)%>%</span>
            </div>

           <div class="progress-bg">
                <div class="progress-fill"
                    style="width:<%=Math.min(pct,100)%>%; background:<%=color%>;">
                </div>

            </div>

        </div>

        <% } %>

    </div>

</div>


</body>
</html>