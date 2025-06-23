<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Product, dao.ProductDAO" %>
<%
    String idStr = request.getParameter("id");
    Product product = null;
    if (idStr != null) {
        try {
            int id = Integer.parseInt(idStr);
            product = new ProductDAO().getProductById(id);
        } catch (Exception e) {
            out.println("<p style='color:red;'>상품 정보를 불러오지 못했습니다.</p>");
        }
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>Nomz 상품 수정</title>
  <link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
  <link rel="stylesheet" href="<%=request.getContextPath()%>/Frontend/common/header.css" />
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    #editor { max-width: 800px; margin: 20px auto; }
    .toastui-editor-contents { text-align: center; }
    .toastui-editor-contents img { display: block; margin: 0 auto; max-width: 100%; height: auto; }
    .add_text { font-size: 24px; text-align: center; margin-top: 30px; }
    .section_1 {
      width: 500px; margin: 100px auto 0; padding: 40px;
      display: flex; flex-direction: column; align-items: center;
      background-color: #dce5ed; border: 1px solid #0b1838;
    }
    .form-group {
      width: 100%; display: flex;
      justify-content: flex-start; align-items: center; margin-bottom: 15px;
    }
    label { font-size: 14px; width: 100px; }
    input[type="text"], input[type="number"] {
      flex: 1; height: 30px; padding: 5px 10px;
      border: none; background-color: transparent;
      border-bottom: 1px solid #0b1838; outline: none;
    }
    input[type="file"] { display: none; }
    .add_file {
      width: 100%; display: flex; flex-direction: column; align-items: center;
    }
    .btn-upload {
      width: 100%; height: 40px; font-size: 14px;
      cursor: pointer; background-color: #fffdf9;
      border: none; margin-bottom: 10px;
    }
    .dash { margin: 20px 0; width: 100%; border-bottom: 1px dashed #333; }
    #fileNameDisplay {
      font-size: 14px; text-align: center; white-space: pre-wrap;
    }
    .btn-row {
      width: 500px; margin: 50px auto;
      display: flex; justify-content: space-between;
    }
    .btn {
      width: 49%; height: 50px; font-size: 14px;
      border: none; cursor: pointer;
      background-color: #dce5ed; border: 1px solid #0b1838;
    }
  </style>
</head>
<body>
  <header>
    <img onclick="location.href='<%=request.getContextPath()%>/productList'"
         src="<%=request.getContextPath()%>/Frontend/images/logo_b.png"
         alt="로고" class="logo" />
    <div class="menu_wrap">
      <div class="menu" onclick="location.href='<%=request.getContextPath()%>/Frontend/addItem.jsp'">ADD MENU</div>
      <div class="menu" onclick="location.href='<%=request.getContextPath()%>/Frontend/login.jsp'">LOGIN</div>
      <div class="menu" onclick="location.href='<%=request.getContextPath()%>/Frontend/qna.jsp'">Q&A</div>
      <div class="menu" onclick="location.href='<%=request.getContextPath()%>/Frontend/profile.jsp'">MY PAGE</div>
      <div class="menu" onclick="location.href='<%=request.getContextPath()%>/Frontend/cart.jsp'">CART</div>
    </div>
  </header>

  <% if (product != null) { %>
  <form method="post" action="<%=request.getContextPath()%>/updateProduct" enctype="multipart/form-data">
    <input type="hidden" name="id" value="<%=product.getProductId()%>">

    <section class="section_1">
      <div class="form-group">
        <label for="productName">상품 이름 :</label>
        <input type="text" id="productName" name="name" value="<%=product.getName()%>" required />
      </div>

      <div class="dash"></div>

      <div class="form-group">
        <label for="productPrice">가격 :</label>
        <input type="number" id="productPrice" name="price" value="<%=product.getPrice()%>" required />
      </div>

      <div class="dash"></div>

      <div class="add_file">
        <button type="button" class="btn-upload" onclick="document.getElementById('productImage').click()">사진 추가</button>
        <input type="file" id="productImage" name="images" accept="image/*" multiple onchange="displayFileNames(event)" />
        <div id="fileNameDisplay">사진 최대 5장</div>
      </div>
    </section>

    <div class="add_text">상세페이지 입력</div>
    <div id="editor"></div>

    <div class="btn-row">
      <button type="button" class="btn" onclick="location.href='<%=request.getContextPath()%>/productList'">취소</button>
      <button type="submit" class="btn">수정하기</button>
    </div>
  </form>
  <% } else { %>
    <p style="color:red; text-align:center;">잘못된 상품 ID입니다.</p>
  <% } %>

  <script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
  <script>
    const editor = new toastui.Editor({
      el: document.querySelector("#editor"),
      height: "500px",
      initialEditType: "wysiwyg",
      previewStyle: "none",
      language: "ko",
      hideModeSwitch: true,
      hooks: {
        addImageBlobHook: (blob, callback) => {
          const imageUrl = URL.createObjectURL(blob);
          callback(imageUrl, "이미지 설명");
          return false;
        },
      },
    });

    window.addEventListener("DOMContentLoaded", () => {
      editor.setHTML(`<%=product != null ? product.getDescription().replaceAll("\"", "\\\\\"") : ""%>`);
    });

    function displayFileNames(event) {
      const fileInput = event.target;
      const fileNameDisplay = document.getElementById("fileNameDisplay");

      if (fileInput.files.length > 5) {
        alert("최대 5장까지만 선택할 수 있습니다.");
        fileInput.value = "";
        fileNameDisplay.textContent = "사진 최대 5장";
        return;
      }

      const names = Array.from(fileInput.files).map(file => file.name);
      fileNameDisplay.textContent = names.join("\n");
    }

    document.querySelector("form")?.addEventListener("submit", function (e) {
      const detailHtml = editor.getHTML().trim();
      if (!detailHtml || detailHtml === "<p><br></p>") {
        e.preventDefault();
        alert("상세페이지 내용을 입력해주세요.");
      } else {
        const hidden = document.createElement("input");
        hidden.type = "hidden";
        hidden.name = "description";
        hidden.value = detailHtml;
        this.appendChild(hidden);
      }
    });
  </script>
</body>
</html>
