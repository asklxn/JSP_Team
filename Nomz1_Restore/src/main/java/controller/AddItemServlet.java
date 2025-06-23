package controller;

import java.io.*;
import java.nio.file.*;

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
        
        // ✅ 저장할 경로 (webapp/uploads)
        String uploadDir = request.getServletContext().getRealPath("/uploads");
        Files.createDirectories(Paths.get(uploadDir)); // 폴더 없으면 생성
        
        // 🔍 실제 저장되는 위치 확인
        System.out.println("✅ 이미지 저장 경로: " + uploadDir);

        // 저장할 파일명
        String fileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();

        // 실제 파일 저장
        imagePart.write(uploadDir + File.separator + fileName);

        // ✅ DB에 저장할 이미지 URL (상대 경로)
        String imagePath = "uploads/" + fileName;

        // Product 객체 생성
        Product p = new Product();
        p.setName(name);
        p.setPrice(price);
        p.setStock(999); // 기본 재고
        p.setDescription(description);
        p.setImageUrl(imagePath);

        // DAO 저장
        ProductDAO dao = new ProductDAO();
        dao.insertProduct(p);

        response.sendRedirect("productList");
    }
}
