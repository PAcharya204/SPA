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
/* ---------------------------------------- */

String sid = request.getParameter("sid");

String studentName = "";
String rollNo = "";
String dept = "";
String section = "";
String profile = "../images/default_user.png";
int semester = 0;

double average = 0;
double attendance = 0;
double percentage = 0;
String overallGrade = "-";

if(sid != null)
{
    PreparedStatement ps = con.prepareStatement(
        "SELECT * FROM student WHERE sid=?"
    );

    ps.setInt(1,Integer.parseInt(sid));

    ResultSet rs = ps.executeQuery();

    if(rs.next())
    {
        studentName = rs.getString("s_name");
        rollNo = rs.getString("roll_no");
        dept = rs.getString("dept");
        semester = rs.getInt("semester");
        section = rs.getString("section");

        if(rs.getString("s_profile") != null)
        {
            profile = "../" + rs.getString("s_profile");
        }
    }

    rs.close();
    ps.close();

    PreparedStatement psMarks = con.prepareStatement(
        "SELECT AVG(total_marks) avg_marks," +
        "AVG(attendance) avg_attendance " +
        "FROM marks WHERE sid=?"
    );

    psMarks.setInt(1,Integer.parseInt(sid));

    ResultSet rsMarks = psMarks.executeQuery();

    if(rsMarks.next())
    {
        average = rsMarks.getDouble("avg_marks");
        attendance = rsMarks.getDouble("avg_attendance");
        percentage = average;

        if(percentage >= 90)
            overallGrade = "O";
        else if(percentage >= 80)
            overallGrade = "A+";
        else if(percentage >= 70)
            overallGrade = "A";
        else if(percentage >= 60)
            overallGrade = "B+";
        else if(percentage >= 50)
            overallGrade = "B";
        else if(percentage >= 40)
            overallGrade = "C";
        else
            overallGrade = "F";
    }

    rsMarks.close();
    psMarks.close();
}
%>

<!DOCTYPE html>

<html>

<head>

    <title>Student Analytics</title>

    <meta charset="UTF-8">

    <meta name="viewport"
    content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
    <link rel="stylesheet" href="../common.css">

    <style>


.logo-section{
    display:flex;
    align-items:center;
    gap:15px;
}

#logo{
    width:60px;
    height:60px;
    background:white;
    padding:8px;
    border-radius:15px;
    object-fit:contain;
}

.logo-section h1{
    color:white;
    font-size:28px;
    font-weight:700;
}

#profile-section{
    display:flex;
    align-items:center;
    gap:12px;
}

#profile-pic{
    width:50px;
    height:50px;
    border-radius:50%;
    object-fit:cover;
    border:3px solid white;
}

#profile-section a{
    color:white;
    text-decoration:none;
    font-weight:600;
}

.sidebar{
    position:fixed;

    top:80px;
    left:0;

    width:250px;
    height:100vh;

    background:linear-gradient(180deg,#184C85,#2E6FB2);

    padding-top:25px;
}

.sidebar a{
    display:block;

    margin:10px 15px;

    padding:15px 18px;

    color:white;

    text-decoration:none;

    border-radius:12px;

    transition:.3s;
}

.sidebar a:hover{
    background:rgba(255,255,255,.18);
    transform:translateX(6px);
}

.main{
    margin-left:270px;
    margin-top:100px;
    padding:30px;
}

.page-title{
    margin-bottom:30px;
}

.page-title h1{
    color:#184C85;
    margin-bottom:8px;
}

.page-title p{
    color:#666;
}

.student-card{

    background:white;

    border-radius:20px;

    padding:25px;

    display:flex;

    align-items:center;

    gap:25px;

    box-shadow:0 10px 25px rgba(0,0,0,.08);

    margin-bottom:30px;
}

.student-card img{

    width:120px;
    height:120px;

    border-radius:50%;

    object-fit:cover;

    border:5px solid #2E6FB2;
}

.student-info h2{
    color:#184C85;
    margin-bottom:12px;
}

.student-info p{
    margin:6px 0;
    color:#444;
}

.cards{

    display:grid;

    grid-template-columns:repeat(4,1fr);

    gap:20px;

    margin-bottom:30px;
}

.card{

    background:white;

    padding:25px;

    border-radius:18px;

    text-align:center;

    box-shadow:0 8px 20px rgba(0,0,0,.08);

    border-top:5px solid #2E6FB2;
}

.card h3{
    color:#666;
    margin-bottom:10px;
}

.card h1{
    color:#184C85;
    font-size:34px;
}

.section{

    background:white;

    border-radius:20px;

    padding:25px;

    box-shadow:0 8px 20px rgba(0,0,0,.08);

    margin-bottom:30px;
}

.section h2{

    color:#184C85;

    margin-bottom:20px;
}

@media(max-width:900px){

.cards{
grid-template-columns:repeat(2,1fr);
}

.student-card{
flex-direction:column;
text-align:center;
}

}

@media(max-width:768px){

.sidebar{
display:none;
}

.main{
margin-left:0;
padding:20px;
}

.cards{
grid-template-columns:1fr;
}

.logo h2{
font-size:22px;
}

}

    </style>

</head>
<body>

    <header>
    <div class="logo-section">
        <img src="../images/logo.png" id="logo">
        <h1>STUDENT ANALYTICS</h1>
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
            <h1>Student Performance Analytics</h1>
            <p>Detailed academic performance report of the selected student.</p>
        </div>

        <div class="student-card">
            <img src="<%=profile%>">
            <div class="student-info">
                <h2><%=studentName%></h2>
                <p><b>Roll Number :</b><%=rollNo%></p>
                <p><b>Department :</b><%=dept%></p>
                <p><b>Semester :</b><%=semester%></p>
                <p><b>Section :</b><%=section%></p>
            </div>

        </div>

        <div class="cards">

            <div class="card">
                <h3><i class="fa-solid fa-percent"></i>Overall Percentage</h3>
                <h1><%=String.format("%.2f",percentage)%>%</h1>
            </div>

            <div class="card">
                <h3><i class="fa-solid fa-chart-column"></i>Average Marks</h3>
                <h1><%=String.format("%.2f",average)%></h1>
            </div>


            <div class="card">
                <h3><i class="fa-solid fa-user-check"></i>Attendance </h3>
                <h1><%=String.format("%.2f",attendance)%>%</h1> 
            </div>


            <div class="card">
                <h3><i class="fa-solid fa-award"></i>Overall Grade</h3>
                <h1><%=overallGrade%></h1>
            </div>

        </div>
        <%
            if(sid != null)
            {
                PreparedStatement psTable = con.prepareStatement(
                    "SELECT s.subject_name," +
                    "m.internal_marks," +
                    "m.external_marks," +
                    "m.total_marks," +
                    "m.attendance," +
                    "m.grade," +
                    "m.remarks " +
                    "FROM marks m " +
                    "INNER JOIN subject s ON m.subid=s.subid " +
                    "WHERE m.sid=? " +
                    "ORDER BY s.subject_name"
                );

                psTable.setInt(1,Integer.parseInt(sid));

                ResultSet rsTable = psTable.executeQuery();
            %>

        <div class="section">

            <h2><i class="fa-solid fa-chart-simple"></i>Subject Wise Performance</h2>
            <%
            while(rsTable.next())
            {
                int total = rsTable.getInt("total_marks");
            %>

            <div style="margin-bottom:20px;">

                <div style="display:flex;justify-content:space-between;margin-bottom:8px;">
                    <span><b><%=rsTable.getString("subject_name")%></b></span>
                    <span><%=total%>%</span>
                </div>

                <div style="
                    width:100%;
                    height:18px;
                    background:#dde7f3;
                    border-radius:20px;
                    overflow:hidden;
                ">

                    <div style="
                        width:<%=total%>%;
                        height:18px;
                        background:linear-gradient(90deg,#2E6FB2,#184C85);
                        border-radius:20px;
                    ">

                    </div>

                </div>

            </div>

            <%
            }
            %>

        </div>

<%
    rsTable.close();
    psTable.close();
}
%>

<%
if(sid != null)
{
    PreparedStatement psMarks = con.prepareStatement(

        "SELECT s.subject_name," +
        "m.internal_marks," +
        "m.external_marks," +
        "m.total_marks," +
        "m.attendance," +
        "m.grade," +
        "m.remarks " +

        "FROM marks m " +

        "INNER JOIN subject s " +

        "ON m.subid=s.subid " +

        "WHERE m.sid=? " +

        "ORDER BY s.subject_name"

    );

    psMarks.setInt(1,Integer.parseInt(sid));

    ResultSet rsMarks = psMarks.executeQuery();
%>

        <div class="section">

            <h2>

                <i class="fa-solid fa-table"></i>

                Subject Wise Marks

            </h2>

            <table style="
                width:100%;
                border-collapse:collapse;
                text-align:center;
            ">

                <tr style="
                    background:#184C85;
                    color:white;
                ">

                    <th style="padding:14px;">Subject</th>

                    <th>Internal</th>

                    <th>External</th>

                    <th>Total</th>

                    <th>Attendance</th>

                    <th>Grade</th>

                    <th>Remarks</th>

                </tr>

                <%
                while(rsMarks.next())
                {
                %>

                <tr>

                    <td style="padding:14px;border-bottom:1px solid #e5e5e5;">

                        <%=rsMarks.getString("subject_name")%>

                    </td>

                    <td>

                        <%=rsMarks.getInt("internal_marks")%>

                    </td>

                    <td>

                        <%=rsMarks.getInt("external_marks")%>

                    </td>

                    <td>

                        <b>

                            <%=rsMarks.getInt("total_marks")%>

                        </b>

                    </td>

                    <td>

                        <%=rsMarks.getDouble("attendance")%>%

                    </td>

                    <td>

                        <span style="
                            background:#2E6FB2;
                            color:white;
                            padding:6px 14px;
                            border-radius:20px;
                            font-weight:bold;
                        ">

                            <%=rsMarks.getString("grade")%>

                        </span>

                    </td>

                    <td>

                        <%=rsMarks.getString("remarks")==null ? "-" : rsMarks.getString("remarks")%>

                    </td>

                </tr>

                <%
                }

                rsMarks.close();
                psMarks.close();
                %>

            </table>

        </div>

        <div class="section">

            <h2>

                <i class="fa-solid fa-comments"></i>

                Performance Summary

            </h2>

            <p style="
                color:#555;
                line-height:1.8;
                font-size:16px;
            ">

                This report summarizes the student's academic performance,
                attendance, and grades across all enrolled subjects.
                Teachers can use this information to identify strengths,
                monitor consistency, and provide guidance where improvement
                is needed.

            </p>

        </div>

        

<%
}
%>
    </div>

</body>

</html>