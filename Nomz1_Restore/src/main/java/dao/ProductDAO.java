package dao;

import java.sql.*;
import java.util.*;

import db.DBConnect;
import model.Product;

public class ProductDAO {

    // 상품 전체 조회
	public List<Product> getAllProducts() {
		System.out.println("🔍 ProductDAO.getAllProducts() 실행됨");

	    List<Product> list = new ArrayList<>();
	    try (Connection conn = DBConnect.getConnection()) {

	        String sql = "SELECT p.product_id, p.name, p.price, p.stock, p.description, " +
	                     "       (SELECT image_url FROM product_images WHERE product_id = p.product_id LIMIT 1) AS image_url " +
	                     "FROM products p";

	        try (PreparedStatement ps = conn.prepareStatement(sql);
	             ResultSet rs = ps.executeQuery()) {

	            while (rs.next()) {
	            	System.out.println("📦 상품 이름: " + rs.getString("name"));
	                Product p = new Product();
	                p.setProductId(rs.getInt("product_id"));
	                p.setName(rs.getString("name"));
	                p.setPrice(rs.getInt("price"));
	                p.setStock(rs.getInt("stock"));
	                p.setDescription(rs.getString("description"));
	                p.setImageUrl(rs.getString("image_url"));
	                list.add(p);
	            }
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}



    // 상품 등록
    public void insertProduct(Product p) {
        try (Connection conn = DBConnect.getConnection()) {

            // 1. 상품 등록
            String sql1 = "INSERT INTO products (name, price, stock, description) VALUES (?, ?, ?, ?)";
            PreparedStatement ps1 = conn.prepareStatement(sql1, Statement.RETURN_GENERATED_KEYS);
            ps1.setString(1, p.getName());
            ps1.setInt(2, p.getPrice());
            ps1.setInt(3, p.getStock());
            ps1.setString(4, p.getDescription());
            ps1.executeUpdate();

            // 2. 생성된 product_id 가져오기
            ResultSet rs = ps1.getGeneratedKeys();
            int productId = 0;
            if (rs.next()) {
                productId = rs.getInt(1);
            }

            // 3. 이미지 등록
            if (p.getImageUrl() != null && !p.getImageUrl().isEmpty()) {
                String sql2 = "INSERT INTO product_images (product_id, image_url) VALUES (?, ?)";
                PreparedStatement ps2 = conn.prepareStatement(sql2);
                ps2.setInt(1, productId);
                ps2.setString(2, p.getImageUrl());
                ps2.executeUpdate();
                ps2.close();
            }

            rs.close();
            ps1.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
