<%@ include file="db.jsp" %>
<%@ page import="java.sql.*" %>

<%
String t_username=(String)session.getAttribute("t_username");

if(t_username==null)
{
    response.sendRedirect("teach_login.jsp");
    return;
}

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

String teacherDept = "";
String semester = request.getParameter("semester");
if(semester == null || semester.equals(""))
{
    semester = "1";
}

PreparedStatement psDept = con.prepareStatement("SELECT dept FROM teacher WHERE t_username=?");
psDept.setString(1, t_username);
ResultSet rsDept = psDept.executeQuery();
if(rsDept.next())
{
    teacherDept = rsDept.getString("dept");
}
rsDept.close();
psDept.close();

int totalStudents = 0;
double avgMarks = 0;
double avgAttendance = 0;
String overallGrade = "C";

PreparedStatement psStudents = con.prepareStatement(
    "SELECT COUNT(*) FROM student WHERE dept=? AND semester=?"
);
psStudents.setString(1, teacherDept);
psStudents.setInt(2, Integer.parseInt(semester));
ResultSet rsStudents = psStudents.executeQuery();
if(rsStudents.next())
{
    totalStudents = rsStudents.getInt(1);
}
rsStudents.close();
psStudents.close();

PreparedStatement psMarks = con.prepareStatement(
    "SELECT AVG(total_marks) FROM marks m INNER JOIN student s ON m.sid=s.sid WHERE s.dept=? AND s.semester=?"
);
psMarks.setString(1, teacherDept);
psMarks.setInt(2, Integer.parseInt(semester));
ResultSet rsMarks = psMarks.executeQuery();
if(rsMarks.next())
{
    avgMarks = rsMarks.getDouble(1);
}
rsMarks.close();
psMarks.close();

PreparedStatement psAttendance = con.prepareStatement(
    "SELECT AVG(attendance_percent) FROM attendance a INNER JOIN student s ON a.sid=s.sid WHERE s.dept=? AND s.semester=?"
);
psAttendance.setString(1, teacherDept);
psAttendance.setInt(2, Integer.parseInt(semester));
ResultSet rsAttendance = psAttendance.executeQuery();
if(rsAttendance.next())
{
    avgAttendance = rsAttendance.getDouble(1);
}
rsAttendance.close();
psAttendance.close();

if(avgMarks >= 90)
{
    overallGrade = "O";
}
else if(avgMarks >= 80)
{
    overallGrade = "A+";
}
else if(avgMarks >= 70)
{
    overallGrade = "A";
}
else if(avgMarks >= 60)
{
    overallGrade = "B+";
}
else if(avgMarks >= 50)
{
    overallGrade = "B";
}
else
{
    overallGrade = "C";
}

String performance = "";
String remark = "";

if(avgMarks >= 85 && avgAttendance >= 90)
{
    performance = "Excellent";
    remark = "Students are performing exceptionally well in both academics and attendance.";
}
else if(avgMarks >= 70 && avgAttendance >= 80)
{
    performance = "Very Good";
    remark = "Department performance is good. Continue maintaining the current progress.";
}
else if(avgMarks >= 60 && avgAttendance >= 75)
{
    performance = "Good";
    remark = "Department performance is satisfactory. Focus on improving academic results.";
}
else
{
    performance = "Needs Improvement";
    remark = "Special attention is required to improve marks and attendance.";
}
%>
<!DOCTYPE html>
<html>
<head>
    <title>Departmental Analytics</title>
    <style>
      .stats-row{
    display:grid;
    grid-template-columns:repeat(4,1fr);
    gap:20px;
    margin:25px 0;
}

.chart-row{
    display:grid;
    grid-template-columns:repeat(2,1fr);
    gap:25px;
    margin-top:35px;
}

.chart-box,
.report-box{
    background:#fff;
    padding:25px;
    border-radius:20px;
    box-shadow:0 10px 25px rgba(0,0,0,.08);
}

.chart-box h2,
.report-box h2{
    color:#184C85;
    margin-bottom:20px;
}

.report-row{
    display:grid;
    grid-template-columns:2fr 1fr;
    gap:25px;
    margin-top:35px;
}

.analytics-card h2{
    margin-bottom:20px;
}

.analytics-card h3{
    margin:20px 0 10px;
    color:#184C85;
}

.analytics-card p{
    color:#666;
    line-height:28px;
    text-align:justify;
}

@media(max-width:992px){
    .stats-row{
        grid-template-columns:repeat(2,1fr);
    }
}

@media(max-width:768px){
    .stats-row,
    .chart-row,
    .report-row{
        grid-template-columns:1fr;
    }
}
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
    <link rel="stylesheet" href="../common.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>

<body>

    <header>
        <div class="logo-section">
            <img src="../images/logo.png" id="logo">
            <h1>DEPARTMENTAL ANALYTICS</h1>
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

    <div id="main">

        <div class="page-title">
            <h2>Departmental Analytics</h2>
        </div>

        <div class="stats-row">
            <div class="card">
                <h3>Total Students</h3>
                <h1><%=totalStudents%></h1>
                <p>Department Strength</p>
            </div>
            <div class="card">
                <h3>Average Marks</h3>
                <h1><%=String.format("%.2f",avgMarks)%></h1>
                <p>Department Average</p>
            </div>
            <div class="card">
                <h3>Attendance</h3>
                <h1><%=String.format("%.2f",avgAttendance)%>%</h1>
                <p>Average Attendance</p>
            </div>
            <div class="card">
                <h3>Overall Grade</h3>
                <h1><%=overallGrade%></h1>
                <p>Department Grade</p>
            </div>
        </div>

        <form method="get">
            <div class="form-grid">
                <div>
                    <label>Department</label>
                    <input type="text" value="<%=teacherDept%>" readonly>
                </div>
                <div>
                    <label>Semester</label>
                    <select name="semester" onchange="this.form.submit()">
                    <%
                    for(int i=1;i<=4;i++)
                    {
                    %>
                    <option value="<%=i%>" <%=semester.equals(String.valueOf(i)) ? "selected" : ""%>>Semester <%=i%></option>
                    <%
                    }
                    %>
                    </select>
                </div>
            </div>
        </form>

        <%
        StringBuilder subjectLabels = new StringBuilder();
        StringBuilder avgMarksData = new StringBuilder();
        StringBuilder avgAttendanceData = new StringBuilder();

        PreparedStatement psChart = con.prepareStatement(
            "SELECT s.subject_name, " +
            "COALESCE(AVG(m.total_marks),0) AS avg_marks, " +
            "COALESCE(AVG(a.attendance_percent),0) AS avg_attendance " +
            "FROM subject s " +
            "LEFT JOIN marks m ON s.subid = m.subid " +
            "LEFT JOIN attendance a ON a.sid = m.sid AND a.subid = m.subid " +
            "WHERE s.department=? AND s.semester=? " +
            "GROUP BY s.subid,s.subject_name " +
            "ORDER BY s.subject_name"
        );
        psChart.setString(1, teacherDept);
        psChart.setInt(2, Integer.parseInt(semester));
        ResultSet rsChart = psChart.executeQuery();

        while(rsChart.next())
        {
            subjectLabels.append("'").append(rsChart.getString("subject_name")).append("',");
            avgMarksData.append(String.format("%.2f", rsChart.getDouble("avg_marks"))).append(",");
            avgAttendanceData.append(String.format("%.2f", rsChart.getDouble("avg_attendance"))).append(",");
        }
        rsChart.close();
        psChart.close();
        %>

        <div class="chart-row">
            <div class="chart-box">
                <h2 style="color:#184C85;margin-bottom:20px;">Average Marks by Subject</h2>
                <canvas id="marksChart"></canvas>
            </div>
            <div class="chart-box">
                <h2 style="color:#184C85;margin-bottom:20px;">Average Attendance by Subject</h2>
                <canvas id="attendanceChart"></canvas>
            </div>
        </div>

        <script>
            const labels = [<%=subjectLabels.toString()%>];
            const marks = [<%=avgMarksData.toString()%>];
            const attendance = [<%=avgAttendanceData.toString()%>];

            new Chart(document.getElementById("marksChart"), {
                type:"bar",
                data:{
                    labels:labels,
                    datasets:[{label:"Average Marks",data:marks,borderWidth:1}]
                },
                options:{
                    responsive:true,
                    plugins:{legend:{display:false}},
                    scales:{y:{beginAtZero:true,max:100}}
                }
            });

            new Chart(document.getElementById("attendanceChart"), {
                type:"bar",
                data:{
                    labels:labels,
                    datasets:[{label:"Average Attendance",data:attendance,borderWidth:1}]
                },
                options:{
                    responsive:true,
                    plugins:{legend:{display:false}},
                    scales:{y:{beginAtZero:true,max:100}}
                }
            });
        </script>

        <div class="report-box">
            <h2 style="color:#184C85;margin-bottom:20px;">Subject Wise Statistics</h2>
            <table style="width:100%;border-collapse:collapse;text-align:center;">
                <tr style="background:#184C85;color:white;">
                    <th style="padding:12px;">Subject</th>
                    <th>Average Internal</th>
                    <th>Average External</th>
                    <th>Average Total</th>
                    <th>Average Attendance</th>
                    <th>Highest</th>
                    <th>Lowest</th>
                </tr>
                <%
                PreparedStatement psTable = con.prepareStatement(
                    "SELECT s.subject_name, " +
                    "AVG(m.internal_marks) avg_internal, " +
                    "AVG(m.external_marks) avg_external, " +
                    "AVG(m.total_marks) avg_total, " +
                    "AVG(a.attendance_percent) avg_attendance, " +
                    "MAX(m.total_marks) highest_marks, " +
                    "MIN(m.total_marks) lowest_marks " +
                    "FROM subject s " +
                    "LEFT JOIN marks m ON s.subid=m.subid " +
                    "LEFT JOIN attendance a ON a.sid=m.sid AND a.subid=m.subid " +
                    "LEFT JOIN student st ON st.sid=m.sid " +
                    "WHERE s.department=? AND s.semester=? " +
                    "GROUP BY s.subid,s.subject_name " +
                    "ORDER BY s.subject_name"
                );
                psTable.setString(1, teacherDept);
                psTable.setInt(2, Integer.parseInt(semester));
                ResultSet rsTable = psTable.executeQuery();

                while(rsTable.next())
                {
                %>
                <tr>
                    <td style="padding:12px;font-weight:600;"><%=rsTable.getString("subject_name")%></td>
                    <td><%=String.format("%.2f", rsTable.getDouble("avg_internal"))%></td>
                    <td><%=String.format("%.2f", rsTable.getDouble("avg_external"))%></td>
                    <td><b><%=String.format("%.2f", rsTable.getDouble("avg_total"))%></b></td>
                    <td><%=String.format("%.2f", rsTable.getDouble("avg_attendance"))%>%</td>
                    <td><%=String.format("%.0f", rsTable.getDouble("highest_marks"))%></td>
                    <td><%=String.format("%.0f", rsTable.getDouble("lowest_marks"))%></td>
                </tr>
                <%
                }
                rsTable.close();
                psTable.close();
                %>
            </table>
        </div>

        <div class="report-box">
            <h2 style="color:#184C85;margin-bottom:20px;">Top 10 Students</h2>
            <table style="width:100%;border-collapse:collapse;text-align:center;">
                <tr style="background:#184C85;color:white;">
                    <th style="padding:12px;">Rank</th>
                    <th>Roll No</th>
                    <th>Student Name</th>
                    <th>Average Marks</th>
                    <th>Average Attendance</th>
                    <th>Grade</th>
                </tr>
                <%
                PreparedStatement psTop = con.prepareStatement(
                    "SELECT s.roll_no, s.s_name, " +
                    "AVG(m.total_marks) avg_marks, " +
                    "AVG(a.attendance_percent) avg_attendance " +
                    "FROM student s " +
                    "LEFT JOIN marks m ON s.sid=m.sid " +
                    "LEFT JOIN attendance a ON s.sid=a.sid " +
                    "WHERE s.dept=? AND s.semester=? " +
                    "GROUP BY s.sid,s.roll_no,s.s_name " +
                    "ORDER BY AVG(m.total_marks) DESC " +
                    "LIMIT 10"
                );
                psTop.setString(1, teacherDept);
                psTop.setInt(2, Integer.parseInt(semester));
                ResultSet rsTop = psTop.executeQuery();
                int rank=1;

                while(rsTop.next())
                {
                    double topMarks = rsTop.getDouble("avg_marks");
                    String topGrade="C";
                    if(topMarks>=90) topGrade="O";
                    else if(topMarks>=80) topGrade="A+";
                    else if(topMarks>=70) topGrade="A";
                    else if(topMarks>=60) topGrade="B+";
                    else if(topMarks>=50) topGrade="B";
                %>
                <tr>
                    <td><b><%=rank%></b></td>
                    <td><%=rsTop.getString("roll_no")%></td>
                    <td><%=rsTop.getString("s_name")%></td>
                    <td><%=String.format("%.2f", topMarks)%></td>
                    <td><%=String.format("%.2f", rsTop.getDouble("avg_attendance"))%>%</td>
                    <td><%=topGrade%></td>
                </tr>
                <%
                    rank++;
                }
                rsTop.close();
                psTop.close();
                %>
            </table>
        </div>

            <div class="report-box">            
                <h2 style="color:#184C85;margin-bottom:20px;">Lowest Performing Students</h2>
                <table style="width:100%;border-collapse:collapse;text-align:center;">
                <tr style="background:#184C85;color:white;">
                    <th style="padding:12px;">Rank</th>
                    <th>Roll No</th>
                    <th>Student Name</th>
                    <th>Average Marks</th>
                    <th>Average Attendance</th>
                    <th>Grade</th>
                </tr>
                <%
                PreparedStatement psLow = con.prepareStatement(
                    "SELECT s.roll_no, s.s_name, " +
                    "AVG(m.total_marks) AS avg_marks, " +
                    "AVG(a.attendance_percent) AS avg_attendance " +
                    "FROM student s " +
                    "LEFT JOIN marks m ON s.sid=m.sid " +
                    "LEFT JOIN attendance a ON s.sid=a.sid " +
                    "WHERE s.dept=? AND s.semester=? " +
                    "GROUP BY s.sid,s.roll_no,s.s_name " +
                    "ORDER BY AVG(m.total_marks) ASC " +
                    "LIMIT 10"
                );
                psLow.setString(1, teacherDept);
                psLow.setInt(2, Integer.parseInt(semester));
                ResultSet rsLow = psLow.executeQuery();
                int lowRank=1;

                while(rsLow.next())
                {
                    double lowMarks = rsLow.getDouble("avg_marks");
                    String lowGrade="C";
                    if(lowMarks>=90) lowGrade="O";
                    else if(lowMarks>=80) lowGrade="A+";
                    else if(lowMarks>=70) lowGrade="A";
                    else if(lowMarks>=60) lowGrade="B+";
                    else if(lowMarks>=50) lowGrade="B";
                %>
                <tr>
                    <td><b><%=lowRank%></b></td>
                    <td><%=rsLow.getString("roll_no")%></td>
                    <td><%=rsLow.getString("s_name")%></td>
                    <td><%=String.format("%.2f", lowMarks)%></td>
                    <td><%=String.format("%.2f", rsLow.getDouble("avg_attendance"))%>%</td>
                    <td><%=lowGrade%></td>
                </tr>
                <%
                    lowRank++;
                }
                rsLow.close();
                psLow.close();
                %>
            </table>
        </div>

        <div class="report-row">
            <div class="report-box">
                <h2 style="color:#184C85;margin-bottom:20px;">Department Performance Summary</h2>
                <table class="summary-table">
                    <tr><td><strong>Department</strong></td><td><%=teacherDept%></td></tr>
                    <tr><td><strong>Semester</strong></td><td><%=semester%></td></tr>
                    <tr><td><strong>Total Students</strong></td><td><%=totalStudents%></td></tr>
                    <tr><td><strong>Average Marks</strong></td><td><%=String.format("%.2f",avgMarks)%></td></tr>
                    <tr><td><strong>Average Attendance</strong></td><td><%=String.format("%.2f",avgAttendance)%>%</td></tr>
                    <tr><td><strong>Department Grade</strong></td><td><%=overallGrade%></td></tr>
                    <tr><td><strong>Performance</strong></td><td><%=performance%></td></tr>
                </table>
            </div>
            <div class="analytics-card">
                <h2>Analytics Report</h2>
                <div class="grade-circle"><%=overallGrade%></div>
                <h3><%=performance%></h3>
                <p><%=remark%></p>
            </div>
        </div>

    </div>

</body>
</html>