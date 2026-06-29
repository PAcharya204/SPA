<%@ include file="db.jsp" %>
<%@ page import="java.sql.*" %>

<%
String s_username=(String)session.getAttribute("s_username");

if(s_username==null)
{
    response.sendRedirect("stud_login.jsp");
}
%>

<!DOCTYPE html>
<html>
<head>

    <title>Change Password</title>

    <link rel="stylesheet" href="../common.css">
<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
    <style>
        /*========== CHANGE PASSWORD COMMON ==========*/

        body{
    min-height:100vh;
    display:flex;
    justify-content:center;
    align-items:center;
    background:linear-gradient(135deg,#184C85,#2E6FB2,#8CB7E8);
    padding:30px;
}
.change-form{
    width:100%;
    max-width:480px;
    background:rgba(255,255,255,.96);
    border-radius:25px;
    padding:40px;
    box-shadow:0 20px 40px rgba(0,0,0,.18);
}

.change-logo{
    width:90px;
    height:90px;
    display:block;
    margin:auto;
    background:#fff;
    border-radius:20px;
    padding:10px;
    object-fit:contain;
    box-shadow:0 10px 25px rgba(0,0,0,.15);
    margin-bottom:20px;
}

.change-title{
    text-align:center;
    color:#184C85;
    margin-bottom:8px;
    font-size:30px;
}

.change-subtitle{
    text-align:center;
    color:#666;
    margin-bottom:30px;
}

.password-note{
    margin-top:20px;
    padding:15px;
    background:#eef5fd;
    border-left:5px solid #2E6FB2;
    border-radius:10px;
    color:#555;
    line-height:1.6;
}

.password-buttons{
    display:flex;
    gap:15px;
    margin-top:30px;
}

.password-buttons>*{
    flex:1;
}

.back-btn{
    display:flex;
    justify-content:center;
    align-items:center;
    text-decoration:none;
    background:#e8edf5;
    color:#184C85;
    border-radius:12px;
    font-weight:600;
    transition:.3s;
}

.back-btn:hover{
    background:#184C85;
    color:white;
}

.password-box{
    position:relative;
}

.toggle{
    position:absolute;
    right:15px;
    top:50%;
    transform:translateY(-50%);
    cursor:pointer;
    color:#184C85;
    user-select:none;
}

@media(max-width:600px){

    .change-form{
        padding:30px 20px;
    }

    .password-buttons{
        flex-direction:column;
    }

}
    </style>

</head>

<body>

    <form method="post" class="change-form">

        <img src="../images/logo.png" class="change-logo">

       <h2 class="change-title">Change Password</h2>

        <p class="change-subtitle">Student Account Security</p>

        <label>Current Password</label>
        <input type="password" name="oldpass">

        <label>New Password</label>
        <input type="password" name="newpass">

        <label>Confirm Password</label>
        <input type="password" name="confpass">

        <div class="password-note">
            <h4>Password Requirements</h4>

            <ul>
                <li>Minimum 8 characters</li>
                <li>Do not reuse your current password</li>
                <li>Use uppercase, lowercase, numbers and symbols</li>
            </ul>
        </div>

           <div class="password-buttons">

            <a href="stud_profile.jsp" class="back-btn">
            Back
            </a>

            <input type="submit" value="Update Password">

        </div>

    </form>

    <%

    String old=request.getParameter("oldpass");
    String np=request.getParameter("newpass");
    String cp=request.getParameter("confpass");

    if(old!=null)
    {

        if(!np.equals(cp))
        {
            out.println("<script>alert('Passwords do not match');</script>");
        }
        else if(np.length()<8)
        {
            out.println("<script>alert('Password must be at least 8 characters');</script>");
        }
        else if(np.equals(old))
        {
            out.println("<script>alert('New password cannot be the same as the old password');</script>");
        }
        else
        {
            try
            {

                PreparedStatement ps=
                con.prepareStatement(
                "select s_password from student where s_username=?");

                ps.setString(1,s_username);

                ResultSet rs=ps.executeQuery();

                if(rs.next())
                {
                    String dbpass=rs.getString("s_password");

                    if(dbpass.equals(old))
                    {

                        PreparedStatement ps2=con.prepareStatement("update student set s_password=? where s_username=?");

                        ps2.setString(1,np);
                        ps2.setString(2,s_username);

                        int x=ps2.executeUpdate();

                        if(x>0)
                        {
                            out.println("<script>alert('Password Updated Successfully');window.location='stud_profile.jsp';</script>");
                        }

                        ps2.close();

                    }
                    else
                    {
                        out.println("<script>alert('Current Password Incorrect');</script>");
                    }
                }

                rs.close();
                ps.close();

            }
            catch(Exception e)
            {
                out.println(e.getMessage());
            }
        }

    }

    %>
    <script>
    document.querySelectorAll("input[type=password]").forEach(function(box){

        box.insertAdjacentHTML(
            "afterend",
            '<span class="toggle" onclick="toggle(this)">👁</span>'
        );

    });

    function toggle(ele){

        let input=ele.previousElementSibling;

        if(input.type==="password"){

            input.type="text";
            ele.innerHTML="🙈";

        }else{

            input.type="password";
            ele.innerHTML="👁";

        }

    }
    </script>
</body>
</html>