package dao;

import java.sql.*;
import model.Member;

public class MemberDAO {

	private static final String URL = "jdbc:mariadb://localhost:3307/kimdb";
	private static final String USER = "kim";
	private static final String PWD = "1111";


    public Member login(String id, String pwd) {
        Member member = null;

        try {
            Class.forName("org.mariadb.jdbc.Driver");
            Connection conn = DriverManager.getConnection(URL, USER, PWD);

            String sql = "SELECT * FROM member WHERE id = ? AND pwd = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, id);
            ps.setString(2, pwd);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String name = rs.getString("name");
                member = new Member(id, pwd, name);
            }

            rs.close(); ps.close(); conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return member;
    }
}
