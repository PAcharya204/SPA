import java.sql.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/AddStudentServlet")
@MultipartConfig
public class AddStudentServlet extends HttpServlet
{
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException
    {
        String sname=request.getParameter("sname");
        String addr=request.getParameter("addr");
        String dept=request.getParameter("dept");
        String dob=request.getParameter("dob");
        String phone=request.getParameter("phone");
        String gender=request.getParameter("gender");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String rollno = request.getParameter("rollno");
        String semester = request.getParameter("semester");
        String section = request.getParameter("section");

        Part profilePart = request.getPart("profile");

        String profilePath = "";

        if(profilePart != null && profilePart.getSize() > 0)
        {
            String fileName =Paths.get(profilePart.getSubmittedFileName()).getFileName() .toString();
            String uploadFolder = getServletContext().getRealPath("/images/");
            File folder = new File(uploadFolder);
            if(!folder.exists())
            {
                folder.mkdirs();
            }
            profilePart.write(uploadFolder + File.separator + fileName);
            profilePath = "images/" + fileName;
        }

       if(sname == null || sname.trim().equals(""))
        {
            response.sendRedirect("admin/add_student.jsp?error=Enter Student Name");
            return;
        }
        else if(username == null || username.trim().equals(""))
        {
            response.sendRedirect("admin/add_student.jsp?error=Enter Username");
            return;
        }
        else if(!username.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$"))
        {
            response.sendRedirect("admin/add_student.jsp?error=Enter Valid Username");
            return;
        }
        else if(password == null || password.trim().equals(""))
        {
            response.sendRedirect("admin/add_student.jsp?error=Enter Password");
            return;
        }
        else if(password.length() < 8)
        {
            response.sendRedirect("admin/add_student.jsp?error=Password must contain at least 8 characters");
            return;
        }
        else if(confirmPassword == null || confirmPassword.trim().equals(""))
        {
            response.sendRedirect("admin/add_student.jsp?error=Confirm Password");
            return;
        }
        else if(!password.equals(confirmPassword))
        {
            response.sendRedirect("admin/add_student.jsp?error=Passwords do not match");
            return;
        }
        else if(profilePart == null || profilePart.getSize() == 0)
        {
            response.sendRedirect("admin/add_student.jsp?error=Select Profile Picture");
            return;
        }
        else if(!profilePart.getContentType().equals("image/jpeg")
            && !profilePart.getContentType().equals("image/png")
            && !profilePart.getContentType().equals("image/jpg"))
        {
            response.sendRedirect("admin/add_student.jsp?error=Only JPG and PNG images allowed");
            return;
        }
        else if(addr == null || addr.trim().equals(""))
        {
            response.sendRedirect("admin/add_student.jsp?error=Enter Address");
            return;
        }
        else if(dept == null || dept.trim().equals(""))
        {
            response.sendRedirect("admin/add_student.jsp?error=Select Department");
            return;
        }
        else if(dob == null || dob.trim().equals(""))
        {
            response.sendRedirect("admin/add_student.jsp?error=Select Date Of Birth");
            return;
        }
        else if(rollno == null || rollno.trim().equals(""))
        {
            response.sendRedirect("admin/add_student.jsp?error=Enter Roll Number");
            return;
        }
        else if(semester == null || semester.trim().equals(""))
        {
            response.sendRedirect("admin/add_student.jsp?error=Select Semester");
            return;
        }
        else if(section == null || section.trim().equals(""))
        {
            response.sendRedirect("admin/add_student.jsp?error=Select Section");
            return;
        }
        else if(phone == null || !phone.matches("\\d{10}"))
        {
            response.sendRedirect("admin/add_student.jsp?error=Phone Number must be exactly 10 digits");
            return;
        }
        else if(gender == null || gender.trim().equals(""))
        {
            response.sendRedirect("admin/add_student.jsp?error=Select Gender");
            return;
        }
        else
        { 
            Connection con = null;
            PreparedStatement ps = null;

            try
            {
                Class.forName("com.mysql.cj.jdbc.Driver");

                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/saps","root","");
                ps = con.prepareStatement(
                "INSERT INTO student (roll_no,s_name,s_username,s_password,s_gender,s_dob,s_phone,s_addr,s_profile,dept,semester,section) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)");
                ps.setString(1, rollno);
                ps.setString(2, sname);
                ps.setString(3, username);
                ps.setString(4, password);
                ps.setString(5, gender);
                ps.setString(6, dob);
                ps.setString(7, phone);
                ps.setString(8, addr);
                ps.setString(9, profilePath);
                ps.setString(10, dept);
                ps.setString(11, semester);
                ps.setString(12, section);
                int rows = ps.executeUpdate();
                if(rows > 0)
                {
                    response.sendRedirect("admin/add_student.jsp?success=Student Added Successfully");
                }
                else
                {
                    response.sendRedirect("admin/add_student.jsp?error=Student Not Added");
                }
            }
            catch(Exception e)
            {
                e.printStackTrace();
                response.sendRedirect("admin/add_student.jsp?error=Database Error");
            }
            finally
            {
                try
                {
                    if(ps != null)
                        ps.close();

                    if(con != null)
                        con.close();
                }
                catch(Exception e)
                {
                    e.printStackTrace();
                }
            }
        }
    }
}