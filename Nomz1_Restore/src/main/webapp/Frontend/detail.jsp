<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
  request.setCharacterEncoding("UTF-8");
  String productId = request.getParameter("product_id");

  String name = "";
  String price = "0";
  String description = "";
  String thumbnail = "";

  try {
    Class.forName("org.mariadb.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/Nomz", "YeonJi", "1111");

    String sql = "SELECT * FROM products WHERE product_id = ?";
    PreparedStatement pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, productId);
    ResultSet rs = pstmt.executeQuery();

    if (rs.next()) {
      name = rs.getString("name");
      price = rs.getString("price");
      description = rs.getString("description");
      thumbnail = rs.getString("thumbnail");
    }

    rs.close();
    pstmt.close();
    conn.close();
  } catch (Exception e) {
    e.printStackTrace();
  }


%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Nomz Detail Page</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/Frontend/common/header.css" />
<style>
    swiper-container {
      width: 500px;
      height: 500px;
      overflow: visible;
    }
    swiper-slide {
      background-position: center;
      background-size: cover;
      overflow: visible;
    }
    swiper-slide img {
      display: block;
      width: 100%;
      height: 100%;
      object-fit: cover;
    }
    .section_1 {
      width: 1200px;
      height: 100vh;
      margin: 0 auto;
      padding-top: 60px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      overflow: visible;
    }
    .item_img {
      width: 500px;
      height: 500px;
      object-fit: cover;
      border: 2px solid rgba(0, 0, 0, 0.5);
    }
    .text_wrap {
      width: 550px;
      height: 500px;
    }
    .item_text {
      font-size: 30px;
      margin-bottom: 5px;
    }
    .item_price {
      font-size: 20px;
    }
    .line {
      margin-top: 40px;
    }
    .item_desc {
      width: 100%;
      font-size: 14px;
      margin-top: 5px;
    }
    .item_wrap {
      bottom: 70px;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      width: 100%;
      height: 120px;
      background-color: #dce5ed;
      margin-top: 120px;
      padding: 20px;
    }
    .price_wrap {
      width: 100%;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    .item_text_2 {
      font-size: 18px;
    }
    .count_wrap {
      width: 100px;
      height: 27px;
      border: 1px solid #0b1838;
      display: flex;
      justify-content: space-between;
      align-items: center;
      user-select: none;
      overflow: hidden;
    }
    .minus,
    .plus {
      width: 25px;
      height: 25px;
      font-size: 14px;
      text-align: center;
      line-height: 25px;
      font-weight: 300;
      cursor: pointer;
      overflow: hidden;
    }
    .item_count {
      width: 50px;
      height: 27px;
      text-align: center;
      font-size: 14px;
      border: 1px solid #0b1838;
      line-height: 27px;
    }
    .total {
      width: 90px;
      text-align: right;
      font-size: 14px;
    }
    .btn_wrap {
      display: flex;
      justify-content: space-between;
      align-items: center;
      width: 100%;
      height: 50px;
      margin-top: 20px;
    }
    .cart_btn,
    .buy_btn {
      width: 270px;
      height: 100%;
      background-color: #0b1838;
      color: #fffdf9;
      font-size: 20px;
      text-align: center;
      line-height: 50px;
      cursor: pointer;
      user-select: none;
    }
    .title {
      font-size: 35px;
      text-align: center;
      margin: 30px;
    }
    .section_2 {
      width: 100%;
      padding: 100px;
      text-align: center;
    }
  </style>
</head>
<body>
  <header>
    <img onclick="location.href='<%=request.getContextPath()%>/Frontend/index.jsp'" src="<%=request.getContextPath()%>/Frontend/images/logo_b.png" alt="로고" class="logo" />
    <div class="menu_wrap">
      <div class="menu" onclick="location.href='<%=request.getContextPath()%>/Frontend/addItem.jsp'">ADD MENU</div>
      <div class="menu" onclick="location.href='<%=request.getContextPath()%>/Frontend/login.html'">LOGIN</div>
      <div class="menu" onclick="location.href='<%=request.getContextPath()%>/Frontend/qna.html'">Q&A</div>
      <div class="menu" onclick="location.href='<%=request.getContextPath()%>/Frontend/profile.html'">MY PAGE</div>
      <div class="menu" onclick="location.href='<%=request.getContextPath()%>/Frontend/cart.jsp'">CART</div>
    </div>
  </header>

  <section class="section_1">
    <img class="item_img" src="<%=request.getContextPath()%>/<%= thumbnail %>" alt="<%= name %>">
    <div class="text_wrap">
      <div class="item_text" id="productName"><%= name %></div>
      <div class="item_price" id="productPrice"><%= price %>원</div>
      <div class="line"></div>
      <div class="item_desc"><%= description %></div>

      <div class="item_wrap">
        <div class="item_text_2" id="productNameSmall"><%= name %></div>
        <div class="dash"></div>
        <div class="price_wrap">
          <div class="count_wrap">
            <div class="minus">▼</div>
            <div class="item_count">1</div>
            <div class="plus">▲</div>
          </div>
          <div class="total" id="productTotal"><%= price %>원</div>
        </div>
      </div>

      <div class="btn_wrap">
        <div class="cart_btn">장바구니</div>
        <div class="buy_btn">구매하기</div>
      </div>
    </div>
  </section>

  <script>
    document.addEventListener("DOMContentLoaded", () => {
      const minusBtn = document.querySelector(".minus");
      const plusBtn = document.querySelector(".plus");
      const countEl = document.querySelector(".item_count");
      const priceEl = document.querySelector("#productPrice");
      const totalEl = document.querySelector("#productTotal");
      const cartBtn = document.querySelector(".cart_btn");
      const buyBtn = document.querySelector(".buy_btn");

      const unitPrice = parseInt(<%= price %>);
      let count = 1;

      function updateTotal() {
        totalEl.textContent = (unitPrice * count).toLocaleString() + "원";
      }

      plusBtn.addEventListener("click", () => {
        count++;
        countEl.textContent = count;
        updateTotal();
      });

      minusBtn.addEventListener("click", () => {
        if (count > 1) {
          count--;
          countEl.textContent = count;
          updateTotal();
        }
      });

      cartBtn.addEventListener("click", () => {
        const item = {
          name: "<%= name %>",
          price: unitPrice,
          count: count,
          imageUrl: "<%=request.getContextPath()%>/<%= thumbnail %>"
        };

        const cart = JSON.parse(localStorage.getItem("cart") || "[]");
        const existing = cart.find(c => c.name === item.name);

        if (existing) {
          existing.count += item.count;
        } else {
          cart.push(item);
        }

        localStorage.setItem("cart", JSON.stringify(cart));
        alert("장바구니에 추가되었습니다.");
      });

      buyBtn.addEventListener("click", () => {
        alert("구매가 완료되었습니다.");
        location.href = "<%=request.getContextPath()%>/Frontend/index.jsp";
      });

      updateTotal();
    });
  </script>
</body>
</html>
