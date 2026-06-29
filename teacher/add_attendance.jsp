<%@ include file="db.jsp" %>
<%@ page import="java.sql.*" %>

<%
String t_username=(String)session.getAttribute("t_username");

if(t_username==null)
{
    response.sendRedirect("teach_login.jsp");
    return;
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

    <title>Add Attendance</title>

    <style>
    /* Only page-specific CSS */

.form-container{
    max-width:900px;
}

.button-area{
    display:flex;
    gap:15px;
    margin-top:30px;
}

.button-area input,
.button-area .reset-btn{
    flex:1;
}

.reset-btn{
    display:flex;
    justify-content:center;
    align-items:center;
    text-decoration:none;
    background:#e8edf5;
    color:#184C85;
    border-radius:12px;
    font-size:15px;
    font-weight:600;
    transition:.3s;
}

.reset-btn:hover{
    background:#184C85;
    color:#fff;
}

/* Attendance table */

.attendance-table{
    width:100%;
    margin-top:30px;
    border-collapse:collapse;
    background:#fff;
    border-radius:15px;
    overflow:hidden;
    box-shadow:0 10px 25px rgba(0,0,0,.08);
}

.attendance-table th{
    background:#184C85;
    color:#fff;
    padding:14px;
    text-align:center;
}

.attendance-table td{
    padding:12px;
    border-bottom:1px solid #e6edf7;
    text-align:center;
}

.attendance-table tr:hover{
    background:#f5f9ff;
}

.attendance-table input{
    width:100%;
}
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
    <link rel="stylesheet" href="../common.css">
</head>

<body>

    <header>
        <div class="logo-section">
            <img src="../images/logo.png" id="logo">
            <h1>ADD STUDENTS' MARKS</h1>
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
            <h2>Add Student Attendance</h2>
            <p>Enter attendance for students.</p>
        </div>

        <%
        String teacherDept="";

        PreparedStatement psDept=con.prepareStatement(
        "SELECT dept FROM teacher WHERE t_username=?");

        psDept.setString(1,t_username);

        ResultSet rsDept=psDept.executeQuery();

        if(rsDept.next())
        {
            teacherDept=rsDept.getString("dept");
        }

        rsDept.close();
        psDept.close();

        String semester=request.getParameter("semester");
        if(semester==null) semester="";

        String subid=request.getParameter("subid");
        if(subid==null) subid="";

        String total=request.getParameter("total_classes");
        if(total==null) total="";
        %>

        <form method="post" action="add_attendance.jsp">

            <div class="form-grid">

            <div>
                <label>Department</label>
                <input type="text" id="dept" name="dept" value="<%=teacherDept%>" readonly>
            </div>

            <div>
                <label>Semester</label>
                <select id="semester" name="semester" onchange="loadSubjects()" required>
                <option value="">Select Semester</option>
                <%
                    for(int i=1;i<=4;i++)
                    {
                %>
                <option value="<%=i%>" <%=semester.equals(String.valueOf(i))?"selected":""%>> Semester <%=i%> </option>
                <%
                    }
                %>
                </select>
            </div>

            <div>
                <label>Subject</label>
                <select id="subject" name="subid" required>
                    <option value="">Select Subject</option>
                </select>
            </div>

            <div>
                <label>Total Classes</label>
                <input type="number" name="total_classes" min="1" value="<%=total%>" required>
            </div>

        </div>

        <div class="button-area">
            <input type="submit" name="load" value="Load Students">
            <a href="teach_dashboard.jsp" class="reset-btn"> Cancel </a> 
        </div>

    </form>

        <%

        if(request.getParameter("load")!=null)
        {

            PreparedStatement psStudent=con.prepareStatement( "SELECT sid,roll_no,s_name FROM student WHERE dept=? AND semester=? ORDER BY roll_no" );
            psStudent.setString(1,teacherDept);
            psStudent.setInt(2,Integer.parseInt(semester));
            ResultSet rsStudent=psStudent.executeQuery();
        %>

        <form method="post" action="save_attendance.jsp">

            <input type="hidden" name="subid" value="<%=subid%>">
            <input type="hidden" name="total_classes" value="<%=total%>">
            <table class="attendance-table">
                <tr>
                    <th>Roll No</th>
                    <th>Name</th>
                    <th>Attended Classes</th>
                    <th>Attendance %</th>
                    <th>Remarks</th>
                </tr>
                <%

                while(rsStudent.next())
                {
                %>
                <tr>
                    <td><%=rsStudent.getString("roll_no")%><input type="hidden" name="sid" value="<%=rsStudent.getInt("sid")%>"></td>
                    <td><%=rsStudent.getString("s_name")%></td>
                    <td> <input type="number" name="attended" class="attended" min="0" max="<%=total%>" value="0" onkeyup="calculate(this)" onchange="calculate(this)" required></td>
                    <td> <input type="text" class="percent" value="0.00" readonly> </td>
                    <td> <input type="text" name="remarks" placeholder="Remarks"> </td>
                </tr>

                <%
                }

                rsStudent.close();
                psStudent.close();
                %>

            </table>

            <div class="button-area">
                <input type="submit" value="Save Attendance">
            </div>

        </form>

        <%
        }
        %>

        <script>

        function calculate(x)
        {
            var total=<%=total.equals("")?0:total%>;

            if(total==0)
                return;

            var attended=parseFloat(x.value)||0;

            if(attended>total)
            {
                alert("Attended classes cannot exceed Total Classes");
                x.value=total;
                attended=total;
            }

            var per=(attended*100)/total;

            x.parentNode.parentNode
            .querySelector(".percent")
            .value=per.toFixed(2);
        }

        </script>
  <script>

function loadSubjects()
{
    var dept = document.getElementById("dept").value;
    var semester = document.getElementById("semester").value;

    if(dept=="" || semester=="")
    {
        document.getElementById("subject").innerHTML =
        "<option value=''>Select Subject</option>";
        return;
    }

    var xhr = new XMLHttpRequest();

    xhr.onreadystatechange = function()
    {
        if(xhr.readyState==4)
        {
            if(xhr.status==200)
            {
                document.getElementById("subject").innerHTML =
                xhr.responseText;
            }
            else
            {
                alert("Unable to load subjects.");
            }
        }
    };

    xhr.open(
        "GET",
        "get_subject.jsp?dept=" +
        encodeURIComponent(dept) +
        "&semester=" +
        encodeURIComponent(semester),
        true
    );

    xhr.send();
}

</script>

</div>
      


</script>
</body>
</html>