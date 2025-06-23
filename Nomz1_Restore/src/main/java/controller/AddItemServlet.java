package controller;

import java.io.*;
import java.nio.file.*;
import java.util.*;

import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;

import dao.ProductDAO;
import model.Product;

@MultipartConfig(
    maxFileSize = 2 * 1024 * 1024, // 2MB
    maxRequestSize = 10 * 1024 * 1024 // 최대 10MB
)
public class AddItemServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String name = request.getParameter("productName");
        int price = Integer.parseInt(request.getParameter("productPrice"));
        String description = request.getParameter("productDescription");
        Part imagePart = request.getPart("productImage");

        // 저장할 경로 (웹 루트 기준 /Frontend/uploads/)
        String uploadDir = request.getServletContext().getRealPath("/Frontend/uploads");
        Files.createDirectories(Paths.get(uploadDir)); // 폴더 없으면 생성

        // 저장할 파일명
        String fileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
        String imagePath = "/Frontend/uploads/" + fileName;

        // 실제 파일 저장
        imagePart.write(uploadDir + File.separator + fileName);

        // Product 객체 생성
        Product p = new Product();
        p.setName(name);
        p.setPrice(price);
        p.setStock(999); // 기본 재고 (필요시 수정)
        p.setDescription(description);
        p.setImageUrl(imagePath);

        // DAO 저장
        ProductDAO dao = new ProductDAO();
        dao.insertProduct(p);

        response.sendRedirect("productList");
    }
}
