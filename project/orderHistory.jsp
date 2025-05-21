<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="db.DBConnect" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nome 주문내역</title>
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
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .text {
            font-size: 40px;
            margin-bottom: 40px;
        }
        .bar {
            width: 100%;
            height: 1px;
            background-color: black;
        }
        #orderList{
            width: 100%;
            height: 700px;
            overflow-y: auto;
            padding-right: 10px;
        }
        .item_wrap {
            width: 100%;
            height: 120px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 50px;
            border-bottom: 1px solid black;
            font-size: 18px;
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
        .item_price{
        		width: 100px;
        		text-align: right;
        }
    </style>
</head>
<body>
	<jsp:include page="common/header.jsp" />

    <section class="section_1">
        <div class="text">주문내역</div>
        <div class="bar"></div>
        <div id="orderList"></div>
    </section>

    <script>
        document.addEventListener("DOMContentLoaded", () => {
            const orders = JSON.parse(localStorage.getItem("orders") || "[]").reverse();
            const orderList = document.getElementById("orderList");

            if (orders.length === 0) {
                const noData = document.createElement("div");
                noData.textContent = "주문 내역이 없습니다.";
                noData.style.fontSize = "20px";
                noData.style.marginTop = "50px";
                orderList.appendChild(noData);
                return;
            }

            orders.forEach(order => {
                const itemWrap = document.createElement("div");
                itemWrap.className = "item_wrap";

                const day = document.createElement("div");
                day.className = "item_day";
                day.textContent = order.date;

                const img = document.createElement("img");
                img.className = "item_img";
                img.src = order.imageUrl;
                img.alt = order.name;

                const name = document.createElement("div");
                name.className = "item_text";
                name.textContent = order.name;

                const count = document.createElement("div");
                count.className = "item_count";
                count.textContent = order.count + "개";

                const price = document.createElement("div");
                price.className = "item_price";
                price.textContent = (order.price * order.count).toLocaleString() + "원";

                itemWrap.appendChild(day);
                itemWrap.appendChild(img);
                itemWrap.appendChild(name);
                itemWrap.appendChild(count);
                itemWrap.appendChild(price);

                orderList.appendChild(itemWrap);
            });
        });
    </script>
</body>
</html>
