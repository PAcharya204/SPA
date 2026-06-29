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

    <title>Add Marks</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
   <link rel="stylesheet" href="../common.css">

<style>
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

    height:48px;

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
</style>
    

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
        <h2>Add Student Marks</h2>
        <p>Enter student marks for each subject.</p>
    </div>

    <form method="post">

        <div class="form-grid">

        <div>
            <label>Department</label>
            <select id="dept" name="dept">
                <option value="">Select Department</option>
                <option>MCA</option>
                <option>MSC</option>
                <option>MA</option>
                <option>MTECH</option>
            </select>
        </div>

        <div>
            <label>Semester</label>
            <select id="semester" name="semester">
                <option value="">Select Semester</option>
                <option>1</option>
                <option>2</option>
                <option>3</option>
                <option>4</option>
            </select>
        </div>

        <div>
            <label>Student</label>

            <select id="student" name="sid">
                <option>Select Student</option>
            </select>

        </div>

        <div class="full-width">
            <label>Subject</label>

            <select id="subject" name="subid">
                <option value="">Select Subject</option>
            </select>

        </div>

        <div>
            <label>Internal Marks</label>
            <input type="number" name="internal">
        </div>

        <div>
            <label>External Marks</label>
            <input type="number" name="external">
        </div>

    </div>

    <div class="button-area">
        <input type="submit" value="Save Marks">
        <a href="teach_dashboard.jsp" class="reset-btn">Cancel</a>
    </div>

</form>

        <%
        String sid = request.getParameter("sid");

        if(sid != null){

           String subid = request.getParameter("subid");
            String dept = request.getParameter("dept");
            String semester = request.getParameter("semester");

            int internal = Integer.parseInt(request.getParameter("internal"));
            int external = Integer.parseInt(request.getParameter("external"));

            int total = internal + external;
            PreparedStatement check = con.prepareStatement(
            "SELECT * FROM marks WHERE sid=? AND subid=?");

            check.setString(1, sid);
            check.setString(2, subid);

            ResultSet r = check.executeQuery();

            if(r.next())
            {
                out.println("<script>alert('Marks already entered for this subject');</script>");
            }
            else
            {
                PreparedStatement ps = con.prepareStatement(
                "INSERT INTO marks(sid,subid,internal_marks,external_marks,total_marks) VALUES(?,?,?,?,?)");

                ps.setInt(1,Integer.parseInt(sid));
                ps.setString(2,subid);
                ps.setInt(3,internal);
                ps.setInt(4,external);
                ps.setInt(5,total);

                int x = ps.executeUpdate();

                if(x > 0){
        %>

        <script>
        alert("Marks Added Successfully");
        window.location="teach_dashboard.jsp";
        </script>

        <%
            }

            ps.close();
        }
            
        

            r.close();
            check.close();
    }
        %>

            

    </div>
</div>
<script>

function loadStudents()
{
alert("Loading...");
    var dept = document.getElementById("dept").value;
    var semester = document.getElementById("semester").value;

    if(dept=="" || semester=="")
    {
        document.getElementById("student").innerHTML =
        "<option value=''>Select Student</option>";

        document.getElementById("subject").innerHTML =
        "<option value=''>Select Subject</option>";

        return;
    }

    // Load Students
    var xhr1 = new XMLHttpRequest();

    xhr1.onreadystatechange = function()
    {
        if(xhr1.readyState==4 && xhr1.status==200)
        {
            document.getElementById("student").innerHTML = xhr1.responseText;
        }
    };

    xhr1.open("GET",
    "get_student.jsp?dept="+dept+"&semester="+semester,true);

    xhr1.send();


    // Load Subjects
    var xhr2 = new XMLHttpRequest();

    xhr2.onreadystatechange = function()
    {
        if(xhr2.readyState==4 && xhr2.status==200)
        {
            document.getElementById("subject").innerHTML = xhr2.responseText;
        }
    };

    xhr2.open("GET",
    "get_subject.jsp?dept="+dept+"&semester="+semester,true);

    xhr2.send();
}

document.getElementById("dept").onchange = loadStudents;
document.getElementById("semester").onchange = loadStudents;

</script>
</body>
</html>