package controller;

import dao.MemberDAO;
import model.Member;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String id = request.getParameter("username");
        String pwd = request.getParameter("password");

        MemberDAO dao = new MemberDAO();
        Member member = dao.login(id, pwd);

        if (member != null) {
            HttpSession session = request.getSession();
            session.setAttribute("member", member);
            response.sendRedirect("productList"); // ✅ 여기 수정됨
        } else {
            response.sendRedirect("Frontend/login.jsp?error=1"); // 실패 시
        }
    }
}
