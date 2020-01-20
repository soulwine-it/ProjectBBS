package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {
	
	//Connection 데이터 베이스 접근하게 해주는 하나의 객체
	private Connection conn;
	private PreparedStatement pstmt;
	//하나의 정보를 담을 수 있는 하나의 객체
	private ResultSet rs;
	
	//ctrl +shift + o 를 눌러 외부 라이브러리를 넣어줍니다
	
	//생성자를 만들어줍니다.
	public UserDAO() {
		try {
			//localhost:3306은 우리 컴퓨터에 설치된 mysql 서버 자체를 의미하고 bbs는 우리가 만든 테이블 이름입니다.
			//String dbURL = "jdbc:mysql://localhost:3306/BBS";
			String dbURL = "jdbc:mysql://localhost:3306/BBS?serverTimezone=UTC";
			String dbID ="root";
			String dbPassword ="root";
			Class.forName("com.mysql.jdbc.Driver");
			conn=DriverManager.getConnection(dbURL, dbID, dbPassword);
		}catch(Exception e) {
			e.printStackTrace();
		}
		
	}
	public int login(String userID, String userPassword) {
		//실제로 db에 입력할 sql문
		String SQL = "SELECT userPassword FROM USER WHERE userID= ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1,  userID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				if(rs.getString(1).equals(userPassword)) 
					return 1; // 로그인 성공
				else
					return 0; //비밀번호 불일치
				
			}
			return -1; //아이디가 없음
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -2; // 데이터베이스 오류를 의미합니다.
	}
	
	// 회원가입 기능 구현
	public int join(User user) {
		String SQL = "INSERT INTO USER VALUES(?, ?, ?, ?, ?)";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user.getUserID());
			pstmt.setString(2, user.getUserPassword());
			pstmt.setString(3, user.getUserName());
			pstmt.setString(4, user.getUserGender());
			pstmt.setString(5, user.getUserEmail());
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류
	}

}
