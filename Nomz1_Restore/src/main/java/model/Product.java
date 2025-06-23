package model;

public class Product {
    private int productId;       // product_id: 상품 고유 번호
    private String name;         // name: 상품 이름
    private int price;           // price: 상품 가격
    private int stock;           // stock: 재고
    private String description;  // description: 상품 설명
    private String imageUrl;     // image_url: 이미지 경로 (JOIN 결과로 가져옴)

    // Getter & Setter

    public int getProductId() {
        return productId;
    }
    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }

    public int getPrice() {
        return price;
    }
    public void setPrice(int price) {
        this.price = price;
    }

    public int getStock() {
        return stock;
    }
    public void setStock(int stock) {
        this.stock = stock;
    }

    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }

    public String getImageUrl() {
        return imageUrl;
    }
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
}
