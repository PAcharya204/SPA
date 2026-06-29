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

<%
String idParam=request.getParameter("id");

if(idParam==null)
{
    response.sendRedirect("view_student.jsp");
    return;
}

int id=Integer.parseInt(idParam);

String sname="";
String username="";
String password="";
String profile="";
String dept="";
String dob="";
String phone="";
String gender="";
String addr="";
String rollno="";
int semester=0;
String section="";

try
{
    PreparedStatement ps=con.prepareStatement("select * from student where sid=?");

    ps.setInt(1,id);

    ResultSet rs=ps.executeQuery();

    if(rs.next())
    {
        sname=rs.getString("s_name");
        username=rs.getString("s_username");
        password=rs.getString("s_password");
        profile=rs.getString("s_profile");
        dept=rs.getString("dept");
        dob=rs.getString("s_dob");
        phone=rs.getString("s_phone");
        gender=rs.getString("s_gender");
        addr=rs.getString("s_addr");
        rollno=rs.getString("roll_no");
        semester=rs.getInt("semester");
        section=rs.getString("section");
    }

    rs.close();
    ps.close();
    }
    catch(Exception e)
    {
        out.println(e.getMessage());
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Student</title>
    <style>
       .student-photo{
    width:150px;
    height:150px;
    border-radius:50%;
    object-fit:cover;
    border:4px solid #2E6FB2;
    background:#fff;
    box-shadow:0 10px 20px rgba(0,0,0,.15);
}

.info-card p{
    font-size:22px;
    font-weight:700;
}
</style>
<link rel="stylesheet" href="../common.css">
<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
    </head>
    <body>
        <header>

            <div class="logo-section">
                <img src="../images/logo.png" id="logo">
                <h1>EDIT STUDENT</h1>
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
            <div class="page-header">
                <h2>Edit Student Information</h2>
                <p>Update the student's academic and personal information.</p>
            </div>
            <div class="info-card">

                <div>
                    <h3>Student ID</h3>
                    <p><%=id%></p>
                </div>

                <div>
                    <h3>Department</h3>
                    <p><%=dept%></p>
                </div>

                <div>
                    <h3>Status</h3>
                    <p>Active</p>
                </div>

            </div>
            <form method="post" class="form-card">

                <div class="row">

                    <div class="col">
                        <label>Student Name</label>
                        <input type="text" name="sname" value="<%=sname%>">
                    </div>

                    <div class="col">
                        <label>Username</label>
                        <input type="email" name="username" value="<%=username%>" readonly>
                    </div>

                </div>

                <div class="row">

                    <div class="col">
                        <label>Initial Password</label>
                        <input type="password" value="<%=password%>" readonly>

                    </div>
                    <div class="col">
                        <label>Profile Picture</label><br>
                        <img src="../<%=profile%>" class="student-photo">            
                    </div>

                </div>
                <div class="row">

                    <div class="col">
                        <label>Roll Number</label>
                        <input type="text" name="rollno" value="<%=rollno%>" readonly>
                    </div>

                    <div class="col">
                        <label>Semester</label>

                        <select name="semester">
                            <option value="1" <%=semester==1?"selected":""%>>1</option>
                            <option value="2" <%=semester==2?"selected":""%>>2</option>
                            <option value="3" <%=semester==3?"selected":""%>>3</option>
                            <option value="4" <%=semester==4?"selected":""%>>4</option>
                        </select>

                    </div>

                </div>

                <div class="row">

                    <div class="col">
                        <label>Section</label>

                        <select name="section">
                            <option value="A" <%=section.equals("A")?"selected":""%>>A</option>
                            <option value="B" <%=section.equals("B")?"selected":""%>>B</option>
                            <option value="C" <%=section.equals("C")?"selected":""%>>C</option>
                        </select>

                    </div>

                </div>

                <div class="row">

                    <div class="col">
                        <label>Department</label>
                        <select name="dept">
                            <option value="MCA" <%=dept.equals("MCA")?"selected":""%>> MCA </option>
                            <option value="MSC" <%=dept.equals("MSC")?"selected":""%>> MSC </option>
                            <option value="MA" <%=dept.equals("MA")?"selected":""%>> MA </option>
                            <option value="MTECH" <%=dept.equals("MTECH")?"selected":""%>> MTECH </option>
                        </select>
                    </div>

                    <div class="col">
                        <label>Date Of Birth</label>
                        <input type="date" name="dob" value="<%=dob%>" max="<%= java.time.LocalDate.now() %>">
                    </div>
                </div>

                <div class="row">
                    <div class="col">
                        <label>Phone Number</label>
                        <input type="text" name="phone" value="<%=phone%>" maxlength="10">
                    </div>

                    <div class="col">
                        <label>Gender</label>
                        <select name="gender">
                            <option value="Male" <%=gender.equals("Male")?"selected":""%>> Male </option>
                            <option value="Female" <%=gender.equals("Female")?"selected":""%>> Female </option>
                            <option value="Other" <%=gender.equals("Other")?"selected":""%>> Other </option>
                        </select>
                    </div>
                </div>
                <label>Address</label>
                <textarea name="addr"><%=addr%></textarea>
                <br><br>
                <div class="button-group">
                    <input type="submit" class="primary-btn" value=" UPDATE STUDENT">
                    <input type="button" class="secondary-btn"" value=" BACK" onclick="location.href='view_student.jsp'">
                </div>
            </form>

            <%
                if(request.getMethod().equalsIgnoreCase("POST"))
                {
                    String newSname=request.getParameter("sname");
                    String newDept=request.getParameter("dept");
                    String newDob=request.getParameter("dob");
                    String newPhone=request.getParameter("phone");
                    String newGender=request.getParameter("gender");
                    String newAddr=request.getParameter("addr");
                    String newRollno=request.getParameter("rollno");
                    String newSemester=request.getParameter("semester");
                    String newSection=request.getParameter("section");

                    if(newSname.trim().equals(""))
                    {
                        out.println("<script>alert('Enter Student Name');</script>");
                    }
                    else if(newPhone.length()!=10)
                    {
                        out.println("<script>alert('Phone Number Must Be 10 Digits');</script>");
                    }
                    else if(newAddr.trim().equals(""))
                    {
                        out.println("<script>alert('Enter Address');</script>");
                    }
                    else
                    {
                        try
                        {
                            PreparedStatement ps = con.prepareStatement(
                            "UPDATE student SET roll_no=?, s_name=?, dept=?, semester=?, section=?, s_dob=?, s_phone=?, s_gender=?, s_addr=? WHERE sid=?");

                            ps.setString(1,newRollno);
                            ps.setString(2,newSname);
                            ps.setString(3,newDept);
                            ps.setInt(4,Integer.parseInt(newSemester));
                            ps.setString(5,newSection);
                            ps.setString(6,newDob);
                            ps.setString(7,newPhone);
                            ps.setString(8,newGender);
                            ps.setString(9,newAddr);
                            ps.setInt(10,id);

                            int rows=ps.executeUpdate();

                            if(rows>0)
                            {
                                out.println(
                                "<script>alert('Student Updated Successfully');window.location='view_student.jsp';</script>");
                            }
                            else
                            {
                                out.println(
                                "<script>alert('Student Not Updated');</script>");
                            }

                            ps.close();
                        }
                        catch(Exception e)
                        {
                            out.println(
                            "<script>alert('Database Error');</script>");
                            out.println(e.getMessage());
                        }
                    }
                }
            %>
        </div>
    </body>
</html>