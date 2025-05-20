<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="db.DBConnect" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nome 프로필</title>
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
            margin-left: 50%;
            transform: translateX(-50%);
            padding-top: 80px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .profile {
            width: 300px;
            height: 300px;
            border-radius: 50%;
            user-select: none;
        }
        .con_wrap {
            width: 850px;
        }
        .btn_wrap {
            width: 60%;
            height: 50px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-left: 50%;
            transform: translateX(-50%);
            margin-bottom: 20px;
        }
        .btn {
            width: 46%;
            height: 100%;
            background-color: #c0c0c0;
            text-align: center;
            line-height: 50px;
            font-size: 26px;
            cursor: pointer;
            user-select: none;
        }
        .bar {
            width: 100%;
            height: 1px;
            background-color: black;
        }
        .text_wrap {
            width: 100%;
            border-bottom: 1px solid black;
            display: flex;
            align-items: center;
            padding: 10px 0;
        }
        .label {
            width: 200px;
            text-align: center;
            font-weight: 600;
        }
        .value {
            width: 300px;
        }
    </style>
</head>
<body>
	<jsp:include page="common/header.jsp" />

    <section class="section_1">
        <img src="images/profile.jpg" alt="프로필 이미지" class="profile">
        <div class="con_wrap">
            <div class="btn_wrap">
                <div class="btn" onclick="location.href='orderHistory.jsp'">주문내역</div>
                <div class="btn">로그아웃</div>
            </div>
            <div class="bar"></div>

            <div class="text_wrap">
                <div class="label">이름</div>
                <div class="value">이예진</div>
            </div>
            <div class="text_wrap">
                <div class="label">아이디</div>
                <div class="value">yejin</div>
            </div>
            <div class="text_wrap">
                <div class="label">생년월일</div>
                <div class="value">051102</div>
            </div>
            <div class="text_wrap">
                <div class="label">전화번호</div>
                <div class="value">01012345678</div>
            </div>
            <div class="text_wrap">
                <div class="label">주소</div>
                <div class="value">부산광역시 부산진구 양지로 54 동의과학대학</div>
            </div>
        </div>
    </section>
</body>
</html>