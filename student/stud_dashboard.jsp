<%@ include file="db.jsp" %>
<%@ page import="java.sql.*" %>

<%
String s_username=(String)session.getAttribute("s_username");

if(s_username==null)
{
    response.sendRedirect("stud_login.jsp");
}

/*------------------------Principal Name------------------------*/
String name="";
try
{
    PreparedStatement ps;
    ResultSet rs;

    ps=con.prepareStatement("select s_name from student where s_username=?");
    ps.setString(1,s_username);
    rs=ps.executeQuery();
    if(rs.next())
    {
        name=rs.getString("s_name");
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

PreparedStatement ps1=con.prepareStatement("select s_profile from student where s_username=?");

ps1.setString(1,s_username);

ResultSet rs1=ps1.executeQuery();

if(rs1.next())
{
    String dbPhoto=rs1.getString("s_profile");

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

    <title>Student Dashboard</title>
    <link rel="stylesheet" href="../common.css">
    <link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
    <style>
    /*======================================================
                STUDENT DASHBOARD ONLY
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

    .ma::before{
        background:#18A085;
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
            <h1>STUDENT DASHBOARD</h1>
        </div>

        <div id="profile-section">
            <img src="<%=photo%>" id="profile-pic">
            <a href="stud_profile.jsp"><%=name%></a>
        </div>

    </header>

    <div id="sidebar">

        <div><a href="stud_dashboard.jsp"><i class="fa-solid fa-house"></i>&nbsp;&nbsp;DASHBOARD</a></div>

        <div><a href="stud_acad.jsp"><i class="fa-solid fa-user-plus"></i>&nbsp;&nbsp;STUDENT ACADEMICS</a></div>

        <div><a href="stud_profile.jsp"><i class="fa-solid fa-users"></i>&nbsp;&nbsp;PROFILE</a></div>

    </div>

    <div id="main">
        <%

            double avgMarks = 0;
            double avgAttendance = 0;
            String overallGrade = "-";

            int subjectCount = 0;

            PreparedStatement psDash = con.prepareStatement(
            "SELECT AVG(total_marks),AVG(attendance),COUNT(*) FROM marks m INNER JOIN student s ON m.sid=s.sid WHERE s.s_username=?");

            psDash.setString(1,s_username);

            ResultSet rsDash = psDash.executeQuery();

            if(rsDash.next())
            {
                avgMarks = rsDash.getDouble(1);
                avgAttendance = rsDash.getDouble(2);
                subjectCount = rsDash.getInt(3);
            }

            rsDash.close();
            psDash.close();


            PreparedStatement psGrade = con.prepareStatement(
            "SELECT grade,COUNT(*) c FROM marks m INNER JOIN student s ON m.sid=s.sid WHERE s.s_username=? GROUP BY grade ORDER BY c DESC LIMIT 1");

            psGrade.setString(1,s_username);

            ResultSet rsGrade = psGrade.executeQuery();

            if(rsGrade.next())
            {
                overallGrade = rsGrade.getString("grade");
            }

            rsGrade.close();
            psGrade.close();

            %>


            <div id="welcome">

                <h2>Welcome, <%=name%></h2>

                <p>
                    View your academic progress, marks and attendance.
                </p>

            </div>


            <div class="dashboard-grid">

                <div class="card students">

                    <h3>Subjects</h3>

                    <h1><%=subjectCount%></h1>

                </div>

                <div class="card teachers">

                    <h3>Average Marks</h3>

                    <h1><%=String.format("%.2f",avgMarks)%></h1>

                </div>

                <div class="card mca">

                    <h3>Attendance</h3>

                    <h1><%=String.format("%.2f",avgAttendance)%>%</h1>

                </div>

                <div class="card ma">

                    <h3>Overall Grade</h3>

                    <h1><%=overallGrade%></h1>

                </div>

            </div>


            <%

            String subjectLabels="";
            String marksData="";
            String attendanceData="";

            PreparedStatement psChart = con.prepareStatement(

            "SELECT sub.subject_name,m.total_marks,m.attendance FROM marks m INNER JOIN student s ON m.sid=s.sid INNER JOIN subject sub ON m.subid=sub.subid WHERE s.s_username=? ORDER BY sub.subject_name"

            );

            psChart.setString(1,s_username);

            ResultSet rsChart=psChart.executeQuery();

            while(rsChart.next())
            {

            subjectLabels += "'" + rsChart.getString("subject_name") + "',";

            marksData += rsChart.getDouble("total_marks") + ",";

            attendanceData += rsChart.getDouble("attendance") + ",";

            }

            rsChart.close();
            psChart.close();

            if(subjectLabels.length()>0)
            {
            subjectLabels=subjectLabels.substring(0,subjectLabels.length()-1);
            marksData=marksData.substring(0,marksData.length()-1);
            attendanceData=attendanceData.substring(0,attendanceData.length()-1);
            }

            %>


            <div class="charts-grid">

                <div class="chart-box">

                    <h3>Subject-wise Marks</h3>

                    <canvas id="marksChart"></canvas>

                </div>

                <div class="chart-box">

                    <h3>Attendance Percentage</h3>

                    <canvas id="attendanceChart"></canvas>

                </div>

            </div>


            <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

            <script>

            const labels=[<%=subjectLabels%>];

            new Chart(document.getElementById("marksChart"),{

            type:"bar",

            data:{
            labels:labels,
            datasets:[{

            label:"Marks",

            data:[<%=marksData%>]

            }]
            },

            options:{
            responsive:true,
            maintainAspectRatio:false
            }

            });


            new Chart(document.getElementById("attendanceChart"),{

            type:"bar",

            data:{

            labels:labels,

            datasets:[{

            label:"Attendance %",

            data:[<%=attendanceData%>],

            fill:false

            }]

            },

            options:{
            responsive:true,
            maintainAspectRatio:false
            }

            });

        </script>

    
    </div>

</body>
</html>