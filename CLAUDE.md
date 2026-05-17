# CLAUDE.md - Hướng dẫn hành vi & Ngôn ngữ

**Yêu cầu quan trọng nhất:** Luôn phản hồi, giải thích và trả lời bằng **tiếng Việt**, trừ khi mã nguồn hoặc các thuật ngữ kỹ thuật bắt buộc phải giữ nguyên tiếng Anh.

## Nguyên tắc hành vi (Behavioral Guidelines)
Các hướng dẫn này ưu tiên sự thận trọng và chính xác hơn là tốc độ.

### 1. Suy nghĩ trước khi lập trình (Think Before Coding)
* **Không giả định:** Nêu rõ các giả định của bạn. Nếu không chắc chắn, hãy hỏi.
* **Làm rõ sự mơ hồ:** Nếu có nhiều cách hiểu, hãy trình bày tất cả thay vì tự ý chọn một cách.
* **Đề xuất sự đơn giản:** Nếu có cách tiếp cận đơn giản hơn, hãy nói rõ. Sẵn sàng phản biện nếu yêu cầu quá phức tạp.
* **Dừng lại khi chưa rõ:** Nếu có gì đó khó hiểu, hãy dừng lại và đặt câu hỏi cụ thể.

### 2. Ưu tiên sự đơn giản (Simplicity First)
* Chỉ viết lượng mã tối thiểu để giải quyết vấn đề. Không dự đoán tương lai.
* Không thêm tính năng, sự trừu tượng hoặc cấu hình linh hoạt nếu không được yêu cầu.
* Nếu có thể viết 50 dòng thay vì 200 dòng, hãy viết 50 dòng.

### 3. Thay đổi mang tính "phẫu thuật" (Surgical Changes)
* Chỉ chạm vào những gì cần thiết. Chỉ dọn dẹp những gì do bạn tạo ra.
* Không tự ý cải thiện định dạng, chú thích hoặc cấu trúc của các đoạn mã lân cận không liên quan.
* Khớp với phong cách (style) hiện có của dự án.
* **Dọn dẹp hệ quả:** Xóa bỏ các import/biến/hàm trở nên dư thừa **do thay đổi của bạn** tạo ra.

### 4. Thực hiện theo mục tiêu (Goal-Driven Execution)
* Chuyển đổi nhiệm vụ thành các mục tiêu có thể kiểm chứng (Ví dụ: Viết test lỗi trước, sau đó viết code để pass test).
* Đối với các nhiệm vụ nhiều bước, hãy nêu kế hoạch ngắn gọn:
    1. [Bước] → Kiểm chứng: [Cách kiểm tra]
    2. [Bước] → Kiểm chứng: [Cách kiểm tra]

## Cấu hình kỹ năng (Agent Skills)
Dựa trên bộ kỹ năng của Matt Pocock:
* **Issue tracker:** [Tóm tắt hệ thống quản lý task của bạn]. Xem `docs/agents/issue-tracker.md`.
* **Triage labels:** [Tóm tắt các nhãn phân loại]. Xem `docs/agents/triage-labels.md`.
* **Domain docs:** [Single-context hoặc Multi-context]. Xem `docs/agents/domain.md`.# CLAUDE.md - Hướng dẫn hành vi & Ngôn ngữ

**Yêu cầu quan trọng nhất:** Luôn phản hồi, giải thích và trả lời bằng **tiếng Việt**, trừ khi mã nguồn hoặc các thuật ngữ kỹ thuật bắt buộc phải giữ nguyên tiếng Anh.

## Nguyên tắc hành vi (Behavioral Guidelines)
Các hướng dẫn này ưu tiên sự thận trọng và chính xác hơn là tốc độ.

### 1. Suy nghĩ trước khi lập trình (Think Before Coding)
* **Không giả định:** Nêu rõ các giả định của bạn. Nếu không chắc chắn, hãy hỏi.
* **Làm rõ sự mơ hồ:** Nếu có nhiều cách hiểu, hãy trình bày tất cả thay vì tự ý chọn một cách.
* **Đề xuất sự đơn giản:** Nếu có cách tiếp cận đơn giản hơn, hãy nói rõ. Sẵn sàng phản biện nếu yêu cầu quá phức tạp.
* **Dừng lại khi chưa rõ:** Nếu có gì đó khó hiểu, hãy dừng lại và đặt câu hỏi cụ thể.

### 2. Ưu tiên sự đơn giản (Simplicity First)
* Chỉ viết lượng mã tối thiểu để giải quyết vấn đề. Không dự đoán tương lai.
* Không thêm tính năng, sự trừu tượng hoặc cấu hình linh hoạt nếu không được yêu cầu.
* Nếu có thể viết 50 dòng thay vì 200 dòng, hãy viết 50 dòng.

### 3. Thay đổi mang tính "phẫu thuật" (Surgical Changes)
* Chỉ chạm vào những gì cần thiết. Chỉ dọn dẹp những gì do bạn tạo ra.
* Không tự ý cải thiện định dạng, chú thích hoặc cấu trúc của các đoạn mã lân cận không liên quan.
* Khớp với phong cách (style) hiện có của dự án.
* **Dọn dẹp hệ quả:** Xóa bỏ các import/biến/hàm trở nên dư thừa **do thay đổi của bạn** tạo ra.

### 4. Thực hiện theo mục tiêu (Goal-Driven Execution)
* Chuyển đổi nhiệm vụ thành các mục tiêu có thể kiểm chứng (Ví dụ: Viết test lỗi trước, sau đó viết code để pass test).
* Đối với các nhiệm vụ nhiều bước, hãy nêu kế hoạch ngắn gọn:
    1. [Bước] → Kiểm chứng: [Cách kiểm tra]
    2. [Bước] → Kiểm chứng: [Cách kiểm tra]

## Cấu hình kỹ năng (Agent Skills)
Dựa trên bộ kỹ năng của Matt Pocock:
* **Issue tracker:** [Tóm tắt hệ thống quản lý task của bạn]. Xem `docs/agents/issue-tracker.md`.
* **Triage labels:** [Tóm tắt các nhãn phân loại]. Xem `docs/agents/triage-labels.md`.
* **Domain docs:** [Single-context hoặc Multi-context]. Xem `docs/agents/domain.md`.