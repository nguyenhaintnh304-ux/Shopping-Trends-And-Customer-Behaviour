--Câu 1: Tổng doanh thu tạo ra bởi khách hàng Nam so với Nữ?
--Mục tiêu: So sánh mức đóng góp doanh thu giữa các nhóm nhân khẩu học theo giới tính để giúp doanh nghiệp thiết kế các chiến dịch tiếp thị mục tiêu hiệu quả hơn

SELECT gender, 
       SUM(purchase_amount) AS revenue 
FROM customer 
GROUP BY gender;

--Câu 2: Những khách hàng nào áp dụng giảm giá nhưng vẫn chi tiêu nhiều hơn mức trung bình?
--Mục tiêu: Nhận diện phân khúc khách hàng "chịu chi" – những người dù săn tìm ưu đãi (discount_applied = 'Yes') nhưng thực tế vẫn mua sắm với giá trị đơn hàng vượt trội so với mức trung bình của toàn hệ thống
-- (Subquery)

SELECT top 10 customer_id, 
       purchase_amount 
FROM customer 
WHERE discount_applied = 'Yes' 
  AND purchase_amount >= (SELECT AVG(purchase_amount) FROM customer)
ORDER BY purchase_amount DESC;


-- Câu 3: Top 5 sản phẩm có điểm đánh giá trung bình cao nhất?
-- Mục tiêu: Tìm ra các sản phẩm được khách hàng yêu thích nhất để làm nổi bật trong các chiến dịch marketing hoặc định giá bán cao hơn (premium price)

SELECT TOP 5 item_purchased, 
       ROUND(AVG(review_rating), 2) AS average_product_rating 
FROM customer 
GROUP BY item_purchased 
ORDER BY average_product_rating DESC 


-- Câu 4: So sánh mức chi tiêu trung bình giữa giao hàng tiêu chuẩn (Standard) và giao hàng nhanh (Express)?
-- Mục tiêu: Xác định xem khách hàng chọn giao hàng nhanh có xu hướng chi nhiều tiền hơn không, từ đó giúp doanh nghiệp quyết định có nên đầu tư thêm vào các dịch vụ vận chuyển hỏa tốc

SELECT shipping_type, 
       ROUND(AVG(purchase_amount), 2) AS average_purchase_amount 
FROM customer 
WHERE shipping_type IN ('Standard', 'Express') 
GROUP BY shipping_type;


-- Câu 5: Khách hàng đăng ký thành viên (Subscribed) có chi tiêu nhiều hơn không?
-- Mục tiêu: Đánh giá hiệu quả của chương trình thẻ thành viên bằng cách so sánh đồng thời số lượng khách hàng, mức chi tiêu trung bình và tổng doanh thu giữa nhóm có đăng ký (Yes) và không đăng ký (No)

SELECT subscription_status, 
       COUNT(customer_id) AS total_customers, 
       ROUND(AVG(purchase_amount), 2) AS average_spend, 
       SUM(purchase_amount) AS total_revenue 
FROM customer 
GROUP BY subscription_status 
ORDER BY total_revenue DESC, average_spend DESC;


--Câu 6: Top 5 sản phẩm có tỷ lệ áp dụng giảm giá cao nhất khi mua?
-- Mục tiêu: Tính toán tỷ lệ phần trăm các đơn hàng có áp dụng giảm giá trên tổng số đơn bán ra của từng sản phẩm
-- Điều này giúp doanh nghiệp xác định những dòng sản phẩm nào đang bị phụ thuộc quá nhiều vào khuyến mãi để thúc đẩy doanh số

SELECT TOP 5 item_purchased, 
       ROUND(
           (SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 
           2
       ) AS discount_rate 
FROM customer 
GROUP BY item_purchased 
ORDER BY discount_rate DESC ;


-- Câu 7: Phân khúc khách hàng thành "Mới", "Quay lại" và "Thân thiết" dựa trên số lượng đơn hàng cũ?
--Mục tiêu: Phân nhóm khách hàng theo mức độ trung thành để phục vụ chăm sóc khách hàng
-- định nghĩa: mua 1 lần là "New", từ 2 đến 10 lần là "Returning", và trên 10 lần là "Loyal"

WITH customer_type AS (
    SELECT customer_id, 
           previous_purchases, 
           CASE 
               WHEN previous_purchases = 1 THEN 'New' 
               WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning' 
               ELSE 'Loyal' 
           END AS customer_segment 
    FROM customer
) 
SELECT customer_segment, 
       COUNT(*) AS number_of_customers 
FROM customer_type 
GROUP BY customer_segment;


--Câu 8: Top 3 sản phẩm được mua nhiều nhất trong mỗi danh mục ngành hàng?
-- Mục tiêu: Tìm ra các sản phẩm bán chạy nhất (best-selling) của từng danh mục sản phẩm

WITH item_counts AS (
    SELECT category, 
           item_purchased, 
           COUNT(customer_id) AS total_orders, 
           ROW_NUMBER() OVER (
               PARTITION BY category 
               ORDER BY COUNT(customer_id) DESC
           ) AS item_rank 
    FROM customer 
    GROUP BY category, item_purchased
) 
SELECT item_rank, 
       category, 
       item_purchased, 
       total_orders 
FROM item_counts 
WHERE item_rank <= 3;


-- Câu 9: Những khách hàng mua lặp lại (có trên 5 đơn cũ) có xu hướng đăng ký thành viên không?
-- Mục tiêu: Kiểm tra xem nhóm khách hàng trung thành thực tế (đã mua > 5 lần) đã tham gia chương trình thành viên chưa
-- Nếu tỷ lệ chưa đăng ký còn cao, điều đó chứng tỏ chính sách ưu đãi thành viên hiện tại chưa đủ hấp dẫn để chuyển đổi họ

SELECT subscription_status, 
       COUNT(customer_id) AS repeat_buyers 
FROM customer 
WHERE previous_purchases > 5 
GROUP BY subscription_status;


-- Câu 10: Tổng doanh thu đóng góp bởi mỗi nhóm tuổi?
-- Mục tiêu: Xác định nhóm tuổi nào mang lại nguồn tiền lớn nhất cho doanh nghiệp để tối ưu hóa ngân sách tiếp thị

SELECT age_group, 
       SUM(purchase_amount) AS total_revenue 
FROM customer 
GROUP BY age_group 
ORDER BY total_revenue DESC;