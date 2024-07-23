<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.ProductDao" %>
<%@ page import="bean.Product" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%
    HttpSession httpSession = request.getSession(false); // false parameter to avoid creating a new session
    if (httpSession == null || httpSession.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    ProductDao productDao = new ProductDao();
    List<Product> products = new ArrayList<>();
    
    try {
        // Retrieve all products using ProductDAO
        products = productDao.getAllProducts();
    } catch (Exception e) {
        e.printStackTrace();
        // Handle the error appropriately
        out.println("Error retrieving products.");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Products</title>
    <!-- Bootstrap CSS -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2 class="text-center mb-4">Product List</h2>
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Brand</th>
                    <th>Price</th>
                    <th>Color</th>
                    <th>Specification</th>
                    <th>Image</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% for (Product product : products) { %>
                    <tr>
                        <td><%= product.getId() %></td>
                        <td><%= product.getName() %></td>
                        <td><%= product.getBrand_name() %></td>
                        <td><%= product.getPrice() %></td>
                        <td><%= product.getColor() %></td>
                        <td><%= product.getSpecification() %></td>
                        <td><img src="<%= product.getImage() %>" alt="<%= product.getName() %>" width="100"></td>
                        <td>
                            <a href="editproduct.jsp?id=<%= product.getId() %>" class="btn btn-primary btn-sm">Edit</a>
                            <a href="deleteproduct.jsp?id=<%= product.getId() %>" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure?');">Delete</a>
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <!-- Bootstrap JS (optional) -->
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
