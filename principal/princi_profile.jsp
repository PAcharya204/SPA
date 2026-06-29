<%@ include file="db.jsp" %>
<%@ page import="java.sql.*" %>

<%
String p_username=(String)session.getAttribute("p_username");

if(p_username==null)
{
    response.sendRedirect("princi_login.jsp");
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

<title>Principal Profile</title>


<link rel="stylesheet" href="../common.css">
<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
</head>
<style>

    /*======================================================
                    PROFILE PAGES
    ======================================================*/

    .profile-card{
        width:100%;
        max-width:900px;
        margin:auto;
        background:#fff;
        border-radius:25px;
        padding:40px;
        box-shadow:0 15px 35px rgba(0,0,0,.08);
    }

    .profile-photo{
        width:170px;
        height:170px;
        display:block;
        margin:auto;
        object-fit:cover;
        border-radius:50%;
        border:6px solid #2F72B7;
        padding:5px;
        background:#fff;
        box-shadow:0 10px 30px rgba(0,0,0,.20);
    }

    .profile-title{
        text-align:center;
        margin-top:20px;
        color:#184C85;
        font-size:32px;
    }

    .profile-role{
        text-align:center;
        color:#666;
        margin-bottom:30px;
        font-size:16px;
    }

    /* Status Cards */

    .status-grid{
        display:grid;
        grid-template-columns:repeat(auto-fit,minmax(220px,1fr));
        gap:20px;
        margin:30px 0;
    }

    .status-item{
        background:linear-gradient(135deg,#2D6FAF,#4C8CD1);
        color:white;
        border-radius:18px;
        padding:25px;
        text-align:center;
        box-shadow:0 10px 25px rgba(0,0,0,.12);
    }

    .status-item h3{
        font-size:18px;
        margin-bottom:10px;
    }

    .status-item p{
        font-size:20px;
        font-weight:600;
    }

    /* Profile Table */

    .profile-table{
        width:100%;
        border-collapse:separate;
        border-spacing:0 10px;
    }

    .profile-table tr{
        background:#f6f9fd;
        transition:.3s;
    }

    .profile-table tr:hover{
        background:#edf4fb;
    }

    .profile-table td{
        padding:18px;
        font-size:15px;
    }

    .profile-table td:first-child{
        width:240px;
        color:#184C85;
        font-weight:700;
    }

    /* Buttons */

    .profile-buttons{
        text-align:center;
    }

    .logout-btn{
        display:inline-block;
        background:linear-gradient(90deg,#d63031,#e74c3c);
        color:#fff;
        padding:14px 28px;
        border-radius:10px;
        text-decoration:none;
        font-weight:600;
        transition:.3s;
    }

    .logout-btn:hover{
        transform:translateY(-3px);
    }

    .action-btn{
        display:inline-block;
        background:linear-gradient(90deg,#2C67A8,#4D8DD0);
        color:#fff;
        padding:14px 28px;
        border-radius:10px;
        text-decoration:none;
        font-weight:600;
        transition:.3s;
    }

    .action-btn:hover{
        transform:translateY(-3px);
    }

    /* Responsive */

    @media(max-width:768px){

        .profile-photo{
            width:130px;
            height:130px;
        }

        .profile-card{
            padding:25px;
        }

        .profile-table td{
            display:block;
            width:100%;
        }

    }

    @media(max-width:600px){

        .status-grid{
            grid-template-columns:1fr;
        }

    }

    </style>
<body>

<header>

    <div class="logo-section">
        <img src="../images/logo.png" id="logo">
        <h1>PRINCIPAL PROFILE</h1>
    </div>

    <div id="profile-section">
        <img src="<%=photo%>" id="profile-pic">
        <a href="princi_profile.jsp"><%=name%></a>
    </div>

</header>
<hr>
<div id="sidebar">

    <div><a href="princi_dashboard.jsp"><i class="fa-solid fa-house"></i>&nbsp;&nbsp;DASHBOARD</a></div>

    <div><a href="view_student.jsp"><i class="fa-solid fa-user-plus"></i>&nbsp;&nbsp;STUDENT DETAILS</a></div>

    <div><a href="tea_ana.jsp"><i class="fa-solid fa-users"></i>&nbsp;&nbsp;TEACHER DETAILS</a></div>

    <div><a href="dept_ana.jsp"><i class="fa-solid fa-graduation-cap"></i>&nbsp;&nbsp;DEPARTMENT DETAILS</a></div>

</div>

<div id="main">
        <%
            try
                {
                    PreparedStatement ps=con.prepareStatement("select * from principal where p_username=?");
                    ps.setString(1,p_username);
                    ResultSet rs=ps.executeQuery();
                    while(rs.next())
                    {
                        
                %>
                <div class="profile-card">

                    <img src="<%=photo%>" class="profile-photo">

                    <h2 class="profile-title"><%=rs.getString("p_name")%></h2>
                    <p class="profile-role">Principal</p>

                    <div class="status-grid">
                        <div class="status-item">
                            <h3>Account Status</h3>
                            <p>Active</p>
                        </div>

                        <div class="status-item">
                            <h3>Access Level</h3>
                            <p>Principal</p>
                        </div>
                    </div>
                    <table class="profile-table">

                        <tr>
                            <td><b>Principal ID</b></td>
                            <td><%=rs.getInt("pid")%></td>
                        </tr>

                        <tr>
                            <td><b>Username</b></td>
                            <td><%=rs.getString("p_username")%></td>
                        </tr>

                        <tr>
                            <td><b>Date Of Birth</b></td>
                            <td><%=rs.getString("p_dob")%></td>
                        </tr>

                        <tr>
                            <td><b>Phone</b></td>
                            <td><%=rs.getString("p_phone")%></td>
                        </tr>

                        <tr>
                            <td><b>Gender</b></td>
                            <td><%=rs.getString("p_gender")%></td>
                        </tr>

                        <tr>
                            <td><b>Address</b></td>
                            <td><%=rs.getString("p_addr")%></td>
                        </tr>


                    </table>
                    <div class="profile-buttons">

                        <a href="princi_change_pass.jsp" class="action-btn">
                            <i class="fa-solid fa-key"></i>
                            Change Password
                        </a>

                        <a href="#" class="logout-btn" onclick="confirmLogout()">
                            <i class="fa-solid fa-right-from-bracket"></i>
                            Logout
                        </a>

                    </div>

                </div>
                <%
                    }
                rs.close();
                    ps.close();
                    con.close();
                }
                catch(Exception e)
                {
                    out.println(e.getMessage());
                }
                %>
            <script>
            function confirmLogout()
            {
                let choice=confirm(
                    "Do you really want to logout from the Principal Panel?"
                );

                if(choice)
                {
                    window.location="princi_logout.jsp";
                }
            }
            </script>
        
</div>
</body>
</html>