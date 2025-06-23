<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Nomz Login</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/Frontend/common/header.css" />
  <style>
    /* 기존 스타일 그대로 유지 */
    .section_1 {
      width: 500px;
      height: 350px;
      margin: 200px auto;
    }
    form {
      width: 100%;
      background-color: #dce5ed;
      display: flex;
      flex-direction: column;
      align-items: center;
      padding: 50px;
      border: 1px solid #0b1838;
      box-shadow: 5px 5px 5px rgba(0, 0, 0, 0.3);
    }
    .text {
      font-family: "amoria-font";
      font-size: 35px;
      margin-bottom: 30px;
    }
    input {
      width: 100%;
      height: 40px;
      margin-bottom: 15px;
      border: 1px solid #0b1838;
      padding: 10px;
      font-size: 16px;
      outline: none;
    }
    .btn_wrap {
      width: 320px;
      height: 40px;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    button {
      margin-top: 10px;
      width: 150px;
      height: 40px;
      font-size: 16px;
      cursor: pointer;
      background-color: #0b1838;
      border: none;
      color: #fffdf9;
      user-select: none;
      box-shadow: 3px 3px 3px rgba(0, 0, 0, 0.3);
    }
  </style>
</head>
<body>
<header>
  <img onclick="location.href='<%=request.getContextPath()%>/Frontend/index.jsp'"
       src="<%=request.getContextPath()%>/Frontend/images/logo_b.png" alt="로고" class="logo" />
  <div class="menu_wrap">
    <div class="menu" onclick="location.href='<%=request.getContextPath()%>/Frontend/addItem.jsp'">ADD MENU</div>
    <div class="menu" onclick="location.href='<%=request.getContextPath()%>/Frontend/login.jsp'">LOGIN</div>
    <div class="menu" onclick="location.href='<%=request.getContextPath()%>/Frontend/qna.jsp'">Q&A</div>
    <div class="menu" onclick="location.href='<%=request.getContextPath()%>/Frontend/profile.jsp'">MY PAGE</div>
    <div class="menu" onclick="location.href='<%=request.getContextPath()%>/Frontend/cart.jsp'">CART</div>
  </div>
</header>

<section class="section_1">
  <form method="post" action="<%=request.getContextPath()%>/login">
    <div class="text">LOGIN</div>
    <input type="text" name="id" placeholder="아이디" required />
    <input type="password" name="pwd" placeholder="비밀번호" required />
    <div class="btn_wrap">
      <button type="submit">로그인</button>
      <button type="button" onclick="location.href='<%=request.getContextPath()%>/Frontend/register.jsp'">회원가입</button>
    </div>
  </form>

  <%-- 에러 메시지 출력 (optional) --%>
  <% if (request.getParameter("error") != null) { %>
    <p style="color:red; text-align:center; margin-top:10px;">로그인 실패! 다시 시도해주세요.</p>
  <% } %>
</section>
</body>
</html>
