<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.sql.*" %>
<%
    HttpSession sessionObj = request.getSession(false);
    String id = (sessionObj != null) ? (String) sessionObj.getAttribute("id") : null;
    String name = "";
    String birth = "";
    String phone = "";
    String address = "";
    String detailAddress = "";

    if (id != null) {
        try {
            Class.forName("org.mariadb.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/Nomz", "YeonJi", "1111");
            String sql = "SELECT * FROM members WHERE username = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, id);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                name = rs.getString("name");
                birth = rs.getString("birth");
                phone = rs.getString("phone");
                address = rs.getString("address");
                detailAddress = rs.getString("detail_address");
            }

            rs.close();
            pstmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="utf-8" />
  <title>Nomz Profile</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <link rel="stylesheet" href="<%=request.getContextPath()%>/Frontend/common/header.css" />
<style>
    .section_1 {
      width: 100%;
      height: 100vh;
      padding: 100px;
      display: flex;
      justify-content: center;
      align-items: center;
      perspective: 1000px;
    }
    swiper-container {
      position: relative;
      width: 550px;
      height: 360px;
    }
    swiper-slide {
      width: 100%;
      height: 100%;
      box-shadow: 15px 30px 20px rgba(0, 0, 0, 0.3);
      background-color: #dce5ed;
      padding: 70px 50px;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      align-items: center;
      border: 1px solid #0b1838;
    }
    .profile {
      width: 100px;
      height: 100px;
      border-radius: 50%;
      border: 1px solid #0b183880;
    }
    .id {
      font-size: 14px;
    }
    .btn_wrap {
      width: 100%;
      display: flex;
      justify-content: space-between;
      align-items: center;
      text-align: center;
      line-height: 40px;
    }
    .btn {
      width: 49%;
      height: 40px;
      background-color: #0b1838;
      color: #fffdf9;
      font-size: 14px;
      margin-top: 30px;
      cursor: pointer;
      box-shadow: 3px 3px 3px rgba(0, 0, 0, 0.3);
      pointer-events: auto;
    }
    .text_wrap {
      width: 100%;
      padding: 10px 0;
      display: flex;
      justify-content: space-between;
      align-items: center;
      font-size: 14px;
    }
    .lable {
      width: 100px;
      border-right: 0.5px solid #0b1838;
    }
    .value {
      padding-left: 20px;
      width: 100%;
    }
    @keyframes flip-on-load {
      0% { transform: rotateY(0deg); }
      25% { transform: rotateY(-10deg); }
      50% { transform: rotateY(-20deg); }
      75% { transform: rotateY(0deg); }
      85% { transform: rotateY(3deg); }
      100% { transform: rotateY(0deg); }
    }
    .swiper-animate {
      animation: flip-on-load 0.8s linear;
      backface-visibility: hidden;
      will-change: transform;
    }
  </style>
</head>
<body>
<header>
  <img onclick="location.href='<%=request.getContextPath()%>/Frontend/index.jsp'" src="<%=request.getContextPath()%>/Frontend/images/logo_b.png" alt="로고" class="logo" />
  <div class="menu_wrap">
    <div class="menu" onclick="location.href='<%=request.getContextPath()%>/Frontend/addItem.jsp'">ADD MENU</div>
    <div class="menu" onclick="location.href='<%=request.getContextPath()%>/Frontend/login.jsp'">LOGIN</div>
    <div class="menu" onclick="location.href='<%=request.getContextPath()%>/Frontend/qna.jsp'">Q&A</div>
    <div class="menu" onclick="location.href='<%=request.getContextPath()%>/Frontend/profile.jsp'">MY PAGE</div>
    <div class="menu" onclick="location.href='<%=request.getContextPath()%>/Frontend/cart.jsp'">CART</div>
  </div>
</header>
<section class="section_1">
  <swiper-container class="mySwiper" effect="flip" grab-cursor="true" loop="true">
    <swiper-slide>
      <img src="<%=request.getContextPath()%>/Frontend/images/profile.jpg" alt="프로필" class="profile" />
      <div class="id"><%= id != null ? id : "비회원" %></div>
      <div class="btn_wrap">
        <div class="btn orderHistory_btn" onclick="location.href='<%=request.getContextPath()%>/Frontend/orderHistory.jsp'">주문내역</div>
        <div class="btn logout_btn" onclick="alert('로그아웃 되었습니다.'); location.href='<%=request.getContextPath()%>/Frontend/index.jsp';">로그아웃</div>
      </div>
    </swiper-slide>
    <swiper-slide>
      <div class="text_wrap"><div class="lable">이름</div><div class="value"><%= name %></div></div>
      <div class="text_wrap"><div class="lable">아이디</div><div class="value"><%= id %></div></div>
      <div class="text_wrap"><div class="lable">생년월일</div><div class="value"><%= birth %></div></div>
      <div class="text_wrap"><div class="lable">전화번호</div><div class="value"><%= phone %></div></div>
      <div class="text_wrap"><div class="lable">주소</div><div class="value"><%= address %> <%= detailAddress %></div></div>
    </swiper-slide>
  </swiper-container>
</section>
<script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-element-bundle.min.js"></script>
</body>
</html>
