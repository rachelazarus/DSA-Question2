import ballerina/grpc;
import ballerina/io;
import ballerina/uuid;

// Define the Ballerina listener
listener grpc:Listener ep = new (9090);

// Define the Ballerina records corresponding to ProtoBuf messages

// In-memory store for products
map<Product> productInventory = {};
map<Order> orderInventory = {};
map<UserCreationResponse> users = {};
map<UserCarts> carts = {};

@grpc:Descriptor {value: HELLOWORLDNEW_DESC}

// Define the service
service "OnlineShopping" on ep {

    remote function AddProduct(Product product) returns ProductResponse|error {

        string normalizedSku = product.sku.trim();

        if productInventory.hasKey(normalizedSku) {
            io:println("Product already exists with SKU:", normalizedSku);
            return {message: "Product with that Stock keeping unit already exists", product: product};
        } else {
            // Add the product to the inventory using the normalized SKU
            productInventory[normalizedSku] = product;
            io:println("Product added successfully:", normalizedSku, "Details:", product);
            return {message: "Product added successfully", product: product};
        }
    }

    remote function UpdateProduct(ProductUpdateRequest productUpdateRequest) returns ProductResponse|error {
        string sku = productUpdateRequest.sku;
        if !productInventory.hasKey(sku) {
            io:println("Product not found:", sku);
            return {message: "Product not found", product: {}};
        } else {
            Product updatedProduct = productUpdateRequest.product;
            productInventory[sku] = updatedProduct;
            io:println("Product updated successfully:", sku, "Updated Details:", updatedProduct);
            return {message: "Product updated successfully", product: updatedProduct};
        }
    }

    remote function RemoveProduct(ProductID productId) returns ProductList|error {
        if !productInventory.hasKey(productId.sku) {
            io:println("Product not found:", productId.sku);
            return {products: []};
        } else {
            _ = productInventory.remove(productId.sku);
            io:println("Product removed successfully:", productId.sku);

            Product[] products = [];
            foreach var [_, product] in productInventory.entries() {
                products.push(product);
            }

            io:println("Updated product list after removal:", products);
            return {products: products}; // Return the updated product list
        }
    }

    remote function ListAvailableProducts(Empty value) returns ProductList {
        Product[] availableProducts = [];

        // Iterate through productInventory and filter only the available products
        foreach var [_, product] in productInventory.entries() {
            if product.status == "Available" {
                availableProducts.push(product);
            }
        }

        io:println("Listing available products:", availableProducts);
        return {products: availableProducts};
    }

    remote function ListAllOrders(Empty value) returns OrderList {
        Order[] orders = [];
        foreach var [_, orderValue] in orderInventory.entries() {
            orders.push(orderValue);
        }
        io:println("Listing all orders:", orders);
        return {orders: orders};
    }

    remote function SearchProduct(ProductID productId) returns ProductResponse {
        if !productInventory.hasKey(productId.sku) {
            io:println("Product not found:", productId.sku);
            return {message: "Product not found", product: {}};
        } else {
            Product product = <Product>productInventory[productId.sku];
            io:println("Product found:", product);
            return {message: "Product found", product: product};
        }
    }

    remote function AddToCart(AddToCartRequest request) returns CartResponse|error {
        if request.sku == "" || request.user_id == "" {
            return {message: "User ID or SKU cannot be empty"};
        }

        // Check if the product exists in the inventory
        Product? product = productInventory[request.sku];

        if product is Product {
            // Check if the user already has a cart
            UserCarts? userCart = carts[request.user_id];

            if userCart is UserCarts {

                // Add the product to the existing cart with a quantity of 1 (default for cart)
                Product cartProduct = product.clone();
                cartProduct.stock_quantity = 1; // Set quantity to 1 for the cart
                userCart.cartproducts.push(cartProduct);
                carts[request.user_id] = userCart; // Update the cart in the map

            } else {
                // Create a new cart for the user and add the product with a quantity of 1
                Product cartProduct = product.clone();
                cartProduct.stock_quantity = 1; // Set quantity to 1 for the cart
                carts[request.user_id] = {user_id: request.user_id, cartproducts: [cartProduct]};
            }

            io:println("Product added to cart:", request.sku, "for user:", request.user_id);
            return {message: "Product added to cart successfully"};
        } else {
            return {message: "Product not found in inventory"};
        }
    }

    remote function PlaceOrder(UserID userId) returns OrderResponse|error {
        if userId.user_id == "" {
            return error("User ID cannot be empty");
        }

        // Check if the user has a cart
        UserCarts? userCart = carts[userId.user_id];
        if userCart is UserCarts {
            // Generate a random order ID
            string orderId = uuid:createType4AsString();

            // Create the order
            Order newOrder = {
                order_id: orderId,
                user_id: userId.user_id,
                products: userCart.cartproducts,
                status: "Pending"
            };

            // Add the order to the order inventory
            orderInventory[orderId] = newOrder;

            foreach var cartProduct in userCart.cartproducts {
                ProductID productID = {sku: cartProduct.sku};
                Product? product = productInventory[productID.sku];

                if product is Product {
                    // Deduct the cart quantity (which is always 1) from the inventory stock
                    product.stock_quantity -= cartProduct.stock_quantity;

                    if product.stock_quantity <= 0 {
                        product.status = "Out of stock";
                    }

                    productInventory[product.sku] = product; // Update the inventory
                } else {
                    return {message: "Product not found in inventory"};
                }
            }

            // Clear the user's cart after placing the order
            _ = carts.remove(userId.user_id);

            io:println("Order placed for user:", userId.user_id, "Order details:", newOrder);
            return {message: "Order placed successfully"};
        } else {
            return {message: "No cart found for user"};
        }
    }

    remote function CreateUsers(stream<UserID, grpc:Error?> clientStream) returns UserCreationResponse|error {
        string[] userIds = [];
        checkpanic clientStream.forEach(function(UserID user) {
            userIds.push(user.user_id);
            io:println("User created:", user.user_id);
        });
        return {message: "Users created successfully", user_ids: userIds};
    }
}
