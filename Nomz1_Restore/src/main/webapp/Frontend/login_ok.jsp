<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%
    request.setCharacterEncoding("UTF-8");

    String id = request.getParameter("id");
    String password = request.getParameter("password");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("org.mariadb.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/Nomz", "YeonJi", "1111");

        String sql = "SELECT * FROM members WHERE username = ? AND password = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, id);
        pstmt.setString(2, password);

        rs = pstmt.executeQuery();

        if (rs.next()) {
            // 로그인 성공: 세션에 사용자 정보 저장
            session.setAttribute("id", id);
            session.setAttribute("name", rs.getString("name"));
%>
<script>
    alert("로그인 성공! 메인 페이지로 이동합니다.");
    location.href = "<%= request.getContextPath() %>/Frontend/index.jsp";
</script>
<%
        } else {
%>
<script>
    alert("아이디 또는 비밀번호가 잘못되었습니다.");
    history.back();
</script>
<%
        }
    } catch (Exception e) {
        e.printStackTrace();
%>
<script>
    alert("서버 오류 발생: <%= e.getMessage() %>");
    history.back();
</script>
<%
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
