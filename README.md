# Shopping Trends And Customer Behaviour

Dự án phân tích dữ liệu mô phỏng quy trình làm việc thực tế tại doanh nghiệp. Dự án bao gồm toàn bộ quá trình phân tích: từ làm sạch dữ liệu bằng **Python**, truy vấn nâng cao bằng **SQL Server**, trực quan hóa tương tác trên **Power BI**, tài liệu hóa báo cáo và chuyển đổi thành slide thuyết trình.

## 📋 Mục tiêu Kinh doanh 
Một doanh nghiệp bán lẻ lớn muốn hiểu sâu hơn về hành vi mua sắm của khách hàng nhằm tối ưu hóa doanh số, nâng cao mức độ hài lòng và xây dựng lòng trung thành dài hạn. Ban giám đốc muốn tìm câu trả lời cho câu hỏi: **Làm thế nào để doanh nghiệp khai thác dữ liệu mua sắm của khách hàng để nhận diện xu hướng, cải thiện mức độ tương tác và tối ưu hóa chiến lược tiếp thị & sản phẩm?**

---

## 🛠️ Công cụ & Công nghệ Sử dụng
*   **Python (Pandas):** Khám phá, xử lý dữ liệu khuyết, chuẩn hóa và kỹ thuật đặc trưng (Feature Engineering).
*   **SQL Server:** Thiết lập cơ sở dữ liệu và thực hiện truy vấn phân tích nâng cao (Subqueries, CTE, Window Functions).
*   **Power BI:** Viết các thước đo DAX, xây dựng mô hình dữ liệu và thiết kế Dashboard.

---

## 📊 Tập dữ liệu 
Tập dữ liệu thô [`Data/Shopping Trends And Customer Behaviour Dataset.csv`](./Data) ghi nhận thông tin giao dịch gần nhất của từng khách hàng đơn lẻ:
*   **Nhân khẩu học:** `customer_id` (Khóa chính), `age` (Tuổi), `gender` (Giới tính).
*   **Chi tiết giao dịch:** `item_purchased` (Sản phẩm), `category` (Danh mục ngành hàng), `purchase_amount` (Số tiền chi tiêu - USD), `location` (Địa điểm).
*   **Thuộc tính & Đánh giá:** `size` (Kích cỡ), `color` (Màu sắc), `season` (Mùa), `review_rating` (Điểm đánh giá - có 37 giá trị khuyết).
*   **Khuyến mãi & Vận chuyển:** `subscription_status` (Trạng thái thành viên), `shipping_type` (Hình thức giao hàng), `discount_applied` (Có áp dụng giảm giá), `promo_code_used` (Mã khuyến mãi).
*   **Lịch sử tóm tắt:** `previous_purchases` (Số đơn hàng trước đây), `frequency_of_purchases` (Tần suất mua sắm dạng chữ).

---

## 🔄 Quy trình thực hiện

### Bước 1: Python - Làm sạch & Tiền xử lý dữ liệu 
Trong bước này, tiến hành xử lý dữ liệu thô trong Jupyter Notebook trước khi nạp vào hệ thống SQL:
1.  **Kiểm tra tổng quan dữ liệu:** Đọc dữ liệu, kiểm tra kích thước, kiểu dữ liệu, thông tin tổng quan và giá trị trùng lặp.
2.  **Chuẩn hóa tên cột (Snake Casing):** Chuyển toàn bộ tên cột sang viết thường, thay khoảng trắng bằng dấu gạch dưới (`_`), đổi tên cột chi tiêu thành `purchase_amount`.
3.  **Kỹ thuật đặc trưng:**
    *   Tạo cột nhóm tuổi `age_group` phân chia khách hàng thành 4 nhóm bằng nhau (`young adult`, `adult`, `middle-aged`, `senior`) bằng hàm `pd.qcut`.
    *   Ánh xạ tần suất mua hàng dạng văn bản thành số ngày cụ thể `purchase_frequency_days` bằng hàm `map`.
4.  **Loại bỏ dữ liệu trùng lặp:** Loại bỏ cột `promo_code_used` vì chứa thông tin giống hoàn toàn 100% với cột `discount_applied`.
5.  **Import dữ liệu vào SQL Server:** Xuất file csv, tải về và import vào SQL Server, đổi tên bảng thành `customer`.

### Bước 2: SQL - Phân tích dữ liệu chuyên sâu

Sử dụng các truy vấn SQL nâng cao để giải quyết 10 câu hỏi cốt lõi của doanh nghiệp:

1. Tổng doanh thu tạo ra bởi khách hàng Nam so với Nữ
2. Khách hàng áp dụng giảm giá nhưng vẫn chi tiêu trên mức trung bình
3. Top 5 sản phẩm có điểm đánh giá trung bình cao nhất
4. So sánh chi tiêu trung bình giữa giao hàng Standard và Express
5. Khách hàng đăng ký thành viên có chi tiêu nhiều hơn không
6. Top 5 sản phẩm có tỷ lệ áp dụng giảm giá cao nhất
7. Phân khúc khách hàng: New / Returning / Loyal theo số đơn hàng cũ
8. Top 3 sản phẩm bán chạy nhất trong mỗi danh mục
9. Mối liên hệ giữa khách mua lặp lại (>5 đơn) và việc đăng ký thành viên
10. Tổng doanh thu đóng góp bởi mỗi nhóm tuổi

---

### Bước 3: Power BI - Xây dựng Dashboard
Thiết kế một dashboard với các thành phần:
1.  **Chỉ số KPIs cốt lõi (DAX Measures):** Tính tổng số khách hàng (`COUNT`), chi tiêu trung bình (`AVERAGE`) và điểm đánh giá trung bình.
2.  **Trực quan hóa dữ liệu:**
    *   **Donut Chart:** Tỷ lệ khách hàng đăng ký thành viên.
    *   **Clustered Column Charts:** So sánh doanh thu và sản lượng bán ra theo danh mục sản phẩm.
    *   **Clustered Bar Charts:** Thể hiện doanh thu và sản lượng theo nhóm tuổi.
3.  **Bộ lọc tương tác (Button Slicers):** Thiết lập các nút bấm lọc nhanh theo giới tính, trạng thái thành viên, danh mục và hình thức giao hàng để người dùng dễ dàng khám phá dữ liệu.

### Bước 4 & 5: Báo cáo & Slide Thuyết trình (Presentation)
*   **Báo cáo kỹ thuật:** Biên soạn tài liệu chi tiết mô tả quy trình kỹ thuật và hình ảnh minh họa cho các phần.
*   **Slide Thuyết trình:** Xây dựng Slide bài thuyết trình tổng hợp toàn bộ quy trình và kết quả phân tích.

---

## 📈 Kết quả Phân tích & Đề xuất Kinh doanh
*   Nâng cấp chương trình thành viên và khách hàng thân thiết: đẩy mạnh ưu đãi cho khách mua lại nhiều lần và cải tiến gói thành viên để thu hút nhóm 2.500 khách mua trên 5 lần nhưng chưa đăng ký.
*   Tiếp thị mục tiêu theo lứa tuổi và giới tính: Dồn ngân sách tiếp thị vào nhóm trẻ tuổi, đây phân khúc mang lại doanh thu cao nhất, đồng thời cá nhân hóa chiến dịch cho khách hàng nam và nữ.
*   Ưu tiên và tối ưu dịch vụ giao hàng nhanh (Express Shipping): Mở rộng và cải thiện trải nghiệm giao hỏa tốc để thúc đẩy doanh số từ nhóm khách hàng có mức chi tiêu trung bình cao.
*   Quảng bá và tối ưu giá sản phẩm hàng đầu: Làm nổi các sản phẩm bán chạy và được đánh giá cao, cân nhắc áp dụng mức giá cao hơn.
*   Kiểm soát chính sách chiết khấu và giảm giá: Rà soát tỷ lệ khuyến mãi để giảm sự phụ thuộc giá, bảo vệ biên lợi nhuận và tránh làm giảm giá trị sản phẩm trong mắt người tiêu dùng.

---

## Tác giả
Dự án mô phỏng quy trình xử lý và phân tích dữ liệu Shopping Trends And Customer Behaviour, bao gồm Data Cleaning, SQL Modeling và trực quan hóa qua Power BI.

📫 Liên hệ: *nguyenhaintnh304@gmail.com*
