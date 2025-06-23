package controller;

import java.io.IOException;
import java.sql.Date;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import dao.MemberDAO;
import model.Member;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // 폼 데이터 받기
        String name = request.getParameter("name");
        String username = request.getParameter("id"); // 아이디 name 속성은 id
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String birth = request.getParameter("birth"); // YYMMDD 형식
        String address = request.getParameter("zipcode");
        String detailAddress = request.getParameter("detailAddress");

        // birth 변환: YYMMDD → yyyy-MM-dd
        Date birthDate = null;
        try {
            if (birth != null && birth.length() == 6) {
                String yearPrefix = Integer.parseInt(birth.substring(0, 2)) >= 50 ? "19" : "20";
                String yyyy = yearPrefix + birth.substring(0, 2);
                String MM = birth.substring(2, 4);
                String dd = birth.substring(4, 6);
                String formattedBirth = yyyy + "-" + MM + "-" + dd;
                birthDate = Date.valueOf(formattedBirth);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println("<script>alert('생년월일 형식이 올바르지 않습니다.'); history.back();</script>");
            return;
        }

        // Member 객체 생성
        Member member = new Member();
        member.setName(name);
        member.setUsername(username);
        member.setPassword(password);
        member.setPhone(phone);
        member.setBirth(birthDate); // java.sql.Date
        member.setAddress(address);
        member.setDetailAddress(detailAddress);

        // DB 저장
        MemberDAO dao = new MemberDAO();
        boolean success = dao.insertMember(member);

        // 결과에 따른 이동
        if (success) {
            response.sendRedirect("Frontend/login.jsp");
        } else {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println("<script>alert('회원가입에 실패했습니다.'); history.back();</script>");
        }
    }
}
