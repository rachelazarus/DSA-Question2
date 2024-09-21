import ballerina/grpc;
import ballerina/protobuf;

public const string HELLOWORLDNEW_DESC = "0A1368656C6C6F776F726C646E65772E70726F746F120873686F7070696E6722A6010A0750726F6475637412120A046E616D6518012001280952046E616D6512200A0B6465736372697074696F6E180220012809520B6465736372697074696F6E12140A0570726963651803200128015205707269636512250A0E73746F636B5F7175616E74697479180420012805520D73746F636B5175616E7469747912100A03736B751805200128095203736B7512160A067374617475731806200128095206737461747573221D0A0950726F64756374494412100A03736B751801200128095203736B7522580A0F50726F64756374526573706F6E736512180A076D65737361676518012001280952076D657373616765122B0A0770726F6475637418022001280B32112E73686F7070696E672E50726F64756374520770726F64756374223C0A0B50726F647563744C697374122D0A0870726F647563747318012003280B32112E73686F7070696E672E50726F64756374520870726F647563747322550A1450726F647563745570646174655265717565737412100A03736B751801200128095203736B75122B0A0770726F6475637418022001280B32112E73686F7070696E672E50726F64756374520770726F64756374223D0A10416464546F436172745265717565737412170A07757365725F6964180120012809520675736572496412100A03736B751802200128095203736B75225F0A0C43617274526573706F6E736512180A076D65737361676518012001280952076D65737361676512350A0C6361727470726F647563747318022003280B32112E73686F7070696E672E50726F64756374520C6361727470726F6475637473225B0A0955736572436172747312170A07757365725F6964180120012809520675736572496412350A0C6361727470726F647563747318022003280B32112E73686F7070696E672E50726F64756374520C6361727470726F647563747322360A0943617274734C69737412290A05636172747318012003280B32132E73686F7070696E672E557365724361727473520563617274732282010A054F7264657212190A086F726465725F696418012001280952076F72646572496412170A07757365725F69641802200128095206757365724964122D0A0870726F647563747318032003280B32112E73686F7070696E672E50726F64756374520870726F647563747312160A06737461747573180420012809520673746174757322340A094F726465724C69737412270A066F726465727318012003280B320F2E73686F7070696E672E4F7264657252066F726465727322500A0D4F72646572526573706F6E736512180A076D65737361676518012001280952076D65737361676512250A056F7264657218022001280B320F2E73686F7070696E672E4F7264657252056F7264657222470A045573657212170A07757365725F6964180120012809520675736572496412120A046E616D6518022001280952046E616D6512120A04726F6C651803200128095204726F6C65224B0A14557365724372656174696F6E526573706F6E736512180A076D65737361676518012001280952076D65737361676512190A08757365725F69647318022003280952077573657249647322210A0655736572494412170A07757365725F6964180120012809520675736572496422070A05456D70747932C9040A0E4F6E6C696E6553686F7070696E67123A0A0A41646450726F6475637412112E73686F7070696E672E50726F647563741A192E73686F7070696E672E50726F64756374526573706F6E7365124A0A0D55706461746550726F64756374121E2E73686F7070696E672E50726F64756374557064617465526571756573741A192E73686F7070696E672E50726F64756374526573706F6E7365123B0A0D52656D6F766550726F6475637412132E73686F7070696E672E50726F6475637449441A152E73686F7070696E672E50726F647563744C69737412350A0D4C697374416C6C4F7264657273120F2E73686F7070696E672E456D7074791A132E73686F7070696E672E4F726465724C697374123F0A154C697374417661696C61626C6550726F6475637473120F2E73686F7070696E672E456D7074791A152E73686F7070696E672E50726F647563744C697374123F0A0D53656172636850726F6475637412132E73686F7070696E672E50726F6475637449441A192E73686F7070696E672E50726F64756374526573706F6E7365123F0A09416464546F43617274121A2E73686F7070696E672E416464546F43617274526571756573741A162E73686F7070696E672E43617274526573706F6E736512370A0A506C6163654F7264657212102E73686F7070696E672E5573657249441A172E73686F7070696E672E4F72646572526573706F6E7365123F0A0B4372656174655573657273120E2E73686F7070696E672E557365721A1E2E73686F7070696E672E557365724372656174696F6E526573706F6E73652801620670726F746F33";

public isolated client class OnlineShoppingClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, HELLOWORLDNEW_DESC);
    }

    isolated remote function AddProduct(Product|ContextProduct req) returns ProductResponse|grpc:Error {
        map<string|string[]> headers = {};
        Product message;
        if req is ContextProduct {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.OnlineShopping/AddProduct", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ProductResponse>result;
    }

    isolated remote function AddProductContext(Product|ContextProduct req) returns ContextProductResponse|grpc:Error {
        map<string|string[]> headers = {};
        Product message;
        if req is ContextProduct {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.OnlineShopping/AddProduct", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ProductResponse>result, headers: respHeaders};
    }

    isolated remote function UpdateProduct(ProductUpdateRequest|ContextProductUpdateRequest req) returns ProductResponse|grpc:Error {
        map<string|string[]> headers = {};
        ProductUpdateRequest message;
        if req is ContextProductUpdateRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.OnlineShopping/UpdateProduct", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ProductResponse>result;
    }

    isolated remote function UpdateProductContext(ProductUpdateRequest|ContextProductUpdateRequest req) returns ContextProductResponse|grpc:Error {
        map<string|string[]> headers = {};
        ProductUpdateRequest message;
        if req is ContextProductUpdateRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.OnlineShopping/UpdateProduct", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ProductResponse>result, headers: respHeaders};
    }

    isolated remote function RemoveProduct(ProductID|ContextProductID req) returns ProductList|grpc:Error {
        map<string|string[]> headers = {};
        ProductID message;
        if req is ContextProductID {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.OnlineShopping/RemoveProduct", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ProductList>result;
    }

    isolated remote function RemoveProductContext(ProductID|ContextProductID req) returns ContextProductList|grpc:Error {
        map<string|string[]> headers = {};
        ProductID message;
        if req is ContextProductID {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.OnlineShopping/RemoveProduct", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ProductList>result, headers: respHeaders};
    }

    isolated remote function ListAllOrders(Empty|ContextEmpty req) returns OrderList|grpc:Error {
        map<string|string[]> headers = {};
        Empty message;
        if req is ContextEmpty {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.OnlineShopping/ListAllOrders", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <OrderList>result;
    }

    isolated remote function ListAllOrdersContext(Empty|ContextEmpty req) returns ContextOrderList|grpc:Error {
        map<string|string[]> headers = {};
        Empty message;
        if req is ContextEmpty {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.OnlineShopping/ListAllOrders", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <OrderList>result, headers: respHeaders};
    }

    isolated remote function ListAvailableProducts(Empty|ContextEmpty req) returns ProductList|grpc:Error {
        map<string|string[]> headers = {};
        Empty message;
        if req is ContextEmpty {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.OnlineShopping/ListAvailableProducts", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ProductList>result;
    }

    isolated remote function ListAvailableProductsContext(Empty|ContextEmpty req) returns ContextProductList|grpc:Error {
        map<string|string[]> headers = {};
        Empty message;
        if req is ContextEmpty {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.OnlineShopping/ListAvailableProducts", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ProductList>result, headers: respHeaders};
    }

    isolated remote function SearchProduct(ProductID|ContextProductID req) returns ProductResponse|grpc:Error {
        map<string|string[]> headers = {};
        ProductID message;
        if req is ContextProductID {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.OnlineShopping/SearchProduct", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ProductResponse>result;
    }

    isolated remote function SearchProductContext(ProductID|ContextProductID req) returns ContextProductResponse|grpc:Error {
        map<string|string[]> headers = {};
        ProductID message;
        if req is ContextProductID {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.OnlineShopping/SearchProduct", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ProductResponse>result, headers: respHeaders};
    }

    isolated remote function AddToCart(AddToCartRequest|ContextAddToCartRequest req) returns CartResponse|grpc:Error {
        map<string|string[]> headers = {};
        AddToCartRequest message;
        if req is ContextAddToCartRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.OnlineShopping/AddToCart", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <CartResponse>result;
    }

    isolated remote function AddToCartContext(AddToCartRequest|ContextAddToCartRequest req) returns ContextCartResponse|grpc:Error {
        map<string|string[]> headers = {};
        AddToCartRequest message;
        if req is ContextAddToCartRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.OnlineShopping/AddToCart", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <CartResponse>result, headers: respHeaders};
    }

    isolated remote function PlaceOrder(UserID|ContextUserID req) returns OrderResponse|grpc:Error {
        map<string|string[]> headers = {};
        UserID message;
        if req is ContextUserID {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.OnlineShopping/PlaceOrder", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <OrderResponse>result;
    }

    isolated remote function PlaceOrderContext(UserID|ContextUserID req) returns ContextOrderResponse|grpc:Error {
        map<string|string[]> headers = {};
        UserID message;
        if req is ContextUserID {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.OnlineShopping/PlaceOrder", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <OrderResponse>result, headers: respHeaders};
    }

    isolated remote function CreateUsers() returns CreateUsersStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("shopping.OnlineShopping/CreateUsers");
        return new CreateUsersStreamingClient(sClient);
    }
}

public isolated client class CreateUsersStreamingClient {
    private final grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendUser(User message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextUser(ContextUser message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveUserCreationResponse() returns UserCreationResponse|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <UserCreationResponse>payload;
        }
    }

    isolated remote function receiveContextUserCreationResponse() returns ContextUserCreationResponse|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <UserCreationResponse>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public isolated client class OnlineShoppingProductResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendProductResponse(ProductResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextProductResponse(ContextProductResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class OnlineShoppingProductListCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendProductList(ProductList response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextProductList(ContextProductList response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class OnlineShoppingCartResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendCartResponse(CartResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextCartResponse(ContextCartResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class OnlineShoppingOrderListCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendOrderList(OrderList response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextOrderList(ContextOrderList response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class OnlineShoppingUserCreationResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendUserCreationResponse(UserCreationResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextUserCreationResponse(ContextUserCreationResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class OnlineShoppingOrderResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendOrderResponse(OrderResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextOrderResponse(ContextOrderResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public type ContextUserStream record {|
    stream<User, error?> content;
    map<string|string[]> headers;
|};

public type ContextProductUpdateRequest record {|
    ProductUpdateRequest content;
    map<string|string[]> headers;
|};

public type ContextUser record {|
    User content;
    map<string|string[]> headers;
|};

public type ContextProduct record {|
    Product content;
    map<string|string[]> headers;
|};

public type ContextProductID record {|
    ProductID content;
    map<string|string[]> headers;
|};

public type ContextOrderResponse record {|
    OrderResponse content;
    map<string|string[]> headers;
|};

public type ContextAddToCartRequest record {|
    AddToCartRequest content;
    map<string|string[]> headers;
|};

public type ContextCartResponse record {|
    CartResponse content;
    map<string|string[]> headers;
|};

public type ContextProductList record {|
    ProductList content;
    map<string|string[]> headers;
|};

public type ContextEmpty record {|
    Empty content;
    map<string|string[]> headers;
|};

public type ContextUserCreationResponse record {|
    UserCreationResponse content;
    map<string|string[]> headers;
|};

public type ContextUserID record {|
    UserID content;
    map<string|string[]> headers;
|};

public type ContextProductResponse record {|
    ProductResponse content;
    map<string|string[]> headers;
|};

public type ContextOrderList record {|
    OrderList content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: HELLOWORLDNEW_DESC}
public type Order record {|
    string order_id = "";
    string user_id = "";
    Product[] products = [];
    string status = "";
|};

@protobuf:Descriptor {value: HELLOWORLDNEW_DESC}
public type ProductUpdateRequest record {|
    string sku = "";
    Product product = {};
|};

@protobuf:Descriptor {value: HELLOWORLDNEW_DESC}
public type User record {|
    string user_id = "";
    string name = "";
    string role = "";
|};

@protobuf:Descriptor {value: HELLOWORLDNEW_DESC}
public type Product record {|
    string name = "";
    string description = "";
    float price = 0.0;
    int stock_quantity = 0;
    string sku = "";
    string status = "";
|};

@protobuf:Descriptor {value: HELLOWORLDNEW_DESC}
public type ProductID record {|
    string sku = "";
|};

@protobuf:Descriptor {value: HELLOWORLDNEW_DESC}
public type OrderResponse record {|
    string message = "";
    Order 'order = {};
|};

@protobuf:Descriptor {value: HELLOWORLDNEW_DESC}
public type AddToCartRequest record {|
    string user_id = "";
    string sku = "";
|};

@protobuf:Descriptor {value: HELLOWORLDNEW_DESC}
public type CartResponse record {|
    string message = "";
    Product[] cartproducts = [];
|};

@protobuf:Descriptor {value: HELLOWORLDNEW_DESC}
public type ProductList record {|
    Product[] products = [];
|};

@protobuf:Descriptor {value: HELLOWORLDNEW_DESC}
public type Empty record {|
|};

@protobuf:Descriptor {value: HELLOWORLDNEW_DESC}
public type UserCarts record {|
    string user_id = "";
    Product[] cartproducts = [];
|};

@protobuf:Descriptor {value: HELLOWORLDNEW_DESC}
public type UserCreationResponse record {|
    string message = "";
    string[] user_ids = [];
|};

@protobuf:Descriptor {value: HELLOWORLDNEW_DESC}
public type UserID record {|
    string user_id = "";
|};

@protobuf:Descriptor {value: HELLOWORLDNEW_DESC}
public type ProductResponse record {|
    string message = "";
    Product product = {};
|};

@protobuf:Descriptor {value: HELLOWORLDNEW_DESC}
public type OrderList record {|
    Order[] orders = [];
|};

@protobuf:Descriptor {value: HELLOWORLDNEW_DESC}
public type CartsList record {|
    UserCarts[] carts = [];
|};

