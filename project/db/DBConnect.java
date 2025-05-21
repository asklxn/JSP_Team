package db;

import java.sql.*;

public class DBConnect {
    public static Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName("org.mariadb.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/backend", "yejin", "1111");
        } catch(Exception e) {
            e.printStackTrace();
        }
        return conn;
    }
}
