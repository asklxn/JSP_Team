<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="db.DBConnect" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Nome Q&A</title>
  <link rel="stylesheet" type="text/css" href="common/header.css">
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }
    .section_1 {
      width: 1200px;
      padding-top: 100px;
      margin-left: 50%;
      transform: translateX(-50%);
    }
    .title {
      text-align: center;
      font-size: 40px;
      margin: 30px 0;
      user-select: none;
    }
    .con_wrap {
      width: 100%;
      display: flex;
      flex-direction: column;
      margin-top: 30px;
      background-color: #e8e8e8;
      border-radius: 20px;
      padding: 10px 0;
    }
    .date {
      font-size: 12px;
      color: #666;
      user-select: none;
    }
    .con {
      width: 100%;
      display: flex;
      flex-direction: column;
      padding: 10px 20px;
    }
    .con_row {
      display: flex;
      align-items: center;
      justify-content: space-between;
    }
    .profile_wrap {
      display: flex;
      flex-direction: column;
      align-items: center;
      margin-right: 20px;
      user-select: none;
    }
    .profile_img {
      width: 50px;
      height: 50px;
      border-radius: 50%;
      object-fit: cover;
      margin-bottom: 3px;
      border: 1px solid rgba(60, 60, 60, 0.334);
      user-select: none;
    }
    .id {
      font-size: 16px;
      user-select: none;
    }
    .text_wrap {
      flex: 1;
      display: flex;
      flex-direction: column;
    }
    .text {
      border-radius: 100px;
      background-color: ivory;
      padding: 10px 20px;
      word-break: break-word;
      margin: 5px 0;
    }
    .reply_input {
      display: none;
      gap: 10px;
      margin-left: 70px;
      margin-top: 10px;
    }
    .btns {
      display: flex;
      align-items: center;
      margin-left: 10px;
      user-select: none;
    }
    .comment_btn, .del_btn {
      width: 30px;
      height: 30px;
      object-fit: cover;
      cursor: pointer;
      margin-left: 10px;
      user-select: none;
    }
    .reply {
      display: flex;
      padding-left: 70px;
      margin-top: 10px;
      align-items: center;
    }
    .reply .profile_wrap {
      margin-right: 20px;
    }
    .no_comments {
      padding: 20px;
      text-align: center;
      color: #555;
      user-select: none;
    }
    form {
      width: 100%;
      background-color: #e8e8e8;
      border-radius: 20px;
      padding: 20px;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    input {
      width: 100%;
      padding: 10px;
      border-radius: 5px;
      border: 1px solid gray;
    }
    button {
      width: 70px;
      padding: 10px;
      cursor: pointer;
      margin-left: 10px;
      border-radius: 5px;
      border: 1px solid gray;
      background-color: ivory;
      user-select: none;
    }
  </style>
</head>
<body>
	<jsp:include page="common/header.jsp" />
  <section class="section_1">
    <div class="title">Q&A</div>
    <form id="commentForm" onsubmit="return false;">
      <input type="text" name="comment" id="commentInput" placeholder="댓글을 남겨주세요." required>
      <button type="button" id="submitBtn">등록</button>
    </form>
    <div class="con_wrap" id="commentList"></div>
  </section>
  <script>
    document.addEventListener("DOMContentLoaded", () => {
      const input = document.getElementById("commentInput");
      const list = document.getElementById("commentList");
      const submitBtn = document.getElementById("submitBtn");
      let comments = JSON.parse(localStorage.getItem("qna_comments") || "[]");

      function renderComments() {
        list.innerHTML = "";
        comments.forEach((comment, index) => {
          const wrapper = document.createElement("div");
          wrapper.className = "con";

          const row = document.createElement("div");
          row.className = "con_row";

          const profileWrap = document.createElement("div");
          profileWrap.className = "profile_wrap";
          profileWrap.innerHTML = '<img src="images/profile.jpg" alt="프로필" class="profile_img">' +
                                  '<div class="id">user</div>';

          const textWrap = document.createElement("div");
          textWrap.className = "text_wrap";

          const dateDiv = document.createElement("div");
          dateDiv.className = "date";
          dateDiv.textContent = comment.date || "";

          const textDiv = document.createElement("div");
          textDiv.className = "text";
          textDiv.textContent = comment.content || "";

          textWrap.appendChild(dateDiv);
          textWrap.appendChild(textDiv);

          const btns = document.createElement("div");
          btns.className = "btns";

          const commentBtn = document.createElement("img");
          commentBtn.src = "images/comment.png";
          commentBtn.alt = "댓글";
          commentBtn.className = "comment_btn";

          const delBtn = document.createElement("img");
          delBtn.src = "images/del.png";
          delBtn.alt = "삭제";
          delBtn.className = "del_btn";

          btns.appendChild(commentBtn);
          btns.appendChild(delBtn);

          row.appendChild(profileWrap);
          row.appendChild(textWrap);
          row.appendChild(btns);

          wrapper.appendChild(row);

          const replyInputDiv = document.createElement("div");
          replyInputDiv.className = "reply_input";
          replyInputDiv.style.display = "none";

          const replyInput = document.createElement("input");
          replyInput.placeholder = "답글을 입력하세요";

          const replyBtn = document.createElement("button");
          replyBtn.textContent = "등록";

          replyInputDiv.appendChild(replyInput);
          replyInputDiv.appendChild(replyBtn);
          wrapper.appendChild(replyInputDiv);

          commentBtn.addEventListener("click", () => {
            replyInputDiv.style.display = replyInputDiv.style.display === "flex" ? "none" : "flex";
          });

          delBtn.addEventListener("click", () => {
            comments.splice(index, 1);
            localStorage.setItem("qna_comments", JSON.stringify(comments));
            renderComments();
          });

          replyBtn.addEventListener("click", () => {
            const replyText = replyInput.value.trim();
            if (!replyText) return;

            const now = new Date();
            const date = now.getFullYear() + "-" +
                        String(now.getMonth() + 1).padStart(2, "0") + "-" +
                        String(now.getDate()).padStart(2, "0") + " " +
                        String(now.getHours()).padStart(2, "0") + ":" +
                        String(now.getMinutes()).padStart(2, "0");

            const replyObj = {
              content: replyText,
              date: date,
              profile: "images/logo_profile.png",
              id: "nomz"
            };

            if (!comment.replies) comment.replies = [];
            comment.replies.push(replyObj);
            localStorage.setItem("qna_comments", JSON.stringify(comments));
            renderComments();
          });

          if (comment.replies) {
            comment.replies.forEach((reply, rIndex) => {
              const replyRow = document.createElement("div");
              replyRow.className = "reply";

              const replyProfile = document.createElement("div");
              replyProfile.className = "profile_wrap";
              replyProfile.innerHTML = '<img src="images/logo_profile.png" alt="프로필" class="profile_img">' +
                                       '<div class="id">nomz</div>';

              const replyTextWrap = document.createElement("div");
              replyTextWrap.className = "text_wrap";

              const replyDate = document.createElement("div");
              replyDate.className = "date";
              replyDate.textContent = reply.date;

              const replyContent = document.createElement("div");
              replyContent.className = "text";
              replyContent.textContent = reply.content;

              replyTextWrap.appendChild(replyDate);
              replyTextWrap.appendChild(replyContent);

              const replyDel = document.createElement("img");
              replyDel.src = "images/del.png";
              replyDel.alt = "삭제";
              replyDel.className = "del_btn";
              replyDel.addEventListener("click", () => {
                comment.replies.splice(rIndex, 1);
                localStorage.setItem("qna_comments", JSON.stringify(comments));
                renderComments();
              });

              replyRow.appendChild(replyProfile);
              replyRow.appendChild(replyTextWrap);
              replyRow.appendChild(replyDel);

              wrapper.appendChild(replyRow);
            });
          }

          list.appendChild(wrapper);
        });
      }

      submitBtn.addEventListener("click", () => {
        const content = input.value.trim();
        if (!content) return;

        const now = new Date();
        const date = now.getFullYear() + "-" +
                    String(now.getMonth() + 1).padStart(2, "0") + "-" +
                    String(now.getDate()).padStart(2, "0") + " " +
                    String(now.getHours()).padStart(2, "0") + ":" +
                    String(now.getMinutes()).padStart(2, "0");

        const newComment = { content, date, replies: [] };
        comments.push(newComment);
        localStorage.setItem("qna_comments", JSON.stringify(comments));
        input.value = "";
        renderComments();
      });

      renderComments();
    });
  </script>
</body>
</html>
