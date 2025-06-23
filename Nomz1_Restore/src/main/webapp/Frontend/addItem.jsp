<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>Nomz add item</title>
  <link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
  <link rel="stylesheet" href="<%=request.getContextPath()%>/Frontend/common/header.css" />
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    #editor { max-width: 800px; margin: 20px auto; }
    .toastui-editor-contents { text-align: center; }
    .toastui-editor-contents img { display: block; margin: 0 auto; width: 500px; height: auto; }
    .add_text { font-size: 24px; text-align: center; margin-top: 30px; }
    .section_1 {
      width: 400px;
      margin: 100px auto 0;
      padding: 40px;
      display: flex;
      flex-direction: column;
      align-items: center;
      background-color: #dce5ed;
      border: 1px solid #0b1838;
      box-shadow: 5px 5px 5px rgba(0, 0, 0, 0.3);
    }
    .form-group {
      width: 100%; height: 40px;
      display: flex; justify-content: space-between; align-items: center;
    }
    .add_file { width: 100%; display: flex; flex-direction: column; align-items: center; }
    label { font-size: 14px; }
    input[type="text"], input[type="number"] {
      width: 240px;
      height: 30px;
      padding: 5px 10px;
      border: none;
      background-color: transparent;
      border-bottom: 1px solid #0b1838;
      outline: none;
    }
    input[type="file"] { display: none; }
    .btn-upload {
      width: 100%; height: 40px;
      font-size: 14px; cursor: pointer;
      background-color: #fffdf9;
      border: none; margin-bottom: 10px;
    }
    .dash { margin: 20px 0; }
    #fileNameDisplay { font-size: 14px; text-align: center; white-space: pre-wrap; }
    .btn-row {
      width: 500px;
      margin: 50px auto;
      display: flex;
      justify-content: space-between;
    }
    .btn {
      width: 49%; height: 50px;
      font-size: 14px; border: none;
      cursor: pointer; background-color: #dce5ed;
      border: 1px solid #0b1838;
      box-shadow: 3px 3px 3px rgba(0, 0, 0, 0.3);
    }
    .logo { height: 60px; margin: 10px; cursor: pointer; }
  </style>
</head>
<body>
<header>
  <img onclick="location.href='<%=request.getContextPath()%>/index.jsp'"
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

<form action="<%=request.getContextPath()%>/addItem" method="post" enctype="multipart/form-data">
  <section class="section_1">
    <div class="form-group">
      <label for="productName">상품 이름 : </label>
      <input type="text" id="productName" name="productName" placeholder="상품명을 입력하세요" />
    </div>
    <div class="dash"></div>
    <div class="form-group">
      <label for="productPrice">가격 : </label>
      <input type="number" id="productPrice" name="productPrice" placeholder="가격을 입력하세요 ex.3000" />
    </div>
    <div class="dash"></div>
    <div class="add_file">
      <button type="button" class="btn-upload" onclick="document.getElementById('productImage').click()">사진 추가</button>
      <input type="file" id="productImage" name="productImage" accept="image/*" multiple onchange="displayFileNames(event)" />
      <div id="fileNameDisplay">사진 최대 5장</div>
    </div>
  </section>

  <div class="add_text">상세페이지 입력</div>
  <div id="editor"></div>
  <textarea name="productDescription" id="productDetail" style="display: none;"></textarea>
  <div class="btn-row">
    <button type="reset" class="btn">취소</button>
    <button type="submit" class="btn">상품 추가</button>
  </div>
</form>

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

  function validateForm() {
    const name = document.getElementById("productName").value.trim();
    const price = document.getElementById("productPrice").value.trim();
    const files = document.getElementById("productImage").files;
    const detailHtml = editor.getHTML().trim();

    if (!name) {
      alert("상품 이름을 입력해주세요.");
      return false;
    }
    if (!price || isNaN(price) || parseInt(price) <= 0) {
      alert("가격은 0보다 큰 숫자만 입력 가능합니다.");
      return false;
    }
    if (files.length < 1) {
      alert("최소 1장 이상의 이미지를 선택해주세요.");
      return false;
    }
    if (files.length > 5) {
      alert("이미지는 최대 5장까지 업로드할 수 있습니다.");
      return false;
    }
    for (let file of files) {
      if (file.size > 2 * 1024 * 1024) {
        alert("각 이미지 파일은 2MB 이하여야 합니다.");
        return false;
      }
    }
    if (!detailHtml || detailHtml === "<p><br></p>") {
      alert("상세페이지 내용을 입력해주세요.");
      return false;
    }

    document.getElementById("productDetail").value = detailHtml;
    return true;
  }
</script>
</body>
</html>
