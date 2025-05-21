<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Nome 상세페이지</title>
  <link rel="stylesheet" type="text/css" href="common/header.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
		    
        .section_1 {
            width: 1200px;
            height: 780px;
            background-color: #fff;
            margin-left: 50%;
            transform: translateX(-50%);
            padding: 180px 0 100px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .item_img {
            width: 500px;
            height: 500px;
            object-fit: cover;
            border: 2px solid rgba(0, 0, 0, 0.5);
        }
        .text_wrap {
            position: relative;
            width: 650px;
            height: 500px;
            background-color: #fff;
        }
        .item_text {
            font-size: 50px;
            margin-bottom: 5px;
        }
        .item_price {
            font-size: 22px;
            font-weight: 700;
        }
        .item_wrap {
            position: absolute;
            bottom: 70px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            width: 100%;
            height: 50px;
        }
        .item_text_2 {
            font-size: 18px;
        }
        .count_wrap {
            width: 80px;
            height: 50px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-right: 200px;
            user-select: none;
        }
        .minus, .plus {
            width: 25px;
            height: 25px;
            background-color: lightgray;
            border: 1px solid darkgray;
            border-radius: 5px;
            font-size: 30px;
            text-align: center;
            line-height: 25px;
            font-weight: 300;
            cursor: pointer;
        }
        .item_count {
        		width: 20px;
        		text-align: center;
            font-size: 18px;
        }
        .total {
        		width: 90px;
        		text-align: right;
            font-size: 18px;
        }
        .btn_wrap {
            position: absolute;
            bottom: 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
            width: 100%;
            height: 60px;
        }
        .cart_btn, .buy_btn {
            width: 300px;
            height: 100%;
            background-color: lightgray;
            border-radius: 10px;
            font-size: 30px;
            text-align: center;
            line-height: 60px;
            cursor: pointer;
            user-select: none;
    </style>
</head>
<body>
	<jsp:include page="common/header.jsp" />

  <section class="section_1">
    <img src="" alt="상품 이미지" class="item_img" id="productImage">
    <div class="text_wrap">
      <div class="item_text" id="productName">상품명</div>
      <div class="item_price" id="productPrice">가격</div>

      <div class="item_wrap">
        <div class="item_text_2" id="productNameSmall">상품명</div>
        <div class="count_wrap">
          <div class="minus">-</div>
          <div class="item_count">1</div>
          <div class="plus">+</div>
        </div>
        <div class="total" id="productTotal">총합</div>
      </div>

      <div class="btn_wrap">
        <div class="cart_btn">장바구니</div>
        <div class="buy_btn">구매하기</div>
      </div>
    </div>
  </section>

	<script>
	  document.addEventListener("DOMContentLoaded", () => {
	    const product = JSON.parse(localStorage.getItem("selectedProduct"));
	
	    if (!product || !product.name || !product.price || !product.imageUrl) {
	      alert("상품 정보를 불러올 수 없습니다.");
	      location.href = "index.jsp";
	      return;
	    }
	
	    const imageEl = document.getElementById("productImage");
	    const nameEl = document.getElementById("productName");
	    const nameSmallEl = document.getElementById("productNameSmall");
	    const priceEl = document.getElementById("productPrice");
	    const totalEl = document.getElementById("productTotal");
	    const countDisplay = document.querySelector(".item_count");
	
	    const unitPrice = Number(product.price);
	    let count = 1;
	
	    imageEl.src = product.imageUrl;
	    nameEl.textContent = product.name;
	    nameSmallEl.textContent = product.name;
	    priceEl.textContent = unitPrice.toLocaleString() + "원";
	    totalEl.textContent = (unitPrice * count).toLocaleString() + "원";
	
	    document.querySelector(".plus").addEventListener("click", () => {
	      count++;
	      countDisplay.textContent = count;
	      totalEl.textContent = (unitPrice * count).toLocaleString() + "원";
	    });
	
	    document.querySelector(".minus").addEventListener("click", () => {
	      if (count > 1) {
	        count--;
	        countDisplay.textContent = count;
	        totalEl.textContent = (unitPrice * count).toLocaleString() + "원";
	      }
	    });
	
	    document.querySelector(".cart_btn").addEventListener("click", () => {
	      const cart = JSON.parse(localStorage.getItem("cart") || "[]");
	      const existing = cart.find(p => p.name === product.name && p.price === product.price);
	      if (existing) {
	        existing.count += count;
	      } else {
	        cart.push({ ...product, count: count });
	      }
	      localStorage.setItem("cart", JSON.stringify(cart));
	      alert("장바구니에 추가되었습니다.");
	      location.href = "cart.jsp";
	    });
	
	    document.querySelector(".buy_btn").addEventListener("click", () => {
	      const orders = JSON.parse(localStorage.getItem("orders") || "[]");
	
	      const now = new Date();
	      const date = now.getFullYear() + '-' +
	                   String(now.getMonth() + 1).padStart(2, '0') + '-' +
	                   String(now.getDate()).padStart(2, '0') + ' ' +
	                   String(now.getHours()).padStart(2, '0') + ':' +
	                   String(now.getMinutes()).padStart(2, '0');
	
	      const newOrder = {
	        name: product.name,
	        price: unitPrice,
	        count: count,
	        imageUrl: product.imageUrl,
	        date: date
	      };
	
	      orders.push(newOrder);
	      localStorage.setItem("orders", JSON.stringify(orders));
	
	      alert("구매되었습니다.");
	      location.href = "index.jsp";
	    });
	  });
	</script>



</body>
</html>
