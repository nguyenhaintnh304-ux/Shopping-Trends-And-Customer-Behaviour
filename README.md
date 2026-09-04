# End-to-End Data Analytics Portfolio Project: Customer Shopping Behavior Analysis

Dự án phân tích dữ liệu toàn diện (End-to-End) mô phỏng quy trình làm việc thực tế tại doanh nghiệp [1]. Dự án bao gồm toàn bộ vòng đời phân tích: từ làm sạch dữ liệu bằng **Python**, truy vấn nâng cao bằng **SQL (PostgreSQL)**, trực quan hóa tương tác trên **Power BI**, tài liệu hóa báo cáo và chuyển đổi thành slide thuyết trình tự động bằng AI [1, 2, 4].

## 📋 Mục tiêu Kinh doanh (Problem Statement)
Một doanh nghiệp bán lẻ lớn muốn hiểu sâu hơn về hành vi mua sắm của khách hàng nhằm tối ưu hóa doanh số, nâng cao mức độ hài lòng và xây dựng lòng trung thành dài hạn [3]. Ban giám đốc muốn tìm câu trả lời cho câu hỏi: **Làm thế nào để doanh nghiệp khai thác dữ liệu mua sắm của khách hàng để nhận diện xu hướng, cải thiện mức độ tương tác và tối ưu hóa chiến lược tiếp thị & sản phẩm?** [3, 4]

---

## 🛠️ Công cụ & Công nghệ Sử dụng
*   **Python (Pandas, SQLAlchemy, Psycopg2):** Khám phá, xử lý dữ liệu khuyết, chuẩn hóa và kỹ thuật đặc trưng (Feature Engineering) [7, 12, 13, 15].
*   **PostgreSQL (pgAdmin):** Thiết lập cơ sở dữ liệu và thực hiện truy vấn phân tích nâng cao (Subqueries, CTEs, Window Functions) [15, 19, 25, 27].
*   **Power BI:** Viết các thước đo DAX, xây dựng mô hình dữ liệu và thiết kế bảng điều khiển tương tác trực quan [31, 35, 38].
*   **Gamma AI & Markdown:** Tự động hóa thiết kế tài liệu báo cáo và slide thuyết trình cấp quản lý [42, 43].

---

## 📊 Tập dữ liệu (Dataset Overview)
Tập dữ liệu thô `customer_shopping_behavior.csv` ghi nhận thông tin giao dịch gần nhất của từng khách hàng đơn lẻ [4, 7]:
*   **Nhân khẩu học:** `customer_id` (Khóa chính), `age` (Tuổi), `gender` (Giới tính) [4, 5].
*   **Chi tiết giao dịch:** `item_purchased` (Sản phẩm), `category` (Danh mục ngành hàng), `purchase_amount` (Số tiền chi tiêu - USD), `location` (Địa điểm) [5].
*   **Thuộc tính & Đánh giá:** `size` (Kích cỡ), `color` (Màu sắc), `season` (Mùa), `review_rating` (Điểm đánh giá - có 37 giá trị khuyết) [5, 8].
*   **Khuyến mãi & Vận chuyển:** `subscription_status` (Trạng thái thành viên), `shipping_type` (Hình thức giao hàng), `discount_applied` (Có áp dụng giảm giá), `promo_code_used` (Mã khuyến mãi) [5].
*   **Lịch sử tóm tắt:** `previous_purchases` (Số đơn hàng trước đây), `frequency_of_purchases` (Tần suất mua sắm dạng chữ) [5, 6].

---

## 🔄 Quy trình Thực hiện Dự án

### Bước 1: Python - Làm sạch & Tiền xử lý dữ liệu (Data Cleaning & Prep)
Trong bước này, chúng ta tiến hành xử lý dữ liệu thô trong Jupyter Notebook trước khi nạp vào hệ thống SQL [7]:
1.  **Xử lý giá trị bị khuyết (Null Imputation):** Điền 37 giá trị khuyết ở cột `review_rating` bằng giá trị **trung vị (median) theo từng danh mục sản phẩm (category)** để tránh sai lệch dữ liệu [8, 9].
2.  **Chuẩn hóa tên cột (Snake Casing):** Chuyển toàn bộ tên cột sang viết thường, thay khoảng trắng bằng dấu gạch dưới (`_`), đổi tên cột chi tiêu thành `purchase_amount` [11, 12].
3.  **Kỹ thuật đặc trưng (Feature Engineering):**
    *   Tạo cột nhóm tuổi `age_group` phân chia khách hàng thành 4 nhóm bằng nhau (`young adult`, `adult`, `middle-aged`, `senior`) bằng hàm `pd.qcut` [12].
    *   Ánh xạ tần suất mua hàng dạng văn bản thành số ngày cụ thể `purchase_frequency_days` bằng hàm `map` [12, 13].
4.  **Loại bỏ dữ liệu trùng lặp:** Loại bỏ cột `promo_code_used` vì chứa thông tin giống hoàn toàn 100% với cột `discount_applied` [14].
5.  **Nạp dữ liệu vào PostgreSQL:** Kết nối Python với pgAdmin thông qua thư viện `SQLAlchemy` để chuyển đổi DataFrame thành bảng `customer` [15, 16].

### Bước 2: SQL - Phân tích dữ liệu chuyên sâu (Advanced SQL Analysis)
Sử dụng các truy vấn SQL nâng cao để giải quyết 10 câu hỏi cốt lõi của doanh nghiệp [1, 2, 18]:
*   *Doanh thu theo giới tính:* Phân tích tỷ lệ chi tiêu giữa Nam và Nữ [18, 19].
*   *Phân tích hành vi giảm giá:* Lọc các khách hàng áp dụng mã giảm giá nhưng vẫn chi tiêu cao hơn mức trung bình bằng **Subquery** [19].
*   *Top 3 sản phẩm bán chạy nhất mỗi danh mục:* Sử dụng hàm cửa sổ **`ROW_NUMBER() OVER (PARTITION BY category ORDER BY ... DESC)`** để xếp hạng chính xác [27, 28].
*   *Đánh giá chương trình thành viên:* Sử dụng **CTE** kết hợp `CASE WHEN` phân khúc khách hàng theo độ trung thành và so sánh hiệu quả chi tiêu giữa nhóm có và không đăng ký thành viên [22, 25, 26].

### Bước 3: Power BI - Xây dựng Dashboard Tương tác
Thiết kế một dashboard chuyên nghiệp cấp doanh nghiệp với các thành phần sau [2, 31]:
1.  **Chỉ số KPIs cốt lõi (DAX Measures):** Tính tổng số khách hàng (`COUNT`), chi tiêu trung bình (`AVERAGE`) và điểm đánh giá trung bình [31].
2.  **Trực quan hóa dữ liệu:**
    *   **Donut Chart:** Tỷ lệ khách hàng đăng ký thành viên (đã tối giản phần Legend, lồng nhãn trực tiếp) [34, 35].
    *   **Clustered Column Charts:** So sánh doanh thu và sản lượng bán ra theo danh mục sản phẩm [37].
    *   **Clustered Bar Charts:** Thể hiện doanh thu và sản lượng theo nhóm tuổi [40, 41].
3.  **Bộ lọc tương tác (Button Slicers):** Thiết lập các nút bấm lọc nhanh theo giới tính, trạng thái thành viên, danh mục và hình thức giao hàng để người dùng dễ dàng khám phá dữ liệu [38, 39, 41].

### Bước 4 & 5: Báo cáo & Slide Thuyết trình (Presentation)
*   **Báo cáo kỹ thuật:** Biên soạn tài liệu chi tiết mô tả quy trình kỹ thuật và hình ảnh minh họa cho các phòng ban kỹ thuật [2, 41, 42].
*   **Slide Thuyết trình thông minh:** Nhập tệp báo cáo dự án vào công cụ AI **Gamma (GMA)** để tạo tự động slide thuyết trình chuyên nghiệp chỉ trong 2 phút nhằm trình bày trực tiếp với khách hàng hoặc quản lý [2, 42, 43].

---

## 📈 Kết quả Phân tích & Đề xuất Kinh doanh
*   **Đẩy mạnh Vận chuyển Express:** Chi tiêu trung bình của nhóm khách hàng chọn giao hàng nhanh (Express) cao hơn đáng kể so với giao hàng tiêu chuẩn (Standard) [21, 22]. Do nghiệp cần tối ưu hóa trải nghiệm giao hàng nhanh này để kích thích chi tiêu [21].
*   **Cải tiến Chương trình Thành viên:** Phát hiện có tới **2.500 khách hàng mua lặp lại (trên 5 lần)** nhưng vẫn chưa đăng ký thành viên (chỉ có 958 người đã đăng ký) [29]. Doanh nghiệp cần cải tiến ngay chính sách đặc quyền thành viên vì ưu đãi hiện tại chưa đủ sức hấp dẫn [28, 29].
*   **Tập trung vào Nhóm Khách hàng Trẻ tuổi (Young Adults):** Phân tích doanh thu theo nhóm tuổi chỉ ra nhóm thanh niên (young adults) là nguồn đóng góp doanh thu lớn nhất của hệ thống [29, 30]. Doanh nghiệp nên tập trung ngân sách tiếp thị nhắm mục tiêu vào phân khúc này [29].

---

## 🚀 Cách Chạy Dự án Trên Máy Cá nhân
1.  **Bước 1: Làm sạch dữ liệu bằng Python**
    *   Cài đặt thư viện: `pip install pandas sqlalchemy psycopg2` [7, 15]
    *   Mở và chạy tệp jupyter notebook xử lý dữ liệu thô `customer_shopping_behavior.csv` [7].
2.  **Bước 2: Cài đặt Cơ sở dữ liệu**
    *   Tạo database tên là `customer_behavior` trong pgAdmin [15].
    *   Chạy dòng lệnh Python nạp bảng `customer` vào database [16].
    *   Thực thi các truy vấn SQL phân tích có sẵn trong thư mục `queries/`.
3.  **Bước 3: Mở Dashboard**
    *   Khởi chạy Power BI Desktop, kết nối với PostgreSQL cục bộ của bạn theo thông tin máy chủ và database tương ứng [30].
    *   Nhấn **Refresh** để cập nhật dữ liệu trực quan [41].

---
*Dự án được hoàn thiện dựa trên tài liệu hướng dẫn chuẩn doanh nghiệp của Amlan Mohanty [1].*
