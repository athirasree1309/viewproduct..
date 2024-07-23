<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="bean.Product" %>

<%
    String dbURL = "jdbc:mysql://localhost:3306/ultras";
    String dbUser = "root";
    String dbPassword = "";
    
    List<Map<String, Object>> brands = new ArrayList<>();
    Product product = new Product(); // Assuming Product is a class you've defined
    
    int productId = Integer.parseInt(request.getParameter("id"));

    Connection connection = null;
    PreparedStatement productStatement = null;
    ResultSet productResultSet = null;
    Statement brandStatement = null;
    ResultSet brandResultSet = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        connection = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        // Fetch the product
        String productQuery = "SELECT * FROM products WHERE id = ?";
        productStatement = connection.prepareStatement(productQuery);
        productStatement.setInt(1, productId);
        productResultSet = productStatement.executeQuery();
        
        if (productResultSet.next()) {
            product.setId(productResultSet.getInt("id"));
            product.setName(productResultSet.getString("name"));
            product.setBrand_id(productResultSet.getInt("brand_id"));
            product.setPrice(productResultSet.getInt("price"));
            product.setColor(productResultSet.getString("color"));
            product.setSpecification(productResultSet.getString("specification"));
            product.setImage(productResultSet.getString("image"));
        }

        // Fetch the brands
        String brandQuery = "SELECT * FROM brands";
        brandStatement = connection.createStatement();
        brandResultSet = brandStatement.executeQuery(brandQuery);
        
        while (brandResultSet.next()) {
            Map<String, Object> brand = new HashMap<>();
            brand.put("id", brandResultSet.getInt("id"));
            brand.put("brand_name", brandResultSet.getString("brand_name"));
            brands.add(brand);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (productResultSet != null) productResultSet.close();
            if (productStatement != null) productStatement.close();
            if (brandResultSet != null) brandResultSet.close();
            if (brandStatement != null) brandStatement.close();
            if (connection != null) connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Product</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2 class="text-center mb-4">Edit Product</h2>
        <form action="updateproduct.jsp" method="post">
            <input type="hidden" name="id" value="<%= product.getId() %>">
            <div class="form-group">
                <label for="name">Name</label>
                <input type="text" class="form-control" id="name" name="name" value="<%= product.getName() %>" required>
            </div>
            <div class="form-group">
                <label for="brand">Brand</label>
                <select class="form-control" id="brand" name="brand_id" required>
                    <% for (Map<String, Object> brand : brands) { %>
                        <option value="<%= brand.get("id") %>" <%= product.getBrand_id() == (Integer) brand.get("id") ? "selected" : "" %>>
                            <%= brand.get("brand_name") %>
                        </option>
                    <% } %>
                </select>
            </div>
            <div class="form-group">
                <label for="price">Price</label>
                <input type="number" class="form-control" id="price" name="price" value="<%= product.getPrice() %>" required>
            </div>
            <div class="form-group">
                <label for="color">Color</label>
                <input type="text" class="form-control" id="color" name="color" value="<%= product.getColor() %>" required>
            </div>
            <div class="form-group">
                <label for="specification">Specification</label>
                <textarea class="form-control" id="specification" name="specification" required><%= product.getSpecification() %></textarea>
            </div>
            <div class="form-group">
                <label for="image">Image URL</label>
                <input type="text" class="form-control" id="image" name="image" value="<%= product.getImage() %>" required>
            </div>
            <button type="submit" class="btn btn-primary">Update Product</button>
        </form>
    </div>
</body>
</html>
