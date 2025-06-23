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
        String id = request.getParameter("id");
        String pwd = request.getParameter("pwd");

        MemberDAO dao = new MemberDAO();
        Member member = dao.login(id, pwd);

        if (member != null) {
            HttpSession session = request.getSession();
            session.setAttribute("member", member);
            response.sendRedirect("Frontend/index.jsp"); // 로그인 성공 시
        } else {
            response.sendRedirect("login.jsp?error=1"); // 실패 시
        }
    }
}
