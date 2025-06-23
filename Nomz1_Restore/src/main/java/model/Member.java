package model;

import java.sql.Date;

public class Member {
    private String username;
    private String password;
    private String name;
    private String phone;
    private Date birth; // ← String → Date 로 수정
    private String address;
    private String detailAddress;

    // 기본 생성자
    public Member() {}

    // 로그인 시 사용할 생성자
    public Member(String username, String password, String name) {
        this.username = username;
        this.password = password;
        this.name = name;
    }

    // 전체 필드 생성자
    public Member(String username, String password, String name, String phone, Date birth, String address, String detailAddress) {
        this.username = username;
        this.password = password;
        this.name = name;
        this.phone = phone;
        this.birth = birth;
        this.address = address;
        this.detailAddress = detailAddress;
    }

    // getter/setter
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public Date getBirth() {
        return birth;
    }

    public void setBirth(Date birth) {
        this.birth = birth;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getDetailAddress() {
        return detailAddress;
    }

    public void setDetailAddress(String detailAddress) {
        this.detailAddress = detailAddress;
    }
}
