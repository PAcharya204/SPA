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

    <title>Student Academics</title>
    <link rel="stylesheet" href="../common.css">
    <link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
    <style>

    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">

</head>

<body>

    <header>
        <div class="logo-section">
            <img src="../images/logo.png" id="logo">
            <h1>STUDENT ACADEMICS</h1>
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
            double avgMarks=0;
            double avgAttendance=0;
            String overallGrade="-";
            int totalSubjects=0;

            PreparedStatement psSummary=con.prepareStatement(

            "SELECT AVG(total_marks),AVG(attendance),COUNT(*) FROM marks m INNER JOIN student s ON m.sid=s.sid WHERE s.s_username=?"

            );

            psSummary.setString(1,s_username);

            ResultSet rsSummary=psSummary.executeQuery();

            if(rsSummary.next())
            {
                avgMarks=rsSummary.getDouble(1);
                avgAttendance=rsSummary.getDouble(2);
                totalSubjects=rsSummary.getInt(3);
            }

            rsSummary.close();
            psSummary.close();

            if(avgMarks>=90)
            overallGrade="O";
            else if(avgMarks>=80)
            overallGrade="A+";
            else if(avgMarks>=70)
            overallGrade="A";
            else if(avgMarks>=60)
            overallGrade="B+";
            else if(avgMarks>=50)
            overallGrade="B";
            else
            overallGrade="C";
            %>

            <div class="page-title">
                <h2>Student Academic Record</h2>
                <p>View your complete academic performance.</p>
            </div>

            <div class="dashboard-grid">

                <div class="card">
                    <h3>Overall Percentage</h3>
                    <h1><%=String.format("%.2f",avgMarks)%>%</h1>
                    <p>Academic Percentage</p>
                </div>

                <div class="card">
                    <h3>Attendance</h3>
                    <h1><%=String.format("%.2f",avgAttendance)%>%</h1>
                    <p>Overall Attendance</p>
                </div>

                <div class="card">
                    <h3>Grade</h3>
                    <h1><%=overallGrade%></h1>
                    <p>Overall Grade</p>
                </div>

                <div class="card">
                    <h3>Subjects</h3>
                    <h1><%=totalSubjects%></h1>
                    <p>Total Subjects</p>

                </div>

            </div>


            <div class="table-container">

                <h3 class="section-title">Subject Wise Academic Details </h3>

                <table>
                    <thead>
                    <>
                        <th>Subject</th>
                        <th>Internal</th>
                        <th>External</th>
                        <th>Total</th>
                        <th>Total Classes</th>
                        <th>Attended</th>
                        <th>Attendance %</th>
                        <th>Grade</th>
                    </tr>
                    </thead>
                    <tbody>

                    <%

                    PreparedStatement psTable = con.prepareStatement(

                    "SELECT sub.subject_name, " +
                    "m.internal_marks, " +
                    "m.external_marks, " +
                    "m.total_marks, " +
                    "a.total_classes, " +
                    "a.attended_classes, " +
                    "a.attendance_percent, " +
                    "m.grade " +
                    "FROM marks m " +
                    "INNER JOIN student s ON m.sid=s.sid " +
                    "INNER JOIN subject sub ON m.subid=sub.subid " +
                    "LEFT JOIN attendance a ON m.sid=a.sid AND m.subid=a.subid " +
                    "WHERE s.s_username=? " +
                    "ORDER BY sub.subject_name"

                    );


                    psTable.setString(1,s_username);

                    ResultSet rsTable=psTable.executeQuery();

                    while(rsTable.next())
                    {

                    %>

                    <tr>
                        <td><%=rsTable.getString("subject_name")%></td>
                        <td><%=rsTable.getDouble("internal_marks")%></td>
                        <td><%=rsTable.getDouble("external_marks")%></td>
                        <td><strong><%=rsTable.getDouble("total_marks")%></strong></td>
                        <td><%=rsTable.getInt("total_classes")%></td>
                        <td><%=rsTable.getInt("attended_classes")%></td>
                        <td><%=String.format("%.2f",rsTable.getDouble("attendance_percent"))%>%</td>
                        <td><%=rsTable.getString("grade")%></td>
                    </tr>
                    <%

                    }

                    rsTable.close();
                    psTable.close();

                    %>
                    </tbody>
                </table>

            </div>


            <div class="card" style="margin-top:30px;">

                <h2 style="color:#184C85;margin-bottom:20px;">Academic Summary</h2>
                <table class="summary-table">
                    <tr>
                        <td>Overall Percentage</td>
                        <td><%=String.format("%.2f",avgMarks)%>%</td>
                    </tr>
                    <tr>
                        <td>Overall Attendance</td>
                        <td><%=String.format("%.2f",avgAttendance)%>%</td>
                    </tr>
                    <tr>
                        <td>Overall Grade</td>
                        <td><%=overallGrade%></td>
                    </tr>
                    <tr>
                        <td>Result</td>
                        <td><%=avgMarks>=40?"PASS":"FAIL"%></td>
                    </tr>

                </table>

            </div>


   </div>

</body>
</html>