package controller;

import dao.ProductDAO;
import model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.*;
import java.util.UUID;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,      // 1MB
    maxFileSize = 1024 * 1024 * 5,        // 5MB per file
    maxRequestSize = 1024 * 1024 * 30     // 30MB total
)
public class UpdateProductServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        int price = Integer.parseInt(request.getParameter("price"));
        String description = request.getParameter("description");

        // 업로드 경로 설정
        String uploadPath = request.getServletContext().getRealPath("/uploaded");
        Files.createDirectories(Paths.get(uploadPath));

        String imageUrl = null;

        for (Part part : request.getParts()) {
            if (part.getName().equals("images") && part.getSize() > 0) {
                String fileName = UUID.randomUUID() + "_" + Paths.get(part.getSubmittedFileName()).getFileName().toString();
                Path filePath = Paths.get(uploadPath, fileName);

                try (InputStream input = part.getInputStream()) {
                    Files.copy(input, filePath, StandardCopyOption.REPLACE_EXISTING);
                }

                imageUrl = "uploaded/" + fileName;
                break; // 첫 번째 이미지만 사용 (이미지 1장만 저장)
            }
        }

        // 상품 정보 객체 생성
        Product p = new Product();
        p.setProductId(id);
        p.setName(name);
        p.setPrice(price);
        p.setDescription(description);
        if (imageUrl != null) {
            p.setImageUrl(imageUrl);  // 새 이미지 있을 경우만 설정
        }

        // DAO 호출
        ProductDAO dao = new ProductDAO();
        dao.updateProduct(p);

        // 완료 후 상품 목록 페이지로 이동
        response.sendRedirect("productList");
    }
}
