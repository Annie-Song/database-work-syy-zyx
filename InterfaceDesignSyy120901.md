# **网上书店系统统一接口设计规范**

## **一、 基础约定**

### **1.1 接口调用规范**
所有业务操作通过**存储过程**完成，禁止直接操作表

### **1.2 返回值标准格式**
```sql
-- 存储过程统一输出参数
OUT p_success INT,        -- 0=成功, >0=错误码
OUT p_message VARCHAR(200) -- 成功/错误消息
```

### **1.3 错误码体系**
| 错误码 | 分类 | 描述 |
|--------|------|------|
| 0 | 成功 | 操作成功 |
| 1000-1999 | 用户相关 | 注册、登录、权限 |
| 2000-2999 | 库存订单 | 库存、订单、发货 |
| 3000-3999 | 支付相关 | 余额、信用、支付 |
| 4000-4999 | 数据校验 | 参数、格式、重复 |
| 9999 | 系统错误 | 未知错误 |

---

## **二、 核心接口详细设计**

### **2.1 用户管理模块**

#### **2.1.1 用户注册**
```sql
DELIMITER $$
CREATE PROCEDURE sp_RegisterCustomer(
    IN p_username VARCHAR(50),
    IN p_password_hash VARCHAR(255),  -- SHA256加密后的密码
    IN p_email VARCHAR(100),
    IN p_real_name VARCHAR(100),
    IN p_phone VARCHAR(20),
    IN p_address TEXT,
    OUT p_customer_id INT,
    OUT p_success INT,
    OUT p_message VARCHAR(200)
)
BEGIN
    -- 实现逻辑：
    -- 1. 检查用户名唯一性
    -- 2. 检查邮箱唯一性
    -- 3. 插入用户记录
    -- 4. 初始化信用等级
    -- 返回新用户ID
END$$
DELIMITER ;
```

#### **2.1.2 用户登录**
```sql
DELIMITER $$
CREATE PROCEDURE sp_LoginCustomer(
    IN p_username VARCHAR(50),
    IN p_password_hash VARCHAR(255),
    OUT p_customer_id INT,
    OUT p_customer_info JSON,  -- 返回完整的用户信息JSON
    OUT p_success INT,
    OUT p_message VARCHAR(200)
)
BEGIN
    -- 实现逻辑：
    -- 1. 验证用户名密码
    -- 2. 返回用户信息（JSON格式包含所有字段）
    -- 3. 更新最后登录时间
END$$
DELIMITER ;
```

**返回JSON示例：**
```json
{
  "customer_id": 1,
  "username": "customer1",
  "real_name": "张三",
  "email": "test@example.com",
  "account_balance": 5000.00,
  "credit_level": 3,
  "address": "北京市海淀区"
}
```

---

### **2.2 图书查询模块**

#### **2.2.1 图书搜索**
```sql
DELIMITER $$
CREATE PROCEDURE sp_SearchBooks(
    -- 搜索条件
    IN p_keyword VARCHAR(100) DEFAULT NULL,
    IN p_category VARCHAR(50) DEFAULT NULL,
    IN p_author VARCHAR(100) DEFAULT NULL,
    IN p_publisher VARCHAR(100) DEFAULT NULL,
    IN p_min_price DECIMAL(8,2) DEFAULT 0,
    IN p_max_price DECIMAL(8,2) DEFAULT 99999,
    IN p_in_stock_only BOOLEAN DEFAULT FALSE,
    IN p_has_image_only BOOLEAN DEFAULT FALSE,
    
    -- 排序分页
    IN p_sort_by VARCHAR(20) DEFAULT 'relevance',  -- price_asc, price_desc, sales, date
    IN p_page INT DEFAULT 1,
    IN p_page_size INT DEFAULT 20,
    
    -- 返回结果
    OUT p_total_count INT,
    OUT p_total_pages INT
)
BEGIN
    -- 实现逻辑：
    -- 1. 动态构建WHERE条件
    -- 2. 根据排序参数排序
    -- 3. 分页查询
    -- 4. 计算总数和总页数
    -- 5. 返回结果集
END$$
DELIMITER ;
```

**返回字段：**
```sql
-- 结果集包含：
book_id, title, main_author, publisher, price, 
category, quantity, stock_status, cover_image_url,
discount_rate, final_price, avg_rating, sales_count
```

#### **2.2.2 图书详情**
```sql
DELIMITER $$
CREATE PROCEDURE sp_GetBookDetail(
    IN p_book_id INT,
    OUT p_book_info JSON,
    OUT p_success INT,
    OUT p_message VARCHAR(200)
)
BEGIN
    -- 返回图书完整信息，包括：
    -- 图书基本信息、库存信息、供应商信息、相关推荐
END$$
DELIMITER ;
```

---

### **2.3 订单管理模块**

#### **2.3.1 创建订单**
```sql
DELIMITER $$
CREATE PROCEDURE sp_CreateOrder(
    IN p_customer_id INT,
    IN p_shipping_address TEXT,
    IN p_items JSON,  -- 统一JSON格式
    IN p_notes TEXT DEFAULT NULL,
    
    OUT p_order_id INT,
    OUT p_order_number VARCHAR(20),
    OUT p_final_amount DECIMAL(10,2),
    OUT p_success INT,
    OUT p_message VARCHAR(200)
)
BEGIN
    -- 实现逻辑：
    -- 1. 验证客户存在性和信用
    -- 2. 解析JSON items
    -- 3. 逐项检查库存
    -- 4. 计算总金额（考虑折扣）
    -- 5. 扣减库存（预扣）
    -- 6. 生成订单号和记录
    -- 7. 返回订单信息
END$$
DELIMITER ;
```

**JSON items格式（严格约定）：**
```json
{
  "items": [
    {
      "book_id": 1,
      "quantity": 2,
      "selected": true
    },
    {
      "book_id": 3,
      "quantity": 1,
      "selected": true
    }
  ]
}
```

#### **2.3.2 订单支付**
```sql
DELIMITER $$
CREATE PROCEDURE sp_PayOrder(
    IN p_order_id INT,
    IN p_payment_method VARCHAR(20),  -- balance, wechat, alipay
    IN p_payment_amount DECIMAL(10,2),
    
    OUT p_payment_id INT,
    OUT p_success INT,
    OUT p_message VARCHAR(200)
)
BEGIN
    -- 实现逻辑：
    -- 1. 验证订单状态（必须是pending）
    -- 2. 验证支付金额匹配
    -- 3. 扣减账户余额（如果使用余额）
    -- 4. 更新订单状态为paid
    -- 5. 记录支付流水
END$$
DELIMITER ;
```

#### **2.3.3 查询订单列表**
```sql
DELIMITER $$
CREATE PROCEDURE sp_GetCustomerOrders(
    IN p_customer_id INT,
    IN p_status VARCHAR(20) DEFAULT NULL,  -- pending, paid, shipping, completed, cancelled
    IN p_start_date DATE DEFAULT NULL,
    IN p_end_date DATE DEFAULT NULL,
    IN p_page INT DEFAULT 1,
    IN p_page_size INT DEFAULT 10,
    
    OUT p_total_count INT,
    OUT p_total_pages INT
)
BEGIN
    -- 返回订单列表（含汇总信息）
END$$
DELIMITER ;
```

#### **2.3.4 订单详情**
```sql
DELIMITER $$
CREATE PROCEDURE sp_GetOrderDetail(
    IN p_order_id INT,
    OUT p_order_info JSON,
    OUT p_items JSON,
    OUT p_deliveries JSON,
    OUT p_success INT,
    OUT p_message VARCHAR(200)
)
BEGIN
    -- 返回订单的完整信息，包括：
    -- 订单基本信息、商品列表、发货记录、支付信息
END$$
DELIMITER ;
```

---

### **2.4 库存管理模块**

#### **2.4.1 检查库存**
```sql
DELIMITER $$
CREATE PROCEDURE sp_CheckStock(
    IN p_book_id INT,
    IN p_quantity INT,
    
    OUT p_available BOOLEAN,
    OUT p_available_quantity INT,
    OUT p_success INT,
    OUT p_message VARCHAR(200)
)
BEGIN
    -- 检查指定数量的图书是否可用
END$$
DELIMITER ;
```

#### **2.4.2 库存预警（自动触发）**
```sql
DELIMITER $$
CREATE PROCEDURE sp_GetLowStockAlerts(
    IN p_threshold INT DEFAULT NULL,
    IN p_include_zero BOOLEAN DEFAULT TRUE
)
BEGIN
    -- 返回库存低于阈值或为零的图书列表
    -- 供后台管理系统显示
END$$
DELIMITER ;
```

---

### **2.5 发货管理模块**

#### **2.5.1 处理发货**
```sql
DELIMITER $$
CREATE PROCEDURE sp_ProcessDelivery(
    IN p_order_id INT,
    IN p_delivery_items JSON,  -- [{"detail_id":1, "quantity":2}, ...]
    IN p_courier_company VARCHAR(50),
    IN p_tracking_number VARCHAR(100),
    IN p_shipping_cost DECIMAL(8,2) DEFAULT 0,
    IN p_notes TEXT DEFAULT NULL,
    
    OUT p_delivery_id INT,
    OUT p_success INT,
    OUT p_message VARCHAR(200)
)
BEGIN
    -- 实现逻辑：
    -- 1. 验证订单状态（必须是paid）
    -- 2. 验证发货数量不超过订单数量
    -- 3. 扣减实际库存（与预扣库存抵消）
    -- 4. 更新订单明细的发货状态
    -- 5. 如果所有商品都发货，更新订单状态
    -- 6. 记录发货信息
END$$
DELIMITER ;
```

#### **2.5.2 发货记录查询**
```sql
DELIMITER $$
CREATE PROCEDURE sp_GetOrderDeliveries(
    IN p_order_id INT
)
BEGIN
    -- 返回指定订单的所有发货记录
END$$
DELIMITER ;
```

---

### **2.6 后台管理模块**

#### **2.6.1 添加图书**
```sql
DELIMITER $$
CREATE PROCEDURE sp_AddBook(
    IN p_book_info JSON,  -- 包含所有图书信息的JSON
    IN p_initial_stock INT DEFAULT 0,
    IN p_location_code VARCHAR(50) DEFAULT NULL,
    
    OUT p_book_id INT,
    OUT p_success INT,
    OUT p_message VARCHAR(200)
)
BEGIN
    -- 实现逻辑：
    -- 1. 解析图书信息JSON
    -- 2. 检查ISBN唯一性
    -- 3. 插入图书记录
    -- 4. 初始化库存记录
    -- 5. 处理多作者、多关键字
END$$
DELIMITER ;
```

**JSON格式示例：**
```json
{
  "isbn": "9787111636664",
  "title": "Java核心技术 卷I",
  "authors": [
    {"name": "Cay S. Horstmann", "order": 1},
    {"name": "Gary Cornell", "order": 2}
  ],
  "publisher": "机械工业出版社",
  "price": 119.00,
  "category": "编程",
  "keywords": ["Java", "编程", "核心技术"],
  "description": "Java经典著作...",
  "cover_image": "http://example.com/cover.jpg"
}
```

#### **2.6.2 更新库存**
```sql
DELIMITER $$
CREATE PROCEDURE sp_UpdateInventory(
    IN p_book_id INT,
    IN p_adjustment_type VARCHAR(10),  -- increase, decrease, set
    IN p_quantity INT,
    IN p_reason VARCHAR(100),  -- purchase, return, adjust, loss
    IN p_notes TEXT DEFAULT NULL,
    
    OUT p_new_quantity INT,
    OUT p_success INT,
    OUT p_message VARCHAR(200)
)
BEGIN
    -- 实现逻辑：
    -- 1. 验证图书存在
    -- 2. 根据调整类型更新库存
    -- 3. 记录库存变更历史
    -- 4. 触发库存预警检查
END$$
DELIMITER ;
```

---

## **三、 触发器接口设计**

### **3.1 自动触发器（无需应用层调用）**

#### **3.1.1 库存预警触发器**
```sql
DELIMITER $$
CREATE TRIGGER trg_Inventory_AfterUpdate
AFTER UPDATE ON Inventory
FOR EACH ROW
BEGIN
    -- 当库存更新后：
    -- 1. 如果库存低于阈值，自动生成缺书登记
    -- 2. 避免重复的缺书记录
    -- 3. 记录库存变更历史
END$$
DELIMITER ;
```

#### **3.1.2 订单状态同步触发器**
```sql
DELIMITER $$
CREATE TRIGGER trg_OrderDetail_AfterDelivery
AFTER INSERT ON Delivery
FOR EACH ROW
BEGIN
    -- 当发货记录添加后：
    -- 1. 更新订单明细的发货状态
    -- 2. 检查订单是否全部发货，更新订单状态
    -- 3. 记录发货历史
END$$
DELIMITER ;
```

#### **3.1.3 信用等级自动更新**
```sql
DELIMITER $$
CREATE EVENT ev_UpdateCreditLevel
ON SCHEDULE EVERY 1 MONTH
STARTS '2024-02-01 00:00:00'
DO
BEGIN
    -- 每月1日凌晨：
    -- 1. 根据账户余额和累计消费更新信用等级
    -- 2. 记录信用变更历史
    -- 3. 发送信用等级变更通知（可选）
END$$
DELIMITER ;
```

---

## **四、 数据一致性保证**

### **4.1 事务处理规范**
```sql
DELIMITER $$
CREATE PROCEDURE sp_CreateOrder(
    -- 参数列表
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_success = 9999;
        SET p_message = CONCAT('系统错误: ', ERROR_MESSAGE());
    END;
    
    START TRANSACTION;
    
    -- 所有业务逻辑在事务内完成
    -- 1. 验证和预扣库存
    -- 2. 创建订单记录
    -- 3. 创建订单明细
    -- 4. 更新相关统计
    
    COMMIT;
    
    SET p_success = 0;
    SET p_message = '订单创建成功';
END$$
DELIMITER ;
```

### **4.2 乐观锁机制**
```sql
-- 在库存更新时使用版本号
UPDATE Inventory 
SET quantity = quantity - 1,
    version = version + 1
WHERE book_id = ? AND quantity >= 1 AND version = ?;
```

---

## **五、 性能优化接口**

### **5.1 分页查询优化**
```sql
DELIMITER $$
CREATE PROCEDURE sp_SearchBooks_Optimized(
    -- 参数
)
BEGIN
    -- 使用延迟关联优化分页
    SELECT * FROM Book b
    JOIN (
        SELECT book_id FROM Book
        WHERE -- 条件
        ORDER BY -- 排序
        LIMIT offset, page_size
    ) AS tmp ON b.book_id = tmp.book_id;
END$$
DELIMITER ;
```

### **5.2 缓存刷新接口**
```sql
DELIMITER $$
CREATE PROCEDURE sp_RefreshCache(
    IN p_cache_type VARCHAR(50),  -- book_list, hot_books, recommendations
    OUT p_success INT,
    OUT p_message VARCHAR(200)
)
BEGIN
    -- 刷新指定的缓存数据
    -- 供后台管理系统调用
END$$
DELIMITER ;
```

---

## **六、 接口调用示例（给B的参考）**

### **Java端调用示例**
```java
public class DatabaseService {
    
    // 调用存储过程示例
    public int createOrder(int customerId, String address, List<OrderItem> items) {
        try (Connection conn = getConnection()) {
            // 1. 准备JSON参数
            String jsonItems = convertItemsToJson(items);
            
            // 2. 调用存储过程
            String sql = "{call sp_CreateOrder(?, ?, ?, ?, ?, ?, ?)}";
            try (CallableStatement cstmt = conn.prepareCall(sql)) {
                cstmt.setInt(1, customerId);
                cstmt.setString(2, address);
                cstmt.setString(3, jsonItems);
                cstmt.setString(4, null); // notes
                
                // 注册输出参数
                cstmt.registerOutParameter(5, Types.INTEGER); // order_id
                cstmt.registerOutParameter(6, Types.VARCHAR); // order_number
                cstmt.registerOutParameter(7, Types.DECIMAL); // final_amount
                cstmt.registerOutParameter(8, Types.INTEGER); // success
                cstmt.registerOutParameter(9, Types.VARCHAR); // message
                
                cstmt.execute();
                
                // 获取结果
                int successCode = cstmt.getInt(8);
                String message = cstmt.getString(9);
                
                if (successCode == 0) {
                    return cstmt.getInt(5); // 返回order_id
                } else {
                    throw new BusinessException(successCode, message);
                }
            }
        }
    }
    
    // JSON转换辅助方法
    private String convertItemsToJson(List<OrderItem> items) {
        JSONObject json = new JSONObject();
        JSONArray array = new JSONArray();
        
        for (OrderItem item : items) {
            JSONObject obj = new JSONObject();
            obj.put("book_id", item.getBookId());
            obj.put("quantity", item.getQuantity());
            obj.put("selected", true);
            array.put(obj);
        }
        
        json.put("items", array);
        return json.toString();
    }
}
```

---

## **七、 接口版本管理**

### **7.1 接口版本标识**
```sql
-- 在数据库中记录接口版本
CREATE TABLE API_Version (
    version_id INT PRIMARY KEY AUTO_INCREMENT,
    module_name VARCHAR(50),
    procedure_name VARCHAR(100),
    version VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    description TEXT
);
```

### **7.2 向后兼容保证**
- 所有现有接口参数不变
- 新增参数放在参数列表最后
- 返回结果增加新字段而不删除旧字段

---

## **八、 监控和日志**

### **8.1 接口调用日志**
```sql
CREATE TABLE API_Log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    procedure_name VARCHAR(100),
    parameters TEXT,
    user_id INT,
    execution_time_ms INT,
    success BOOLEAN,
    error_message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_procedure (procedure_name),
    INDEX idx_created (created_at)
);
```

### **8.2 性能监控接口**
```sql
DELIMITER $$
CREATE PROCEDURE sp_GetPerformanceMetrics(
    IN p_time_range INT DEFAULT 24  -- 小时
)
BEGIN
    -- 返回各接口的调用次数、平均耗时、错误率
    -- 供系统监控使用
END$$
DELIMITER ;
```

---

## **九、 安全规范**

### **9.1 SQL注入防护**
- 所有输入参数使用预编译语句
- 存储过程使用参数化查询
- 敏感数据加密存储

### **9.2 权限控制**
```sql
-- 创建只读用户供应用查询使用
CREATE USER 'bookstore_reader'@'localhost' IDENTIFIED BY 'reader_pass';
GRANT SELECT ON bookstore_db.* TO 'bookstore_reader'@'localhost';

-- 创建只写用户供应用写操作使用
CREATE USER 'bookstore_writer'@'localhost' IDENTIFIED BY 'writer_pass';
GRANT EXECUTE ON PROCEDURE bookstore_db.* TO 'bookstore_writer'@'localhost';
```

---

## **十、 紧急联系方式**

当接口调用出现问题时：
1. **错误码非0**：根据错误码显示对应提示
2. **连接失败**：检查数据库连接配置
3. **JSON解析错误**：检查JSON格式是否符合规范
4. **事务超时**：检查是否有死锁或长事务

**关键检查点**：
- 所有JSON参数必须严格符合格式
- 调用存储过程前先加密密码
- 分页参数page从1开始
- 金额计算保留2位小数

---
