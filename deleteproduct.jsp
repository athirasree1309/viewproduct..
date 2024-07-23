
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.io.*"%>

<%
	HttpSession httpSession = request.getSession();
	if (httpSession == null || httpSession.getAttribute("user") == null) {
		response.sendRedirect("login.jsp");
		return;

	}

	String user = (String) httpSession.getAttribute("user");
%>
<%
    String id = request.getParameter("id");

    if (id != null) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // Load the JDBC driver
            Class.forName("com.mysql.jdbc.Driver");
            // Establish a connection to the database
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ultras", "root", "");

            // SQL statement to delete the product
            String sql = "DELETE FROM products WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(id));

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
            	%>
            	  <script>
                  alert('Product deleted successfully!');
                  window.location.href = 'viewproduct.jsp';
              </script>
<% 
            } else {
                out.println("Product not found.");
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            out.println("Error deleting product: " + e.getMessage());
        } finally {
            if (pstmt != null) {
                try {
                    pstmt.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    } else {
        out.println("Invalid product ID.");
    }
%>
