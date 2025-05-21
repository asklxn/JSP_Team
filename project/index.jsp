<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="db.DBConnect" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Nome Home</title>
  <link rel="stylesheet" type="text/css" href="common/header.css">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    
    .section_1 {
      width: 100%;
      padding: 130px 0px 50px 0px;
      background-color: #fff;
    }
    .item_wrap {
      width: 1200px;
      margin: 0 auto;
      display: grid;
      grid-template-columns: repeat(5, 1fr);
      gap: 30px 25px;
    }
    .item {
   		position: relative;
   		top: 0;
   		left: 0;
      width: 220px;
      height: 260px;
      background-color: #ede1cb;
      border-radius: 10px;
      padding: 15px;
      box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
      overflow: hidden;
      transition: transform 0.2s ease;
      cursor: pointer;
    }
    .item_img {
      width: 190px;
      height: 180px;
      border-radius: 15px;
      object-fit: cover;
    }
    .price {
      font-size: 14px;
      font-weight: 700;
      margin-top: 5px;
      margin-left: 5px;
    }
    .item_name {
      font-size: 16px;
      margin-top: 5px;
      margin-left: 5px;
    }
    .set_btn{
    	width: 30px;
    	height: 30px;
    	position: absolute;
    	bottom: 10px;
    	right: 10px;
    	background-color: white;
    	border-radius: 10px;
    }
  </style>
</head>
<body>
	<jsp:include page="common/header.jsp" />

  <section class="section_1">
    <div class="item_wrap" id="itemWrap"></div>
  </section>

	<script>
	  document.addEventListener("DOMContentLoaded", () => {
	    const itemWrap = document.getElementById("itemWrap");
	    const products = JSON.parse(localStorage.getItem("products") || "[]");
	
	    itemWrap.innerHTML = "";
	
	    products.forEach((product, index) => {
	      const item = document.createElement("div");
	      item.className = "item";
	
	      const img = document.createElement("img");
	      img.className = "item_img";
	      img.src = product.imageUrl || "images/no-image.png";
	      img.alt = product.name || "상품 이미지";
	
	      const priceDiv = document.createElement("div");
	      priceDiv.className = "price";
	      priceDiv.textContent = product.price ? product.price + "원" : "가격 없음";
	
	      const nameDiv = document.createElement("div");
	      nameDiv.className = "item_name";
	      nameDiv.textContent = product.name || "이름 없음";
	      
	     	const setBtn = document.createElement("img");
	     	setBtn.className = "set_btn";
	     	setBtn.src = "images/set_btn.png";
		    setBtn.alt = product.name || "수정";
		    setBtn.addEventListener("click", (e) => {
		    	  e.stopPropagation();
		    	  localStorage.setItem("selectedProduct", JSON.stringify(product));
		    	  location.href = "setItem.jsp";
		    });
	
	      item.appendChild(img);
	      item.appendChild(priceDiv);
	      item.appendChild(nameDiv);
	     	item.appendChild(setBtn);
	
	      item.addEventListener("click", () => {
	        localStorage.setItem("selectedProduct", JSON.stringify(product));
	        window.location.href = "detail.jsp";
	      });
	
	      itemWrap.appendChild(item);
	    });
	  });
	</script>


</body>
</html>