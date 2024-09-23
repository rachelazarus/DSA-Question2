import ballerina/grpc;
import ballerina/io;

OnlineShoppingClient onlineShoppingClient = check new ("http://localhost:9090");

// Function to display the admin menu

function InitializeUsers() returns grpc:Error? {
    User Admin1 = {
        user_id: "172s",
        name: "Shamiso Vushe",
        role: "Admin"
    };
    User Customer1 = {
        user_id: "173s",
        name: "Rachel",
        role: "Customer"
    };
    User Customer2 = {
        user_id: "174s",
        name: "Taapopi",
        role: "Customer"
    };
    User Customer3 = {
        user_id: "175s",
        name: "MJ",
        role: "Customer"
    };
 User Customer4 = {
        user_id: "180",
        name: "John",
        role: "Customer"
    };
    CreateUsersStreamingClient createUsersStreamingClient = check onlineShoppingClient->CreateUsers();
    check createUsersStreamingClient->sendUser(Admin1);
    check createUsersStreamingClient->sendUser(Customer1);
    check createUsersStreamingClient->sendUser(Customer2);
    check createUsersStreamingClient->sendUser(Customer3);
    check createUsersStreamingClient->sendUser(Customer4);
    check createUsersStreamingClient->complete();
}

public function main() returns error? {
    check InitializeUsers();
    check StartAndAuthentication();

}

function StartAndAuthentication() returns error? {
    io:println("Please select your role:\n1. Admin\n2. Customer");
    int role = check int:fromString(io:readln());

    if role == 1 {
    io:println("Please enter userId");
    string userId = io:readln();
    if userId == "172s" {
        check handleAdminOperations("Shamiso");
    } else {
        io:print("Invalid user Id, Try again");
        check StartAndAuthentication();
    }

} else if role == 2 {
    io:println("Please enter userId");
    string userId = io:readln();
    if userId == "173s" {
        check handleCustomerOperations("Rachel");
    } else if userId == "174s" {
        check handleCustomerOperations("Taapopi");
    } else if userId == "175s" {
        check handleCustomerOperations("MJ");
    } else if userId == "180" {
        check handleCustomerOperations("John");
    } else {
        io:print("Invalid user Id, Try again");
        check StartAndAuthentication();
    }


    } else {
        io:println("Invalid role selected.");
        return;
    }

    return;
}

function adminMenu() {
    io:println("\nAdmin Menu:");
    io:println("1. Add Product");
    io:println("2. Update Product");
    io:println("3. Remove Product");
    io:println("4. List All Orders");
    io:println("5. Exit");
}

// Function to display the customer menu
function customerMenu() {
    io:println("\nCustomer Menu:");
    io:println("1. View Available Products");
    io:println("2. Search for a Product");
    io:println("3. Add Product to Cart");
    io:println("4. Place Order");
    io:println("5. Exit");
}

function handleAdminOperations(string name) returns error? {
    io:println("Welcome to the Online Shopping System " + name + " !!");
    while true {
        adminMenu();
        io:println("Enter your choice: ");
        int adminChoice = check int:fromString(io:readln());

        match adminChoice {
            1 => {
                check addProduct();
            }
            2 => {
                check updateProduct();
            }
            3 => {
                check removeProduct();
            }
            4 => {
                check listOrders();
            }
            5 => {
                io:println("Exiting Admin mode.")
                ;
                break;
            }
            _ => {
                io:println("Invalid choice. Please try again.");
            }
        }
    }
    return;
}

function handleCustomerOperations(string name) returns error? {
    io:println("Welcome to the online shopping system " + name, "!!!");
    while true {
        customerMenu();
        io:println("Enter your choice: ");
        int customerChoice = check int:fromString(io:readln());

        match customerChoice {
            1 => {
                check listAvailableProducts();
            }
            2 => {
                check searchProduct();
            }
            3 => {
                check addToCart();
            }
            4 => {
                check placeOrder();
            }
            5 => {
                io:println("Exiting Customer mode.")
                ;
                break;
            }
            _ => {
                io:println("Invalid choice. Please try again.");
            }
        }
    }
    return;
}

function addProduct() returns error? {
    io:println("\nEnter Product Details:");
    string name = io:readln("Product Name: ");
    string description = io:readln("Description: ");
    float price = check float:fromString(io:readln("Price: "));
    int stock = check int:fromString(io:readln("Stock Quantity: "));
    string sku = io:readln("SKU: ");

    string status = stock > 0 ? "Available" : "Out of stock";

    Product newProduct = {name, description, price, stock_quantity: stock, sku, status};
    ProductResponse response = check onlineShoppingClient->AddProduct(newProduct);
    io:println(response.message);
    return;
}

function updateProduct() returns error? {
    io:println("\nEnter SKU of Product to Update: ");
    string sku = io:readln();

    // Fetch the current details of the product
    ProductID productID = {sku};
    ProductResponse productResponse = check onlineShoppingClient->SearchProduct(productID);
    Product currentProduct = productResponse.product;

    if (productResponse.message == "Product not found") {
        io:println("Product not found");
        return;
    } else {
        io:println("Current Product Details: ", currentProduct);

        boolean isUpdating = true;

        while isUpdating {
            io:println("\nWhat do you want to update?");
            io:println("1. Product Name");
            io:println("2. Description");
            io:println("3. Price");
            io:println("4. Stock Quantity");
            io:println("5. Finalize Update");
            io:println("6. Cancel Update");

            int updateChoice = check int:fromString(io:readln());

            match updateChoice {
                1 => {
                    io:println("Enter new Product Name: ");
                    string newName = io:readln();
                    currentProduct.name = newName;
                }
                2 => {
                    io:println("Enter new Description: ");
                    string newDescription = io:readln();
                    currentProduct.description = newDescription;
                }
                3 => {
                    io:println("Enter new Price: ");
                    float newPrice = check float:fromString(io:readln());
                    currentProduct.price = newPrice;
                }
                4 => {
                    io:println("Enter new Stock Quantity: ");
                    int newStock = check int:fromString(io:readln());
                    currentProduct.stock_quantity = newStock;

                    // Automatically determine status based on the stock quantity
                    currentProduct.status = newStock > 0 ? "Available" : "Out of stock";
                }
                5 => {
                    // Finalize the update
                    ProductUpdateRequest productUpdate = {sku, product: currentProduct};
                    ProductResponse response = check onlineShoppingClient->UpdateProduct(productUpdate);
                    io:println("Update Product Response: ", response);
                    isUpdating = false;
                }
                6 => {
                    // Cancel the update process
                    io:println("Update cancelled.");
                    return;
                }
                _ => {
                    io:println("Invalid choice. Please try again.");
                }
            }

            if isUpdating {
                io:println("\nDo you want to update something else?");
                io:println("1. Yes");
                io:println("2. Finalize update and exit");

                int continueChoice = check int:fromString(io:readln());
                if continueChoice == 2 {
                    // Finalize the update
                    ProductUpdateRequest productUpdate = {sku, product: currentProduct};
                    ProductResponse response = check onlineShoppingClient->UpdateProduct(productUpdate);
                    io:println("Updated product: ", response.product);
                    isUpdating = false;
                }
            }
        }
        return;
    }
}

function removeProduct() returns error? {
    io:println("\nEnter SKU of Product to Remove: ");
    string sku = io:readln();
    ProductID productID = {sku};
    ProductList response = check onlineShoppingClient->RemoveProduct(productID);
    if (response.length() == 0) {
        io:print("Product not found");
    }
    else {
        io:println("Updated list of products after deletion ", response.products);
    }
    return;
}

function listOrders() returns error? {
    io:println("Listing All Orders:");

    Empty emptyRequest = {};
    OrderList orders = check onlineShoppingClient->ListAllOrders(emptyRequest);

    if orders.orders.length() == 0 {
        io:println("No orders have been placed.");
        return;
    }

    foreach var orderss in orders.orders {
        io:println("------------------------------------------------");
        io:println("Order ID       : ", orderss.order_id);
        io:println("User ID        : ", orderss.user_id);
        io:println("Order Status   : ", orderss.status);
        io:println("Products in Order:");
        foreach var product in orderss.products {
            io:println("  - ", product.name, " | SKU: ", product.sku, " | Quantity: ", product.stock_quantity);
        }
        io:println("------------------------------------------------\n");
    }
    return;
}

function listAvailableProducts() returns error? {
    io:println("Available Products:");

    Empty emptyRequest = {};
    ProductList productList = check onlineShoppingClient->ListAvailableProducts(emptyRequest);

    if productList.products.length() == 0 {
        io:println("No products available at the moment.");
        return;
    }

    foreach var product in productList.products {
        io:println("------------------------------------------------");
        io:println("Product Name   : ", product.name);
        io:println("Description    : ", product.description);
        io:println("Price          : $", product.price);
        io:println("Stock Quantity : ", product.stock_quantity);
        io:println("SKU            : ", product.sku);
        io:println("Status         : ", product.status);
        io:println("------------------------------------------------\n");
    }
    return;
}

function searchProduct() returns error? {
    io:println("Enter the SKU of the Product you want to search for:");
    string sku = io:readln();

    ProductID productID = {sku};
    ProductResponse response = check onlineShoppingClient->SearchProduct(productID);

    if response.message == "Product not found" {
        io:println("Product not found. Please check the SKU and try again.");
    } else {
        Product product = response.product;
        io:println("------------------------------------------------");
        io:println("Product Name   : ", product.name);
        io:println("Description    : ", product.description);
        io:println("Price          : $", product.price);
        io:println("Stock Quantity : ", product.stock_quantity);
        io:println("SKU            : ", product.sku);
        io:println("Status         : ", product.status);
        io:println("------------------------------------------------\n");
    }

    return;
}

function addToCart() returns error? {
    io:println("\nEnter Your User ID: ");

    string userID = io:readln();
    io:println("Enter SKU of Product to Add to Cart: ");
    string sku =  io:readln();

    AddToCartRequest cartRequest = {user_id: userID, sku: sku};
    CartResponse response = check onlineShoppingClient->AddToCart(cartRequest);
    io:println(response.message);
    return;
}

function placeOrder() returns error? {
    io:println("\nEnter Your User ID to Place Order: ");
    string userID = io:readln();
    UserID user = {user_id: userID};
    OrderResponse response = check onlineShoppingClient->PlaceOrder(user);

    io:print(response.message);
    return;
}
