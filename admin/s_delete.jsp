<%@ include file="db.jsp" %>
<%@ page import="java.sql.*" %>
<%
String admin_username=(String)session.getAttribute("admin_username");
if(admin_username==null)
{
    response.sendRedirect("ad_log.jsp");
}

String idParam=request.getParameter("id");

if(idParam==null)
{
    response.sendRedirect("view_student.jsp");
    return;
}

int id=Integer.parseInt(idParam);


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
    <title>Delete Student</title>
    <style>
  *{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:'Segoe UI',Arial,sans-serif;
}

body{
    background:linear-gradient(135deg,#eef4fb,#dce8f7,#eef4fb);
    overflow-x:hidden;
}

/*================ HEADER ================*/

header{
    height:80px;
    background:linear-gradient(90deg,#184C85,#2E6FB2);
    display:flex;
    justify-content:space-between;
    align-items:center;
    padding:0 35px;
    color:white;
    position:sticky;
    top:0;
    z-index:999;
    box-shadow:0 8px 20px rgba(0,0,0,.18);
}

.logo-section{
    display:flex;
    align-items:center;
    gap:15px;
}

#logo{
    width:60px;
    height:60px;
    background:white;
    border-radius:18px;
    padding:8px;
    object-fit:contain;
    box-shadow:0 5px 18px rgba(0,0,0,.2);
}

.logo-section h1{
    font-size:28px;
    letter-spacing:1px;
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

/*================ SIDEBAR ================*/

#sidebar{
    position:fixed;
    top:80px;
    left:0;
    width:250px;
    height:100vh;
    background:linear-gradient(180deg,#184C85,#245f9d,#2E6FB2);
    padding-top:20px;
    box-shadow:5px 0 15px rgba(0,0,0,.15);
}

#sidebar div{
    margin:8px 12px;
}

#sidebar a{
    display:block;
    padding:16px 18px;
    color:white;
    text-decoration:none;
    border-radius:12px;
    font-weight:600;
    transition:.3s;
}

#sidebar a:hover{
    background:rgba(255,255,255,.15);
    transform:translateX(8px);
}

/*================ MAIN ================*/

#main{
    margin-left:270px;
    padding:40px;
}

/*================ DELETE CARD ================*/

form{
    max-width:700px;
    margin:auto;
    background:white;
    border-radius:25px;
    padding:45px;
    text-align:center;
    box-shadow:0 15px 35px rgba(0,0,0,.08);
    animation:fade .5s ease;
}

@keyframes fade{

from{

opacity:0;

transform:translateY(30px);

}

to{

opacity:1;

transform:translateY(0);

}

}

.warning-icon{
    font-size:80px;
    color:#dc3545;
    margin-bottom:20px;
}

form h2{
    color:#dc3545;
    margin-bottom:15px;
    font-size:30px;
}

.warning-text{
    color:#666;
    font-size:17px;
    line-height:1.8;
    margin-bottom:30px;
}

.student-id{
    display:inline-block;
    padding:12px 30px;
    border-radius:12px;
    background:#eef4fb;
    color:#184C85;
    font-size:18px;
    font-weight:700;
    margin-bottom:35px;
}

/*================ BUTTONS ================*/

.button-group{
    display:flex;
    gap:20px;
}

#addbtn{
    flex:1;
    padding:15px;
    border:none;
    border-radius:12px;
    background:linear-gradient(90deg,#dc3545,#c82333);
    color:white;
    font-size:16px;
    font-weight:600;
    cursor:pointer;
    transition:.3s;
}

#addbtn:hover{
    transform:translateY(-4px);
    box-shadow:0 10px 25px rgba(220,53,69,.35);
}

#backbtn{
    flex:1;
    padding:15px;
    border:none;
    border-radius:12px;
    background:#e8edf5;
    color:#184C85;
    font-size:16px;
    font-weight:600;
    cursor:pointer;
    transition:.3s;
}

#backbtn:hover{
    background:#184C85;
    color:white;
    transform:translateY(-4px);
}

/*================ RESPONSIVE ================*/

@media(max-width:900px){

#sidebar{
width:210px;
}

#main{
margin-left:230px;
}

}

@media(max-width:768px){

header{
padding:0 15px;
}

.logo-section h1{
font-size:20px;
}

#logo{
width:48px;
height:48px;
}

#sidebar{
display:none;
}

#main{
margin-left:0;
padding:20px;
}

.button-group{
flex-direction:column;
}

form{
padding:30px;
}

}

@media(max-width:576px){

.warning-icon{
font-size:60px;
}

form h2{
font-size:24px;
}

.warning-text{
font-size:15px;
}

#profile-section a{
display:none;
}

}
</style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">

    </head>
    <body>
        <header>

            <div class="logo-section">
                <img src="../images/logo.png" id="logo">
                <h1>DELETE STUDENT</h1>
            </div>

            <div id="profile-section">
                <img src="<%=photo%>" id="profile-pic">
                <a href="ad_profile.jsp"><%=name%></a>
            </div>

        </header>
        <div id="sidebar">

        <div><a href="ad_dashboard.jsp"><i class="fa-solid fa-house"></i>&nbsp;&nbsp;DASHBOARD</a></div>

        <div><a href="add_teacher.jsp"><i class="fa-solid fa-user-plus"></i>&nbsp;&nbsp;ADD TEACHER</a></div>

        <div><a href="view_teacher.jsp"><i class="fa-solid fa-users"></i>&nbsp;&nbsp;VIEW TEACHERS</a></div>

        <div><a href="add_student.jsp"><i class="fa-solid fa-graduation-cap"></i>&nbsp;&nbsp;ADD STUDENT</a></div>

        <div><a href="view_student.jsp"><i class="fa-solid fa-user-graduate"></i>&nbsp;&nbsp;VIEW STUDENTS</a></div>

        </div>

        <div id="main">
           <form method="post">

                <div class="warning-icon"></div>
                    <h2>Delete Student</h2>
                    <p class="warning-text">You are about to permanently remove this student's account from theStudent Performance Analysis System.
                    <br><br>
                    This action cannot be undone.</p>
                <div class="student-id">
                    Student ID : <%=id%>
                </div>

                <div class="button-group">

                    <input type="submit" id="addbtn" value=" Delete Student">

                    <input type="button" id="backbtn" value=" Cancel" onclick="location.href='view_student.jsp'">

                </div>

            </form>

            <%
                if(request.getMethod().equalsIgnoreCase("POST"))
                {
                        try
                        {
                            PreparedStatement ps=con.prepareStatement("delete from student where sid=?");
                            ps.setInt(1,id);
                            int rows=ps.executeUpdate();

                            if(rows>0)
                            {
                                out.println(
                                "<script>alert('Student Deleted Successfully');window.location='view_student.jsp';</script>");
                            }
                            else
                            {
                                out.println(
                                "<script>alert('Student Not Deleted');</script>");
                            }

                            ps.close();
                            con.close();
                        }
                        catch(Exception e)
                        {
                            out.println(
                            "<script>alert('Database Error');</script>");
                            out.println(e.getMessage());
                        }
                    }
            %>
        </div>
    </body>
</html>