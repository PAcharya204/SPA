
<%@ include file="db.jsp" %>
<%@ page import="java.sql.*" %>

<%
    /*------------------------Session Check------------------------*/
    String p_username = (String) session.getAttribute("p_username");

    if (p_username == null) {
        response.sendRedirect("p_login.jsp");
        return;
    }

    /*------------------------Principal Name------------------------*/
    String name = "";
    try {
        PreparedStatement psName = con.prepareStatement(
            "SELECT p_name FROM principal WHERE p_username=?"
        );
        psName.setString(1, p_username);
        ResultSet rsName = psName.executeQuery();
        if (rsName.next()) {
            name = rsName.getString("p_name");
        }
        rsName.close();
        psName.close();
    } catch (Exception e) {
        out.println(e.getMessage());
    }

    /*------------------------Profile Image------------------------*/
    String photo = "../images/princi_pic.jpg";
    try {
        PreparedStatement psPhoto = con.prepareStatement(
            "SELECT p_profile FROM principal WHERE p_username=?"
        );
        psPhoto.setString(1, p_username);
        ResultSet rsPhoto = psPhoto.executeQuery();
        if (rsPhoto.next()) {
            String dbPhoto = rsPhoto.getString("p_profile");
            if (dbPhoto != null && !dbPhoto.trim().equals("")) {
                photo = "../" + dbPhoto;
            }
        }
        rsPhoto.close();
        psPhoto.close();
    } catch (Exception e) {
        out.println(e.getMessage());
    }

    /*------------------------Department & Semester from Form------------------------*/
    String selectedDept = request.getParameter("department");
    String semester     = request.getParameter("semester");

    if (selectedDept == null || selectedDept.trim().equals("")) {
        selectedDept = "MCA";
    }
    if (semester == null || semester.trim().equals("")) {
        semester = "1";
    }

    int semInt = Integer.parseInt(semester);

    /*------------------------Summary Stats------------------------*/
    int    totalStudents  = 0;
    double avgMarks       = 0;
    double avgAttendance  = 0;
    String overallGrade   = "C";
    String performance    = "";
    String remark         = "";

    try {
        /*-- Total Students --*/
        PreparedStatement psStudents = con.prepareStatement(
            "SELECT COUNT(*) " +
            "FROM student " +
            "WHERE dept=? AND semester=?"
        );
        psStudents.setString(1, selectedDept);
        psStudents.setInt(2, semInt);
        ResultSet rsStudents = psStudents.executeQuery();
        if (rsStudents.next()) {
            totalStudents = rsStudents.getInt(1);
        }
        rsStudents.close();
        psStudents.close();

        /*-- Average Marks --*/
        PreparedStatement psMarks = con.prepareStatement(
            "SELECT AVG(m.total_marks) " +
            "FROM marks m " +
            "INNER JOIN student s ON m.sid = s.sid " +
            "WHERE s.dept=? AND s.semester=?"
        );
        psMarks.setString(1, selectedDept);
        psMarks.setInt(2, semInt);
        ResultSet rsMarks = psMarks.executeQuery();
        if (rsMarks.next()) {
            avgMarks = rsMarks.getDouble(1);
        }
        rsMarks.close();
        psMarks.close();

        /*-- Average Attendance --*/
        PreparedStatement psAtt = con.prepareStatement(
            "SELECT AVG(a.attendance_percent) " +
            "FROM attendance a " +
            "INNER JOIN student s ON a.sid = s.sid " +
            "WHERE s.dept=? AND s.semester=?"
        );
        psAtt.setString(1, selectedDept);
        psAtt.setInt(2, semInt);
        ResultSet rsAtt = psAtt.executeQuery();
        if (rsAtt.next()) {
            avgAttendance = rsAtt.getDouble(1);
        }
        rsAtt.close();
        psAtt.close();

    } catch (Exception e) {
        out.println(e.getMessage());
    }

    /*------------------------Grade Logic------------------------*/
    if      (avgMarks >= 90) overallGrade = "O";
    else if (avgMarks >= 80) overallGrade = "A+";
    else if (avgMarks >= 70) overallGrade = "A";
    else if (avgMarks >= 60) overallGrade = "B+";
    else if (avgMarks >= 50) overallGrade = "B";
    else                     overallGrade = "C";

    /*------------------------Performance & Remark------------------------*/
    if (avgMarks >= 85 && avgAttendance >= 90) {
        performance = "Excellent";
        remark = "Students are performing exceptionally well in both academics and attendance.";
    } else if (avgMarks >= 70 && avgAttendance >= 80) {
        performance = "Very Good";
        remark = "Department performance is good. Continue maintaining the current progress.";
    } else if (avgMarks >= 60 && avgAttendance >= 75) {
        performance = "Good";
        remark = "Department performance is satisfactory. Focus on improving academic results.";
    } else {
        performance = "Needs Improvement";
        remark = "Special attention is required to improve marks and attendance.";
    }

    /*------------------------Chart Data------------------------*/
    StringBuilder subjectLabels     = new StringBuilder();
    StringBuilder avgMarksData      = new StringBuilder();
    StringBuilder avgAttendanceData = new StringBuilder();

    try {
        PreparedStatement psChart = con.prepareStatement(
            "SELECT s.subject_name, " +
            "    COALESCE(AVG(m.total_marks), 0)          AS avg_marks, " +
            "    COALESCE(AVG(a.attendance_percent), 0)   AS avg_attendance " +
            "FROM subject s " +
            "LEFT JOIN marks m      ON s.subid = m.subid " +
            "LEFT JOIN attendance a ON a.sid = m.sid AND a.subid = m.subid " +
            "WHERE s.department=? AND s.semester=? " +
            "GROUP BY s.subid, s.subject_name " +
            "ORDER BY s.subject_name"
        );
        psChart.setString(1, selectedDept);
        psChart.setInt(2, semInt);
        ResultSet rsChart = psChart.executeQuery();

        while (rsChart.next()) {
            subjectLabels.append("'")
                         .append(rsChart.getString("subject_name"))
                         .append("',");
            avgMarksData.append(
                String.format("%.2f", rsChart.getDouble("avg_marks"))
            ).append(",");
            avgAttendanceData.append(
                String.format("%.2f", rsChart.getDouble("avg_attendance"))
            ).append(",");
        }
        rsChart.close();
        psChart.close();
    } catch (Exception e) {
        out.println(e.getMessage());
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Departmental Analytics</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
    <link rel="stylesheet" href="../common.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
       
    </style>
</head>

<body>

    <%-- ==================== HEADER ==================== --%>
    <header>
        <div class="logo-section">
            <img src="../images/logo.png" id="logo">
            <h1>DEPARTMENT ANALYTICS</h1>
        </div>
        <div id="profile-section">
            <img src="<%= photo %>" id="profile-pic">
            <a href="princi_profile.jsp"><%= name %></a>
        </div>
    </header>

    <%-- ==================== SIDEBAR ==================== --%>
    <div id="sidebar">
        <div><a href="princi_dashboard.jsp"><i class="fa-solid fa-house"></i>&nbsp;&nbsp;DASHBOARD</a></div>
        <div><a href="view_student.jsp"><i class="fa-solid fa-user-plus"></i>&nbsp;&nbsp;STUDENT DETAILS</a></div>
        <div><a href="tea_ana.jsp"><i class="fa-solid fa-users"></i>&nbsp;&nbsp;TEACHER DETAILS</a></div>
        <div><a href="dept_ana.jsp"><i class="fa-solid fa-graduation-cap"></i>&nbsp;&nbsp;DEPARTMENT DETAILS</a></div>
    </div>

    <%-- ==================== MAIN ==================== --%>
    <div id="main">

        <%-- Page Title --%>
        <div class="page-header">
            <h2>Departmental Analytics</h2>
            <p>Select a department and semester to view analytics.</p>
        </div>

        <%-- ---- Filter Form ---- --%>
        <form method="get">
            <div class="form-grid">
                <div>
                    <label>Department</label>
                    <select name="department" onchange="this.form.submit()">
                        <option value="MCA"   <%= selectedDept.equals("MCA")   ? "selected" : "" %>>MCA</option>
                        <option value="MSC"   <%= selectedDept.equals("MSC")   ? "selected" : "" %>>MSC</option>
                        <option value="MA"    <%= selectedDept.equals("MA")    ? "selected" : "" %>>MA</option>
                        <option value="MTECH" <%= selectedDept.equals("MTECH") ? "selected" : "" %>>MTECH</option>
                    </select>
                </div>
                <div>
                    <label>Semester</label>
                    <select name="semester" onchange="this.form.submit()">
                        <%
                            for (int i = 1; i <= 4; i++) {
                                String sel = semester.equals(String.valueOf(i)) ? "selected" : "";
                        %>
                        <option value="<%= i %>" <%= sel %>>Semester <%= i %></option>
                        <%
                            }
                        %>
                    </select>
                </div>
            </div>
        </form>

        <%-- ---- Summary Cards ---- --%>
        <div class="dashboard-grid">
            <div class="card">
                <h3>Total Students</h3>
                <h1><%= totalStudents %></h1>
                <p>Department Strength</p>
            </div>
            <div class="card">
                <h3>Average Marks</h3>
                <h1><%= String.format("%.2f", avgMarks) %></h1>
                <p>Department Average</p>
            </div>
            <div class="card">
                <h3>Attendance</h3>
                <h1><%= String.format("%.2f", avgAttendance) %>%</h1>
                <p>Average Attendance</p>
            </div>
            <div class="card">
                <h3>Overall Grade</h3>
                <h1><%= overallGrade %></h1>
                <p>Department Grade</p>
            </div>
        </div>

        <%-- ---- Charts ---- --%>
        <div class="chart-grid">
            <div class="chart-card">
                <h3>Average Marks by Subject</h3>
                <canvas id="marksChart"></canvas>
            </div>
            <div class="chart-card">
                <h3>Average Attendance by Subject</h3>
                <canvas id="attendanceChart"></canvas>
            </div>
        </div>

        <script>
            const labels     = [ <%= subjectLabels.toString() %> ];
            const marks      = [ <%= avgMarksData.toString() %> ];
            const attendance = [ <%= avgAttendanceData.toString() %> ];

            new Chart(document.getElementById("marksChart"), {
                type: "bar",
                data: {
                    labels: labels,
                    datasets: [{
                        label: "Average Marks",
                        data: marks,
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    plugins: { legend: { display: false } },
                    scales: { y: { beginAtZero: true, max: 100 } }
                }
            });

            new Chart(document.getElementById("attendanceChart"), {
                type: "bar",
                data: {
                    labels: labels,
                    datasets: [{
                        label: "Average Attendance",
                        data: attendance,
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    plugins: { legend: { display: false } },
                    scales: { y: { beginAtZero: true, max: 100 } }
                }
            });
        </script>
        <br>
        <%-- ---- Subject Wise Statistics ---- --%>
        <div class="table-container">
            <h3 class="section-title">Subject Wise Statistics</h3>
            <table>
                <thead>
                    <tr>
                        <th>Subject</th>
                        <th>Avg Internal</th>
                        <th>Avg External</th>
                        <th>Avg Total</th>
                        <th>Avg Attendance</th>
                        <th>Highest</th>
                        <th>Lowest</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try {
                            PreparedStatement psTable = con.prepareStatement(
                                "SELECT s.subject_name, " +
                                "    AVG(m.internal_marks)       AS avg_internal, " +
                                "    AVG(m.external_marks)       AS avg_external, " +
                                "    AVG(m.total_marks)          AS avg_total, " +
                                "    AVG(a.attendance_percent)   AS avg_attendance, " +
                                "    MAX(m.total_marks)          AS highest_marks, " +
                                "    MIN(m.total_marks)          AS lowest_marks " +
                                "FROM subject s " +
                                "LEFT JOIN marks m      ON s.subid = m.subid " +
                                "LEFT JOIN attendance a ON a.sid = m.sid AND a.subid = m.subid " +
                                "LEFT JOIN student st   ON st.sid = m.sid " +
                                "WHERE s.department=? AND s.semester=? " +
                                "GROUP BY s.subid, s.subject_name " +
                                "ORDER BY s.subject_name"
                            );
                            psTable.setString(1, selectedDept);
                            psTable.setInt(2, semInt);
                            ResultSet rsTable = psTable.executeQuery();

                            while (rsTable.next()) {
                    %>
                    <tr>
                        <td><strong><%= rsTable.getString("subject_name") %></strong></td>
                        <td><%= String.format("%.2f", rsTable.getDouble("avg_internal")) %></td>
                        <td><%= String.format("%.2f", rsTable.getDouble("avg_external")) %></td>
                        <td><strong><%= String.format("%.2f", rsTable.getDouble("avg_total")) %></strong></td>
                        <td><%= String.format("%.2f", rsTable.getDouble("avg_attendance")) %>%</td>
                        <td><%= String.format("%.0f", rsTable.getDouble("highest_marks")) %></td>
                        <td><%= String.format("%.0f", rsTable.getDouble("lowest_marks")) %></td>
                    </tr>
                    <%
                            }
                            rsTable.close();
                            psTable.close();
                        } catch (Exception e) {
                            out.println(e.getMessage());
                        }
                    %>
                </tbody>
            </table>
        </div>
        <br>
        <%-- ---- Top 10 Students ---- --%>
        <div class="table-container">
            <h3 class="section-title">Top 10 Students</h3>
            <table>
                <thead>
                    <tr>
                        <th>Rank</th>
                        <th>Roll No</th>
                        <th>Student Name</th>
                        <th>Average Marks</th>
                        <th>Average Attendance</th>
                        <th>Grade</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try {
                            PreparedStatement psTop = con.prepareStatement(
                                "SELECT s.roll_no, s.s_name, " +
                                "    AVG(m.total_marks)        AS avg_marks, " +
                                "    AVG(a.attendance_percent) AS avg_attendance " +
                                "FROM student s " +
                                "LEFT JOIN marks m      ON s.sid = m.sid " +
                                "LEFT JOIN attendance a ON s.sid = a.sid " +
                                "WHERE s.dept=? AND s.semester=? " +
                                "GROUP BY s.sid, s.roll_no, s.s_name " +
                                "ORDER BY AVG(m.total_marks) DESC " +
                                "LIMIT 10"
                            );
                            psTop.setString(1, selectedDept);
                            psTop.setInt(2, semInt);
                            ResultSet rsTop = psTop.executeQuery();
                            int rank = 1;

                            while (rsTop.next()) {
                                double topMarks = rsTop.getDouble("avg_marks");
                                String topGrade = "C";
                                if      (topMarks >= 90) topGrade = "O";
                                else if (topMarks >= 80) topGrade = "A+";
                                else if (topMarks >= 70) topGrade = "A";
                                else if (topMarks >= 60) topGrade = "B+";
                                else if (topMarks >= 50) topGrade = "B";
                    %>
                    <tr>
                        <td><strong><%= rank %></strong></td>
                        <td><%= rsTop.getString("roll_no") %></td>
                        <td><%= rsTop.getString("s_name") %></td>
                        <td><%= String.format("%.2f", topMarks) %></td>
                        <td><%= String.format("%.2f", rsTop.getDouble("avg_attendance")) %>%</td>
                        <td><%= topGrade %></td>
                    </tr>
                    <%
                                rank++;
                            }
                            rsTop.close();
                            psTop.close();
                        } catch (Exception e) {
                            out.println(e.getMessage());
                        }
                    %>
                </tbody>
            </table>
        </div>
        <br>
        <%-- ---- Lowest Performing Students ---- --%>
        <div class="table-container">
            <h3 class="section-title">Lowest Performing Students</h3>
            <table>
                <thead>
                    <tr>
                        <th>Rank</th>
                        <th>Roll No</th>
                        <th>Student Name</th>
                        <th>Average Marks</th>
                        <th>Average Attendance</th>
                        <th>Grade</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try {
                            PreparedStatement psLow = con.prepareStatement(
                                "SELECT s.roll_no, s.s_name, " +
                                "    AVG(m.total_marks)        AS avg_marks, " +
                                "    AVG(a.attendance_percent) AS avg_attendance " +
                                "FROM student s " +
                                "LEFT JOIN marks m      ON s.sid = m.sid " +
                                "LEFT JOIN attendance a ON s.sid = a.sid " +
                                "WHERE s.dept=? AND s.semester=? " +
                                "GROUP BY s.sid, s.roll_no, s.s_name " +
                                "ORDER BY AVG(m.total_marks) ASC " +
                                "LIMIT 10"
                            );
                            psLow.setString(1, selectedDept);
                            psLow.setInt(2, semInt);
                            ResultSet rsLow = psLow.executeQuery();
                            int lowRank = 1;

                            while (rsLow.next()) {
                                double lowMarks = rsLow.getDouble("avg_marks");
                                String lowGrade = "C";
                                if      (lowMarks >= 90) lowGrade = "O";
                                else if (lowMarks >= 80) lowGrade = "A+";
                                else if (lowMarks >= 70) lowGrade = "A";
                                else if (lowMarks >= 60) lowGrade = "B+";
                                else if (lowMarks >= 50) lowGrade = "B";
                    %>
                    <tr>
                        <td><strong><%= lowRank %></strong></td>
                        <td><%= rsLow.getString("roll_no") %></td>
                        <td><%= rsLow.getString("s_name") %></td>
                        <td><%= String.format("%.2f", lowMarks) %></td>
                        <td><%= String.format("%.2f", rsLow.getDouble("avg_attendance")) %>%</td>
                        <td><%= lowGrade %></td>
                    </tr>
                    <%
                                lowRank++;
                            }
                            rsLow.close();
                            psLow.close();
                        } catch (Exception e) {
                            out.println(e.getMessage());
                        }
                    %>
                </tbody>
            </table>
        </div>
        
        <%-- ---- Performance Summary + Analytics Report ---- --%>
        <div class="analytics-grid">

            <div class="analytics-card">
                <h3>Department Performance Summary</h3>
                <table class="summary-table analytics-summary">
                    <tbody>
                        <tr>
                            <td>Department</td>
                            <td><%= selectedDept %></td>
                        </tr>
                        <tr>
                            <td>Semester</td>
                            <td><%= semester %></td>
                        </tr>
                        <tr>
                            <td>Total Students</td>
                            <td><%= totalStudents %></td>
                        </tr>
                        <tr>
                            <td>Average Marks</td>
                            <td><%= String.format("%.2f", avgMarks) %></td>
                        </tr>
                        <tr>
                            <td>Average Attendance</td>
                            <td><%= String.format("%.2f", avgAttendance) %>%</td>
                        </tr>
                        <tr>
                            <td>Department Grade</td>
                            <td><%= overallGrade %></td>
                        </tr>
                        <tr>
                            <td>Performance</td>
                            <td><%= performance %></td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="analytics-card">
                <h3>Analytics Report</h3>
                <div class="grade-circle"><%= overallGrade %></div>
                <h3><%= performance %></h3>
                <p><%= remark %></p>
            </div>

        </div>

        <div class="footer">
            &copy; 2025 Department Analytics System. All rights reserved.
        </div>

    </div><%-- end #main --%>

</body>
</html>

