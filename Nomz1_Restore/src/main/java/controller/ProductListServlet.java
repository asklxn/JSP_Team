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
        ProductDAO dao = new ProductDAO();
        List<Product> productList = dao.getAllProducts();
        request.setAttribute("productList", productList);
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}
