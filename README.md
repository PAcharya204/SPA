# 🎓 Student Academic Portal System (SAPS)

A web-based **Student Academic Portal System** developed using **JSP, Java Servlets, MySQL, and Apache Tomcat**. The system provides dedicated portals for **Admin, Principal, Teachers, and Students** to manage academic records, attendance, and performance analytics.

---

##  Features

###  Authentication
- Role-based login (Admin, Principal, Teacher, Student)
- Session management
- CAPTCHA-secured Admin login
- PreparedStatement-based SQL queries for security

###  Admin
- Add, edit, delete students and teachers
- Profile photo upload (JPG/PNG)
- View all records
- Manage profile and password

###  Principal
- Dashboard with department-wise statistics
- Department performance analytics
- Student performance analysis
- Teacher details by department
- View all student records

###  Teacher
- Add and update student marks
- Record attendance
- Department analytics
- Individual student analysis
- View students of assigned department
- Manage profile

###  Student
- View marks and attendance
- Academic performance summary
- Update profile
- Change password

###  Analytics
- Subject-wise average marks and attendance
- Interactive Chart.js bar charts
- Top performers and low performers
- Overall grade calculation
- Student progress reports

###  Dynamic Features
- AJAX-based student and subject selection
- Responsive interface
- Profile image upload

---

##  Tech Stack

| Category | Technology |
|----------|------------|
| Frontend | JSP, HTML5, CSS3, JavaScript |
| Charts | Chart.js |
| Backend | Java Servlets, JDBC |
| Database | MySQL |
| Server | Apache Tomcat 10+ |

---

##  Project Structure

```text
SAPS/
├── admin/
├── principal/
├── teacher/
├── student/
├── servlets/
├── images/
└── WEB-INF/
```
