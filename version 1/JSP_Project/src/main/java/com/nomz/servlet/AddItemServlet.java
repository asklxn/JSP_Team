// AddItemServlet.java

package com.nomz.servlet;


import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;
import java.util.UUID;

@WebServlet("/addItem")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1MB
    maxFileSize = 5 * 1024 * 1024,   // 5MB
    maxRequestSize = 25 * 1024 * 1024 // 25MB
)
public class AddItemServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        PrintWriter out = response.getWriter();

        String name = request.getParameter("productName");
        String priceStr = request.getParameter("productPrice");
        String description = request.getParameter("productDetail");
        Part imagePart = request.getPart("productImage");

        if (name == null || name.trim().isEmpty()) {
            out.println("<script>alert('상품 이름이 비어있습니다.'); history.back();</script>");
            return;
        }

        int price = (priceStr != null && !priceStr.isEmpty()) ? Integer.parseInt(priceStr) : 0;

        String uploadPath = getServletContext().getRealPath("/") + "upload";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        String imageName = null;
        if (imagePart != null && imagePart.getSize() > 0) {
            imageName = UUID.randomUUID().toString() + "_" + imagePart.getSubmittedFileName();
            imagePart.write(uploadPath + File.separator + imageName);
        }

        Connection conn = null;
        PreparedStatement ps = null;
        PreparedStatement psImg = null;
        ResultSet rs = null;

        try {
            Class.forName("org.mariadb.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/Nomz", "YeonJi", "1111");

            String sql = "INSERT INTO products (name, price, description) VALUES (?, ?, ?)";
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, name);
            ps.setInt(2, price);
            ps.setString(3, description);
            ps.executeUpdate();

            rs = ps.getGeneratedKeys();
            int productId = 0;
            if (rs.next()) {
                productId = rs.getInt(1);
            }

            if (imageName != null && !imageName.isEmpty()) {
                String imgSql = "INSERT INTO product_images (product_id, image_url) VALUES (?, ?)";
                psImg = conn.prepareStatement(imgSql);
                psImg.setInt(1, productId);
                psImg.setString(2, "upload/" + imageName);
                psImg.executeUpdate();
            }

            out.println("<script>alert('상품이 등록되었습니다.'); location.href='Frontend/index.jsp';</script>");
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script>alert('오류 발생: " + e.getMessage() + "'); history.back();</script>");
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (psImg != null) psImg.close();
                if (conn != null) conn.close();
            } catch (Exception e) { e.printStackTrace(); }
        }
    }
}
