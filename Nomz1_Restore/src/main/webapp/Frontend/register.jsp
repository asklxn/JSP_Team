<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>회원가입</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/Frontend/common/header.css" />
  <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
  <style>
    .section_1 {
      width: 500px;
      margin: 100px auto;
    }
    form {
      background-color: #dce5ed;
      border: 1px solid #0b1838;
      padding: 40px 0;
      box-shadow: 5px 5px 5px rgba(0, 0, 0, 0.3);
      display: flex;
      flex-direction: column;
      align-items: center;
    }
    .title {
      font-size: 35px;
      margin-bottom: 20px;
    }
    .form-group {
      width: 100%;
      padding: 10px 40px;
      display: flex;
      align-items: center;
    }
    label {
      width: 100px;
      font-size: 14px;
    }
    input {
      flex: 1;
      height: 35px;
      padding: 0 10px;
      font-size: 13px;
      border: 1px solid #0b1838;
      margin-right: 10px;
    }
    button {
      background-color: #0b1838;
      color: white;
      border: none;
      padding: 10px 20px;
      font-size: 14px;
      cursor: pointer;
      margin-top: 15px;
      box-shadow: 3px 3px 3px rgba(0, 0, 0, 0.3);
    }
    .sub_btn {
      background-color: #fffdf9a5;
      color: #0b1838;
      border: 1px solid #0b1838;
      font-size: 12px;
      padding: 5px 10px;
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

<section class="section_1">
  <form method="post" action="<%=request.getContextPath()%>/register">
    <div class="title">SIGN UP</div>
    <div class="form-group">
      <label for="name">이름</label>
      <input type="text" id="name" name="name" required placeholder="실명 입력" />
    </div>
    <div class="form-group">
      <label for="id">아이디</label>
      <input type="text" id="id" name="id" required minlength="6" maxlength="12" placeholder="6~12자 영소문자/숫자" />
      <button class="sub_btn" type="button" onclick="checkDuplicate()">중복 확인</button>
    </div>
    <div class="form-group">
      <label for="password">비밀번호</label>
      <input type="password" id="password" name="password" required minlength="8" maxlength="16" placeholder="특수문자 포함 8~16자" />
    </div>
    <div class="form-group">
      <label for="confirm-password">비밀번호 확인</label>
      <input type="password" id="confirm-password" required />
    </div>
    <div class="form-group">
      <label for="phone">전화번호</label>
      <input type="tel" id="phone" name="phone" required placeholder="01012345678" />
    </div>
    <div class="form-group">
      <label for="birth">생년월일</label>
      <input type="text" id="birth" name="birth" maxlength="6" required placeholder="YYMMDD" />
    </div>
    <div class="form-group">
      <label for="zipcode">주소</label>
      <input type="text" id="zipcode" name="zipcode" readonly />
      <button class="sub_btn" type="button" onclick="searchAddress()">주소 검색</button>
    </div>
    <div class="form-group">
      <label for="detailAddress">상세주소</label>
      <input type="text" id="detailAddress" name="detailAddress" required placeholder="건물명, 동/호수 등" />
    </div>
    <button type="submit">SIGN UP</button>
  </form>
</section>

<script>
  function checkDuplicate() {
    const id = document.getElementById("id").value.trim();
    if (!id) {
      alert("아이디를 입력해주세요.");
      return;
    }
    fetch("<%=request.getContextPath()%>/check_id.jsp?id=" + encodeURIComponent(id))
      .then(res => res.text())
      .then(data => {
        if (data.trim() === "EXISTS") {
          alert("이미 사용 중인 아이디입니다.");
        } else if (data.trim() === "AVAILABLE") {
          alert("사용 가능한 아이디입니다.");
        } else {
          alert("서버 오류가 발생했습니다.");
        }
      });
  }

  function searchAddress() {
    new daum.Postcode({
      oncomplete: function(data) {
        document.getElementById("zipcode").value = data.roadAddress || data.jibunAddress;
      }
    }).open();
  }

  document.querySelector("form").addEventListener("submit", function(e) {
    const pw = document.getElementById("password").value;
    const confirmPw = document.getElementById("confirm-password").value;
    if (pw !== confirmPw) {
      alert("비밀번호가 일치하지 않습니다.");
      e.preventDefault();
    }
  });
</script>

</body>
</html>
