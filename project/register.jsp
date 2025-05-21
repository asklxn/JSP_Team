<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="db.DBConnect" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nome 회원가입</title>
    <link rel="stylesheet" type="text/css" href="common/header.css">
    <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
		    
        .section_1 {
            width: 1200px;
            height: 100vh;
            padding: 130px 300px 50px 300px;
            margin-left: 50%;
            transform: translateX(-50%);
        }
        form {
            width: 550px;
            height: 600px;
            background-color: #e4e4e4;
            display: flex;
            flex-direction: column;
            align-items: center;
            border-radius: 40px;
            padding: 40px;
        }
        .form-group {
            width: 100%;
            height: 35px;
            margin-bottom: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .text {
            font-size: 35px;
            margin-bottom: 30px;
        }
        label {
            width: 150px;
            text-align: center;
            font-size: 16px;
        }
        input {
            width: 270px;
            height: 35px;
            border-radius: 5px;
            border: 1px solid gray;
            padding: 10px;
            font-size: 12px;
            margin-right: 100px;
        }
        .sub_btn {
            width: 90px;
            height: 35px;
            font-size: 12px;
            border-radius: 5px;
            border: 1px solid gray;
            cursor: pointer;
            margin: 0px 0px 0px -90px;
            user-select: none;
        }
        button {
            margin-top: 10px;
            width: 150px;
            height: 50px;
            border-radius: 10px;
            border: 1px solid gray;
            font-size: 20px;
            cursor: pointer;
            background-color: white;
            user-select: none;
        }
    </style>
</head>
<body>
	<jsp:include page="common/header.jsp" />

    <section class="section_1">
        <form method="post" action="register_ok.jsp">
            <div class="text">회원가입</div>
            <div class="form-group">
                <label for="name">이름</label>
                <input type="text" id="name" name="name" placeholder="실명을 입력해주세요" required>
            </div>
            <div class="form-group">
                <label for="id">아이디</label>
                <input type="text" id="id" name="id" placeholder="소문자, 숫자 (6자~12자)" minlength="6" maxlength="12" required>
                <button class="sub_btn" type="button" onclick="checkDuplicate()">중복 확인</button>
            </div>
            <div class="form-group">
                <label for="password">비밀번호</label>
                <input type="password" id="password" name="password" placeholder="소문자, 숫자, (@,!,$) (8자~16자)" minlength="8" maxlength="16" required>
            </div>
            <div class="form-group">
                <label for="confirm-password">비밀번호 확인</label>
                <input type="password" id="confirm-password" name="confirm-password" required>
            </div>
            <div class="form-group">
                <label for="phone">전화번호</label>
                <input type="tel" id="phone" name="phone" placeholder="01012345678" required>
            </div>
            <div class="form-group">
                <label for="birth">생년월일</label>
                <input type="text" id="birth" name="birth" placeholder="YYMMDD" maxlength="6" required>
            </div>
            <div class="form-group">
                <label for="zipcode">주소</label>
                <input type="text" id="zipcode" name="zipcode" placeholder="주소 검색" readonly>
                <button class="sub_btn" type="button" onclick="searchAddress()">주소 검색</button>
            </div>
            <div class="form-group">
                <label for="detailAddress">상세 주소</label>
                <input type="text" id="detailAddress" name="detailAddress" placeholder="건물명, 동/호수 등의 상세주소 입력" required>
            </div>
            <button type="submit" class="submit-btn">회원가입</button>
        </form>
    </section>
    
    <script>
        function checkDuplicate() {
            const id = document.getElementById("id").value.trim();
            if (!id) {
                alert("아이디를 입력해주세요.");
                return;
            }

            fetch("check_id.jsp?id=" + encodeURIComponent(id))
                .then(response => response.text())
                .then(data => {
                    const result = data.trim();
                    if (result === "EXISTS") {
                        alert("이미 사용 중인 아이디입니다.");
                    } else if (result === "AVAILABLE") {
                        alert("사용 가능한 아이디입니다.");
                    } else {
                        alert("오류가 발생했습니다.");
                    }
                })
                .catch(error => {
                    console.error("오류 발생:", error);
                    alert("서버 요청 중 문제가 발생했습니다.");
                });
        }

        document.querySelector("form").addEventListener("submit", function(event) {
            const pw = document.getElementById("password").value;
            const confirmPw = document.getElementById("confirm-password").value;

            if (pw !== confirmPw) {
                alert("비밀번호가 일치하지 않습니다.");
                event.preventDefault();
            }
        });

        function searchAddress() {
            new daum.Postcode({
                oncomplete: function(data) {
                    document.getElementById("zipcode").value = data.roadAddress || data.jibunAddress;
                }
            }).open();
        }
    </script>
</body>
</html>