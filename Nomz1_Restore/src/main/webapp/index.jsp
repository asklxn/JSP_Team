<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>index</title>
  <link rel="stylesheet" href="<c:url value='/Frontend/common/header.css'/>" />
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

	<%-- ✅ 디버깅용 productList 개수 출력 --%>
	  <%
	    java.util.List<model.Product> products = (java.util.List<model.Product>) request.getAttribute("productList");
	    out.println("<div style='text-align:center; color:red;'>상품 개수: " + (products != null ? products.size() : "null") + "</div>");
	  %>
  <header>
    <img onclick="location.href='<%=request.getContextPath()%>/index.jsp'"
     src="<%=request.getContextPath()%>/Frontend/images/logo_b.png"
     alt="로고" class="logo" />
    <div class="menu_wrap">
      <div class="menu" onclick="location.href='Frontend/addItem.jsp'">ADD MENU</div>
      <div class="menu" onclick="location.href='Frontend/login.jsp'">LOGIN</div>
      <div class="menu" onclick="location.href='Frontend/qna.jsp'">Q&A</div>
      <div class="menu" onclick="location.href='Frontend/profile.jsp'">MY PAGE</div>
      <div class="menu" onclick="location.href='Frontend/cart.jsp'">CART</div>
    </div>
  </header>

  <div class="title">MENU</div>

  <section class="section_1">
    <div class="item_wrap" id="itemWrap">
      <c:forEach var="item" items="${productList}">
		  <c:set var="imgSrc" value="${empty item.imageUrl ? 'Frontend/images/bg1.png' : item.imageUrl}" />
		  <div class="item" onclick="location.href='detail.jsp?name=${item.name}'">
		    <img class="item_img" src="${imgSrc}" alt="상품이미지" />
		    <div class="item_name">${item.name}</div>
		    <div class="price">${item.price}원</div>
		    <img class="set_btn" 
		         src="Frontend/images/set_btn.png" 
		         onclick="event.stopPropagation(); location.href='Frontend/setItem.jsp?name=${item.name}'" 
		         alt="수정" />
		  </div>
		</c:forEach>
    </div>
  </section>
</body>
</html>
