<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="db.DBConnect" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nome login</title>
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
            padding: 280px 300px 200px 300px;
            margin-left: 50%;
            transform: translateX(-50%);
        }
        form {
            width: 100%;
            height: 100%;
            background-color: #d4d4d4;
            display: flex;
            flex-direction: column;
            align-items: center;
            border-radius: 40px;
            padding: 40px;
        }
        .text {
            font-size: 35px;
            margin-bottom: 30px;
        }
        input {
            width: 100%;
            height: 40px;
            margin-bottom: 15px;
            border-radius: 5px;
            border: 1px solid gray;
            padding: 10px;
            font-size: 16px;
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
            border-radius: 10px;
            border: 1px solid gray;
            font-size: 20px;
            cursor: pointer;
            user-select: none;
        }
    </style>
</head>
<body>
	<jsp:include page="common/header.jsp" />

    <section class="section_1">
        <form method="post" action="login_ok.jsp">
            <div class="text">로그인</div>
            <input type="text" name="id" placeholder="아이디" required>
            <input type="password" name="password" placeholder="비밀번호" required>
            <div class="btn_wrap">
                <button type="submit">로그인</button>
                <button type="button" onclick="location.href='register.jsp'">회원가입</button>
            </div>
        </form>
    </section>
</body>
</html>