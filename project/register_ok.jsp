<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="db.DBConnect" %>
<%
    request.setCharacterEncoding("utf-8");
    String name = request.getParameter("name");
    String id = request.getParameter("id");
    String pw = request.getParameter("pw");
    String phone = request.getParameter("phone");
    String birth = request.getParameter("birth");

    Connection conn = DBConnect.getConnection();
    PreparedStatement pstmt = conn.prepareStatement("INSERT INTO users (name, userid, password, phone, birth) VALUES (?, ?, ?, ?, ?)");
    pstmt.setString(1, name);
    pstmt.setString(2, id);
    pstmt.setString(3, pw);
    pstmt.setString(4, phone);
    pstmt.setString(5, birth);
    int result = pstmt.executeUpdate();
    if(result > 0) {
        response.sendRedirect("index.jsp");
    } else {
        out.println("회원가입 실패");
    }
    pstmt.close();
    conn.close();
%>