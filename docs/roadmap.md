# Roadmap phát triển Monopoly Game

## Giai đoạn 1: Nền tảng ✅
- [x] Thiết lập dự án Flutter với Flame engine
- [x] Model, data, controller, views cơ bản
- [x] BoardView vẽ bàn 40 ô + token
- [x] Xúc xắc, di chuyển, chuyển lượt

## Giai đoạn 2: Mua bán & tài chính ✅
- [x] Popup mua đất, trừ tiền, cập nhật chủ
- [x] Qua GO +$200, thuế Income/Luxury
- [x] Tính tiền thuê (property, railroad, utility)
- [x] Hiển thị ownership trên bàn

## Giai đoạn 3: Monopoly & Xây dựng ✅
- [x] Logic monopoly (sở hữu hết nhóm màu)
- [x] Xây nhà/hotel (tối đa 4 nhà → hotel)
- [x] Tiền thuê tăng theo cấp độ (5x, 15x, 45x, 90x, 135x)
- [x] Hiển thị số nhà trên ô (chấm xanh/đỏ)

## Giai đoạn 4: Thẻ May & Cộng Đồng ✅
- [x] 13 thẻ Chance + 15 thẻ Community Chest
- [x] Random thẻ khi dừng ở ô tương ứng
- [x] Các hiệu ứng: tiền, di chuyển, vào tù, ra tù, thuế nhà

## Giai đoạn 5: Jail & luật đặc biệt ✅
- [x] Go to Jail, Jail/Just Visiting
- [x] Double dice, 3 doubles liên tiếp → vào tù
- [x] Ra tù: tung double, trả $50, thẻ ra tù
- [x] Hết 3 lượt tù → buộc nộp $50

## Giai đoạn 6: Phá sản & kết thúc ✅
- [x] Xử lý không đủ tiền → phá sản
- [x] Chuyển tài sản cho chủ nợ
- [x] Win condition: còn 1 người → game over + chơi lại

## Giai đoạn 7: UI & trải nghiệm ✅
- [x] HUD dạng Flutter overlay (thông tin, tin nhắn)
- [x] Popup: mua đất, xây nhà, thẻ, tù
- [x] Nút "ĐỔ XÚC XẮC" ở dưới
- [x] Màn hình kết thúc + nút chơi lại

## Giai đoạn 8: Kiểm thử ✅
- [x] flutter analyze: 0 lỗi
- [ ] Integration test
- [ ] Build APK / web release
