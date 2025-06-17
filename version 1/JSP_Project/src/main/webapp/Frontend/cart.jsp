<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.io.*, java.sql.*, java.util.*, javax.servlet.http.Part" %>
<%@ page import="java.util.UUID" %>

<%
    request.setCharacterEncoding("UTF-8");

    String name = null;
    String priceStr = null;
    String description = null;
    String imageName = null;

    String uploadPath = application.getRealPath("/") + "uploads";
    File uploadDir = new File(uploadPath);
    if (!uploadDir.exists()) uploadDir.mkdirs();

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        Collection<Part> parts = request.getParts();

        for (Part part : parts) {
            switch (part.getName()) {
                case "productName":
                    BufferedReader reader1 = new BufferedReader(new InputStreamReader(part.getInputStream(), "UTF-8"));
                    name = reader1.readLine();
                    break;
                case "productPrice":
                    BufferedReader reader2 = new BufferedReader(new InputStreamReader(part.getInputStream(), "UTF-8"));
                    priceStr = reader2.readLine();
                    break;
                case "productDetail":
                    BufferedReader reader3 = new BufferedReader(new InputStreamReader(part.getInputStream(), "UTF-8"));
                    description = reader3.readLine();
                    break;
                case "productImage":
                    if (part.getSize() > 0) {
                        imageName = UUID.randomUUID() + "_" + part.getSubmittedFileName();
                        part.write(uploadPath + File.separator + imageName);
                    }
                    break;
            }
        }

        int price = (priceStr != null && !priceStr.isEmpty()) ? Integer.parseInt(priceStr) : 0;

        try {
            Class.forName("org.mariadb.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                "jdbc:mariadb://localhost:3306/Nomz", "YeonJi", "1111");

            String sql = "INSERT INTO products (name, price, description, thumbnail) VALUES (?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setInt(2, price);
            ps.setString(3, description);
            ps.setString(4, imageName != null ? "uploads/" + imageName : null);
            ps.executeUpdate();

            out.println("<script>alert('상품이 등록되었습니다.'); location.href='index.jsp';</script>");
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script>alert('DB 오류: " + e.getMessage() + "'); history.back();</script>");
        }
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Nomz cart</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/Frontend/common/header.css" />
<style>
      .section_1 {
        width: 100%;
        height: 100vh;
        padding: 80px 100px;
      }
      .title {
        text-align: center;
        font-size: 35px;
        margin-bottom: 30px;
      }
      .con_wrap {
        width: 100%;
        height: 500px;
        overflow-y: auto;
        padding: 0 20px;
        margin-bottom: 10px;
        border-top: 1px solid #0b1838;
        border-bottom: 1px solid #0b1838;
      }
      .con_wrap > :last-child {
        display: none;
      }
      .item_wrap {
        width: 100%;
        height: 120px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 0 50px;
      }
      .item_img {
        width: 100px;
        height: 100px;
        object-fit: cover;
        border: 1px solid rgba(0, 0, 0, 0.5);
      }
      .item_text {
        width: 100px;
        font-size: 16px;
      }
      .count_wrap {
        width: 80px;
        height: 24px;
        border: 1px solid #0b1838;
        display: flex;
        justify-content: space-between;
        align-items: center;
        user-select: none;
        margin-left: 600px;
      }
      .minus,
      .plus {
        width: 23px;
        height: 23px;
        font-size: 12px;
        text-align: center;
        line-height: 23px;
        font-weight: 300;
        cursor: pointer;
        overflow: hidden;
        z-index: 10;
      }
      .item_count {
        width: 34px;
        height: 24px;
        text-align: center;
        font-size: 14px;
        border: 1px solid #0b1838;
        line-height: 24px;
      }
      .item_price {
        width: 90px;
        text-align: right;
        font-size: 14px;
        margin-left: -50px;
      }
      .total {
        width: 100%;
        font-size: 18px;
        text-align: right;
        padding-right: 50px;
      }
      .buy_btn {
        width: 200px;
        height: 50px;
        background-color: #dce5ed;
        border: 1px solid #0b1838;
        margin: 10px auto;
        text-align: center;
        line-height: 50px;
        font-size: 18px;
        cursor: pointer;
        user-select: none;
      }

      .del_btn {
        width: 20px;
        height: 20px;
        object-fit: cover;
        cursor: pointer;
      }
    </style>
</head>
<body>
<header>
  <img
    onclick="location.href='<%=request.getContextPath()%>/Frontend/index.jsp'"
    src="<%=request.getContextPath()%>/Frontend/images/logo_b.png"
    alt="로고"
    class="logo"
  />
  <div class="menu_wrap">
    <div class="menu" onclick="location.href='<%=request.getContextPath()%>/Frontend/addItem.jsp'">ADD MENU</div>
    <div class="menu" onclick="location.href='<%=request.getContextPath()%>/Frontend/login.html'">LOGIN</div>
    <div class="menu" onclick="location.href='<%=request.getContextPath()%>/Frontend/qna.html'">Q&A</div>
    <div class="menu" onclick="location.href='<%=request.getContextPath()%>/Frontend/profile.html'">MY PAGE</div>
    <div class="menu" onclick="location.href='<%=request.getContextPath()%>/Frontend/cart.jsp'">CART</div>
  </div>
</header>

<section class="section_1">
  <div class="title">CART</div>
  <div class="con_wrap"></div>
  <div class="total">총 금액 : 0원</div>
  <div class="buy_btn">구매하기</div>
</section>

<script>
  document.addEventListener("DOMContentLoaded", () => {
    const container = document.querySelector(".con_wrap");
    const totalDiv = document.querySelector(".total");
    const buyBtn = document.querySelector(".buy_btn");
    let cartItems = JSON.parse(localStorage.getItem("cart") || "[]");

    container.innerHTML = "";
    let total = 0;

    cartItems.forEach((item, idx) => {
      const itemWrap = document.createElement("div");
      itemWrap.className = "item_wrap";

      const img = document.createElement("img");
      img.className = "item_img";
      img.src = item.imageUrl;
      img.alt = item.name;

      const name = document.createElement("div");
      name.className = "item_text";
      name.textContent = item.name;

      const countWrap = document.createElement("div");
      countWrap.className = "count_wrap";

      const minus = document.createElement("div");
      minus.className = "minus";
      minus.textContent = "-";

      const countEl = document.createElement("div");
      countEl.className = "item_count";
      countEl.textContent = item.count;

      const plus = document.createElement("div");
      plus.className = "plus";
      plus.textContent = "+";

      countWrap.appendChild(minus);
      countWrap.appendChild(countEl);
      countWrap.appendChild(plus);

      const priceDiv = document.createElement("div");
      priceDiv.className = "item_price";
      priceDiv.dataset.unitPrice = item.price;
      priceDiv.textContent = (item.price * item.count).toLocaleString() + "원";

      const delBtn = document.createElement("img");
      delBtn.className = "del_btn";
      delBtn.src = "<%=request.getContextPath()%>/Frontend/images/del.png";
      delBtn.alt = "삭제";

      const bar = document.createElement("div");
      bar.className = "dash";

      itemWrap.appendChild(img);
      itemWrap.appendChild(name);
      itemWrap.appendChild(countWrap);
      itemWrap.appendChild(priceDiv);
      itemWrap.appendChild(delBtn);

      container.appendChild(itemWrap);
      container.appendChild(bar);

      total += item.price * item.count;

      plus.addEventListener("click", () => {
        item.count++;
        countEl.textContent = item.count;
        priceDiv.textContent = (item.price * item.count).toLocaleString() + "원";
        updateCart();
      });

      minus.addEventListener("click", () => {
        if (item.count > 1) {
          item.count--;
          countEl.textContent = item.count;
          priceDiv.textContent = (item.price * item.count).toLocaleString() + "원";
          updateCart();
        }
      });

      delBtn.addEventListener("click", () => {
        cartItems.splice(idx, 1);
        localStorage.setItem("cart", JSON.stringify(cartItems));
        itemWrap.remove();
        bar.remove();
        updateCart();
      });
    });

    totalDiv.textContent = "총 금액 : " + total.toLocaleString() + "원";

    function updateCart() {
      localStorage.setItem("cart", JSON.stringify(cartItems));
      const newTotal = cartItems.reduce((sum, item) => sum + item.price * item.count, 0);
      totalDiv.textContent = "총 금액 : " + newTotal.toLocaleString() + "원";
    }

    buyBtn.addEventListener("click", () => {
      if (cartItems.length === 0) {
        alert("장바구니에 상품이 없습니다.");
        return;
      }

      const orders = JSON.parse(localStorage.getItem("orders") || "[]");
      const now = new Date();
      const date =
        now.getFullYear() + "-" +
        String(now.getMonth() + 1).padStart(2, "0") + "-" +
        String(now.getDate()).padStart(2, "0") + " " +
        String(now.getHours()).padStart(2, "0") + ":" +
        String(now.getMinutes()).padStart(2, "0");

      cartItems.forEach((item) => {
        orders.push({
          name: item.name,
          price: item.price,
          count: item.count,
          imageUrl: item.imageUrl,
          date: date,
        });
      });

      localStorage.setItem("orders", JSON.stringify(orders));
      localStorage.removeItem("cart");
      alert("구매되었습니다.");
      location.href = "<%=request.getContextPath()%>/index.jsp";
    });
  });
  
  document.addEventListener("DOMContentLoaded", () => {
    const buyBtn = document.querySelector(".buy_btn");

    buyBtn.addEventListener("click", () => {
      alert("구매가 완료되었습니다.");
      location.href = "<%=request.getContextPath()%>/Frontend/index.jsp";
    });
  });

</script>
</body>
</html>
