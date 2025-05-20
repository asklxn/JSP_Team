<%@ page contentType="text/plain; charset=UTF-8" import="java.sql.*" %>
<%@ page contentType="text/plain; charset=UTF-8" %>
<%
    String id = request.getParameter("id");

    boolean exists = false;

    try {
        Class.forName("org.mariadb.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/backend", "yejin", "1111");
        String sql = "SELECT COUNT(*) FROM users WHERE id = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, id);
        ResultSet rs = pstmt.executeQuery();

        if (rs.next() && rs.getInt(1) > 0) {
            exists = true;
        }

        rs.close();
        pstmt.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }

    if (exists) {
        out.print("EXISTS");
    } else {
        out.print("AVAILABLE");
    }
%>
