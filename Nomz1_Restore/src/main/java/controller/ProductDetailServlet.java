package controller;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.ProductDAO;
import model.Product;

@WebServlet("/productDetail")
public class ProductDetailServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        int productId = Integer.parseInt(request.getParameter("product_id"));

        ProductDAO dao = new ProductDAO();
        Product product = dao.getProductById(productId);

        System.out.println("🐾 product = " + product);

        request.setAttribute("product", product);
        RequestDispatcher rd = request.getRequestDispatcher("Frontend/detail.jsp");
        rd.forward(request, response);
    }
}
