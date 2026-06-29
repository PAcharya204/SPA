<%@ include file="db.jsp" %>
<%@ page import="java.sql.*" %>

<%
String captcha=(String)session.getAttribute("captcha");

if(captcha==null)
{
    captcha=String.valueOf((int)(Math.random()*9000)+1000);
    session.setAttribute("captcha",captcha);
}
%>

<!DOCTYPE html>
<html>
<head>

    <title>Admin Login</title>
    <link rel="stylesheet" href="../common.css">
    <style>

        /*======================================================
                    LOGIN PAGE ONLY
    ======================================================*/

    body{
        min-height:100vh;
        display:flex;
        justify-content:center;
        align-items:center;
        background:linear-gradient(135deg,#184C85,#2E6FB2,#8BB7E8);
        padding:30px;
    }

    form{
        width:100%;
        max-width:430px;
        background:rgba(255,255,255,.96);
        border-radius:25px;
        padding:40px;
        box-shadow:0 20px 45px rgba(0,0,0,.22);
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

    .logo-section{
        text-align:center;
        margin-bottom:25px;
    }

    .subtitle{
        color:#666;
        font-size:15px;
        margin-top:5px;
    }

    /*======================================================
                        CAPTCHA
    ======================================================*/

    .captcha-box{
        display:flex;
        gap:10px;
        margin-top:10px;
    }

    #cap1{
        width:45%;
        background:#184C85;
        color:white;
        text-align:center;
        font-size:20px;
        font-weight:bold;
        letter-spacing:4px;
        border:none;
        cursor:not-allowed;
    }

    #cap2{
        width:55%;
    }

    /*======================================================
                        BUTTON GROUP
    ======================================================*/

    .btn-group{
        display:flex;
        gap:15px;
        margin-top:30px;
    }

    .btn-group input{
        flex:1;
    }

    /*======================================================
                        FOOTER
    ======================================================*/

    .footer{
        margin-top:25px;
        text-align:center;
        color:#888;
        font-size:13px;
    }

    /*======================================================
                        RESPONSIVE
    ======================================================*/

    @media(max-width:576px){

        form{
            padding:25px;
        }

        .captcha-box{
            flex-direction:column;
        }

        #cap1,
        #cap2{
            width:100%;
        }

        .btn-group{
            flex-direction:column;
        }

    }
    </style>
    
</head>

<body>

    <form method="post">
        <div class="login-logo">
            <img src="../images/logo.png" id="logo">
            <h1>ADMIN LOGIN</h1>
            <p class="subtitle">Student Performance Analysis System</p>
        </div>
        
        <label>Username</label>
        <input type="text" name="un" id="un">

        <label>Password</label>
        <input type="password" name="ps" id="ps">

        <label>Captcha</label>

        <div class="captcha-box">
            <input type="text" id="cap1" value="<%=captcha%>" disabled>
            <input type="text" id="cap2" name="cap2" placeholder="Enter Captcha">
        </div>
        <div class="btn-group">
            <input type="submit" value="Login">
            <input type="button" value="Back" onclick="location.href='../main.html'">
        </div>

        <div class="footer">
            Secure Administrator Access
        </div>
    </form>

    <%
    String username=request.getParameter("un");
    String password=request.getParameter("ps");
    String userCaptcha=request.getParameter("cap2");

    if(username!=null)
    {
        if(username.trim().equals(""))
        {
            out.println("<script>alert('Enter Email');</script>");
        }

        else if(!username.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$"))
        {
            out.println("<script>alert('Enter Valid Email Address');</script>");
        }

        else if(password==null || password.trim().equals(""))
        {
            out.println("<script>alert('Enter Password');</script>");
        }

        else if(password.length()<8)
        {
            out.println("<script>alert('Password must contain at least 8 characters');</script>");
        }

        else if(userCaptcha==null || userCaptcha.trim().equals(""))
        {
            out.println("<script>alert('Enter Captcha');</script>");
        }

        else if(!userCaptcha.equals(captcha))
        {
            out.println("<script>alert('Invalid Captcha');</script>");
        }

        else
        {
            try
            {
                PreparedStatement ps=
                con.prepareStatement(
                "select * from admin where username=? and password=?");

                ps.setString(1,username);
                ps.setString(2,password);

                ResultSet rs=ps.executeQuery();

                if(rs.next())
                {
                    session.setAttribute("admin_username",username);

                    session.removeAttribute("captcha");

                    out.println("<script>alert('Login Successful'); window.location='ad_dashboard.jsp';</script>");
                }
                else
                {
                    out.println("<script>alert('Invalid Username or Password');</script>");
                }

                rs.close();
                ps.close();
            }
            catch(Exception e)
            {
                out.println("<script>alert('Database Error');</script>");
                out.println(e.getMessage());
            }
        }
    }
    %>
</body>
</html>