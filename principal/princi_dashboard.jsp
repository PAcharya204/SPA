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

<!DOCTYPE html>
<html>
<head>

    <title>Principal Dashboard</title>
     <link rel="stylesheet" href="../common.css">

    <link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
    <style>
        /*======================================================
                    PRINCIPAL DASHBOARD ONLY
        ======================================================*/

        /* Welcome */

        #welcome{
            margin-bottom:30px;
        }

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
            margin-top:10px;
        }

        .chart-box canvas{
            width:100% !important;
            height:330px !important;
        }

        /* Card Top Colors */

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

        @media(max-width:1000px){

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
            <h1>PRINCIPAL DASHBOARD</h1>
        </div>

        <div id="profile-section">
            <img src="<%=photo%>" id="profile-pic">
            <a href="princi_profile.jsp"><%=name%></a>
        </div>

    </header>

    <div id="sidebar">

        <div><a href="princi_dashboard.jsp"><i class="fa-solid fa-house"></i>&nbsp;&nbsp;DASHBOARD</a></div>

        <div><a href="view_student.jsp"><i class="fa-solid fa-user-plus"></i>&nbsp;&nbsp;STUDENT DETAILS</a></div>

        <div><a href="tea_ana.jsp"><i class="fa-solid fa-users"></i>&nbsp;&nbsp;TEACHER DETAILS</a></div>

        <div><a href="dept_ana.jsp"><i class="fa-solid fa-graduation-cap"></i>&nbsp;&nbsp;DEPARTMENT DETAILS</a></div>

    </div>

    <div id="main">

        <div id="welcome">
            <h2>Welcome, <%=name%></h2>
            <p>Principal Dashboard Overview</p>
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
        <!-- ================= CHARTS ================= -->

        <div class="charts-grid">

            <div class="chart-box">
                <h3>Teachers per Department</h3>
                <canvas id="teachersChart"></canvas>
            </div>

            <div class="chart-box">
                <h3>Students per Department</h3>
                <canvas id="studentsChart"></canvas>
            </div>

        </div>

        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

        <script>

            const deptLabels = ["MCA", "MSC", "MA", "MTECH"];

            const teacherData = [
                <%=mcaTeachers%>,
                <%=mscTeachers%>,
                <%=maTeachers%>,
                <%=mtechTeachers%>
            ];

            const studentData = [
                <%=mcaStudents%>,
                <%=mscStudents%>,
                <%=maStudents%>,
                <%=mtechStudents%>
            ];

            const barColors = [
                "#184C85",
                "#2E6FB2",
                "#3ca374",
                "#e67e22"
            ];

            /* ---- Teachers Chart ---- */
            new Chart(document.getElementById("teachersChart"), {
                type: "bar",
                data: {
                    labels: deptLabels,
                    datasets: [{
                        label: "Teachers",
                        data: teacherData,
                        backgroundColor: barColors,
                        borderRadius: 8,
                        borderSkipped: false
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: { display: false }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: { stepSize: 1 },
                            grid: { color: "#eef4fb" }
                        },
                        x: {
                            grid: { display: false }
                        }
                    }
                }
            });

            /* ---- Students Chart ---- */
            new Chart(document.getElementById("studentsChart"), {
                type: "bar",
                data: {
                    labels: deptLabels,
                    datasets: [{
                        label: "Students",
                        data: studentData,
                        backgroundColor: barColors,
                        borderRadius: 8,
                        borderSkipped: false
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: { display: false }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: { stepSize: 1 },
                            grid: { color: "#eef4fb" }
                        },
                        x: {
                            grid: { display: false }
                        }
                    }
                }
            });

        </script>
    </div>

</body>
</html>