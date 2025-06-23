package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.*;
import javax.servlet.http.*;
import dao.ProductDAO;
import model.Product;

public class ProductListServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // ✅ DAO로부터 상품 리스트 가져오기
        ProductDAO dao = new ProductDAO();
        List<Product> productList = dao.getAllProducts();

        // ✅ 디버깅 로그 출력
        System.out.println("📦 최종 상품 개수: " + productList.size());

        // ✅ JSP로 데이터 전달
        request.setAttribute("productList", productList);
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}
