<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.sql.Date" %>
<%
    request.setCharacterEncoding("UTF-8");

    String name = request.getParameter("name");
    String id = request.getParameter("id");
    String password = request.getParameter("password");
    String phone = request.getParameter("phone");
    String birthStr = request.getParameter("birth");
    String zipcode = request.getParameter("zipcode");
    String detailAddress = request.getParameter("detailAddress");

    Date birth = null;
    if (birthStr != null && birthStr.length() == 6) {
        try {
            birth = Date.valueOf("20" + birthStr.substring(0, 2) + "-" + birthStr.substring(2, 4) + "-" + birthStr.substring(4, 6));
        } catch (Exception e) {
            birth = null;
        }
    }

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("org.mariadb.jdbc.Driver");
        conn = DriverManager.getConnection(
        		"jdbc:mariadb://localhost:3307/kimdb", "kim", "1111");

        String sql = "INSERT INTO members (name, username, password, phone, birth, address, detail_address) VALUES (?, ?, ?, ?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, name);
        pstmt.setString(2, id);
        pstmt.setString(3, password);
        pstmt.setString(4, phone);
        pstmt.setDate(5, birth);
        pstmt.setString(6, zipcode);
        pstmt.setString(7, detailAddress);

        int result = pstmt.executeUpdate();

        if (result > 0) {
%>
<script>
    alert("회원가입이 완료되었습니다.");
    location.href = "<%=request.getContextPath()%>/Frontend/login.jsp";
</script>
<%
        } else {
%>
<script>
    alert("회원가입에 실패했습니다.");
    history.back();
</script>
<%
        }

    } catch (SQLIntegrityConstraintViolationException dupEx) {
%>
<script>
    alert("이미 존재하는 아이디입니다.");
    history.back();
</script>
<%
    } catch (Exception e) {
        e.printStackTrace();
%>
<script>
    alert("서버 오류: <%= e.getMessage() %>");
    history.back();
</script>
<%
    } finally {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
