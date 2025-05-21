<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="db.DBConnect" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nome 장바구니</title>
    <link rel="stylesheet" type="text/css" href="common/header.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
		    
        .section_1 {
            width: 1200px;
            height: 100vh;
            padding: 130px 0 50px;
            margin-left: 50%;
            transform: translateX(-50%);
        }
        .title {
            text-align: center;
            font-size: 35px;
            margin-bottom: 30px;
        }
        .con_wrap {
            width: 100%;
            height: 400px;
            overflow-y: auto;
            padding-right: 10px;
        }
        .item_wrap {
            width: 100%;
            height: 130px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 50px;
        }
        .item_img {
            width: 120px;
            height: 120px;
            object-fit: cover;
            border: 1px solid rgba(0, 0, 0, 0.5);
        }
        .item_text {
            width: 100px;
            font-size: 18px;
        }
        .count_wrap {
            width: 80px;
            height: 50px;
            display: flex;
            justify-content: space-between;
            align-items: center;
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
        .item_price {
            width: 90px;
            text-align: right;
            font-size: 18px;
            margin-left: 400px
        }
        .bar {
            width: 100%;
            height: 1px;
            background-color: rgba(0, 0, 0, 0.7);
            margin: 10px 0;
        }
        .total {
            width: 100%;
            font-size: 22px;
            text-align: right;
            padding-right: 50px;
        }
        .buy_btn {
            width: 200px;
            height: 50px;
            background-color: #cbcbcb;
            margin-left: 50%;
            transform: translateX(-50%);
            border-radius: 10px;
            text-align: center;
            line-height: 50px;
            font-size: 20px;
            margin-top: 10px;
            cursor: pointer;
            user-select: none;
        }
        
        .del_btn{
        		width: 30px;
        		height: 30px;
        		object-fit: cover;
        		cursor: pointer;
        }
    </style>
</head>
<body>
		<jsp:include page="common/header.jsp" />
		<section class="section_1">
		    <div class="title">장바구니</div>
		    <div class="con_wrap"></div>
		    <div class="bar"></div>
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
				    delBtn.src = "images/del.png";
				    delBtn.alt = "삭제";
				
				    const bar = document.createElement("div");
				    bar.className = "bar";
				
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
				      cartItems.splice(idx, 1); // 배열에서 삭제
				      localStorage.setItem("cart", JSON.stringify(cartItems)); // 저장
				      itemWrap.remove(); // DOM에서 제거
				      bar.remove();
				      updateCart(); // 총 금액 갱신
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
				    const date = now.getFullYear() + '-' +
				                String(now.getMonth() + 1).padStart(2, '0') + '-' +
				                String(now.getDate()).padStart(2, '0') + ' ' +
				                String(now.getHours()).padStart(2, '0') + ':' +
				                String(now.getMinutes()).padStart(2, '0');
				
				    cartItems.forEach(item => {
				      orders.push({
				        name: item.name,
				        price: item.price,
				        count: item.count,
				        imageUrl: item.imageUrl,
				        date: date
				      });
				    });
				
				    localStorage.setItem("orders", JSON.stringify(orders));
				    localStorage.removeItem("cart");
				    alert("구매되었습니다.");
				    location.href = "index.jsp";
				  });
				});
		</script>


</body>
</html>
