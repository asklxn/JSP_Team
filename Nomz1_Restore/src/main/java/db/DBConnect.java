package db;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnect {
    public static Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName("org.mariadb.jdbc.Driver");
            conn = DriverManager.getConnection(
                "jdbc:mariadb://127.0.0.1:3307/kimdb", // ✅ 정확한 DB명과 포트
                "kim",
                "1111"
            );
        } catch (Exception e) {
            e.printStackTrace();
        }
        return conn;
    }
}
