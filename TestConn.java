import java.lang.System;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class TestConn {

	public static void main(String[] args) throws SQLException {
		// TODO Auto-generated method stub
		try {
			Class.forName("com.mysql.jdbc.Driver");
			
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		String username, password;
		username = "root";
		password = "root";
		Connection conn = DriverManager.getConnection(
				"jdbc:mysql://localhost:3306/test", username, password);
		System.out.println("connected!");
		Statement stmt = conn.createStatement();
		String query = "select count(*) from mesowest_csv";
		long currtime = System.currentTimeMillis();
		ResultSet result = stmt.executeQuery(query);
		System.out.println(result);
		System.out.println("Time: "+(System.currentTimeMillis()-currtime)/1000+" seconds.");
		int i = 10;
		while(result.next() && i-->0){
			String primaryid = result.getString(1);
			System.out.println(primaryid);
		}
	}
}
