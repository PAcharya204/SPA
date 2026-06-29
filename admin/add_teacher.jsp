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
    <title>Add Teacher</title>

    <link rel="stylesheet" href="../common.css">

    <link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">

</head>

<body>

<header>

    <div class="logo-section">
        <img src="../images/logo.png" id="logo">
        <h1>ADD TEACHER</h1>
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
        <div class="page-header">

            <h2>Register New Teacher</h2>

            <p>
            Create a teacher account for the Student Performance Analysis System.
            </p>

        </div>
        <form action="../AddTeacherServlet" method="post" enctype="multipart/form-data">
            
            <div class="row">

                <div class="col">
                    <label>Teacher Name</label>
                    <input type="text" name="tname">
                </div>

                <div class="col">
                    <label>Username</label>
                    <input type="text" name="username">
                </div>

            </div>

            <div class="row">

                <div class="col">
                    <label>Initial Password</label>
                    <input type="password" name="password" maxlength="20"
                        placeholder="Set temporary password">
                </div>

                <div class="col">
                    <label>Confirm Password</label>
                    <input type="password" name="confirmPassword" maxlength="20"
                        placeholder="Re-enter password">
                </div>

            </div>

             <div class="row">

                <div class="col">

                    <div class="upload-box">

                            <img src="../images/default_teach.png" id="preview" class="upload-preview">

                            <input type="file" name="profile" accept="image/*" onchange="previewImage(event)">

                    </div>

                </div>
            </div>

            <div class="row">

                <div class="col">
                    <label>Department</label>

                    <select name="dept">
                        <option>MCA</option>
                        <option>MSC</option>
                        <option>MA</option>
                        <option>MTECH</option>
                    </select>
                </div>

                <div class="col">
                    <label>Date Of Birth</label>
                    <input type="date" name="dob" max="<%= java.time.LocalDate.now() %>">
                </div>

            </div>

            <div class="row">

                <div class="col">
                    <label>Phone Number</label>
                    <input type="text" name="phone" maxlength="10">
                </div>

                <div class="col">
                    <label>Gender</label>

                    <select name="gender">
                        <option value="">-- Select Gender --</option>
                        <option value="Male">Male</option>
                        <option value="Female">Female</option>
                        <option value="Other">Other</option>
                    </select>
                </div>

            </div>

            <label>Address</label>
            <textarea name="addr"></textarea>

            <div class="buttons">

                <input type="reset" value="Reset" class="resetbtn">

                <input type="submit" value="Add Teacher" id="addbtn">

            </div>

            </form>
                <%
                    String error = request.getParameter("error");
                    if(error != null)
                    {
                    %>
                    <script>
                        alert("<%= error %>");
                    </script>
                    <%
                    }
                %>

                <%
                    String success = request.getParameter("success");
                    if(success != null)
                    {
                    %>
                    <script>
                        alert("<%= success %>");
                    </script>
                    <%
                    }
                %>
                    <script>
                    function previewImage(event){

                    let img=document.getElementById("preview");

                    img.src=URL.createObjectURL(event.target.files[0]);

                    }
               </script> 

    </body>
</html>