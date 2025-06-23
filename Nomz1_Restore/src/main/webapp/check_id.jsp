<%@ page contentType="text/plain; charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    String id = request.getParameter("id");

    if (id == null || id.trim().isEmpty()) {
        out.print("INVALID");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("org.mariadb.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mariadb://localhost:3307/kimdb", "kim", "1111");

        String sql = "SELECT COUNT(*) FROM members WHERE username = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, id);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            int count = rs.getInt(1);
            if (count > 0) {
                out.print("EXISTS");
            } else {
                out.print("AVAILABLE");
            }
        } else {
            out.print("ERROR");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.print("ERROR");
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>
