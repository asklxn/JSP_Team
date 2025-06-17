<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%
    // 로그인한 사용자 ID를 세션에서 가져옴
    String loginId = (String) session.getAttribute("loginId");
    if (loginId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    List<Map<String, String>> orderList = new ArrayList<>();

    try {
        Class.forName("org.mariadb.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/Nomz", "YeonJi", "1111");

        String sql = "SELECT o.order_time, p.thumbnail, p.name, oi.quantity, oi.price FROM orders o " +
                     "JOIN order_items oi ON o.order_id = oi.order_id " +
                     "JOIN products p ON oi.product_id = p.product_id " +
                     "JOIN members m ON o.member_id = m.member_id " +
                     "WHERE m.username = ? ORDER BY o.order_time DESC";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, loginId);
        rs = pstmt.executeQuery();

        while (rs.next()) {
            Map<String, String> order = new HashMap<>();
            order.put("date", rs.getString("order_time"));
            order.put("imageUrl", rs.getString("thumbnail"));
            order.put("name", rs.getString("name"));
            order.put("count", rs.getString("quantity"));
            order.put("price", rs.getString("price"));
            orderList.add(order);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Nome orderHistory</title>
  <link rel="stylesheet" href="common/header.css" />
<style>
      .section_1 {
        width: 100%;
        height: 100vh;
        padding: 80px 100px;
        margin-left: 50%;
        transform: translateX(-50%);
        display: flex;
        flex-direction: column;
        align-items: center;
      }
      .title {
        font-size: 34px;
        margin-bottom: 40px;
      }

      #orderList {
        width: 100%;
        height: 700px;
        overflow-y: auto;
        border-bottom: 1px solid #0b1838;
        border-top: 1px solid #0b1838;
      }

      #orderList > :last-child {
        display: none;
      }
      .item_wrap {
        width: 100%;
        height: 120px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 0 50px;
        font-size: 14px;
      }
      .item_day {
        width: 160px;
      }
      .item_img {
        width: 100px;
        height: 100px;
        object-fit: cover;
        border: 1px solid rgba(0, 0, 0, 0.5);
        margin-right: 20px;
      }
      .item_text {
        width: 150px;
        margin-right: 500px;
      }
      .item_count {
        width: 50px;
        margin-right: 100px;
      }
      .item_price {
        width: 100px;
        text-align: right;
      }
    </style>
</head>
<body>
<header>
  <img onclick="location.href='index.jsp'" src="images/logo_b.png" alt="로고" class="logo" />
  <div class="menu_wrap">
    <div class="menu" onclick="location.href='addItem.jsp'">ADD MENU</div>
    <div class="menu" onclick="location.href='login.jsp'">LOGIN</div>
    <div class="menu" onclick="location.href='qna.jsp'">Q&A</div>
    <div class="menu" onclick="location.href='profile.jsp'">MY PAGE</div>
    <div class="menu" onclick="location.href='cart.jsp'">CART</div>
  </div>
</header>

<section class="section_1">
  <div class="title">ORDER HISTORY</div>
  <div id="orderList">
    <% if (orderList.isEmpty()) { %>
      <div style="font-size: 20px; margin-top: 50px;">주문 내역이 없습니다.</div>
    <% } else { 
         for (Map<String, String> order : orderList) { %>
    <div class="item_wrap">
      <div class="item_day"><%= order.get("date") %></div>
      <img class="item_img" src="<%= order.get("imageUrl") %>" alt="<%= order.get("name") %>" />
      <div class="item_text"><%= order.get("name") %></div>
      <div class="item_count"><%= order.get("count") %>개</div>
      <div class="item_price"><%= String.format("%,d원", Integer.parseInt(order.get("price")) * Integer.parseInt(order.get("count"))) %></div>
    </div>
    <div class="dash"></div>
    <%   } 
       } %>
  </div>
</section>
</body>
</html>
