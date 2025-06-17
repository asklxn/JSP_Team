<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*" %>
<%
    List<Map<String, String>> productList = new ArrayList<>();

    try {
        Class.forName("org.mariadb.jdbc.Driver");
        Connection conn = DriverManager.getConnection(
            "jdbc:mariadb://localhost:3306/Nomz", "YeonJi", "1111"
        );

String sql = "SELECT p.product_id, p.name, p.price, i.image_url " +
             "FROM products p LEFT JOIN product_images i ON p.product_id = i.product_id " +
             "GROUP BY p.product_id";

        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Map<String, String> item = new HashMap<>();
            item.put("name", rs.getString("name"));
            item.put("price", rs.getString("price"));
            item.put("image", rs.getString("image_url")); // /uploads/...
            productList.add(item);
        }

        rs.close();
        ps.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>index</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/Frontend/common/header.css" />
  <style>
    .title {
      font-family: "amoria-font";
      font-size: 40px;
      text-align: center;
      margin-top: 80px;
    }

    .section_1 {
      width: 100%;
      padding: 100px;
    }

    .item_wrap {
      display: grid;
      grid-template-columns: repeat(4, 250px);
      justify-content: space-between;
      gap: 30px 0;
      margin: 0 auto;
    }

    .item {
      position: relative;
      width: 250px;
      height: 320px;
      transition: transform 0.2s ease;
      cursor: pointer;
      box-shadow: 5px 5px 5px rgba(0, 0, 0, 0.2);
      margin-bottom: 10px;
    }

    .item_img {
      width: 250px;
      height: 250px;
      object-fit: cover;
    }

    .price {
      text-align: center;
      font-size: 12px;
      margin-top: 5px;
    }

    .item_name {
      text-align: center;
      font-size: 14px;
      margin-top: 5px;
    }

    .set_btn {
      width: 30px;
      height: 30px;
      position: absolute;
      bottom: 10px;
      right: 10px;
      border-radius: 10px;
      pointer-events: auto;
    }

    .item:hover {
      transform: translateY(-10px);
      box-shadow: 7px 7px 7px rgba(0, 0, 0, 0.2);
      z-index: 2;
    }
  </style>
</head>

<body>
  <header>
    <img onclick="location.href='index.jsp'"
         src="<%=request.getContextPath()%>/Frontend/images/logo_b.png"
         alt="로고"
         class="logo" />
    <div class="menu_wrap">
      <div class="menu" onclick="location.href='addItem.jsp'">ADD MENU</div>
      <div class="menu" onclick="location.href='login.jsp'">LOGIN</div>
      <div class="menu" onclick="location.href='qna.jsp'">Q&A</div>
      <div class="menu" onclick="location.href='profile.jsp'">MY PAGE</div>
      <div class="menu" onclick="location.href='cart.jsp'">CART</div>
    </div>
  </header>

  <div class="title">MENU</div>

  <section class="section_1">
    <div class="item_wrap" id="itemWrap">
      <% for (Map<String, String> item : productList) { %>
        <div class="item" onclick="location.href='detail.jsp?name=<%=item.get("name")%>'">
          <img class="item_img" src="<%=item.get("image") != null ? item.get("image") : "Frontend/images/bg1.png"%>" alt="상품이미지" />
          <div class="item_name"><%=item.get("name")%></div>
          <div class="price"><%=item.get("price")%>원</div>
<img class="set_btn" 
     src="Frontend/images/set_btn.png" 
     onclick="event.stopPropagation(); location.href='<%=request.getContextPath()%>/Frontend/setItem.jsp?name=<%=item.get("name")%>'" 
     alt="수정" />


        </div>
      <% } %>
    </div>
  </section>

  <script>
    // 기존 HTML 동작 방식 유지
    document.addEventListener("DOMContentLoaded", function () {
      const items = document.querySelectorAll(".item");
      items.forEach((item) => {
        const setBtn = item.querySelector(".set_btn");
        setBtn.addEventListener("click", (event) => {
          event.stopPropagation();
        });
      });
    });
  </script>
</body>
</html>
