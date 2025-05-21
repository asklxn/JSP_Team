<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="db.DBConnect" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상품 수정</title>
    <link rel="stylesheet" type="text/css" href="common/header.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        .section_1 {
            padding: 230px 0 150px;
            width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .image-preview {
            width: 550px; height: 550px;
            border: 2px solid #4e4e4e;
            display: flex; align-items: center; justify-content: center;
            background-color: white;
        }
        .add_text_wrap {
            width: 600px; display: flex; flex-direction: column; align-items: center;
        }
        .form-group {
            width: 100%; height: 40px; margin-bottom: 15px;
            display: flex; align-items: center;
        }
        label { width: 90px; font-weight: 600; text-align: center; }
        input { width: 100%; height: 40px; }
        input[type="text"], input[type="number"] {
            padding: 10px; border-radius: 5px; border: 1px solid #ccc;
        }
        input[type="file"] { display: none; }
        .btn-row {
            width: 100%;
            display: flex;
            justify-content: space-between;
        }
        .btn {
            width: 32%; height: 40px;
            font-size: 14px;
            border: none; border-radius: 5px;
            cursor: pointer; background-color: #e2e2e2;
        }
        .btn-upload { width: 100%; }
    </style>
</head>
<body>
	<jsp:include page="common/header.jsp" />

<section class="section_1">
    <div class="image-preview" id="imagePreview">
        <span>선택된 이미지 없음</span>
    </div>

    <div class="add_text_wrap">
        <div class="form-group">
            <label for="productName">상품 이름</label>
            <input type="text" id="productName" placeholder="상품명을 입력하세요">
        </div>
        <div class="form-group">
            <label for="productPrice">가격</label>
            <input type="number" id="productPrice" placeholder="가격을 입력하세요 ex.3000">
        </div>
        <div class="form-group">
            <button class="btn btn-upload" onclick="document.getElementById('productImage').click()">사진 변경</button>
            <input type="file" id="productImage" accept="image/*" onchange="previewImage(event)">
        </div>
        <div class="btn-row">
            <button class="btn btn-cancel" onclick="location.href='index.jsp'">취소</button>
            <button class="btn btn-cancel" onclick="deleteProduct()">삭제</button>
            <button class="btn btn-add" onclick="submitForm()">상품 수정</button>
        </div>
    </div>
</section>

<script>
    const selectedProduct = JSON.parse(localStorage.getItem("selectedProduct"));

    window.addEventListener("DOMContentLoaded", () => {
        if (selectedProduct) {
            document.getElementById("productName").value = selectedProduct.name || "";
            document.getElementById("productPrice").value = selectedProduct.price || "";

            const preview = document.getElementById("imagePreview");
            preview.innerHTML = "";
            const img = document.createElement("img");
            img.src = selectedProduct.imageUrl || "";
            img.style.width = "100%";
            img.style.height = "100%";
            img.style.objectFit = "cover";
            preview.appendChild(img);
        }
    });

    function previewImage(event) {
        const preview = document.getElementById("imagePreview");
        preview.innerHTML = "";

        const file = event.target.files[0];
        if (file) {
            const img = document.createElement("img");
            img.src = URL.createObjectURL(file);
            img.onload = () => URL.revokeObjectURL(img.src);
            img.style.width = "100%";
            img.style.height = "100%";
            img.style.objectFit = "cover";
            preview.appendChild(img);
        } else {
            preview.innerHTML = "<span>선택된 이미지 없음</span>";
        }
    }

    function submitForm() {
        const name = document.getElementById("productName").value.trim();
        const price = document.getElementById("productPrice").value.trim();
        const file = document.getElementById("productImage").files[0];

        if (!name || !price) {
            alert("상품 이름과 가격을 입력해주세요.");
            return;
        }

        if (isNaN(price) || parseInt(price) <= 0) {
            alert("가격은 0보다 큰 숫자만 입력 가능합니다.");
            return;
        }

        const products = JSON.parse(localStorage.getItem("products") || "[]");
        const updatedProduct = {
            name: name,
            price: parseInt(price),
            imageUrl: selectedProduct.imageUrl
        };

        if (file) {
            const reader = new FileReader();
            reader.onload = function () {
                updatedProduct.imageUrl = reader.result;
                saveProduct();
            };
            reader.readAsDataURL(file);
        } else {
            saveProduct();
        }

        function saveProduct() {
            const index = products.findIndex(p => p.name === selectedProduct.name && p.price === selectedProduct.price);
            if (index !== -1) {
                products[index] = updatedProduct;
                localStorage.setItem("products", JSON.stringify(products));
                alert("상품이 수정되었습니다!");
                location.href = 'index.jsp';
            } else {
                alert("상품을 찾을 수 없습니다.");
            }
        }
    }

    function deleteProduct() {
        if (!confirm("정말로 이 상품을 삭제하시겠습니까?")) return;

        const products = JSON.parse(localStorage.getItem("products") || "[]");
        const index = products.findIndex(p => p.name === selectedProduct.name && p.price === selectedProduct.price);

        if (index !== -1) {
            products.splice(index, 1);
            localStorage.setItem("products", JSON.stringify(products));
            alert("상품이 삭제되었습니다.");
            location.href = "index.jsp";
        } else {
            alert("삭제할 상품을 찾을 수 없습니다.");
        }
    }
</script>
</body>
</html>
